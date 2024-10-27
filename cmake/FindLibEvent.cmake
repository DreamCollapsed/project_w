# FindLibEvent.cmake
find_path(LIBEVENT_INCLUDE_DIR
    NAMES event2/event.h
    PATHS ${thirdparty_install_dir}/include
    NO_DEFAULT_PATH
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(DEBUG_POSTFIX "_debug")
else()
    set(DEBUG_POSTFIX "")
endif()

find_library(LIBEVENT_LIBRARY
    NAMES "libevent${DEBUG_POSTFIX}" "event${DEBUG_POSTFIX}"
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

find_library(LIBEVENT_CORE_LIBRARY
    NAMES "libevent_core${DEBUG_POSTFIX}" "event_core${DEBUG_POSTFIX}"
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

find_library(LIBEVENT_EXTRA_LIBRARY
    NAMES "libevent_extra${DEBUG_POSTFIX}" "event_extra${DEBUG_POSTFIX}"
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

find_library(LIBEVENT_PTHREADS_LIBRARY
    NAMES "libevent_pthreads${DEBUG_POSTFIX}" "event_pthreads${DEBUG_POSTFIX}"
    PATHS ${thirdparty_install_dir}/lib
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibEvent
    REQUIRED_VARS
        LIBEVENT_LIBRARY
        LIBEVENT_CORE_LIBRARY
        LIBEVENT_EXTRA_LIBRARY
        LIBEVENT_PTHREADS_LIBRARY
        LIBEVENT_INCLUDE_DIR
)

if(LibEvent_FOUND AND NOT TARGET LibEvent::LibEvent)
    add_library(LibEvent::LibEvent STATIC IMPORTED)
    set_target_properties(LibEvent::LibEvent PROPERTIES
        IMPORTED_LOCATION "${LIBEVENT_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LIBEVENT_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(
    LIBEVENT_INCLUDE_DIR
    LIBEVENT_LIBRARY
    LIBEVENT_CORE_LIBRARY
    LIBEVENT_EXTRA_LIBRARY
    LIBEVENT_PTHREADS_LIBRARY
)