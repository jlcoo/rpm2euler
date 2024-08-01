#!/bin/bash

# 检查是否输入了参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <src-rpm>"
    exit 1
fi

# 定义变量
SRC_RPM="$1"
package=$SRC_RPM
WORKDIR="$HOME/rpmbuild"

#rpm -i "$package"
if [ -f "$WORKDIR/SPECS/$package" ]; then
    echo "-----------不用再调用 rpm -i-------------"
    #pkg_name=`python match.py $package`
    # 安装 .src.rpm 文件中的构建依赖项
    sudo dnf builddep -y ${WORKDIR}/SPECS/$package
    if [ $? -eq 0 ]; then
        echo "$(basename "$package") builddep 成功"
    else
        echo "$(basename "$package") builddep 失败"
        exit 1
    fi
    # 编译构建软件包
    rpmbuild -ba ${WORKDIR}/SPECS/$package
    if [ $? -eq 0 ]; then
        echo "$(basename "$package") 编译构建软件包成功"
    else
        echo "$(basename "$package") 编译构建软件包失败"
        exit 1
    fi
fi
