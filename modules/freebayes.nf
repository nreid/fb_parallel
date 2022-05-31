// module to run freebayes
    // I'm worried that we'll have an issue with scrambling bam file input order. 
    // is this an issue?

process freebayes {

    input:
        alignments
        alignment_indexes
        interval
        fasta
        faidx

    output:

    script:
    """
    freebayes \
        --region ${interval} \
        --fasta-reference ${fasta} \
        ${params.options} \

    """
}

process run_freebayes {
    tag "$interval"

    input:
    file(aln) from alignments_ch.collect()
    file(idx) from indexes_ch.collect()
    each interval from intervals_ch
    file(fasta)
    file(faidx)

    output:
    // need to rename due to colon in intervals
    file("${params.project}_${interval.replaceAll(~/\:|\-|\*/, "_")}.vcf.gz") into (vcf_ch, makelist_ch)
    file("${params.project}_${interval.replaceAll(~/\:|\-|\*/, "_")}.vcf.gz.csi") into vcfidx_ch

    script:
    """
    freebayes \
        --region ${interval} \
        --fasta-reference ${fasta} \
        ${params.options} \
        ${aln.collect { "--bam $it" }.join(" ")} \
        | bgzip -c > ${params.project}_${interval.replaceAll(~/\:|\-|\*/, "_")}.vcf.gz
    bcftools index ${params.project}_${interval.replaceAll(~/\:|\-|\*/, "_")}.vcf.gz
    """
}
