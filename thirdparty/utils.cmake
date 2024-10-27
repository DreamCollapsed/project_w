# 添加这个辅助函数
function(safe_copy_file src dst)
    if(EXISTS "${src}")
        file(COPY "${src}" DESTINATION "${dst}")
    else()
        message(STATUS "Source file not found: ${src}")
    endif()
endfunction()

# Check if a library is already installed
function(check_lib_status lib)
    if(lib STREQUAL "gflags")
        if(EXISTS "${thirdparty_install_dir}/lib/libgflags.a" AND
           EXISTS "${thirdparty_install_dir}/include/gflags/gflags.h")
            set(${lib}_INSTALLED TRUE PARENT_SCOPE)
            message(STATUS "Found existing gflags installation")
        else()
            set(${lib}_INSTALLED FALSE PARENT_SCOPE)
            message(STATUS "gflags needs to be built")
        endif()
    else()
        if(EXISTS "${thirdparty_install_dir}/lib/lib${lib}.a" OR 
           EXISTS "${thirdparty_install_dir}/lib/lib${lib}.dylib" OR
           EXISTS "${thirdparty_install_dir}/lib/lib${lib}-mt-d-a64.a")
            set(${lib}_INSTALLED TRUE PARENT_SCOPE)
            message(STATUS "Found existing ${lib} installation")
        else()
            set(${lib}_INSTALLED FALSE PARENT_SCOPE)
            message(STATUS "${lib} needs to be built")
        endif()
    endif()
endfunction()