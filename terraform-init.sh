#!/usr/bin/env bash

setVar() {
  if [[ ${var} =~ $1[[:space:]]*=[[:space:]]*\"(.+)\" ]]; then
    export $1="${BASH_REMATCH[1]}"
  fi
}

setVars() {
  setVar aws_profile
  setVar aws_region
  setVar aws_s3_backend_bucket_name
  setVar aws_s3_backend_bucket_key
}

while read var; do setVars; done <aws.auto.tfvars

echo "S3 backend config:"
echo "aws_profile:" ${aws_profile}
echo "aws_region:" ${aws_region}
echo "aws_s3_backend_bucket_name:" ${aws_s3_backend_bucket_name}
echo "aws_s3_backend_bucket_key:" ${aws_s3_backend_bucket_key}
echo

terraform init \
  -backend=true \
  -backend-config="profile=${aws_profile}" \
  -backend-config="region=${aws_region}" \
  -backend-config="bucket=${aws_s3_backend_bucket_name}" \
  -backend-config="key=${aws_s3_backend_bucket_key}"
