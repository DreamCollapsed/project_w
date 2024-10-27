include(ExternalProject)

check_lib_status(fast-float)
if(NOT fast-float_INSTALLED)
    set(EXTRA_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
    set(FASTFLOAT_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
        -DCMAKE_PREFIX_PATH=${thirdparty_install_dir}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DFASTFLOAT_TEST=OFF
        -DFASTFLOAT_INSTALL=ON
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_OSX_ARCHITECTURES=arm64
        "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
        "-DCMAKE_C_FLAGS=-I/opt/homebrew/opt/llvm/include"
        "-DCMAKE_EXE_LINKER_FLAGS=-L/opt/homebrew/opt/llvm/lib"
        -DCMAKE_MACOSX_RPATH=OFF
    )
    
    message(STATUS "Configuring fast-float with args: ${FASTFLOAT_CMAKE_ARGS}")
    
    ExternalProject_Add(fast-float
        GIT_REPOSITORY   ${FAST_FLOAT_URL}
        GIT_TAG          ${FAST_FLOAT_VERSION}
        SOURCE_DIR       ${thirdparty_src_dir}/fast-float
        CMAKE_ARGS       ${FASTFLOAT_CMAKE_ARGS}
        # Remove BUILD_BYPRODUCTS as it's header-only
        INSTALL_COMMAND
            ${CMAKE_COMMAND} --install <BINARY_DIR>
                --prefix ${thirdparty_install_dir}
                --config ${CMAKE_BUILD_TYPE}
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )

    # 创建一个接口库目标
    add_library(FastFloat::FastFloat INTERFACE IMPORTED GLOBAL)
    set_target_properties(FastFloat::FastFloat PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${thirdparty_install_dir}/include"
    )
    add_dependencies(FastFloat::FastFloat fast-float)
    
    # 打印配置信息
    if(CMAKE_VERBOSE_MAKEFILE)
        message(STATUS "Fast-float configuration:")
        message(STATUS "  Source directory: ${thirdparty_src_dir}/fast-float")
        message(STATUS "  Install directory: ${thirdparty_install_dir}")
        message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
        message(STATUS "  CXX flags: ${EXTRA_CXX_FLAGS}")
    endif()
endif()