process bwa_mem_samtools {
    tag "BWA MEM ALIGN"
    publishDir "./bwa_aligned", mode: 'copy'

    input:
    path(ref)
    path(ref_index_ch)
    path(paired_out_1)
    path(paired_out_2)

    output:
    path "aligned.sam", emit: alignment

    script:
    """
    mkdir bwa_aligned
    echo "Reference Index found as: ${ref_index_ch}"
    bwa mem -t 4 -R'@RG\\tID:1\\tLB:library\\tPL:Illumina\\tPU:lane1\\tSM:human' $PWD/data/${ref} \
$PWD/TRIM_SRR622461/TRIM_SRR622461/${paired_out_1} \
$PWD/TRIM_SRR622461/TRIM_SRR622461/${paired_out_2} \
> aligned.sam
    """
}