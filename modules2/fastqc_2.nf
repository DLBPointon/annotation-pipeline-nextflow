process fastqc_2 {
    tag "FASTQC round 2"
    publishDir "./fastqc_${pair_id}_logs", mode: 'move'

    input:
    path(paired_1)
    path(paired_2)
    path(unpaired_1)
    path(unpaired_2)
    val(pair_id)

    output:
    path("fastqc_${pair_id}_logs")

    script:
    """
    mkdir fastqc_${pair_id}_logs
    fastqc -o fastqc_${pair_id}_logs -f fastq -q ${paired_1} ${paired_2} ${unpaired_1} ${unpaired_2}
    """  
}