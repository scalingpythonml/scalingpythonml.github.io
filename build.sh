#!/bin/bash
set -ex
bundle exec jekyll build --incremental -d docs/ -b https://scalingpythonml.com/
cp *.png *.ico CNAME docs/
