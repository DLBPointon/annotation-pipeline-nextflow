process bwa_index {
    tag "BWA_INDEX on $ref"
    publishDir "./data", mode: 'copy'

    input:
    path(ref)

    output:
    path "ref.fna.sa" // Needs to be changes by making the input a mapped tuple of ID and file


    script:
    """
    bwa index ${ref}
    """
}