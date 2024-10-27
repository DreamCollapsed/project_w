include(ExternalProject)

if(APPLE)
    # On macOS, we use the libunwind provided by LLVM
    find_path(LIBUNWIND_INCLUDE_DIR
        NAMES libunwind.h
        PATHS
            /opt/homebrew/opt/llvm/include
            /usr/local/opt/llvm/include
    )

    find_library(LIBUNWIND_LIBRARY
        NAMES unwind libunwind
        PATHS
            /opt/homebrew/opt/llvm/lib
            /usr/local/opt/llvm/lib
    )

    if(LIBUNWIND_INCLUDE_DIR AND LIBUNWIND_LIBRARY)
        message(STATUS "Found LLVM libunwind:")
        message(STATUS "  Include dir: ${LIBUNWIND_INCLUDE_DIR}")
        message(STATUS "  Library: ${LIBUNWIND_LIBRARY}")
        
        # Create an interface library
        add_library(libunwind_external INTERFACE)
        target_include_directories(libunwind_external INTERFACE ${LIBUNWIND_INCLUDE_DIR})
        target_link_libraries(libunwind_external INTERFACE ${LIBUNWIND_LIBRARY})
        
        # Mark as installed
        set(libunwind_INSTALLED TRUE)
    else()
        message(FATAL_ERROR "Could not find LLVM libunwind. Please install llvm: brew install llvm")
    endif()
else()

  check_lib_status(libunwind)
  if(NOT libunwind_INSTALLED)
      # Create directories
      file(MAKE_DIRECTORY ${thirdparty_install_dir}/include)
      file(MAKE_DIRECTORY ${thirdparty_install_dir}/lib)

      if(CMAKE_BUILD_TYPE STREQUAL "Debug")
          set(CONFIGURE_FLAGS "--enable-debug --enable-shared=no --disable-minidebuginfo --enable-coredump=no")
      else()
          set(CONFIGURE_FLAGS "--disable-debug --enable-shared=no --disable-minidebuginfo --enable-coredump=no")
      endif()

      ExternalProject_Add(libunwind_external
          URL             ${LIBUNWIND_URL}
          URL_HASH        ${LIBUNWIND_URL_HASH}
          SOURCE_DIR      ${thirdparty_src_dir}/libunwind
          PATCH_COMMAND   ""
          UPDATE_COMMAND  ""
          BUILD_IN_SOURCE 1
          CONFIGURE_COMMAND
              sh -c "cd <SOURCE_DIR> && rm -f configure && autoreconf -i"
          COMMAND
              sh -c "cd <SOURCE_DIR> && CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} CFLAGS='${EXTRA_C_FLAGS}' CXXFLAGS='${EXTRA_CXX_FLAGS}' LDFLAGS='${EXTRA_LDFLAGS}' ./configure --prefix=${thirdparty_install_dir} --enable-static --disable-shared --with-pic --disable-dependency-tracking ${CONFIGURE_FLAGS}"
          BUILD_COMMAND
              sh -c "cd <SOURCE_DIR> && make"
          INSTALL_COMMAND
              sh -c "cd <SOURCE_DIR> && make install"
          BUILD_BYPRODUCTS
              ${thirdparty_install_dir}/lib/libunwind.a
          LOG_DOWNLOAD ON
          LOG_CONFIGURE ON
          LOG_BUILD ON
          LOG_INSTALL ON
      )

      # Print configuration for debugging
      if(CMAKE_VERBOSE_MAKEFILE)
          message(STATUS "LIBUNWIND configuration:")
          message(STATUS "  Source directory: ${thirdparty_src_dir}/libunwind")
          message(STATUS "  Install directory: ${thirdparty_install_dir}")
          message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
          message(STATUS "  Configure flags: ${CONFIGURE_FLAGS}")
          message(STATUS "  CXX flags: ${EXTRA_CXX_FLAGS}")
          message(STATUS "  C flags: ${EXTRA_C_FLAGS}")
          message(STATUS "  LD flags: ${EXTRA_LDFLAGS}")
      endif()
  endif()
endif()