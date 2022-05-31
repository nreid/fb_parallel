params.simplebam='/home/FCAM/nreid/fb_parallel_test_data/alignments2/*bam'

process simpleproc {

    input:
        tuple val(sampleid), path (bam)
    script:
    """
    echo ${bam[1]}
    """

}

Channel
    .fromPath(params.simplebam)
    .map {file -> 
        [file.name.replaceAll(/.bam|.bai$/,''),
        file]
    }
    .set {simple_ch}

Channel
    .fromPath(params.simplebam, checkIfExists: true)
    .map { file -> 
        out = [file.name.replaceAll(/.bam|.bai$/,''), file + ("${file}".endsWith('.cram') ? '.crai' : '.bai')]
        if(!out[1].exists()){out[1] = out[1].replaceAll(/.bam/, "")}
        out
    }.view()
    //.set { indexes_ch }


workflow {

    simpleproc(simple_ch)

}
