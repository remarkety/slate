#!/usr/bin/env bash
echo "Building..."
bundle exec middleman build --clean
if [ $? -eq 0 ]; then
    echo "Synching to S3 bucket"
    cd build
    aws s3 sync . s3://docs-api-v1.remarkety.com/
    if [ $? -eq 0 ]; then
        echo "Success!"
    else
        echo "Failed synching to S3"
    fi
else
    echo "Build failed."
fi