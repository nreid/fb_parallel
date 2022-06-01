params.simplebam='/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/alignments/*bam'

process simpleproc {

    input:
        tuple val(sampleid), path (bam), path(bai)
    script:
    """
    echo ${bam[1]}
    """

}

process allbams {

    input:
        path bam
    script:
    """
    ls *bam >bam.list
    """

}

process freebayes {

    tag "${region}"

    input:
        val region
        path fasta
        path faidx
        path bams

    output:

    script:
    """
    ls *bam >bam.list
    freebayes --list bam.list 
    """

}

// goal here is to find index files for supplied bam (maybe also cram?) files
// want the pipeline to fail with an error if user supplies an alignment with no index
// usual behavior with join is to silently drop non-matching elements

// bam channel
Channel
    .fromPath(params.simplebam)
    .map {file -> 
        [file.name.replaceAll(/.bam|.bai$/,''),
        file]
    }
    .set {simple_ch}


// bam index channel inferred from bam file names, bai stored only as string
Channel
    .fromPath(params.simplebam, checkIfExists: true)
    .map { file ->
        if(file.name.endsWith('.bam')) {
            out = [
            file.name.replaceAll(/.bam|.bai$/,''), 
            file + '.bai'
            ]
            if(!out[1].exists()){
                out[1] = out[1].toString().replaceAll(/.bam.bai/,'.bai')
            }   
        }        
        out       
    }.set{ bai_init }

// bam index channel with strings converted to paths, checking that index files exist
bai_init
    .map{ list ->
        x = file(list[1], checkIfExists: true)
        list[1] = x
        list
    }
    .set{ bai_ch }

// join bam and bai channels
simple_ch.join(bai_ch).set{ joint_ch }

// collect bam and bai to emit all together
joint_ch
    .map { list ->
        [ list[1], list[2] ]
    }
    .flatten()
    .collect()
    .set{ allbam_ch }

workflow {

    // simpleproc(joint_ch)
    allbams(allbam_ch)

}
