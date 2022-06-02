include { freebayes; vcf_concat } from '../modules/freebayes.nf'

workflow run_freebayes {
    take: 
        regions_file
        options
        fasta
        faidx
        alignments

    main:
        // get bam channel
        Channel
            .fromPath(alignments)
            .map {file -> 
                [file.name.replaceAll(/.bam|.bai$/,''),
                file]
            }
            .set {simple_ch}


        // bam index channel inferred from bam file names, bai stored only as string
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


        // create regions channel
        regions_file.splitCsv().set{ regions_channel }

        // run processes
        freebayes(regions_channel, options, fasta, faidx, allbam_ch)
        vcf_concat(freebayes.out.collect(), regions_file)

    emit:
        vcf = vcf_concat.out
} 