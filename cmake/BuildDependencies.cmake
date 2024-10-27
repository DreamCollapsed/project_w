function(build_dependencies)
    # 确保目录存在
    file(MAKE_DIRECTORY ${thirdparty_install_dir})
    file(MAKE_DIRECTORY ${thirdparty_src_dir})
    
    # 强制构建所有依赖
    execute_process(
        COMMAND ${CMAKE_COMMAND} --build . --target build_all_deps
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        RESULT_VARIABLE build_result
    )
    
    if(NOT build_result EQUAL 0)
        message(FATAL_ERROR "Failed to build dependencies")
    endif()
endfunction()