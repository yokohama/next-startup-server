#!/bin/bash
#
# 事前に、.evnファイルに、
# AWS_REGIONとAWS_ACCOUNT_IDを記入しておく。
#

AWS_REGION=`cat .env | grep AWS_REGION | awk -F'[=]' '{print $2}'`
AWS_ACCOUNT_ID=`cat .env | grep AWS_ACCOUNT_ID | awk -F'[=]' '{print $2}'`

REPO_PREFIX=nextstartupstack-local
#REPO_PREFIX=nextstartupstack-dev
#REPO_PREFIX=nextstartupstack-prod

# ECRに対してDockerクライアント認証をする。
aws ecr get-login-password --region ${AWS_REGION} | 
  docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# リポジトリのURIを取得
REPO_URI=`aws ecr describe-repositories | 
  jq -r '.repositories[].repositoryUri' | 
  grep ${REPO_PREFIX}`

# イメージにECR用のタグを付ける
docker tag ${REPO_URI}:latest

# イメージをERCRにpush
docker push ${REPO_URI}:latest
