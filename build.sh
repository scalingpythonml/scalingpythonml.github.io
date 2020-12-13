#!/bin/bash
set -ex
bundle exec jekyll build --incremental -d docs/
cp *.png *.ico CNAME docs/
