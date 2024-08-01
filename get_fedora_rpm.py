import os
import requests
from concurrent.futures import ThreadPoolExecutor
from urllib.parse import urljoin
from bs4 import BeautifulSoup

BASE_URL = "https://dl.fedoraproject.org/pub/fedora/linux/releases/39/Everything/source/tree/Packages/"
OUTPUT_DIR = "fedora_src_rpms"

def download_file(url, local_filename):
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    print(f"Downloaded: {local_filename}")

def get_subdirs(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    return [a['href'] for a in soup.find_all('a') if a['href'].endswith('/') and len(a['href']) == 2]

def get_src_rpms(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    return [a['href'] for a in soup.find_all('a') if a['href'].endswith('.src.rpm')]

def main():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    subdirs = get_subdirs(BASE_URL)

    with ThreadPoolExecutor(max_workers=5) as executor:
        for subdir in subdirs:
            subdir_url = urljoin(BASE_URL, subdir)
            src_rpms = get_src_rpms(subdir_url)

            for src_rpm in src_rpms:
                file_url = urljoin(subdir_url, src_rpm)
                local_filename = os.path.join(OUTPUT_DIR, src_rpm)
                executor.submit(download_file, file_url, local_filename)

if __name__ == "__main__":
    main()
