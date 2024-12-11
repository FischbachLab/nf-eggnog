# EggNOG Mapper

## Dependencies

### Pinned Versions

- `Python`: 3.10
- `psutil`: 5.7.0
- `eggnog-mapper`: 2.1.12

### Unpinned/Default Versions

- `BioPython`
- `sqlite3`
- `wget`

### Database

- `emapperdb`: 5.0.2
  - Diamond
  - Novel Families
  - MMSeqs (TODO: [needs to be indexed.](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2.1.5-to-v2.1.12#setup))


## Installation and Setup

- Use the `make` file to create the docker image.

### Download the database to EFS

It is **HIGHLY RECOMMENDED** to execute the following commands in a `screen` session as some of them may take a long time to complete.

- Create the db dir
```bash
mkdir -p /mnt/efs/databases/eggNOG/v5.0.2
```

- Launch the docker image with the EFS db dir as `/db`
```bash
docker container run -it --rm -v /mnt/efs/databases/eggNOG/v5.0.2:/db -v $PWD:$PWD -w $PWD eggnog:2.1.12 bash
```

- Download the database (add `-f` to overwrite existing dbs):
```bash
download_eggnog_data.py -y -M -F
```


## Test

```bash
mkdir -p test/outputs

docker container run --rm -v /mnt/efs/databases/eggNOG/v5.0.2:/db -v $PWD:$PWD -w $PWD eggnog:2.1.12 emapper.py -i test/inputs/proteins.faa -o test/outputs/proteins --cpu 0 --override
```


```bash
mkdir outputs logs
cut -f 2 -d , hCom2.aurum_seedfile.csv | tail -n +2 | parallel -j 10 --joblog "hCom2.joblog" "mkdir -p outputs/{} && docker container run --rm -v /mnt/efs/databases/eggNOG/v5.0.2:/db -v $PWD:$PWD -w $PWD eggnog:2.1.12 emapper.py -i proteins/{}.faa -o outputs/{}/{} --cpu 4 --override &> logs/{}.log"
```