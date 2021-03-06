params.outdir = "$baseDir/results"
params.database = "ecoli_rel_606"

process snpeff_annotate {
    tag "SNPEFF ANNOTATION"
    publishDir "${params.outdir}/variant_called/", mode: 'copy'

    input:
    path(vcf)

    output:
    path "annotated_a_s_mkdup_filt.vcf", emit: annotation
    path "annotation_stats.csv", emit: stats

    script:
    """
    snpeff ${params.database} -csvStats annotation_stats.csv -lof -nodownload ${vcf} > annotated_a_s_mkdup_filt.vcf 
    """
}