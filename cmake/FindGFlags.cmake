# FindGFlags.cmake
find_path(GFLAGS_INCLUDE_DIR
    NAMES gflags/gflags.h
    PATHS ${thirdparty_install_dir}/include
    NO_DEFAULT_PATH
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(GFLAGS_LIB_NAME "gflags_debug")
else()
    set(GFLAGS_LIB_NAME "gflags")
endif()

find_library(GFLAGS_LIBRARY
    NAMES ${GFLAGS_LIB_NAME}
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GFlags
    REQUIRED_VARS
        GFLAGS_LIBRARY
        GFLAGS_INCLUDE_DIR
)

if(GFlags_FOUND AND NOT TARGET GFlags::GFlags)
    add_library(GFlags::GFlags STATIC IMPORTED)
    set_target_properties(GFlags::GFlags PROPERTIES
        IMPORTED_LOCATION "${GFLAGS_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${GFLAGS_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(
    GFLAGS_INCLUDE_DIR
    GFLAGS_LIBRARY
)