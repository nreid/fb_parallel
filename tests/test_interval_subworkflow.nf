include { generate_intervals } from '../subworkflows/generate_intervals.nf'

workflow {

    generate_intervals(params.fai, params.winsize, params.exclude)

}