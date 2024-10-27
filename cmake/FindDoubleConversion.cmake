set(DOUBLE_CONVERSION_FOUND TRUE)
set(DOUBLE_CONVERSION_INCLUDE_DIRS "${thirdparty_install_dir}/include")
set(DOUBLE_CONVERSION_LIBRARIES "${thirdparty_install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}double-conversion${CMAKE_STATIC_LIBRARY_SUFFIX}")

if(NOT TARGET double-conversion::double-conversion)
    add_library(double-conversion::double-conversion STATIC IMPORTED GLOBAL)
    set_target_properties(double-conversion::double-conversion PROPERTIES
        IMPORTED_LOCATION "${DOUBLE_CONVERSION_LIBRARIES}"
        INTERFACE_INCLUDE_DIRECTORIES "${DOUBLE_CONVERSION_INCLUDE_DIRS}"
    )
endif()