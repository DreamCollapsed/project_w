include(ExternalProject)

check_lib_status(boost)
if(NOT boost_INSTALLED)
    set(BOOST_SOURCE_DIR "${thirdparty_src_dir}/boost")
    set(BOOST_INSTALL_DIR "${thirdparty_install_dir}")
    
    # 明确设置Boost路径
    set(BOOST_ROOT "${BOOST_INSTALL_DIR}")
    set(BOOST_INCLUDEDIR "${BOOST_INSTALL_DIR}/include")
    set(BOOST_LIBRARYDIR "${BOOST_INSTALL_DIR}/lib")

    # 确保目录存在
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory "${BOOST_INSTALL_DIR}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${BOOST_INSTALL_DIR}/lib"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${BOOST_INSTALL_DIR}/include"
    )

    # 创建b2配置脚本
    set(B2_CONFIG_JAM "${CMAKE_CURRENT_BINARY_DIR}/user-config.jam")
    file(WRITE ${B2_CONFIG_JAM}
        "using clang : : \"${CMAKE_CXX_COMPILER}\" : "
        "<cxxflags>\"-std=c++23 -stdlib=libc++ -arch arm64\" "
        "<linkflags>\"-stdlib=libc++ -arch arm64\" "
        ";\n"
    )

    # 创建构建脚本
    set(BUILD_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/build-boost.sh")
    file(WRITE ${BUILD_SCRIPT}
        "#!/bin/bash\n"
        "set -ex\n"
        "\n"
        "# Setup environment\n"
        "export PATH=/opt/homebrew/opt/llvm/bin:$PATH\n"
        "\n"
        "# Change to source directory\n"
        "cd \"${BOOST_SOURCE_DIR}\"\n"
        "\n"
        "# Copy config\n"
        "cp \"${B2_CONFIG_JAM}\" tools/build/src/user-config.jam\n"
        "\n"
        "# Bootstrap\n"
        "./bootstrap.sh --prefix=\"${BOOST_INSTALL_DIR}\" --with-libraries=context,system,filesystem,program_options,regex,thread,atomic,chrono\n"
        "\n"
        "# Build and install\n"
        "./b2 \\\n"
        "    --prefix=\"${BOOST_INSTALL_DIR}\" \\\n"
        "    --layout=tagged \\\n"
        "    link=static \\\n"
        "    threading=multi \\\n"
        "    variant=debug \\\n"
        "    toolset=clang \\\n"
        "    architecture=arm \\\n"
        "    address-model=64 \\\n"
        "    runtime-link=shared \\\n"
        "    -j8 \\\n"
        "    install\n"
        "\n"
        "# Create symlinks for folly\n"
        "cd \"${BOOST_INSTALL_DIR}/lib\"\n"
        "for lib in context filesystem program_options regex system thread atomic chrono; do\n"
        "    ln -sf \"libboost_\${lib}-mt-d-a64.a\" \"libboost_\${lib}-mt.a\"\n"
        "done\n"
    )

    # 创建验证脚本
    set(VERIFY_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/verify-boost.sh")
    file(WRITE ${VERIFY_SCRIPT}
        "#!/bin/bash\n"
        "set -ex\n"
        "\n"
        "echo \"Checking library files:\"\n"
        "ls -l \"${BOOST_INSTALL_DIR}/lib/libboost_\"*\n"
        "\n"
        "echo \"\\nChecking include files:\"\n"
        "ls -l \"${BOOST_INSTALL_DIR}/include/boost\"\n"
        "\n"
        "# 验证每个必需的库文件\n"
        "for lib in context filesystem program_options regex system thread; do\n"
        "    if [ ! -f \"${BOOST_INSTALL_DIR}/lib/libboost_\${lib}-mt.a\" ]; then\n"
        "        echo \"Error: Missing library: libboost_\${lib}-mt.a\"\n"
        "        exit 1\n"
        "    fi\n"
        "done\n"
    )

    ExternalProject_Add(boost_external
        URL ${BOOST_URL}
        URL_HASH ${BOOST_URL_HASH}
        SOURCE_DIR "${BOOST_SOURCE_DIR}"
        INSTALL_DIR "${BOOST_INSTALL_DIR}"
        
        # 配置步骤
        CONFIGURE_COMMAND 
            COMMAND chmod +x ${BUILD_SCRIPT}
            COMMAND chmod +x ${VERIFY_SCRIPT}

        # 构建和安装步骤
        BUILD_COMMAND
            COMMAND ${BUILD_SCRIPT}
        
        INSTALL_COMMAND ""  # 安装已经在BUILD_COMMAND中完成

        # 使用源码目录构建
        BUILD_IN_SOURCE 1

        # 记录所有步骤的日志
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )

    # 添加验证步骤
    ExternalProject_Add_Step(boost_external verify_install
        COMMAND ${VERIFY_SCRIPT}
        DEPENDEES install
    )

    # 打印配置信息
    message(STATUS "Boost configuration:")
    message(STATUS "  Source directory: ${BOOST_SOURCE_DIR}")
    message(STATUS "  Install directory: ${BOOST_INSTALL_DIR}")
    message(STATUS "  CXX compiler: ${CMAKE_CXX_COMPILER}")
    message(STATUS "  Build script: ${BUILD_SCRIPT}")
endif()