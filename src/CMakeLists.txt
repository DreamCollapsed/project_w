add_executable(local_env main.cpp)

target_include_directories(local_env PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${THIRD_PARTY_INSTALL}/include
)

target_link_libraries(local_env PRIVATE
    unique_ptr
    Folly::folly
    double-conversion::double-conversion
    gflags::gflags
    Boost::system
    Boost::filesystem
    Boost::program_options
    Boost::regex
    Boost::thread
    Boost::context
    Boost::atomic
    Boost::chrono
)