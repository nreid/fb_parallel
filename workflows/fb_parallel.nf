include { generate_intervals } from '../subworkflows/generate_intervals.nf'
include { run_freebayes }      from '../subworkflows/freebayes.nf'

workflow fb_parallel {

    fasta   = Channel.fromPath( params.fasta )
    fai     = Channel.fromPath( params.fai )

    generate_intervals( fai, params.winsize, exclude )
    run_freebayes( generate_intervals.out, params.fboptions, fasta, fai, params.alignments, params.minQ )

}