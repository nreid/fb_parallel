process faidx {

    cache 'lenient'

    input:
    path fasta

    output:
    path "${fasta}.fai"

    script:
    """
    samtools faidx ${fasta}
    """
}
