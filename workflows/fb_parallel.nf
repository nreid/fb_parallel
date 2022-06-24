include { generate_intervals } from '../subworkflows/generate_intervals.nf'
include { run_freebayes }      from '../subworkflows/freebayes.nf'

workflow fb_parallel {

    generate_intervals( params.fai, params.winsize, params.exclude )
    run_freebayes( generate_intervals.out, params.fboptions, params.fasta, params.fai, params.alignments )

}