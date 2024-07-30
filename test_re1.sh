#filename="accountsservice-0.6.55-9.el9.src.rpm"
filename="ansible-pcp-2.3.0-1.el9.src.rpm"

package_name=$(echo "$filename" | cut -d'-' -f1)
version=$(echo "$filename" | cut -d'-' -f2 | cut -d'.' -f1)

echo "Package Name: $package_name"
echo "Version: $version"

