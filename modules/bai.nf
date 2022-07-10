process bai {
    cache 'lenient'
    
    input:
    path ( bam )

    output:
    tuple val (id), path ("*.bam"),  path ("*.bai"), emit: aln

    script:
    """
    samtools index ${bam}
    """
}