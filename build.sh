#!/bin/bash
set -ex
bundle exec jekyll build -d docs/ -b /
cp *.png *.ico CNAME docs/
