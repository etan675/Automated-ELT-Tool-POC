# README #

Singer ETL POC

version 0.0.1

### What is this repository for? ###

* As a data engineering team, we want a bulk-data movement solution that enforces standards, which will play nice as we move
to kafka and microservices. <br />
* This project uses Singer's pre-built taps to set up connections with our source/transactional DBs (currently supports ```mysql``` and ```hubspot```)
* The source data is extracted, transformed into Singer metadata, and is then loaded into one of Singer's 'target' applications, which reads the metadata and writes the output into a csv file (our destination).
* Finally, the migrated data is converted into parquet format for more efficient columnar storage and analytical processing.  

### How do I get set up? ###

* Clone the repo
* Build the docker images for each of the Singer services as well as the sample mysql server host, using the ```make build``` commands in each respective directory
* Configure your taps' connection settings in the ```config.json``` files in each respective directory, note that 'tap_mysql' already has a default connection set up to the sample db host, and the data has already been replicated as an example

### How to run the ETL process? ###

* In the project root, run ```docker compose up -d``` to start the service containers
* Run ```bash main.sh <SOURCE> discover``` to generate the Singer metadata, where ```<SOURCE>``` is either 'mysql' or 'hubspot'
* In the ```properties.json``` file of the source (tap) directory, there should now be metadata generated for the db streams discovered, find the streams/properties that you want to replicate, and add a ```"selected": true``` flag to the appropriate level(s). Refer to the singer docs at https://github.com/singer-io/getting-started/blob/master/docs/DISCOVERY_MODE.md for how to configure the data replication
* Once the desired streams/properties have been selected, run ```bash main.sh <SOURCE> extract```, this will load the data into a new csv file (inside ```target_csv/Csvs``` dir), as well as generate the corresponding parquet file