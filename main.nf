nextflow.enable.dsl=2

// Module Definition Statements
include { fastqc } from "./modules2/fastqc.nf"
include { trimmomatic } from "./modules2/trimmomatic.nf"
include { fastqc_2 } from "./modules2/fastqc_2.nf"
//include { multiqc } from "./modules2/multiqc.nf"
include { bwa_index } from "./modules2/bwa_index.nf"
include { samtools_faidx } from "./modules2/samtools_faidx.nf"
include { samtools_sort } from "./modules2/samtools_sort.nf"
include { samtools_view } from "./modules2/samtools_view.nf"
include { samtools_index } from "./modules2/samtools_index.nf"
include { bwa_mem_samtools } from "./modules2/bwa_mem.nf"

//include { trimmomatic } from "./modules2/trimmomatic.nf"

// Default & Testing Parameter
params.reference = "$baseDir/data/ref.fna"
params.reads = "$baseDir/data/SRR622461_{1,2}.fastq"
params.outdir = "results"
params.multiqc = "$baseDir/multiqc"
params.readcsv = "$baseDir/samplesheet.csv"

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

    fastqc (read_pairs_ch)
    
    trimmomatic (read_pairs_ch) // <- Trimming adapters from reads (SHOULDN"T BE ANY)

    fastqc_2 (trimmomatic.out.paired_out_1, trimmomatic.out.paired_out_2, trimmomatic.out.unpaired_out_1, trimmomatic.out.unpaired_out_2, fastqc.out.pair_ids) //<- Taking the output trimmed fasta

    // MULTIQC () <- Collect all fastqc runs into one report

    ref_index_ch = bwa_index (reference_ch) //<- Use BWA to index the reference

    samtools_faidx (reference_ch) //<- Use faidx to index the reference too

    bwa_mem_samtools (reference_ch, ref_index_ch, trimmomatic.out.paired_out_1, trimmomatic.out.paired_out_2) //<- Use BWA to allign the TRIMMED.fastq to the REFERENCE and SAMTOOLS convert to BAM
    // Rename the above now that the samtools bit has been changes to the below

    samtools_view (bwa_mem_samtools.out.alignment)

    samtools_sort (samtools_view.out.aligned_bam) // <- Self explanatory

    samtools_index (samtools_sort.out.aligned_sorted)// <- Index the BAM

    // PICARD_MARKDUPES () <- Mark but do not remove dupes (SHOULDN'T BE ANY)

    // PICARD_COLLECT_ALIGNMENT_SUM_METRICS () <- Add to MULTIQC?

    // PICARD_CREATE_SEQ_DICT () <- Create DICT for REFERENCE

    // GATK_HAPLOCALLER () <- Get VCF

    // BCFTOOLS_VIEW () <- Filter Quality of master VCF

    // BCFTOOLS_VIEW () <- Get subset of VCF by chromosome

    // SNP_EFF () <- Annotation of VCF

    // BGZIP () <- bgzip vcf file

    // TABIX () <- Indexing of VCF for

}