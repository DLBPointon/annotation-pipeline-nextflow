params.outdir = "$baseDir/results"

process fastqc {
    tag "FASTQC on $pair_id 1 and 2"
    cpus 2
    publishDir "${params.outdir}/fastqc_${pair_id}_logs/", mode: 'copy'

    input:
    tuple val(pair_id), path(reads)

    output:
    val(pair_id), emit: pair_ids
    tuple file("${pair_id}_1*.zip"), file("${pair_id}_2*.zip"), file("${pair_id}_1*.html"), file("${pair_id}_2*.html"), emit: fastqc_1


    script:
    """
    fastqc -t ${task.cpus} -q ${reads}
    """  
}