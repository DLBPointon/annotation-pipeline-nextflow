params.outdir = "$baseDir/results"

process samtools_sort {
    tag "SAMTOOLS_SORT on $aligned_bam"
    cpus 4
    publishDir "${params.outdir}/bwa_aligned", mode: 'copy'

    input:
    path(aligned_bam)

    output:
    path "aligned_sorted.bam", emit: aligned_sorted// Needs to be changes by making the input a mapped tuple of ID and file


    script:
    """
    samtools sort -@${task.cpus} ${aligned_bam} -o aligned_sorted.bam 
    """
}