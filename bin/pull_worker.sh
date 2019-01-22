#!/bin/bash

TAG=$(grep -e 'mumuki/mumuki-junit-worker:[0-9]*\.[0-9]*' ./lib/java_runner.rb -o | tail -n 1)

echo "Pulling $TAG..."
docker pull $TAG
