find_path(FASTFLOAT_INCLUDE_DIR
    NAMES fast_float/fast_float.h
    PATHS
        ${thirdparty_install_dir}/include
        /usr/local/include
        /usr/include
    PATH_SUFFIXES fast_float
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FastFloat DEFAULT_MSG
    FASTFLOAT_INCLUDE_DIR
)

mark_as_advanced(FASTFLOAT_INCLUDE_DIR)

if(FastFloat_FOUND AND NOT TARGET FastFloat::FastFloat)
    add_library(FastFloat::FastFloat INTERFACE IMPORTED)
    set_target_properties(FastFloat::FastFloat PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${FASTFLOAT_INCLUDE_DIR}"
    )
endif()