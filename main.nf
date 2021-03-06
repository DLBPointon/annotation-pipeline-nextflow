nextflow.enable.dsl=2

// Module Definition Statements
include { fastqc } from "./modules2/fastqc.nf"
include { trimmomatic } from "./modules2/trimmomatic.nf"
include { fastqc_2 } from "./modules2/fastqc_2.nf"
include { merge_fastq } from "./modules2/merge_fastq.nf"
//include { multiqc } from "./modules2/multiqc.nf"
include { bwa_index } from "./modules2/bwa_index.nf"
include { samtools_faidx } from "./modules2/samtools_faidx.nf"
include { samtools_sort } from "./modules2/samtools_sort.nf"
include { samtools_view } from "./modules2/samtools_view.nf"
include { samtools_index } from "./modules2/samtools_index.nf"
include { bwa_mem } from "./modules2/bwa_mem.nf"
include { picard_mkdup } from "./modules2/picard_mkdup.nf"
include { samtools_index_2 } from "./modules2/samtools_index_2.nf"
include { picard_collectmetrics } from "./modules2/picard_collectmetrics.nf"
include { picard_createdict } from "./modules2/picard_createdict.nf"
include { gatk_haplocaller } from "./modules2/gatk.nf"
include { bcftools_filt } from "./modules2/bcftools_filt.nf"
include { snpeff_annotate } from "./modules2/snpeff_annotate.nf"
include { bgzip } from "./modules2/bgzip.nf"
include { tabix } from "./modules2/tabix.nf"

// Default & Testing Parameter
params.reference = "$baseDir/data/ref.fna"
params.reads = "$baseDir/data/SRR*{1,2}.trim.sub.fastq"
params.trimdir = "$baseDir/results/TRIM_SRR_R"
params.outdir = "$baseDir/results"
params.multiqc = "$baseDir/multiqc"

// Logging Information
log.info """\
            Annotation Pipeline For SNPs
        ====================================
        Reference   : ${params.reference}
        Paired Reads: ${params.reads}
        Outdir      : ${params.outdir}
        """.stripIndent()

// Workflow Definition
workflow snp_pipeline {
    Channel 
        .fromFilePairs( params.reads, checkIfExists: true, flatten:true)
        .set { read_pairs_ch }

    Channel
        .fromPath( params.reference, checkIfExists: true )
        .set {reference_ch}

    read_pairs_ch.view()

    fastqc (read_pairs_ch) // ||

    trimmomatic (read_pairs_ch) // || <- Trimming adapters from reads

    merge_fastq (trimmomatic.out.trim_paired.collect())

    fastqc_2 (merge_fastq.out.f1, merge_fastq.out.f2) //<- Taking the output trimmed fasta

    // MULTIQC (fastqc.out.collect().ifEmpty([]),
//              fastqc_2.out.collect().ifEmpty([])
//              ) <- Collect all fastqc runs into one report    // Input of path to ref
    bwa_index (reference_ch) // || <- Use BWA to index the reference

    samtools_faidx (reference_ch) // || <- Use faidx to index the reference too

    bwa_mem (reference_ch, merge_fastq.out.f1, merge_fastq.out.f2) // ||<- Use BWA to allign the TRIMMED.fastq to the REFERENCE and SAMTOOLS convert to BAM

    samtools_view (bwa_mem.out.alignment) // || <- SAM to BAM

    samtools_sort (samtools_view.out.aligned_bam) // || <- Self explanatory

    samtools_index (samtools_sort.out.aligned_sorted)// || <- Index the BAM

    picard_mkdup (samtools_sort.out.aligned_sorted) // ||<- Mark but do not remove dupes

    samtools_index_2 (picard_mkdup.out.mkdup_alignment) // ||

    picard_collectmetrics (reference_ch, picard_mkdup.out.mkdup_alignment) // <- Add to MULTIQC?

    picard_createdict (reference_ch) // ||<- Create DICT for REFERENCE

    gatk_haplocaller (reference_ch,
                        picard_createdict.out.ref_dict,
                        samtools_faidx.out.out_faidx,
                        picard_mkdup.out.mkdup_alignment,
                        samtools_index_2.out.aligned_index) // ||<- Get VCF

    // There was originally a bcf tools excise script here but the cov genome is too small to need it

    bcftools_filt (gatk_haplocaller.out.v_called) // ||<- Get subset of VCF by chromosome

    snpeff_annotate (bcftools_filt.out.v_called) // ||<- Annotation of VCF

    bgzip (snpeff_annotate.out.annotation)

    tabix (bgzip.out.zipped_annotation) // ||<- Indexing of VCF for

}