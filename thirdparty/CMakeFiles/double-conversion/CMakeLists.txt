include(ExternalProject)

check_lib_status(double-conversion)
if(NOT double-conversion_INSTALLED)
    set(EXTRA_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
    
    set(DOUBLE_CONVERSION_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
        -DCMAKE_PREFIX_PATH=${thirdparty_install_dir}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_OSX_ARCHITECTURES=arm64
        "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
        "-DCMAKE_C_FLAGS=-I/opt/homebrew/opt/llvm/include"
        "-DCMAKE_EXE_LINKER_FLAGS=-L/opt/homebrew/opt/llvm/lib"
        -DCMAKE_MACOSX_RPATH=OFF
    )

    message(STATUS "Configuring double-conversion with args: ${DOUBLE_CONVERSION_CMAKE_ARGS}")

    ExternalProject_Add(double-conversion_external
        URL ${DOUBLE_CONVERSION_URL}
        URL_HASH ${DOUBLE_CONVERSION_URL_HASH}
        SOURCE_DIR ${thirdparty_src_dir}/double-conversion
        CMAKE_ARGS ${DOUBLE_CONVERSION_CMAKE_ARGS}
        BUILD_BYPRODUCTS
            ${thirdparty_install_dir}/lib/libdouble-conversion.a
        INSTALL_COMMAND
            ${CMAKE_COMMAND} --install <BINARY_DIR>
                --prefix ${thirdparty_install_dir}
                --config ${CMAKE_BUILD_TYPE}
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )

    # 打印配置信息
    if(CMAKE_VERBOSE_MAKEFILE)
        message(STATUS "Double-conversion configuration:")
        message(STATUS "  Source directory: ${thirdparty_src_dir}/double-conversion")
        message(STATUS "  Install directory: ${thirdparty_install_dir}")
        message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
        message(STATUS "  CXX flags: ${EXTRA_CXX_FLAGS}")
    endif()
endif()