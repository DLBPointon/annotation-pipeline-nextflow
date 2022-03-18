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
include { bwa_mem } from "./modules2/bwa_mem.nf"
include { picard_mkdup } from "./modules2/picard_mkdup.nf"
//include { picard_createdict } from "./modules2/picard_createdict.nf"
//include { picard_collectmetrics } from "./modules2/picard_collectmetrics.nf"


// Default & Testing Parameter
params.reference = "$baseDir/data/ref.fna"
params.reads = "$baseDir/data/COV020619_R{1,2}.fastq"
params.trimdir = "$baseDir/results/TRIM_COV020619_R"
params.outdir = "$baseDir/results"
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

    // Input of [SAMPLE_ID, [FILE1, FILE2]]
    fastqc (read_pairs_ch) // ||
    
    // Input of [SAMPLE_ID, [FILE1, FILE2]]
    trimmomatic (read_pairs_ch) // || <- Trimming adapters from reads

    fastqc_2 (trimmomatic.out.trim_paired, trimmomatic.out.trim_unpaired, fastqc.out.pair_ids) //<- Taking the output trimmed fasta

    // MULTIQC (fastqc.out.collect().ifEmpty([]),
//              fastqc_2.out.collect().ifEmpty([])
//              ) <- Collect all fastqc runs into one report

    // Input of path to ref
    bwa_index (reference_ch) // || <- Use BWA to index the reference

    // Input of path to ref
    samtools_faidx (reference_ch) // || <- Use faidx to index the reference too
    
    // Takes the path to ref and the paired/trimmed reads
    bwa_mem (reference_ch, trimmomatic.out.trim_paired) // ||<- Use BWA to allign the TRIMMED.fastq to the REFERENCE and SAMTOOLS convert to BAM
    // Rename the above now that the samtools bit has been changes to the below

    samtools_view (bwa_mem.out.alignment) // || <- SAM to BAM

    samtools_sort (samtools_view.out.aligned_bam) // || <- Self explanatory

    samtools_index (samtools_sort.out.aligned_sorted)// || <- Index the BAM

    // ------ SO FAR AT LEAST TESTED -------- //

    picard_mkdup (samtools_sort.out.aligned_sorted) // <- Mark but do not remove dupes

    // PICARD_COLLECT_ALIGNMENT_SUM_METRICS () <- Add to MULTIQC?

    // PICARD_CREATE_SEQ_DICT () <- Create DICT for REFERENCE

    // GATK_HAPLOCALLER () <- Get VCF

    // BCFTOOLS_VIEW () <- Filter Quality of master VCF

    // BCFTOOLS_VIEW () <- Get subset of VCF by chromosome

    // SNP_EFF () <- Annotation of VCF

    // BGZIP () <- bgzip vcf file

    // TABIX () <- Indexing of VCF for

}