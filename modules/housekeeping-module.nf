#!/usr/bin/env nextflow
import groovy.json.JsonOutput


process printParams {
    label "small_compute"
    container params.eggnog_container
    publishDir "${s3_base_path}/parameters/${params.workflow}", overwrite: true, pattern: "**.json", saveAs: { "${file(it).getName()}"}

    output:
    path("parameters.json")


    script:
    s3_base_path = params.workingpath
    workflow_dir = "parameters"
    """
    touch parameters.json
    echo '${JsonOutput.toJson(params)}' > parameters.json
    """

    stub:
    s3_base_path = params.workingpath
    """
    touch parameters.json
    echo "${s3_base_path}" > parameters.json
    """
}