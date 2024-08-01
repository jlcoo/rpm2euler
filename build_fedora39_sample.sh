#!/bin/bash

# 检查是否输入了参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <src-rpm>"
    exit 1
fi

# 定义变量
SRC_RPM="$1"
# 指定要检查的目录路径
WORKDIR="$HOME/rpmbuild"
LOG_DIR="$WORKDIR/fedora39_sample_logs"
BUILD_SPEC="$WORKDIR/SPECS"

# 检查目录是否存在
if [ ! -d "$LOG_DIR" ]; then
    # 如果目录不存在，则创建目录
    mkdir -p "$LOG_DIR"
    echo "Directory created: $LOG_DIR"
fi

while read -r spec_fine; do
    pkg_name=`basename $spec_fine .spec`
    success=`grep "编译构建软件包成功" $LOG_DIR/$pkg_name.log | wc -l`
    if [ "$success" -eq 1 ]; then
        echo "$spec_fine 已经构建成功，不用重复构建"
        continue
    fi
    ./build_one_spec.sh $package 2>&1 | tee "$LOG_DIR/$pkg_name.log"
done < $SRC_RPM

echo "脚本执行完成"
