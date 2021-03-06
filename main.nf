/* 
    A pipeline to run freebayes in parallel
    Authors: 
        Noah Reid
        Gabriel Barrett
        Adapted from https://github.com/brwnj/freebayes-nf
 */ 


log.info """\
         Freebayes parallel   
         ===================================

         """
         .stripIndent()

if (params.help) {
    log.info """
    -----------------------------------------------------------------------
    freebayes parallel
    =========================================
    Output is written to <outdir>

    required
    --------
    --alignments    Aligned sequences in .bam format. Indexes (.bai or 
                    .bam.bai) must be present. 
    --fasta         Reference FASTA. 
    --fai           An index (.fai) for the reference genome must be 
                    provided (e.g samtools faidx ref.fasta)
    
    -------
    --outdir        Base results directory for output. Default: './results'
    --winsize       The genomic window size per variant calling job.
                    Default: 1000000
    --options       Arguments to be passed to freebayes command in addition
                    to those already supplied like `--bam`, `--region`, and
                    `--fasta-reference`. Single quote these when specifying
                    on the command line, e.g. --options '--pooled-discrete'.
    --exclude       A BED formatted file containing regions to exclude from 
                    variant calling. 
    --minQ          Minimum variant quality to output a VCF record. 
                    Default: 0
    -----------------------------------------------------------------------
    """.stripIndent()
    exit 0
}

/*  initial steps
    - check that arguments are valid
    - check that fasta file exists
    - check that bam files and indexes exist
    - 
*/



// required arguments
if( !params.alignments ) { exit 1, "--alignments is not defined" }
if( !params.fasta )      { exit 1, "--fasta is not defined" }
if( !params.fai )        { exit 1, "--fai is not defined" }


include { fb_parallel } from './workflows/fb_parallel.nf'
 
workflow FB {

    fb_parallel()

}


workflow {

    FB()
    
}

// execute workflow
