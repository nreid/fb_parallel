process raw_intervals {

    cache 'lenient'

    input:
    path fai

    output:
    path "raw_intervals.bed"

    script:
    """
    
    """
}

process subtract_intervals {

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
