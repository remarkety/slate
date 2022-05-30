#!/usr/bin/env bash
echo "Building..."
docker run --rm --name slate -v $(pwd)/build:/srv/slate/build -v $(pwd)/source:/srv/slate/source slatedocs/slate build
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
