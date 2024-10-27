add_executable(hello_test hello_test.cpp)

target_include_directories(hello_test PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${THIRD_PARTY_INSTALL}/include
)

target_link_libraries(hello_test PRIVATE
    GTest::gtest
    GTest::gtest_main
    unique_ptr
)

add_test(NAME hello_test COMMAND hello_test)