# FindGlog.cmake
find_path(GLOG_INCLUDE_DIR
    NAMES glog/logging.h
    PATHS ${thirdparty_install_dir}/include
    NO_DEFAULT_PATH
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(GLOG_LIB_NAME "glog_debug")
else()
    set(GLOG_LIB_NAME "glog")
endif()

find_library(GLOG_LIBRARY
    NAMES ${GLOG_LIB_NAME}
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Glog
    REQUIRED_VARS
        GLOG_LIBRARY
        GLOG_INCLUDE_DIR
)

if(Glog_FOUND AND NOT TARGET Glog::Glog)
    add_library(Glog::Glog STATIC IMPORTED)
    set_target_properties(Glog::Glog PROPERTIES
        IMPORTED_LOCATION "${GLOG_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${GLOG_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(
    GLOG_INCLUDE_DIR
    GLOG_LIBRARY
)