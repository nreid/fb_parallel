/* 
 * A pipeline to run freebayes in parallel
 * Authors: 
 */ 

 /* 
 * pipeline input parameters 
 */
params.help                = false
params.fasta               = ""
params.alignments          ""
log.info """\
         Freebayes parallel   
         ===================================
         reference genome  : ${params.fasta}
         fastq reads       : ${params.fastq}
         outdir            : ${params.outdir}
         centrifuge db     : ${params.centrifugedb}
         medaka model      : ${params.medaka_model}
         """
         .stripIndent()

if (params.help) {
    log.info """
    -----------------------------------------------------------------------
    freebayes parallel
    =========================================
    Output is written to <outdir>/freebayes/<project>.vcf.gz and represents
    a decomposed and normalized VCF and its index.
    required
    --------
    --alignments   Aligned sequences in .bam and/or .cram format. Indexes
                   (.bai/.crai) must be present.
    --fasta        Reference FASTA. 
    options
    -------
    --outdir       Base results directory for output. Default: '/.results'
    --project      File prefix for merged and annotated VCF files.
                   Default: 'variants'
    --width        The genomic window size per variant calling job.
                   Default: 5000000
    --options      Arguments to be passed to freebayes command in addition
                   to those already supplied like `--bam`, `--region`, and
                   `--fasta-reference`. Single quote these when specifying
                   on the command line, e.g. --options '--pooled-discrete'.
    --intervals    Picard-style intervals file to use rather than intervals
                   defined in .fai. Something like Broad's interval lists
                   work here if you want to omit masked regions.
    --exclude      Chromosome patterns to omit from variant calling.
                   Default: 'decoy,random,Un,alt,EBV,M,HLA,phi'
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
params.alignments = false
if( !params.alignments ) { exit 1, "--alignments is not defined" }
params.fasta = false
if( !params.fasta ) { exit 1, "--fasta is not defined" }


// execute workflow
include{ generate_intervals } from './subworkflows/intervals.nf'
include{ run_freebayes      } from './subworkflows/freebayes.nf'


workflow {

    generate_intervals()
    run_freebayes()

}