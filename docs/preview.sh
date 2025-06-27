#!/bin/bash

# conda run -n jekyll_env --live-stream \
# bundle exec jekyll serve

source $(conda info --base)/etc/profile.d/conda.sh && conda activate jekyll_env

bundle exec jekyll serve

conda deactivate
