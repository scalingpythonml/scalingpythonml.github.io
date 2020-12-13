#!/bin/bash
set -ex
bundle exec jekyll build --incremental -d docs/ -b /
cp *.png *.ico CNAME docs/
