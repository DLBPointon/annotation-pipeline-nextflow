params.outdir = "$baseDir/results"

process tabix {
    tag "TABIX INDEX STEP"
    publishDir "${params.outdir}/variant_called/", mode: 'copy'

    input:
    path(zipped_vcf)

    output:
    path "${zipped_vcf}.tbi", emit: zipped_index

    script:
    """
    tabix -p vcf ${zipped_vcf}
    """
}