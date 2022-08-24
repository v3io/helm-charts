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
#/bin/bash
for f in stable/*/Chart.yaml ; do
  if [[ -f $f ]]; then
    current_version=$(cat $f | grep "version:" | sed 's/[^0-9\.]//g')
    if [[ ! -z $current_version ]]; then
      result=$(echo $current_version | awk -F '-' '{print $1}' | sed "s/v//" | cut -d. -f '1 2' | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
      new_version="${result}.0"
      echo "${current_version} -> ${new_version}"
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|version.*|version: ${new_version}|" "${f}"
      else
        sed -i "s|version.*|version: ${new_version}|" "${f}"
      fi
    fi
  fi
done
