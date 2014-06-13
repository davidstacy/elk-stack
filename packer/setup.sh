#!/bin/bash -v

wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" > /etc/apt/sources.list.d/logstash.list
echo "deb http://packages.elasticsearch.org/elasticsearch/1.1/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list

apt-get -y update
apt-get -y install language-pack-en openjdk-7-jre-headless logstash elasticsearch nginx

/usr/share/elasticsearch/bin/plugin --install elasticsearch/elasticsearch-cloud-aws/2.1.1
/usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head
/usr/share/elasticsearch/bin/plugin --install lukas-vlcek/bigdesk
/usr/share/elasticsearch/bin/plugin --install karmi/elasticsearch-paramedic
/usr/share/elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ

cat << EOF > /etc/init/elasticsearch.conf
start on runlevel [2345]
stop on runlevel [016]

chdir /usr/share/elasticsearch

limit nofile 65536 65536
limit memlock unlimited unlimited
limit nproc 4096 4096

#stderr goes to start starting console until it closes
console output

#respawn

script
  bin/elasticsearch
end script
EOF

cd /usr/share/nginx/html
wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz
tar zxvf kibana-latest.tar.gz
mv kibana-latest kibana

cat << EOF > /etc/init/nginx.conf
start on runlevel [2]
stop on runlevel [016]
console owner
exec /opt/nginx/sbin/nginx -c /opt/nginx/conf/nginx.conf -g "daemon off;"
respawn 
EOF

#start logstash
#start elasticsearch
#start nginx

