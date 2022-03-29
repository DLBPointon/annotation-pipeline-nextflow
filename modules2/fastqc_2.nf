params.outdir = "$baseDir/results"

process fastqc_2 {
    tag "FASTQC2 on ${f1} AND ${f2}"
    cpus 2
    publishDir "${params.outdir}/fastqc_MERGED_logs/", mode: "copy"

    input:
    path(f1)
    path(f2)

    output:
    tuple file("*fastqc.zip"), file("*fastqc.html"), emit: fastqc_2

    script:
    """
    fastqc -t ${task.cpus} -q ${f1} ${f2}
    """
}