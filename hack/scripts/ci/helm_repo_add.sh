#!/bin/bash

declare -A REPOS=(
  [helm]=https://charts.helm.sh/stable
  [nuclio]=https://nuclio.github.io/nuclio/charts
  [v3io-stable]=https://v3io.github.io/helm-charts/stable
  [minio]=https://charts.min.io/
)

for repo in "${!REPOS[@]}"; do
  echo helm repo add "$repo" "${REPOS[$repo]}"
done
