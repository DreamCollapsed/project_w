set(GTEST_FOUND TRUE)
set(GTEST_INCLUDE_DIRS "${thirdparty_install_dir}/include")
set(GTEST_LIBRARIES 
    "${thirdparty_install_dir}/lib/libgtest${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${thirdparty_install_dir}/lib/libgtest_main${CMAKE_STATIC_LIBRARY_SUFFIX}"
)

if(NOT TARGET GTest::gtest)
    add_library(GTest::gtest STATIC IMPORTED GLOBAL)
    set_target_properties(GTest::gtest PROPERTIES
        IMPORTED_LOCATION "${thirdparty_install_dir}/lib/libgtest${CMAKE_STATIC_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET GTest::gtest_main)
    add_library(GTest::gtest_main STATIC IMPORTED GLOBAL)
    set_target_properties(GTest::gtest_main PROPERTIES
        IMPORTED_LOCATION "${thirdparty_install_dir}/lib/libgtest_main${CMAKE_STATIC_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "GTest::gtest"
    )
endif()