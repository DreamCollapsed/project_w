cmake_minimum_required(VERSION 3.28.3)
project(third_party_deps)

# 设置 CMake 策略
cmake_policy(SET CMP0135 NEW)
cmake_policy(SET CMP0074 NEW)

# 包含工具和版本文件
include(${CMAKE_CURRENT_SOURCE_DIR}/versions.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/utils.cmake)

# 设置基础目录
set(thirdparty_src_dir "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(thirdparty_install_dir "${CMAKE_INSTALL_PREFIX}")

# 显示配置信息
message(STATUS "Third party configuration:")
message(STATUS "Source directory: ${thirdparty_src_dir}")
message(STATUS "Install directory: ${thirdparty_install_dir}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "CXX Compiler: ${CMAKE_CXX_COMPILER}")

# 创建必要的目录
execute_process(
    COMMAND ${CMAKE_COMMAND} -E make_directory "${thirdparty_src_dir}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${thirdparty_install_dir}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${thirdparty_install_dir}/lib"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${thirdparty_install_dir}/include"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${thirdparty_install_dir}/lib/cmake"
)

# 设置编译器标志
if(APPLE)
    set(EXTRA_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
    set(EXTRA_C_FLAGS "-I/opt/homebrew/opt/llvm/include")
    set(EXTRA_LINKER_FLAGS "-L/opt/homebrew/opt/llvm/lib")
endif()

# 设置通用的CMake参数
set(COMMON_CMAKE_ARGS
    "-DCMAKE_INSTALL_PREFIX:PATH=${thirdparty_install_dir}"
    "-DCMAKE_PREFIX_PATH:PATH=${thirdparty_install_dir}"
    "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
    "-DBUILD_SHARED_LIBS:BOOL=OFF"
    "-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON"
    "-DCMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}"
    "-DCMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}"
    "-DCMAKE_OSX_ARCHITECTURES:STRING=arm64"
)

if(APPLE)
    list(APPEND COMMON_CMAKE_ARGS
        "-DCMAKE_CXX_FLAGS:STRING=${EXTRA_CXX_FLAGS}"
        "-DCMAKE_C_FLAGS:STRING=${EXTRA_C_FLAGS}"
        "-DCMAKE_EXE_LINKER_FLAGS:STRING=${EXTRA_LINKER_FLAGS}"
        "-DCMAKE_MACOSX_RPATH:BOOL=OFF"
        "-DCMAKE_INSTALL_NAME_DIR:PATH=${thirdparty_install_dir}/lib"
    )
endif()

message(STATUS "Common CMake arguments: ${COMMON_CMAKE_ARGS}")

# 构建所有依赖
foreach(lib IN ITEMS libevent libunwind boost gflags double-conversion fast-float glog folly)
    message(STATUS "Configuring `${lib}...")
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/CMakeFiles/${lib})
endforeach()