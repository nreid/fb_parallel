process bai {
    cache 'lenient'
    
    input:
    path ( bam )

    output:
    tuple val (id), path ("*.bai"),  path ("*.bam"), emit: aln

    script:
    """
    samtools index ${bam}
    """
}