process faidx {

    cache 'lenient'

    input:
    path fasta

    output:
    path "${fasta}.fai", emit: faidx

    script:
    """
    samtools faidx ${fasta}
    """
}
