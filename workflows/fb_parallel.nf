include { index } from '../subworkflows/generate_index.nf'
include { generate_intervals } from '../subworkflows/generate_intervals.nf'
include { run_freebayes }      from '../subworkflows/freebayes.nf'

workflow fb_parallel {

    fasta   =  path ( params.fasta )
    fai     = path ( params.fai )
    bam     = path ( params.bam )
    bai     = path ( params.bai )

    generate_index ( fai, fasta, params.bai, params.bam)
    generate_intervals( fai, params.winsize, params.exclude )
    run_freebayes( generate_intervals.out, params.fboptions, fasta, fai, params.alignments, params.minQ )

}