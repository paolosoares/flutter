#!/bin/bash

set -ex

export PATH="$PWD/bin:$PWD/bin/cache/dart-sdk/bin:$PATH"

LCOV_FILE=./packages/flutter/coverage/lcov.info

if [ "$TRAVIS_OS_NAME" = "linux" ] && \
   [ "$SHARD" = "coverage" ] && \
   [ "$TRAVIS_PULL_REQUEST" = "false" ] && \
   [ "$TRAVIS_BRANCH" = "master" ] && \
   [ -f "$LCOV_FILE" ]; then
  GSUTIL=$HOME/google-cloud-sdk/bin/gsutil
  GCLOUD=$HOME/google-cloud-sdk/bin/gcloud

  $GCLOUD auth activate-service-account --key-file ../gcloud_key_file.json
  STORAGE_URL=gs://flutter_infra/flutter/coverage/lcov.info
  $GSUTIL cp $LCOV_FILE $STORAGE_URL

  (cd packages/flutter && coveralls-lcov coverage/lcov.info)
fi

if [ "$TRAVIS_OS_NAME" = "linux" ] && \
   [ "$SHARD" = "docs" ]; then
  # generate the API docs, upload them
  ./dev/bots/docs.sh
fi
