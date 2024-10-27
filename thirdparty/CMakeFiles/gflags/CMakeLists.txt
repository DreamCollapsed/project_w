include(ExternalProject)

check_lib_status(gflags)
if(NOT gflags_INSTALLED)
    # 确保目标目录存在
    file(MAKE_DIRECTORY ${thirdparty_install_dir}/lib)
    file(MAKE_DIRECTORY ${thirdparty_install_dir}/include/gflags)
    file(MAKE_DIRECTORY ${thirdparty_install_dir}/lib/cmake/gflags)

    # 设置编译器标志
    if(APPLE)
        set(GFLAGS_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
        set(GFLAGS_C_FLAGS "-I/opt/homebrew/opt/llvm/include")
    endif()

    # 设置构建参数
    set(GFLAGS_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
        -DGFLAGS_BUILD_SHARED_LIBS=OFF
        -DGFLAGS_BUILD_STATIC_LIBS=ON
        -DGFLAGS_BUILD_TESTING=OFF
        -DCMAKE_SKIP_INSTALL_RPATH=ON
        -DCMAKE_SKIP_RPATH=ON
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DGFLAGS_IS_A_DLL=0
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_CXX_STANDARD=23
        -DCMAKE_OSX_ARCHITECTURES=arm64
        # 添加调试后缀
        -DCMAKE_DEBUG_POSTFIX=_debug
    )

    if(APPLE)
        list(APPEND GFLAGS_CMAKE_ARGS
            -DCMAKE_MACOSX_RPATH=OFF
            "-DCMAKE_CXX_FLAGS=${GFLAGS_CXX_FLAGS}"
            "-DCMAKE_C_FLAGS=${GFLAGS_C_FLAGS}"
        )
    endif()

    set(GFLAGS_LIB_NAME "libgflags$<$<CONFIG:Debug>:_debug>")
    set(GFLAGS_NOTHREADS_LIB_NAME "libgflags_nothreads$<$<CONFIG:Debug>:_debug>")

    ExternalProject_Add(gflags_external
        GIT_REPOSITORY ${GFLAGS_URL}
        GIT_TAG    ${GFLAGS_VERSION}
        SOURCE_DIR ${thirdparty_src_dir}/gflags
        CMAKE_ARGS ${GFLAGS_CMAKE_ARGS}
        BUILD_BYPRODUCTS
            ${thirdparty_install_dir}/lib/${GFLAGS_LIB_NAME}.a
            ${thirdparty_install_dir}/lib/${GFLAGS_NOTHREADS_LIB_NAME}.a
        INSTALL_COMMAND
            ${CMAKE_COMMAND} --install <BINARY_DIR> --prefix ${thirdparty_install_dir}
        BUILD_COMMAND
            ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE}
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )

    # 移除创建符号链接的步骤，因为现在我们直接生成正确的文件名

    # 打印构建信息
    if(CMAKE_VERBOSE_MAKEFILE)
        message(STATUS "GFLAGS configuration:")
        message(STATUS "  Source directory: ${thirdparty_src_dir}/gflags")
        message(STATUS "  Install directory: ${thirdparty_install_dir}")
        message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
        message(STATUS "  CXX flags: ${GFLAGS_CXX_FLAGS}")
        message(STATUS "  C flags: ${GFLAGS_C_FLAGS}")
        message(STATUS "  Library name: ${GFLAGS_LIB_NAME}")
    endif()
endif()