#!/bin/bash

# 检查是否输入了参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <src-rpm>"
    exit 1
fi

# 定义变量
SRC_RPM="$1"
# 指定要检查的目录路径
LOG_DIR="./logs"

# 检查目录是否存在
if [ ! -d "$LOG_DIR" ]; then
    # 如果目录不存在，则创建目录
    mkdir -p "$LOG_DIR"
    echo "Directory created: $LOG_DIR"
fi

while read -r rpm_file; do
    copr build centos10 $rpm_file --nowait
done < $SRC_RPM
