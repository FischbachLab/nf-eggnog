```bash
aws batch submit-job \
    --job-name sj-egg-hcom2-20241213-3 \
    --job-queue priority-maf-pipelines \
    --job-definition nextflow-production \
    --container-overrides command=FischbachLab/nf-eggnog,\
"--workflow","annotate",\
"--seedfile","s3://genomics-workflow-core/Results/GenomeMining/hCom2/20241106/00_seedfiles/hCom2.aurum_seedfile.csv",\
"--project","hCom2",\
"--outdir","s3://genomics-workflow-core/Results/EggNOG",\
"--prefix","20241213"
```

```bash
nextflow run . \
    --profile local \
    -stub \
    --workflow annotate \
    --seedfile test/test_seedfile.csv
```