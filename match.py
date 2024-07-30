import re
import sys

def extract_package_info(rpm_filename):
    pattern = r'^(.*?)-(\d+(?:\.\d+)*(?:-\d+)?(?:\.\w+)?)'
    match = re.match(pattern, rpm_filename)
    if match:
        package_name = match.group(1)
        version = match.group(2)
        return package_name, version
    return None, None

def main():
    filename = sys.argv[1]
    package_name, version = extract_package_info(filename)
    print(package_name)

if __name__ == "__main__":
    main()
