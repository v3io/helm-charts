# Copyright 2017 Iguazio
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#!/usr/bin/env bash
set -e

helm="${HELM:-helm}"
declare -a repo_dirs=("demo" "incubator" "stable")
${helm} version

for repo_dir in "${repo_dirs[@]}"; do
  for dir in ${repo_dir}/*/; do
    if [ -d ${dir} ]; then
      echo "Helm Linting - ${dir}:"
      ${helm} lint ${dir}
    fi
  done
done
