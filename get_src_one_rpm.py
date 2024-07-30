import os
import re
import requests
from bs4 import BeautifulSoup
from packaging.version import parse
from packaging.version import Version

# Base URL of the CentOS Stream source packages directory
base_url = "https://mirror.stream.centos.org/9-stream/AppStream/source/tree/Packages/"

# Directory to save downloaded files
download_dir = "downloaded_one_packages"
if not os.path.exists(download_dir):
    os.makedirs(download_dir)

def download_file(url, dest_folder):
    local_filename = os.path.join(dest_folder, url.split('/')[-1])
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    return local_filename

def get_src_rpm_links(base_url):
    response = requests.get(base_url)
    response.raise_for_status()
    
    soup = BeautifulSoup(response.text, 'html.parser')
    links = soup.find_all('a')
    
    src_rpm_links = [base_url + link.get('href') for link in links if link.get('href').endswith('.src.rpm')]
    return src_rpm_links

def parse_rpm_filename(filename):
    """
    Parse RPM filename to extract package name, version, and release.
    """
    pattern = r'^(.*?)-(\d+(?:\.\d+)*(?:-\d+)?(?:\.\w+)?)'
    match = re.match(pattern, filename)
    if match:
        package_name = match.group(1)
        version = match.group(2)
        return package_name, version
    return None, None

def filter_latest_versions(src_rpm_links):
    """
    Filter the list of src.rpm links to keep only the latest version for each package.
    """
    latest_versions = {}
    for link in src_rpm_links:
        filename = link.split('/')[-1]
        name, version = parse_rpm_filename(filename)
        print(f"Found name {name} {version} src.rpm files.")
        if name:
            if name not in latest_versions or version > latest_versions[name][1]:
                latest_versions[name] = (link, version)
    return [info[0] for info in latest_versions.values()]

def main():
    src_rpm_links = get_src_rpm_links(base_url)
    print(f"Found {len(src_rpm_links)} src.rpm files.")
    
    latest_src_rpm_links = filter_latest_versions(src_rpm_links)
    print(f"Downloading {len(latest_src_rpm_links)} latest src.rpm files.")
    
    for link in latest_src_rpm_links:
        print(f"Downloading {link} ...")
        download_file(link, download_dir)
        print(f"Downloaded {link}")

if __name__ == "__main__":
    main()