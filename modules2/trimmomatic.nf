params.outdir = "$baseDir/results"

process trimmomatic {
    tag "TRIMMING $pair_id 1 and 2"
    publishDir "${params.outdir}/TRIM_${pair_id}/", mode: 'copy'

    input:
    tuple val(pair_id), path(reads)

    output:
    tuple file("*_1P.fastq"), file("*_2P.fastq"), emit: paired_out
    tuple file("*_1U.fastq"), file("*_2U.fastq"), emit: unpaired_out
    tuple file("*_1P.fastq"), file("*_2P.fastq"), file("*_1U.fastq"), file("*_2U.fastq"), emit: all_out


    script:
    """
    echo "Runnning TRIM for ${reads}"

    trimmomatic PE -threads 4 -phred33 ${reads} \
    -baseout ${pair_id}.fastq \
    LEADING:10 TRAILING:10 SLIDINGWINDOW:4:20 MINLEN:36
    """
}
