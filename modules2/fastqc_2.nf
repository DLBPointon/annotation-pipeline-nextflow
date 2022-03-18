params.outdir = "$baseDir/results"

process fastqc_2 {
    tag "FASTQC2 on $pair_id 1P, 1U, 2P, 2U"
    cpus 2
    publishDir "${params.outdir}/fastqc_${pair_id}_logs/", mode: "copy"

    input:
    path(reads)
    path(reads_2)
    val(pair_id)

    output:
    tuple file("*fastqc.zip"), file("*fastqc.html"), emit: fastqc_2

    script:
    """
    fastqc -t ${task.cpus} -q ${reads} ${reads_2}
    """
}