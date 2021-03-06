params.outdir = "$baseDir/results"

process bwa_index {
    tag "BWA_INDEX on $ref"
    publishDir "${params.outdir}/data", mode: 'copy'

    input:
    path(ref)

    output:
    tuple path("ref.fna.sa"), path("ref.fna.bwt"), path("ref.fna.pac"), path("ref.fna.amb"), path("ref.fna.ann") // Needs to be changes by making the input a mapped tuple of ID and file

    script:
    """
    bwa index ${ref}
    """
}