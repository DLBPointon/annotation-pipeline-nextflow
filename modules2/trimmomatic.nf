params.outdir = "$baseDir/results"

process trimmomatic {
    tag "TRIMMING $pair_id 1 and 2"
    publishDir "${params.outdir}/TRIM_${pair_id}/", mode: 'copy'

    input:
    tuple val(pair_id), path(reads)

    output:
    tuple path("${pair_id}_1P.fastq"), path("${pair_id}_2P.fastq"), emit: trim_paired
    tuple path("${pair_id}_1U.fastq"), path("${pair_id}_2U.fastq"), emit: trim_unpaired

    script:
    """
    echo "Runnning TRIM for ${reads}"

    trimmomatic PE -threads 4 -phred33 ${reads} \
    -baseout ${pair_id}.fastq \
    LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:36
    """
}
