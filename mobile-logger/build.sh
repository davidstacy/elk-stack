#!/usr/bin/env bash

set -e

ELASTICSEARCH_VERSION=1.2.1
KIBANA_VERSION=3.1.0

[ -d target ] && rm -rf target
mkdir target
cd $(dirname $0)/target

mkdir downloads
mkdir -p packages/mobile-logger

# elasticsearch
if wget -O downloads/elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
then
    tar xfv downloads/elasticsearch.tar.gz -C downloads
    mv downloads/elasticsearch-* downloads/elasticsearch
    ./downloads/elasticsearch/bin/plugin -install mobz/elasticsearch-head
    ./downloads/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.1.1
    cp ../elasticsearch.yml downloads/elasticsearch/config
    cp ../logging.yml downloads/elasticsearch/config
    cp ../elasticsearch.in.sh downloads/elasticsearch/bin
    cp ../elasticsearch.conf downloads
else
    echo 'Failed to download Elasticsearch'
    exit 1
fi

# kibana
if wget -O downloads/kibana.tar.gz https://download.elasticsearch.org/kibana/kibana/kibana-$KIBANA_VERSION.tar.gz
then
    tar xfv downloads/kibana.tar.gz -C downloads
    mv downloads/kibana-* downloads/kibana
    cp ../nginx.conf downloads
    cp ../nginx-sites.conf downloads
else
    echo 'Failed to download Kibana'
    exit 1
fi

cp ../scripts/delete-old-indexes.sh downloads

tar czfv packages/mobile-logger/mobile-logger.tar.gz -C downloads elasticsearch elasticsearch.conf kibana nginx.conf nginx-sites.conf delete-old-indexes.sh
cp ../deploy.json .
zip -rv artifacts.zip packages/ deploy.json

echo "##teamcity[publishArtifacts '$(pwd)/artifacts.zip => .']"
