#! /bin/bash

set -ex

package=$1
base_image=$2
input_file="/root/runtime_binaries.txt"
output_file="/root/runtime_applications.yaml"

elementIn () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

if [[ $package != '' ]]; then

  ldd "$package" > "$input_file"
  echo "base_packages:" > "$output_file"
  applications_array=$()

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
        if (! elementIn "$application" "${applications_array[@]}"); then
          echo "$application" | sed 's/\(.*\)-\([0-9].*\)/  - \1: \2/' >> "$output_file"
          applications_array+=($application)
        fi
      elif [[ $base_image == "centos" ]]; then
        application=$(rpm -qf "$var")
        if (! elementIn "$application" "${applications_array[@]}"); then
          if [[ $application == *"fc"* ]]; then
            echo "$application" | sed s'/\(.*\)-\([0-9]*\(\.[0-9]*\)*-[0-9].*\)\.fc.*/  - \1: \2/' >> "$output_file"
          elif [[ $application == *"el"* ]]; then
            echo "$application" | sed s'/\(.*\)-\([0-9]*\(\.[0-9]*\)*-[0-9].*\)\.el.*/  - \1: \2/' >> "$output_file"
          fi
          applications_array+=($application)
        fi
      elif [[ $base_image == "debian" ]]; then
        application=$(dpkg -S "$var" | awk '{print $1}' | sed s'/:$//')
        if [[ $application == '' ]]; then
          application=$(dpkg -S "/usr$var" | awk '{print $1}' | sed s'/:$//')
        fi
        if (! elementIn "$application" "${applications_array[@]}"); then
          version=$(apt-cache policy "$application" | grep 'Installed' | awk '{print $2}')
          if [[ $version == *"ubuntu"* ]]; then
            version=$(echo "$version" | sed s'/ubuntu.*//')
          fi
          echo "  - $application: $version" >> "$output_file"
          applications_array+=($application)
        fi
      fi
    fi
  done < "$input_file"

fi
