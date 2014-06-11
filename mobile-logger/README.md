Flogger
========

Flogger machines run all the components required to store and visualise frontends diagnostic logs.
* Elasticsearch
* Kibana (via Nginx)


Architecture
------------

Each of frontend diagnostic machines run the Logstash agent, which tails the Play log files on that machine, and ships them over to the Elastic search instance inside Flogger.

The machines also run Nginx which is used to serve up Kibana, a nice interface to the whole thing.

The Flogger instances sit behind a load balancer. The Logstash agents point to a this, which should distribute both the indexing load and the Elasticsearch cluster itself.

It runs on EC2 machines through Autoscaling in Cloudformation. They run Ubuntu 12.04 LTS (the Precise Pangolin). You can SSH onto these machines with the `ubuntu` user, given you have our keyfile. Most of our things live in `/home/flogger/`.

All of the components are run through Upstart.


Building and deploying
----------------------

The build server runs `build.sh`, which downloads each of these elements and adds in our various configuration files, producing a deployable artifact. This script is where the various versions are specified.

You should deploy semi-manually, the same way we do the main Elasticsearch builds. First, check the Elasticsearch cluster has a green state. Use Riff Raff to do an 'artifact upload only' deploy, which uploads the artifact to S3. Then use the AWS CLI to double the desired capacity, which will prompt Autoscaling to bring up new machines. Those machines will automatically download and run the latest artifact. Once those machines have joined the Elasticsearch cluster, and it's back to a green state, you can safely terminate the old machines. Celebrate!