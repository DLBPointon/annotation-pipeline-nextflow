params.outdir = "$baseDir/results"
params.filter = "QUAL>20"

process bcftools_filt {
    tag "BCFTOOLS FILTER"
    publishDir "${params.outdir}/variant_called/", mode: 'copy'

    input:
    path(vcf)

    output:
    path "a_s_mkdup_filt.vcf", emit: v_called

    script:
    """
    bcftools view -i '${params.filter}' -a ${vcf} > a_s_mkdup_filt.vcf
    """
}