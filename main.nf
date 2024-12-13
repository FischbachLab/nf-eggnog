#!/usr/bin/env nextflow
// If the user uses the --help flag, print the help text below
params.help = false

// Function which prints help message text
def helpMessage() {
    log.info"""
    Genome Mining using InterGenic Distances
    
    Required Arguments:
      --prefix      Output prefix (default: ${params.prefix})
      --project     Folder to place analysis outputs (default: ${params.project})
      --seedfile    list of s3 paths to *.tar.gz files from IMG (not required with filepath)
      --workflow    Which workflow to run (annotate)
    """.stripIndent()
}

workflow = params.workflow

// Show help message if the user specifies the --help flag at runtime
if (params.help){
    // Invoke the function above which prints the help message
    helpMessage()
    // Exit out and do not run anything else
    exit 0
}

//Creates working dir
def workingpath = params.outdir + "/" + params.project

if(params.prefix){
    workingpath = workingpath + "/" + params.prefix
}
workingdir = file(workingpath)

if( !workingdir.exists() ) {
    if( !workingdir.mkdirs() )     {
        exit 1, "Cannot create working directory: $workingpath"
    } 
}

params.workingpath = workingpath

include {printParams} from "./modules/housekeeping-module.nf"
// Setup Channels for Workflows
switch (workflow) {
    case [null]:
        exit 1, "No workflow specified. #0"
    case ["annotate"]:
        log.info "Initiating ANNOTATE workflow: Run EggNog on all genomes."
        include {annotate} from "./modules/eggnog-module.nf"
        db_ch = Channel.fromPath(params.db_tarball)
        proteins_ch = Channel.fromPath(params.seedfile, checkIfExists: true) \
            | ifEmpty { exit 1, "Cannot find any seed file matching: ${params.seedfile}." } \
            | splitCsv(header:true) \
            | map{ row -> tuple(row.genome_id, file(row.faa_path))}
            | combine(db_ch)
        break
    default:
        exit 1, "No workflow specified! #1"
}

workflow ANNOTATE {
    take:
        proteins_ch

    main:
        annotate(proteins_ch)
}

workflow {
    switch (workflow) {
    case [null]:
        exit 1, "No workflow specified."
    case ["annotate"]:
        take: proteins_ch
        main:
            // printParams()
            ANNOTATE(proteins_ch)
        break
    default:
        exit 1, "No workflow specified! #2"
    }
}