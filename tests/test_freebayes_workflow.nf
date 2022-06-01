params.fasta       = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/genome/GCA_004348285.1_ASM434828v1_genomic.fna'
params.fai         = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/genome/fake.fai'
params.bams   = '/Users/noahreid/Dropbox/cbc_projects/fb_parallel_test_data/alignments/*bam'
params.winsize     = '1000000'
params.exclude     = ''
params.options     = ''


include { generate_intervals } from '../subworkflows/generate_intervals.nf'
include { run_freebayes } from '../subworkflows/freebayes.nf'

workflow {

    generate_intervals( params.fai, params.winsize, params.exclude )

    run_freebayes( generate_intervals.out, params.options, params.fasta, params.fai, params.bams )
}