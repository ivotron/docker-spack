#! /bin/bash

set -ex

package=$1
base_image=$2
input_file="/root/runtime_binaries.txt"
output_file="/root/runtime_applications.yaml"

if [[ $package != '' ]]; then

  ldd "$package" > "$input_file"
  echo "base_packages:" > "$output_file"

  while IFS= read -r line
  do
    if [[ $line != *"linux-vdso"* ]]; then

      if [[ $line == *"=>"* ]]; then
        var=$(echo "$line" | awk '{print $3}')
      else
        var=$(echo "$line" | awk '{print $1}')
      fi

      echo "$var"

      if [[ $base_image == "alpine" ]]; then
        application=$(apk info --who-owns "$var" | awk '{print $5}')
        echo "$application"
        echo "$application" | sed 's/\(.*\)-\([0-9].*\)/  - \1: \2/' >> "$output_file"
      elif [[ $base_image == "centos" ]]; then
        application=$(rpm -qf "$var")
        if [[ $application == *"fc"* ]]; then
          echo "$application" | sed s'/\(.*\)-\([0-9]*\(\.[0-9]*\)*-[0-9].*\)\.fc.*/  - \1: \2/' >> "$output_file"
        elif [[ $application == *"el"* ]]; then
          echo "$application" | sed s'/\(.*\)-\([0-9]*\(\.[0-9]*\)*-[0-9].*\)\.el.*/  - \1: \2/' >> "$output_file"
        fi
      elif [[ $base_image == "debian" ]]; then
        application=$(dpkg -S "$var" | awk '{print $1}' | sed s'/:$//')
        if [[ $application == '' ]]; then
          application=$(dpkg -S "/usr$var" | awk '{print $1}' | sed s'/:$//')
        fi
        version=$(apt-cache policy "$application" | grep 'Installed' | awk '{print $2}')
        if [[ $version == *"ubuntu"* ]]; then
          version=$(echo "$version" | sed s'/ubuntu.*//')
        fi
        echo "  - $application: $version" >> "$output_file"
      fi
    fi
  done < "$input_file"

  rm "$input_file"

fi
