#!/bin/bash

parse_rpm_filename() {
    local filename="$1"
    local pattern='^(.+?)-(\d+(?:\.\d+)?)'

    if [[ "$filename" =~ $pattern ]]; then
        local package_name="${BASH_REMATCH[1]}"
        local version="${BASH_REMATCH[2]}"
        echo "$package_name"
        echo "$version"
    else
        echo "Filename should be in specific format, cannot parse."
    fi
}

filename="accountsservice-0.6.55-9.el9.src.rpm"
package_name=$(parse_rpm_filename "$filename")
version=$(parse_rpm_filename "$filename")

echo "Package Name: $package_name"
echo "Version: $version"

