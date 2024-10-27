set(Boost_FOUND TRUE)
set(Boost_INCLUDE_DIRS "${BOOST_INCLUDEDIR}")
set(Boost_LIBRARY_DIRS "${BOOST_LIBRARYDIR}")

# 定义组件库
set(Boost_system_FOUND TRUE)
set(Boost_filesystem_FOUND TRUE)
set(Boost_program_options_FOUND TRUE)
set(Boost_regex_FOUND TRUE)
set(Boost_thread_FOUND TRUE)
set(Boost_context_FOUND TRUE)
set(Boost_atomic_FOUND TRUE)
set(Boost_chrono_FOUND TRUE)

# 确保导入目标存在
if(NOT TARGET Boost::system)
    add_library(Boost::system STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::system PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_system.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::filesystem)
    add_library(Boost::filesystem STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::filesystem PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_filesystem.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::program_options)
    add_library(Boost::program_options STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::program_options PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_program_options.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::regex)
    add_library(Boost::regex STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::regex PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_regex.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::thread)
    add_library(Boost::thread STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::thread PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_thread.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::context)
    add_library(Boost::context STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::context PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_context.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::atomic)
    add_library(Boost::atomic STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::atomic PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_atomic.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()

if(NOT TARGET Boost::chrono)
    add_library(Boost::chrono STATIC IMPORTED GLOBAL)
    set_target_properties(Boost::chrono PROPERTIES
        IMPORTED_LOCATION "${Boost_LIBRARY_DIRS}/libboost_chrono.a"
        INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}"
    )
endif()
