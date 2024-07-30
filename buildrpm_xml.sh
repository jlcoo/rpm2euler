#!/bin/bash

# 检查是否输入了参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <src-rpm>"
    exit 1
fi

# 定义变量
SRC_RPM="$1"
WORKDIR="$HOME/rpmbuild"

# 指定src.rpm包所在的目录
SRC_RPM_DIR="."

# 指定要检查的目录路径
LOG_DIR="$WORKDIR/logs"

# 检查目录是否存在
if [ ! -d "$LOG_DIR" ]; then
    # 如果目录不存在，则创建目录
    mkdir -p "$LOG_DIR"
    echo "Directory created: $LOG_DIR"
fi

while read -r rpm_file; do
    package_xml="https://mirrors.ustc.edu.cn/fedora/releases/40/Everything/source/tree/$rpm_file"
    package=$(basename "$SRC_RPM")
    if [ -f "$package" ]; then
        echo "正在构建 $(basename "$package")..."
        pkg_name=`python match.py $package`

        ./build_one_xml_rpm.sh $package_xml 2>&1 | tee "$LOG_DIR/$pkg_name.log"
    fi
done < $SRC_RPM

