#!/bin/bash
set -e

# 设置环境变量
export CC=/opt/homebrew/opt/llvm/bin/clang
export CXX=/opt/homebrew/opt/llvm/bin/clang++
export PROJECT_ROOT=$(pwd)
export THIRD_PARTY_DIR=${PROJECT_ROOT}/thirdparty
export INSTALL_DIR=${THIRD_PARTY_DIR}/installed

# 打印环境信息
echo "Build configuration:"
echo "CC: ${CC}"
echo "CXX: ${CXX}"
echo "PROJECT_ROOT: ${PROJECT_ROOT}"
echo "THIRD_PARTY_DIR: ${THIRD_PARTY_DIR}"
echo "INSTALL_DIR: ${INSTALL_DIR}"

# 清理旧的构建文件
echo "Cleaning old build files..."
rm -rf build thirdparty/installed thirdparty/src

# 创建必要的目录
echo "Creating directories..."
mkdir -p ${INSTALL_DIR}/{lib,include,lib/cmake}
mkdir -p build/third_party_build

# 首先构建第三方库
echo "Building third party libraries..."
cd build/third_party_build

echo "Configuring third party libraries..."
cmake ${PROJECT_ROOT}/thirdparty \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      -DCMAKE_PREFIX_PATH=${INSTALL_DIR} \
      -DCMAKE_VERBOSE_MAKEFILE=ON

echo "Building third party libraries..."
cmake --build . --verbose

# 检查构建是否成功
if [ $? -ne 0 ]; then
    echo "Failed to build third party libraries"
    echo "Checking build logs..."
    for lib in boost gflags double-conversion folly; do
        log_file="CMakeFiles/${lib}/${lib}_external-prefix/src/${lib}_external-configure-Debug.log"
        if [ -f "$log_file" ]; then
            echo "=== $lib configuration log ==="
            cat "$log_file"
        fi
    done
    exit 1
fi

# 检查安装的库文件
echo "Checking installed libraries..."
ls -la ${INSTALL_DIR}/lib/
echo "Checking installed headers..."
ls -la ${INSTALL_DIR}/include/

# 返回到主构建目录
cd ${PROJECT_ROOT}

# 构建主项目
echo "Building main project..."
rm -rf build/main
mkdir -p build/main
cd build/main

cmake ../.. \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_PREFIX_PATH=${INSTALL_DIR} \
      -DCMAKE_VERBOSE_MAKEFILE=ON

cmake --build . --verbose

# 检查构建结果
if [ $? -eq 0 ]; then
    echo "Build completed successfully"
    echo "Final library check:"
    ls -la ${INSTALL_DIR}/lib/
else
    echo "Build failed"
    echo "Checking CMake error logs..."
    if [ -f "CMakeFiles/CMakeError.log" ]; then
        cat CMakeFiles/CMakeError.log
    fi
    exit 1
fi