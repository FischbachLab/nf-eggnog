#!/usr/bin/env nextflow
new groovy.json.JsonOutput

s3_base_path = params.workingpath
workflow_dir = "parameters"

process printParams {
    label "small_compute"
    container params.eggnog_container
    publishDir "${s3_base_path}/parameters/${params.workflow}", overwrite: true, pattern: "**.json", saveAs: { "${file(it).getName()}"}

    output:
    path "parameters.json"


    script:
    """
    touch parameters.json
    echo '${JsonOutput.toJson(params)}' > parameters.json
    """
}