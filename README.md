ELK Stack
=========

An [ELK stack](http://www.elasticsearch.org/webinars/elk-stack-devops-environment/) is a stand-alone log management stack based on Elasticsearch, Logstash and Kibana that can be easily and quickly deployed into any AWS EC2 account .


Architecture
------------

Each of your application servers that you want to send to Elasticsearch will need to run the Logstash agent, which will tail any log file on that machine. For example, a Play applicaiton request log file. and ship them to Logstash servers. The logstash servers receive the logs and index them in Elasticsearch. Kibana is used to visualise the logs in a web client.

The Logstash instances sit behind a load balancer. The logstash agents point to this.

The Elasticsearch instances also sit behind a load balancer. The logstash servers and Kibana web client point to this.

Deploying
---------

Deploy the stack using the AWS console to launch a CloudFormation stack or use the command-line like so:

    $ pip install awscli
    $ aws cloudformation create-stack --stack-name myteststack --template-body file:////home//local//test//sampletemplate.json

The build server runs `build.sh`, which downloads each of these elements and adds in our various configuration files, producing a deployable artifact. This script is where the various versions are specified.

You should deploy semi-manually, the same way we do the main Elasticsearch builds. First, check the Elasticsearch cluster has a green state. Use Riff Raff to do an 'artifact upload only' deploy, which uploads the artifact to S3. Then use the AWS CLI to double the desired capacity, which will prompt Autoscaling to bring up new machines. Those machines will automatically download and run the latest artifact. Once those machines have joined the Elasticsearch cluster, and it's back to a green state, you can safely terminate the old machines. Celebrate!
