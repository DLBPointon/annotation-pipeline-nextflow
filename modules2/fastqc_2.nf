params.outdir = "$baseDir/results"

process fastqc_2 {
    tag "FASTQC2 on $pair_id 1P, 1U, 2P, 2U"
    cpus 2
    publishDir "${params.outdir}/fastqc_${pair_id}_logs/", mode: "copy"

    input:
    tuple path(1paired), path(2paired), path(1unpaired), path(2unpaired)
    val(pair_id)

    output:
    tuple file("*1P_fastqc.zip"), file("*2P_fastqc.zip"), file("*1P_fastqc.html"), file("*2P_fastqc.html"), file("*2U_fastqc.zip"), file("*1U_fastqc.zip"), file("*2U_fastqc.html"), file("*1U_fastqc.html")

    script:
    """
    fastqc -t ${task.cpus} -q ${1paired} ${2paired} ${1unpaired} ${2unpaired}
    """
}