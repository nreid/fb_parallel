params.fasta       = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/genome/GCA_004348285.1_ASM434828v1_genomic.fna'
params.fai         = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/genome/fake.fai'
params.simplebam   = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/alignments/*bam'
params.winsize     = '1000000'
params.exclude     = ''
params.options     = ''

include { freebayes; vcf_concat } from '../modules/freebayes.nf'
include { generate_intervals } from '../subworkflows/generate_intervals.nf'

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

    generate_intervals(params.fai, params.winsize, params.exclude)
    generate_intervals.out.splitCsv().set{ interval_ch }
    // generate_intervals.out.splitText().map{it -> it.trim()}.set{ interval_ch }

    freebayes( interval_ch, params.options, params.fasta, params.fai, allbam_ch)
    vcf_concat( freebayes.out.collect(), generate_intervals.out )

}

