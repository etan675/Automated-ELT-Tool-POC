## Singer ETL demo - How to extract transactional data for data warehousing.

version 0.0.1

### What is this repository for? ###

* As a data engineering team, we want a bulk-data movement solution that enforces standards, which will play nice as we move
to kafka and microservices.
* This project uses Singer.io, an open-source ETL tool to ingest data from our transactional DBs (```mysql``` and ```hubspot```) and converts them into a format suitable for data warehousing, this is essentially the E (extract) and T (transform) of ETL.
* We will use Singer.io's 'taps' to set up this pipeline, which involve a few steps:
  - The SQL data is fed into Singer and transformed into Singer metadata.
  - Singer loads this metadata into one of its 'target' applications, which transforms and ouputs it to a csv file.
  - Finally, the csv data is converted into parquet format with a Python script for efficient columnar storage.

### How do I get set up? ###

* Have Docker and Python installed
* Clone the repo
* Build the docker images for each of the Singer services, and the sample MySQL server.
  - to do this, use the ```make build``` commands in each respective directory.
* In each respective directory, configure your Singer tap's connection settings to your local data source (MySQL or hubspot db) in the ```config.json```.
  - Note that 'tap_mysql' already has a default connection set up to the sample db host, and the data has already been replicated as an example.

### How to run the pipeline? ###

* In the project root, run ```docker compose up -d``` to start the service containers
* Run ```bash main.sh <SOURCE> discover``` to generate the Singer metadata, where ```<SOURCE>``` is either ```'mysql'``` or ```'hubspot'```
* In the ```properties.json``` file of the source (tap) directory, there should now be metadata generated for the db streams discovered, find the streams/properties that you want to replicate, and add a ```"selected": true```. Refer to the singer docs at https://github.com/singer-io/getting-started/blob/master/docs/DISCOVERY_MODE.md for more details about configuring data replication.
  - Note that this step should probably be automated in a real ETL pipeline.
* Once the desired streams/properties have been selected, run ```bash main.sh <SOURCE> extract```, this will load the data into a new csv file (inside the ```target_csv/Csvs``` dir), as well as generate the corresponding parquet file for the data.
