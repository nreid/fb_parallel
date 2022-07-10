include { generate_fai } from '../modules/faidx.nf'
include { generate_bai } from '../modules/bai.nf'

workflow index {
    
    take:
    params.fai
    params.fasta
    params.bai
    params.alignments

    main:
    // could change to if file does not exist create index
    if (params.fai == 'false') { 
        generate_fai ( params.fasta )
        fai = generate_fai.out.fai
    } else {
        fai = params.fai
    }

    if (bai == 'false') {
        generate_bai ( params.alignments )
        bai = generate_bai.out.bai
    } else {
        bai = params.bai
    }

    emit:
    fai
    bai

}