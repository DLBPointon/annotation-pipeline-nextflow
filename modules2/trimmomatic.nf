process trimmomatic {
    tag "TRIMMING $pair_id 1 and 2"
    publishDir "./TRIM_${pair_id}", mode: 'move'

    input:
    tuple val(pair_id), path(reads)

    output:
    path "TRIM_${pair_id}/${pair_id}_1P.fastq", emit: paired_out_1
    path "TRIM_${pair_id}/${pair_id}_1U.fastq", emit: unpaired_out_1
    path "TRIM_${pair_id}/${pair_id}_2P.fastq", emit: paired_out_2
    path "TRIM_${pair_id}/${pair_id}_2U.fastq", emit: unpaired_out_2
    path "TRIM_${pair_id}", emit: trim_dir

    script:
    """
    echo "Runnning TRIM for ${reads}"
    mkdir TRIM_${pair_id}
    trimmomatic PE -threads 4 -phred33 ${reads} LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:36 -baseout TRIM_${pair_id}/${pair_id}.fastq
    """
}
