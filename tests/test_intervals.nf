include { raw_intervals ; subtract_intervals ; convert_intervals } from '../modules/intervals.nf'

workflow {

raw_intervals(params.fai, params.winsize)
subtract_intervals(raw_intervals.out, params.exclude)
convert_intervals(subtract_intervals.out)

}