process raw_intervals {

    cache 'lenient'

    input:
    path fai
    val winsize

    output:
    path "raw_intervals.bed"

    script:
    """
    slide=\$(expr ${winsize} - 100)
    bedtools makewindows -g ${fai} -w ${winsize} -s \$slide >raw_intervals.bed
    """
}

process subtract_intervals {

    cache 'lenient'

    input:
    path rawbed
    path excludebed

    output:
    path "subtracted.bed"

    script:
    """
    bedtools subtract -a ${rawbed} -b ${excludebed} >subtracted.bed
    """
}

process convert_intervals {

    cache 'lenient'

    input:
    path bed

    output:
    path "intervals.txt"
    
    script:
    """
    awk '{print \$1":"\$2+1"-"\$3}' ${bed} >intervals.txt
    """
}
