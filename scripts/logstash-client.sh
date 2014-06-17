#!/bin/bash

bin/logstash -e 'input { stdin {} } output { stdout {} tcp { host => "@@LOGSTASH_HOST" port => 6379 } }'
