params.outdir = "$baseDir/results"

process picard_collectmetrics {
    tag "PICARD COLLECT METRICS"
    publishDir "${params.outdir}/mkdup/", mode: 'copy'

    input:
    path(ref)
    path(marked_alignment)

    output:
    path "output.txt", emit: ref_dict

    script:
    """
    picard CollectAlignmentSummaryMetrics \
    -R ${ref} \
    -I ${marked_alignment} \
    -O output.txt
    """
}