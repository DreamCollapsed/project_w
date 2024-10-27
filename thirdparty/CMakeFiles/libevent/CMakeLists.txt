include(ExternalProject)

check_lib_status(libevent)
if(NOT libevent_INSTALLED)
    if(APPLE)
        set(EXTRA_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
        set(EXTRA_C_FLAGS "-I/opt/homebrew/opt/llvm/include")
    endif()

    set(LIBEVENT_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
        -DCMAKE_PREFIX_PATH=${thirdparty_install_dir}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DEVENT__LIBRARY_TYPE=STATIC
        -DEVENT__DISABLE_OPENSSL=ON
        -DEVENT__DISABLE_BENCHMARK=ON
        -DEVENT__DISABLE_TESTS=ON
        -DEVENT__DISABLE_REGRESS=ON
        -DEVENT__DISABLE_SAMPLES=ON
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_OSX_ARCHITECTURES=arm64
        "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
        "-DCMAKE_C_FLAGS=${EXTRA_C_FLAGS}"
        -DCMAKE_DEBUG_POSTFIX=_debug
    )

    ExternalProject_Add(libevent_external
        GIT_REPOSITORY    ${LIBEVENT_URL}
        GIT_TAG           ${LIBEVENT_VERSION}
        SOURCE_DIR        ${thirdparty_src_dir}/libevent
        CMAKE_ARGS        ${LIBEVENT_CMAKE_ARGS}
        BUILD_BYPRODUCTS
            ${thirdparty_install_dir}/lib/libevent$<$<CONFIG:Debug>:_debug>.a
            ${thirdparty_install_dir}/lib/libevent_core$<$<CONFIG:Debug>:_debug>.a
            ${thirdparty_install_dir}/lib/libevent_extra$<$<CONFIG:Debug>:_debug>.a
            ${thirdparty_install_dir}/lib/libevent_pthreads$<$<CONFIG:Debug>:_debug>.a
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )
endif()