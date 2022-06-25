include { generate_fai } from '../modules/faidx.nf'
include { generate_bai } from '../modules/bai.nf'

workflow index {
    if (params.fai == 'false') {
        generate_fai ( params.fasta )
        fai = generate_fai.out.fai
    } else {
        fai = params.fai
    }

    if (bai == 'false') {
        generate_bai ( params.bam )
        bai = generate_bai.out.bai
    } else {
        bai = params.bai
    }
}