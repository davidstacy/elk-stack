#!/usr/bin/env bash

# Usage: delete-old-indexes.sh [DAYS] [HOST]

DAYS=${1:-14}
HOST=${2:-localhost:9200}

THRESHOLD=$(date -d "-$DAYS days" +logstash-%Y.%m.%d)
INDEXES=$(curl -s "$HOST/_aliases" | tr '"' "\n" | grep logstash | sort)

echo "Indexes older than $DAYS days will be deleted"

for INDEX in ${INDEXES[@]}
do
    if [[ $INDEX < $THRESHOLD ]]
    then
        echo "Deleting $INDEX..."
        curl -X DELETE "$HOST/$INDEX" >& /dev/null
    fi
done