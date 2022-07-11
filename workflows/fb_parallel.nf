include { index } from '../subworkflows/generate_index.nf'
include { generate_intervals } from '../subworkflows/generate_intervals.nf'
include { run_freebayes }      from '../subworkflows/freebayes.nf'


/*checkPathParams = [

]*/


// Check if file with list of fastas is provided when running BBSplit
if (!params.bai && !params.bbsplit_index && params.bbsplit_fasta_list) {
    ch_bbsplit_fasta_list = file(params.bbsplit_fasta_list, checkIfExists: true)
    if (ch_bbsplit_fasta_list.isEmpty()) {exit 1, "File provided with --bbsplit_fasta_list is empty: ${ch_bbsplit_fasta_list.getName()}!"}
}

workflow fb_parallel {

    fasta          = path ( params.fasta )
    fai            = path ( params.fai )
    alignments     = path ( params.alignments )
    bai            = path ( params.bai )

    generate_index ( fai, fasta, params.bai, params.alignments)
    generate_intervals( fai, params.winsize, params.exclude )
    run_freebayes( generate_intervals.out, params.fboptions, fasta, fai, params.alignments, params.minQ )

}