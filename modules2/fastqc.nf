process fastqc {
    tag "FASTQC on $pair_id 1 and 2"
    publishDir "./fastqc_${pair_id}_logs/", mode: 'move'

    input:
    tuple val(pair_id), path(reads)

    output:
    val(pair_id), emit: pair_ids
    path("fastqc_${pair_id}_logs")

    script:
    """
    mkdir fastqc_${pair_id}_logs/
    fastqc -o fastqc_${pair_id}_logs/ -f fastq -q ${reads}
    """  
}