// module to run freebayes
    // I'm worried that we'll have an issue with scrambling bam file input order. hence 'ls *bam >bam.list'
    // is this an issue?

process freebayes {

    tag "${region}"

    input:
        val region
        val options
        path fasta
        path faidx
        path bams

    output:
        path "${region[0]}.vcf.gz"

    script:
    // think about removing colon from file name
        // would have to edit when concatenating vcfs as well
    """
    ls *bam >bam.list

    # to prevent "index file is older than alignment" errors
    for file in *bai; do touch \$file; done

    freebayes \
        --bam-list bam.list \
        --region ${region[0]} \
        --fasta-reference ${fasta} \
        ${options} | \
        bgzip >${region[0]}.vcf.gz
    """

}

// module to concatenate vcf files

process vcf_concat {

    publishDir "${params.outdir}/vcf_raw"

    input:
        path vcfs
        path regionlist

    output:
        path "freebayes.vcf.*"

    script:
    """
    for file in \$(cat ${regionlist}); do bgzip -d -c \${file}.vcf.gz; done | \
        vcffirstheader | \
        vcfstreamsort -w 1000 | \
        vcfuniq | \
        bgzip >freebayes.vcf.gz

    tabix -p vcf freebayes.vcf.gz
    """


}