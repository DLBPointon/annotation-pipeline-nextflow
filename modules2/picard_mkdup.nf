params.outdir = "$baseDir/results"

process picard_mkdup {
    tag "PICARD MKDUP"
    publishDir "${params.outdir}/mkdup/", mode: 'copy'

    input:
    path(sorted_bam)

    output:
    path "mkdup.bam"
    path "marked_dupes_metrics.txt"

    script:
    """
    "picard MarkDuplicates -I ${params.outdir}/bwa_aligned/${sorted_bam} -O mkdup.bam -M marked_dupes_metrics.txt"
    """
}