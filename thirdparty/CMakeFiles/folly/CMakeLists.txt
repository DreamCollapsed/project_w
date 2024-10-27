include(ExternalProject)

check_lib_status(folly)
if(NOT folly_INSTALLED)
    set(CXX_FLAGS "-I/opt/homebrew/opt/llvm/include -isystem /opt/homebrew/opt/llvm/include/c++/v1")
    set(C_FLAGS "-I/opt/homebrew/opt/llvm/include")
    set(LINKER_FLAGS "-L/opt/homebrew/opt/llvm/lib")

    # Create initial CMake config
    set(INITIAL_CACHE_FILE "${CMAKE_CURRENT_BINARY_DIR}/folly-initial-cache.cmake")
    file(WRITE ${INITIAL_CACHE_FILE}
        "set(CMAKE_CXX_STANDARD 17 CACHE STRING \"\")\n"
        "set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL \"\")\n"
        "set(BUILD_SHARED_LIBS OFF CACHE BOOL \"\")\n"
        "set(BOOST_ROOT \"${thirdparty_install_dir}\" CACHE PATH \"\")\n"
        "set(BOOST_INCLUDEDIR \"${thirdparty_install_dir}/include\" CACHE PATH \"\")\n"
        "set(BOOST_LIBRARYDIR \"${thirdparty_install_dir}/lib\" CACHE PATH \"\")\n"
        "set(Boost_USE_STATIC_LIBS ON CACHE BOOL \"\")\n"
        "set(Boost_USE_MULTITHREADED ON CACHE BOOL \"\")\n"
        "set(Boost_USE_STATIC_RUNTIME OFF CACHE BOOL \"\")\n"
        "set(Boost_DEBUG OFF CACHE BOOL \"\")\n"
        "set(Boost_NO_SYSTEM_PATHS ON CACHE BOOL \"\")\n"
        "set(FOLLY_USE_JEMALLOC OFF CACHE BOOL \"\")\n"
        "set(FOLLY_HAVE_LIBGFLAGS ON CACHE BOOL \"\")\n"
        "set(BUILD_TESTS OFF CACHE BOOL \"\")\n"
        "set(BUILD_BENCHMARKS OFF CACHE BOOL \"\")\n"
        "set(CMAKE_MACOSX_RPATH OFF CACHE BOOL \"\")\n"
        "set(Boost_NO_BOOST_CMAKE ON CACHE BOOL \"\")\n"
    )

    # Create symlink script
    set(SYMLINK_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/create-symlinks.sh")
    file(WRITE ${SYMLINK_SCRIPT}
        "#!/bin/bash\n"
        "set -e\n"
        "mkdir -p \"${thirdparty_install_dir}/lib\"\n"
        "cd \"${thirdparty_install_dir}/lib\"\n"
        "for lib in context filesystem program_options regex system thread atomic chrono; do\n"
        "    if [ ! -L \"libboost_\${lib}.a\" ]; then\n"
        "        ln -sf \"libboost_\${lib}-mt-d-a64.a\" \"libboost_\${lib}.a\"\n"
        "    fi\n"
        "    if [ ! -L \"libboost_\${lib}-mt.a\" ]; then\n"
        "        ln -sf \"libboost_\${lib}-mt-d-a64.a\" \"libboost_\${lib}-mt.a\"\n"
        "    fi\n"
        "    if [ ! -L \"libboost_\${lib}-mt-d.a\" ]; then\n"
        "        ln -sf \"libboost_\${lib}-mt-d-a64.a\" \"libboost_\${lib}-mt-d.a\"\n"
        "    fi\n"
        "done\n"
    )

    ExternalProject_Add(folly_external
        DEPENDS boost_external gflags_external double-conversion_external
        URL ${FOLLY_URL}
        URL_HASH ${FOLLY_URL_HASH}
        SOURCE_DIR ${thirdparty_src_dir}/folly

        # Pre-configure steps
        CONFIGURE_COMMAND
            COMMAND chmod +x ${SYMLINK_SCRIPT}
            COMMAND ${SYMLINK_SCRIPT}
            COMMAND ${CMAKE_COMMAND} -E echo "Running CMake configure..."
            COMMAND ${CMAKE_COMMAND}
                -C ${INITIAL_CACHE_FILE}
                -DCMAKE_INSTALL_PREFIX=${thirdparty_install_dir}
                -DCMAKE_PREFIX_PATH=${thirdparty_install_dir}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
                -DCMAKE_C_FLAGS=${C_FLAGS}
                -DCMAKE_EXE_LINKER_FLAGS=${LINKER_FLAGS}
                -DCMAKE_OSX_ARCHITECTURES=arm64
                -DGFLAGS_INCLUDE_DIR=${thirdparty_install_dir}/include
                -DGFLAGS_LIBRARY=${thirdparty_install_dir}/lib/libgflags.a
                -DDOUBLE_CONVERSION_INCLUDE_DIR=${thirdparty_install_dir}/include
                -DDOUBLE_CONVERSION_LIBRARY=${thirdparty_install_dir}/lib/libdouble-conversion.a
                -DFastFloat_DIR=${thirdparty_install_dir}/lib/cmake/FastFloat
                -DCMAKE_INSTALL_NAME_DIR=${thirdparty_install_dir}/lib
                -S <SOURCE_DIR>
                -B <BINARY_DIR>

        BUILD_COMMAND
            ${CMAKE_COMMAND} --build <BINARY_DIR> --config ${CMAKE_BUILD_TYPE} --parallel ${CMAKE_BUILD_PARALLEL_LEVEL}

        INSTALL_COMMAND
            ${CMAKE_COMMAND} --install <BINARY_DIR> --prefix ${thirdparty_install_dir} --config ${CMAKE_BUILD_TYPE}

        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON
    )
endif()