params.outdir = "$baseDir/results"

process gatk_haplocaller {
    tag "GATK Haplo"
    publishDir "${params.outdir}/variant_called/", mode: 'copy'

    input:
    path(reference)
    path(dict)
    path(ref_ind)
    path(sorted_bam)
    path(sorted_bam_bai)

    output:
    path "a_s_mkdup.vcf.gz", emit: v_called

    // TODO: This is not good here \/
    script:
    """
    cp ${dict} ref.dict
    gatk HaplotypeCaller -R ${reference} --sequence-dictionary ${dict} -I ${sorted_bam} -O a_s_mkdup.vcf.gz -ERC GVCF
    """
}