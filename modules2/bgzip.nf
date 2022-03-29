params.outdir = "$baseDir/results"

process bgzip {
    tag "BGZIP ZIPPING"
    publishDir "${params.outdir}/variant_called/", mode: 'copy'

    input:
    path(annotated_vcf)

    output:
    path "${annotated_vcf}.gz", emit: zipped_annotation

    script:
    """
    bgzip -c ${annotated_vcf} > ${annotated_vcf}.gz
    """
}