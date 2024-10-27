# 版本信息
set(BOOST_VERSION "1.86.0")
set(GFLAGS_VERSION "v2.2.2")
set(DOUBLE_CONVERSION_VERSION "3.3.0")
set(GTEST_VERSION "1.15.2")
set(FAST_FLOAT_VERSION "v6.1.6")
set(LIBEVENT_VERSION "release-2.1.12-stable")
set(GLOG_VERSION "v0.7.1")
set(LIBUNWIND_VERSION "1.8.1")
set(FOLLY_VERSION "v2024.10.21.00")

# 下载链接
string(REPLACE "." "_" BOOST_VERSION_UNDERSCORE ${BOOST_VERSION})
set(BOOST_URL "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz")
set(GFLAGS_URL "https://github.com/gflags/gflags.git")
set(DOUBLE_CONVERSION_URL "https://github.com/google/double-conversion/archive/v${DOUBLE_CONVERSION_VERSION}.tar.gz")
set(GTEST_URL "https://github.com/google/googletest/archive/refs/tags/v${GTEST_VERSION}.tar.gz")
set(FOLLY_URL "https://github.com/facebook/folly/archive/${FOLLY_VERSION}.tar.gz")
set(FAST_FLOAT_URL "https://github.com/fastfloat/fast_float.git")
set(LIBEVENT_URL "https://github.com/libevent/libevent.git")
set(GLOG_URL "https://github.com/google/glog.git")
set(LIBUNWIND_URL "https://github.com/libunwind/libunwind/releases/download/v1.8.1/libunwind-${LIBUNWIND_VERSION}.tar.gz")

# 校验和
set(BOOST_URL_HASH "SHA256=2575e74ffc3ef1cd0babac2c1ee8bdb5782a0ee672b1912da40e5b4b591ca01f")
set(DOUBLE_CONVERSION_URL_HASH "SHA256=04ec44461850abbf33824da84978043b22554896b552c5fd11a9c5ae4b4d296e")
set(GTEST_URL_HASH "SHA256=8ad598c73ad796e0d8280b082cebd82a630d73e73cd3c70057938a6501bba5d7")
set(FOLLY_URL_HASH "SHA256=94fdb0d04502c3ae675f67a582f9c975d37c5f8912e0c5576ac8565b9a88bd79")
set(LIBUNWIND_URL_HASH "SHA256=ddf0e32dd5fafe5283198d37e4bf9decf7ba1770b6e7e006c33e6df79e6a6157")