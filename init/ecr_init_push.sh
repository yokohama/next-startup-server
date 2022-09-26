#!/bin/bash
#
# 事前に、.evnファイルに、
# AWS_REGIONとAWS_ACCOUNT_IDを記入しておく。
#

AWS_REGION=`cat .env.development | grep AWS_REGION | awk -F'[=]' '{print $2}'`
AWS_ACCOUNT_ID=`cat .env.development | grep AWS_ACCOUNT_ID | awk -F'[=]' '{print $2}'`

IMAGE_ID=`docker images | grep next-startup | awk '{print $3}'`

REPO_PREFIX=ecr-$1

if [ "$1" = "" ]; then
  echo '[Error]'
  echo '- env param required. [ local | dev | prod ]'
  echo '- ex) ./init/ecr_init_push.sh local'
  exit 1
fi

# ECRに対してDockerクライアント認証をする。
aws ecr get-login-password --region ${AWS_REGION} | 
  docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# リポジトリのURIを取得
REPO_URI=`aws ecr describe-repositories | 
  jq -r '.repositories[].repositoryUri' | 
  grep ${REPO_PREFIX}`

# イメージにECR用のタグを付ける
#docker tag ${IMAGE_ID} ${REPO_URI}:latest

echo ${REPO_URI}

# build & タグ付け
DOCKER_BUILDKIT=1 docker build . -t ${REPO_URI}

# イメージをERCRにpush
docker push ${REPO_URI}:latest
