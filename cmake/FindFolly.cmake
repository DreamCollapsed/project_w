# FindFolly.cmake

if(DEFINED ENV{FOLLY_ROOT})
    set(FOLLY_ROOT "$ENV{FOLLY_ROOT}")
endif()

find_library(FOLLY_LIBRARY
    NAMES folly
    PATHS
        ${THIRD_PARTY_INSTALL}/lib
        ${CMAKE_PREFIX_PATH}/lib
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)

find_path(FOLLY_INCLUDE_DIR
    NAMES folly/String.h
    PATHS
        ${THIRD_PARTY_INSTALL}/include
        ${CMAKE_PREFIX_PATH}/include
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)

if (NOT FOLLY_LIBRARY)
    message(STATUS "Failed to find Folly library")
    message(STATUS "Search paths: ${THIRD_PARTY_INSTALL}/lib ${CMAKE_PREFIX_PATH}/lib")
endif()

if (NOT FOLLY_INCLUDE_DIR)
    message(STATUS "Failed to find Folly include directory")
    message(STATUS "Search paths: ${THIRD_PARTY_INSTALL}/include ${CMAKE_PREFIX_PATH}/include")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Folly
    REQUIRED_VARS
        FOLLY_LIBRARY
        FOLLY_INCLUDE_DIR
)

if(Folly_FOUND AND NOT TARGET Folly::folly)
    add_library(Folly::folly STATIC IMPORTED)
    set_target_properties(Folly::folly PROPERTIES
        IMPORTED_LOCATION "${FOLLY_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${FOLLY_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "
            Boost::system
            Boost::filesystem
            Boost::program_options
            Boost::regex
            Boost::thread
            Boost::context
            Boost::atomic
            gflags::gflags
            double-conversion::double-conversion
        "
    )

    if(APPLE)
        find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
        find_library(SECURITY_FRAMEWORK Security)
        target_link_libraries(Folly::folly INTERFACE
            "${CORE_FOUNDATION_FRAMEWORK}"
            "${SECURITY_FRAMEWORK}"
        )
    endif()
endif()

mark_as_advanced(
    FOLLY_INCLUDE_DIR
    FOLLY_LIBRARY
)