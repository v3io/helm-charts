#/bin/bash

if [ -z "$1" ]; then
    chart_name="*"
else
    chart_name="$1"
fi

for f in stable/$chart_name/Chart.yaml ; do
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
