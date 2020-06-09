#!/bin/bash
docker run -it --rm \
-e CI=true\
-v "$PWD":/app \
sirasaoa/build-android \
sh -c "$@"
