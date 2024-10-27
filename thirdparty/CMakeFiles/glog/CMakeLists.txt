include(ExternalProject)

check_lib_status(glog)
if(NOT glog_INSTALLED)
    if(APPLE)
        set(EXTRA_CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
        set(EXTRA_C_FLAGS "-I/opt/homebrew/opt/llvm/include")
        set(EXTRA_LDFLAGS "-L/opt/homebrew/opt/llvm/lib")
        
        # Find LLVM libunwind
        find_library(LIBUNWIND_LIBRARY
            NAMES unwind libunwind
            PATHS /opt/homebrew/opt/llvm/lib
        )
    endif()

    set(GLOG_CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
        -DCMAKE_PREFIX_PATH=${thirdparty_install_dir}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DWITH_GFLAGS=ON
        -DWITH_UNWIND=ON
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_OSX_ARCHITECTURES=arm64
        "-DCMAKE_CXX_FLAGS=${EXTRA_CXX_FLAGS}"
        "-DCMAKE_C_FLAGS=${EXTRA_C_FLAGS}"
        "-DCMAKE_EXE_LINKER_FLAGS=${EXTRA_LDFLAGS}"
        -DCMAKE_DEBUG_POSTFIX=_debug
    )

    if(APPLE)
        list(APPEND GLOG_CMAKE_ARGS
            "-DUNWIND_LIBRARY=${LIBUNWIND_LIBRARY}"
            "-DUNWIND_INCLUDE_DIR=/opt/homebrew/opt/llvm/include"
        )
    endif()

    ExternalProject_Add(glog_external
        GIT_REPOSITORY    ${GLOG_URL}
        GIT_TAG          ${GLOG_VERSION}
        SOURCE_DIR       ${thirdparty_src_dir}/glog
        CMAKE_ARGS       ${GLOG_CMAKE_ARGS}
        BUILD_BYPRODUCTS
            ${thirdparty_install_dir}/lib/libglog$<$<CONFIG:Debug>:_debug>.a
        DEPENDS          gflags_external
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )

    if(CMAKE_VERBOSE_MAKEFILE)
        message(STATUS "GLOG configuration:")
        message(STATUS "  Source directory: ${thirdparty_src_dir}/glog")
        message(STATUS "  Install directory: ${thirdparty_install_dir}")
        message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
        message(STATUS "  CXX flags: ${EXTRA_CXX_FLAGS}")
        message(STATUS "  C flags: ${EXTRA_C_FLAGS}")
        if(APPLE)
            message(STATUS "  UNWIND_LIBRARY: ${LIBUNWIND_LIBRARY}")
            message(STATUS "  UNWIND_INCLUDE_DIR: /opt/homebrew/opt/llvm/include")
        endif()
    endif()
endif()