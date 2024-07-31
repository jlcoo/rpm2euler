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
BUILD_SPEC="$WORKDIR/SPECS"

# 检查目录是否存在
if [ ! -d "$LOG_DIR" ]; then
    # 如果目录不存在，则创建目录
    mkdir -p "$LOG_DIR"
    echo "Directory created: $LOG_DIR"
fi

# 遍历目录中的所有.src.rpm文件并构建
for package in "$SRC_RPM_DIR"/*.src.rpm
do
    if [ -f "$package" ]; then
        pkg_name=`python match.py $package`
        if [ -f "$BUILD_SPEC/$pkg_name.spec" ]; then
            success=`grep "编译构建软件包成功" ~/rpmbuild/logs/$pkg_name.log | wc -l`
            if [ "$success" -eq 1 ]; then
                echo "$package 已经构建成功，不用重复构建"
                continue
            fi
        fi
        echo "正在构建 $(basename "$package")..."

        ./build_one_rpm.sh $package 2>&1 | tee "$LOG_DIR/$pkg_name.log"
    fi
done

# 测试软件包的服务启停
# (此处 vim 没有服务启动脚本，故略过)

# 准备上传到 src-oepkgs 仓库的 spec 文件和源码文件
# 将 spec 文件和源码文件上传到 src-oepkgs 仓库 (具体步骤参考 rpm 包构建及建仓流程)
# 这里假设已经有上传到 src-oepkgs 仓库的权限和工具

# 进入 src-oepkgs 仓库目录
# cd /path/to/src-oepkgs-repo

# 上传 spec 文件和源码文件
# cp ${WORKDIR}/SPECS/vim.spec /path/to/src-oepkgs-repo/
# cp ${WORKDIR}/SOURCES/* /path/to/src-oepkgs-repo/

echo "编译和测试完成，请手动将 spec 文件和源码文件上传到 src-oepkgs 仓库中。"
