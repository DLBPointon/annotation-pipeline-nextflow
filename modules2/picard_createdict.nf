params.outdir = "$baseDir/data"

process picard_createdict {
    tag "PICARD CREATE DICT"
    publishDir "${params.outdir}/", mode: 'copy'

    input:
    path(ref)

    output:
    path "${ref}.dict", emit: ref_dict

    script:
    """
    picard CreateSequenceDictionary -R ${ref} -O ${ref}.dict
    """
}