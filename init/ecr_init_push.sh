#!/bin/bash

REGION=$1
AWS_ACCOUNT_ID=$2

REPO_PREFIX=nextstartup-local
#REPO_PREFIX=nextstartup-dev
#REPO_PREFIX=nextstartup-prod

# ECRに対してDockerクライアント認証をする。
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# リポジトリのURIを取得
#REPO_URI=`aws ecr describe-repositories | jq -r '.repositories[].repositoryUri' | grep ${REPO_PREFIX}`

# イメージにECR用のタグを付ける
#docker tag ${REPO_URI}:latest

# イメージをERCRにpush
#docker push ${REPO_URI}:latest
