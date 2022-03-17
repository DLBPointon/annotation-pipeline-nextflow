params.outdir = "$baseDir/results"

process fastqc {
    tag "FASTQC on $pair_id 1 and 2"
    cpus 2
    publishDir "${params.outdir}/fastqc_${pair_id}_logs/", mode: 'copy'

    input:
    tuple val(pair_id), path(reads)

    output:
    val(pair_id), emit: pair_ids
    tuple file("*1_fastqc.zip"), file("*2_fastqc.zip"), file("*1_fastqc.html"), file("*2_fastqc.html")


    script:
    """
    fastqc -t ${task.cpus} -q ${reads}
    """  
}