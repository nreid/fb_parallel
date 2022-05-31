// use bedtools to make windows
// use .fai as list of scaffold lengths
// make sure to allow inclusion of a set of intervals to EXCLUDE

include { raw_intervals ; subtract_intervals ; convert_intervals } from '../modules/intervals.nf'

workflow generate_intervals {
    take: 
        fai
        winsize
        exclude

    main:
    raw_intervals(fai, winsize)
 
    if( exclude ){
        subtract_intervals(raw_intervals.out, exclude)
        convert_intervals(subtract_intervals.out)
    }
    else{
        convert_intervals(raw_intervals.out)
    }

    emit:
        intervals = convert_intervals.out
} 