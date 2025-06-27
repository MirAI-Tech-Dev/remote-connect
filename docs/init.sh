#!/bin/bash

# create test environment with conda

source $(conda info --base)/etc/profile.d/conda.sh && conda activate jekyll_env

bundle init
bundle add jekyll
bundle add jekyll-relative-links
bundle add jekyll-theme-tactile
bundle add jekyll-theme-midnight
bundle install
#bundle exec jekyll new --force --skip-bundle .

conda deactivate
