include(ExternalProject)

check_lib_status(gtest)
if(NOT gtest_INSTALLED)
    ExternalProject_Add(
        gtest_external
        URL ${GTEST_URL}
        URL_HASH ${GTEST_URL_HASH}
        SOURCE_DIR ${thirdparty_src_dir}/gtest
        CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                  -DBUILD_SHARED_LIBS=OFF
                  -DBUILD_GMOCK=OFF
                  -Dgtest_force_shared_crt=ON
                  -DINSTALL_GTEST=ON
                  -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        BUILD_BYPRODUCTS
            ${thirdparty_install_dir}/lib/libgtest${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${thirdparty_install_dir}/lib/libgtest_main${CMAKE_STATIC_LIBRARY_SUFFIX}
    )
endif()