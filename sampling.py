import os
import re
import requests
from collections import Counter
from urllib.parse import urljoin
import random

def get_all_files_recursively(directory):
    file_paths = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            # 构造完整的文件路径
            full_path = os.path.join(root, file)
            file_paths.append(file)
    return file_paths

# 指定目录路径
directory_path = '/home/jl/test/rpm2euler/fedora39_spec/SPECS'
# 递归获取所有文件
all_files = get_all_files_recursively(directory_path)
rpm_files = all_files

# 初始化一个计数器
lang_counter = Counter()
total = 0
sample_num = 1000

class_item = {}

# 遍历每个src.rpm文件
for rpm_file in rpm_files:
    rpm_content = rpm_file
    total = total + 1

    flag = False
    # 搜索语言关键字
    for lang in ["python", "perl", "ruby", "go", "rust", "c-", "c++", "java", "javascript", "js", "cpp"]:
        # print(rpm_file)
        if rpm_file.startswith(lang):
            if lang == "c++" or lang == "c-" or lang == "cpp":
                lang = "c/cpp"
            if lang == "js":
                lang = "javascript"
            lang_counter[lang] += 1
            flag = True
            if lang not in class_item.keys():
                class_item[lang] = [rpm_file]
            else:
                class_item[lang].append(rpm_file)
            break
    if not flag:
        lang = "other"
        lang_counter[lang] += 1
        if lang not in class_item.keys():
            class_item[lang] = [rpm_file]
        else:
            class_item[lang].append(rpm_file)
        

print(f"total rpm num: {total}")

sample_item = []
# 打印结果
for lang, count in lang_counter.items():
    get_num = int(float(count * sample_num / total) + 0.5)
    print(f"{lang}: {count} sample_num: {get_num}")
    selected_item = random.sample(class_item[lang], get_num)
    sample_item.extend(selected_item)

# 将结果写入到文件中
with open('fedora39-sample1000.txt', 'w', encoding='utf-8') as file:
    for rpm in sorted(sample_item):
        file.write(rpm + '\n')

