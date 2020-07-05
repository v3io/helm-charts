#!/usr/bin/env bash
set -e

declare -a repo_dirs=("demo" "incubator" "stable")

for repo_dir in "${repo_dirs[@]}"; do
  for dir in ${repo_dir}/*/; do
    if [ -d ${dir} ]; then
      echo "Helm Linting - ${dir}:"
      helm lint ${dir}
    fi
  done
done
