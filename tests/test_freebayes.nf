/* params.simplebam='/home/FCAM/nreid/fb_parallel_test_data/alignments/*bam'

process simpleproc {

    input:
        path bam
    script:
    """
    echo ${bam}
    """

}

Channel
    .fromPath(params.simplebam)
    .set {simple_ch}

workflow {

    simpleproc(simple_ch)

}
 */
// now a tuple channel

params.tuplebam='/home/FCAM/nreid/fb_parallel_test_data/alignments/*.{bam,bai}'

process tupleproc {
    tag "$sampleid"

    input:
        tuple val(sampleid), path(bam)
    script:
    """
    echo ${sampleid}
    """

}

// channel idea from here https://nextflow-io.github.io/patterns/index.html#_process_per_file_pairs
Channel
    .fromFilePairs(params.tuplebam) { file -> file.name.replaceAll(/.bam|.bai$/,'') }
    .set { tuple_ch }

workflow {

    tupleproc(tuple_ch)

}



