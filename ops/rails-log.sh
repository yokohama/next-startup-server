#!/bin/bash
#
# Usage: ./ops/rails-log.sh [ local | dev | prod ]
# params was required.
#

LOG_GROUP_ENV=$1
LOG_PREFIX=NextStartupStack-${LOG_GROUP_ENV}-TaskDefinitionContainerLogGroup

LOG_GROUP_NAME=`aws logs describe-log-groups --query 'logGroups[*].logGroupName' | 
  jq -r '.[]' | 
  grep ${LOG_PREFIX}`

echo '############'
echo $LOG_GROUP_NAME
echo '############'

aws logs tail --since 3h --follow ${LOG_GROUP_NAME}
