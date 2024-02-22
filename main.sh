#!/bin/bash

set -e

SOURCE=$1
ACTION=$2

TAP_MYSQL="tap-mysql"
TAP_HUBSPOT="tap-hubspot"
TARGET_CSV="target-csv"

get_parquet () {
    for FILE in target_csv/Csvs/*; 
    do 
    OUT=$(basename $FILE .csv).parquet;

    if [ ! -f $OUT ];
    then
    python3 convert.py $FILE $OUT;
    fi

    done
}

if [ "$SOURCE" == "mysql" ];
then    
    if [ "$ACTION" == "discover" ];
    then 
        (cd ./tap_mysql && docker exec $TAP_MYSQL /bin/bash tap_mysql.sh discover)   
    elif [ "$ACTION" == "extract" ];
    then 
        (
            cd ./tap_mysql && 
            docker exec $TAP_MYSQL /bin/bash tap_mysql.sh extract 
        ) |
        (
            cd ./target_csv &&
            docker exec -i $TARGET_CSV /bin/bash target_csv.sh
        )
        

        get_parquet
    else 
        echo "Unkonwn action [$ACTION]"
    fi

elif [ "$SOURCE" == "hubspot" ];
then
    if [ "$ACTION" == "discover" ];
    then 
        (cd ./tap_hubspot && docker exec $TAP_HUBSPOT /bin/bash tap_hubspot.sh discover)   
    elif [ "$ACTION" == "extract" ];
    then 
        (
            cd ./tap_hubspot && 
            docker exec $TAP_HUBSPOT /bin/bash tap_hubspot.sh extract 
        ) |
        (
            cd ./target_csv &&
            docker exec -i $TARGET_CSV /bin/bash target_csv.sh
        )
        
        get_parquet
    else 
        echo "Unkonwn action [$ACTION]"
    fi

else 
    echo "Cannot find source [$SOURCE]"
fi
