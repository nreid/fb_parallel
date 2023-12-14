// module to run freebayes
    // I'm worried that we'll have an issue with scrambling bam file input order. hence 'ls *bam >bam.list'
    // is this an issue?

process freebayes {

    tag "${region}"
    errorStrategy 'retry'
    maxRetries 5

    input:
        val region
        val options
        val minQ
        path fasta
        path faidx
        path bams

    output:
        path "${region}.vcf.gz"

    script:
    // think about removing colon from file name
        // would have to edit when concatenating vcfs as well
    """
    ls *bam >bam.list

    freebayes \
        --bam-list bam.list \
        --region "${region}" \
        --fasta-reference ${fasta} \
        "${options}" | \
        bcftools filter -i 'QUAL > ${minQ}' | \
        bgzip >"${region}.vcf.gz"
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
    # create header file, count header lines
    R1=\$(head -n 1 ${regionlist})
    zcat "\${R1}.vcf.gz" | awk '{if (\$0 ~ /^#/) print \$0; else exit}' >header.txt
    HL=\$(cat header.txt | wc -l)
    START=\$(expr \$HL + 1)

    # cat header file, cat all vcfs, starting at # header lines + 1, sort, uniq, bgzip
    (
        cat header.txt
        for file in \$(cat ${regionlist}); do bgzip -d -c "\${file}.vcf.gz" | tail -n +\${START}; done
    ) | \
    vcfstreamsort | \
    vcfuniq | \
    bgzip >freebayes.vcf.gz

    tabix -p vcf freebayes.vcf.gz
    """


}
