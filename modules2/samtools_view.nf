params.outdir = "$baseDir/results"

process samtools_view {
    tag "SAMTOOLS_VIEW on $aligned"
    cpus 4
    publishDir "${params.outdir}/bwa_aligned", mode: 'copy'

    input:
    path(aligned)

    output:
    path "aligned.bam", emit: aligned_bam// Needs to be changes by making the input a mapped tuple of ID and file


    script:
    """
    samtools view -bS -@${task.cpus} ${aligned} > aligned.bam 
    """
}