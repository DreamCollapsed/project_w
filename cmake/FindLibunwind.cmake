find_path(LIBUNWIND_INCLUDE_DIR
    NAMES libunwind.h
    PATHS ${thirdparty_install_dir}/include
    NO_DEFAULT_PATH
)

find_library(LIBUNWIND_LIBRARY
    NAMES unwind libunwind
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Libunwind DEFAULT_MSG
    LIBUNWIND_LIBRARY
    LIBUNWIND_INCLUDE_DIR
)

if(Libunwind_FOUND AND NOT TARGET Libunwind::Libunwind)
    add_library(Libunwind::Libunwind STATIC IMPORTED)
    set_target_properties(Libunwind::Libunwind PROPERTIES
        IMPORTED_LOCATION "${LIBUNWIND_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LIBUNWIND_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(
    LIBUNWIND_INCLUDE_DIR
    LIBUNWIND_LIBRARY
)