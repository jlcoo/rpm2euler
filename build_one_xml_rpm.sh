#!/bin/bash

# 检查是否输入了参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <src-rpm>"
    exit 1
fi

# 定义变量
SRC_RPM="$1"
# 使用basename命令获取URL的最后一部分，即文件名
package=$(basename "$SRC_RPM")
WORKDIR="$HOME/rpmbuild"

rpm -i "$SRC_RPM"
if [ $? -eq 0 ]; then
    echo "$(basename "$package") rpm -i 成功"
else
    echo "$(basename "$package") rpm -i 失败"
    exit 1
fi
echo "------------------------"
pkg_name=`python match.py $package`
# 安装 .src.rpm 文件中的构建依赖项
sudo dnf builddep -y ${WORKDIR}/SPECS/$pkg_name.spec
if [ $? -eq 0 ]; then
    echo "$(basename "$package") builddep 成功"
else
    echo "$(basename "$package") builddep 失败"
    exit 1
fi
# 编译构建软件包
rpmbuild -ba ${WORKDIR}/SPECS/$pkg_name.spec
if [ $? -eq 0 ]; then
    echo "$(basename "$package") 编译构建软件包成功"
else
    echo "$(basename "$package") 编译构建软件包失败"
    exit 1
fi
# 兼容性测试
# 安装构建的软件包
# sudo yum localinstall -y ${WORKDIR}/RPMS/aarch64/$pkg_name*.rpm

# # 测试软件包的安装、卸载
# sudo yum remove -y $pkg_name