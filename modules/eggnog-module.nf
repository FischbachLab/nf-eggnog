#!/usr/bin/env nextflow


process annotate {
    debug true
    tag "${genome_id}"
    label "large_compute"
    container params.eggnog_container
    containerOptions "--volume ${params.db_path}:/db:ro"

    publishDir "${s3_base_path}/genome_id=${genome_id}", mode: 'copy', pattern: "${genome_id}*", saveAs: { "${file(it).getName()}" }

    input:
    tuple val(genome_id), path(protein_path)

    output:
    path("output/${genome_id}*")

    script:
    s3_base_path = params.workingpath
    """
    mkdir -p output
    emapper.py -i ${protein_path} -o output/${genome_id} --cpu ${task.cpu}
    """

    stub:
    s3_base_path = params.workingpath
    """
    # echo "genome_id: ${genome_id}, project_dir: ${s3_base_path}" > stub.txt
    echo "emapper.py -i ${protein_path} -o output/${genome_id} --cpu ${task.cpu}" >> stub.txt
    mkdir -p output
    cp stub.txt output/${genome_id}.emapper.annotations  
    cp stub.txt output/${genome_id}.emapper.hits  
    cp stub.txt output/${genome_id}.emapper.seed_orthologs
    """
}
