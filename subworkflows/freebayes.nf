include { freebayes; vcf_concat } from '../modules/freebayes.nf'

workflow run_freebayes {
    take: 
        regions_file
        options
        fasta
        faidx
        alignments
        minQ

    main:
        // create bam channel
            // output is an array with 2 elements, 
                // 1. file prefix, probably sample ID
                // 2. file path object
        Channel
            .fromPath(alignments)
            .map {file -> 
                [file.name.replaceAll(/.bam|.bai$/,''),
                file]
            }
            .set {simple_ch}


        // initial bam index channel inferred from bam file names, 
        // attempts to deal with the fact that indexes can have .bai or .bam.bai suffixes
            // first create array as above, but paste '.bai' onto file names
            // check if .bam.bai files exist
            // if they exist, output array as [ prefix, path object]
            // if they don't exist, change .bam.bai suffix to .bai
            // this converts the path object to a string. I was unable to simply change the path object as above

        Channel
            .fromPath(alignments, checkIfExists: true)
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

        // further manipulate the bam index channel. 
            // run file() on each file name object, checking for existence
            // pipeline now fails if neither .bam.bai nor .bai index files exist
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


        // create regions channel
        regions_file.splitCsv().flatten().set{ regions_channel }

        // run processes
        freebayes(regions_channel, options, minQ, fasta, faidx, allbam_ch )
        vcf_concat(freebayes.out.collect(), regions_file)

    emit:
        vcf = vcf_concat.out
} 