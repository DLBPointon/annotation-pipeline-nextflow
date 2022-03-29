params.outdir = "$baseDir/results"

process merge_fastq {
    tag "MERGE TRIMMED FASTQ"
    publishDir "${params.outdir}/merged_trimmed_fastq/", mode: 'copy'

    input:
    path(list_o_files)

    output:
    path("merged_1.fastq"), emit: f1
    path("merged_2.fastq"), emit: f2

    script:
    """
    cat *_1P.fastq > merged_1.fastq && cat *_2P.fastq > merged_2.fastq
    """
}