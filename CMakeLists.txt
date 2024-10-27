cmake_minimum_required(VERSION 3.28.3)
project(project_w)

# 设置 CMake 策略
cmake_policy(SET CMP0144 NEW)
cmake_policy(SET CMP0074 NEW)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 添加测试支持
enable_testing()

# 路径设置
set(THIRD_PARTY_DIR ${CMAKE_SOURCE_DIR}/thirdparty)
set(THIRD_PARTY_INSTALL ${THIRD_PARTY_DIR}/installed)
set(CMAKE_PREFIX_PATH ${THIRD_PARTY_INSTALL} ${CMAKE_PREFIX_PATH})
# 添加CMake模块路径
list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_SOURCE_DIR}/cmake"
    "${THIRD_PARTY_INSTALL}/lib/cmake"
)

# 编译器和标志设置
if(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -I/opt/homebrew/opt/llvm/include -fdiagnostics-color=always -pthread -fexperimental-library")
    link_directories(/opt/homebrew/opt/llvm/lib)
endif()

# Boost 相关设置
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_NO_SYSTEM_PATHS ON)
set(BOOST_ROOT ${THIRD_PARTY_INSTALL})
set(BOOST_INCLUDEDIR ${THIRD_PARTY_INSTALL}/include)
set(BOOST_LIBRARYDIR ${THIRD_PARTY_INSTALL}/lib)

# 查找依赖包
find_package(Boost REQUIRED COMPONENTS
    system
    filesystem
    program_options
    regex
    thread
    context
    atomic
    chrono
)
find_package(GFlags REQUIRED)
find_package(DoubleConversion REQUIRED)
find_package(GTest REQUIRED)
find_package(FastFloat REQUIRED)
find_package(Folly REQUIRED)

# 添加子目录
add_subdirectory(src)
add_subdirectory(src/tests)
add_subdirectory(src/unique_ptr)

message(STATUS "Build configuration completed successfully")
message(STATUS "THIRD_PARTY_INSTALL: ${THIRD_PARTY_INSTALL}")
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")