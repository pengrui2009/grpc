#!/bin/sh
export GRPC_CROSS_COMPILE=true
export LDXX=arm-linux-gnueabihf-g++
export LD=arm-linux-gnueabihf-g++
export PROTOBUF_CONFIG_OPTS="--host=arm-linux-gnueabihf --with-protoc=/usr/bin/protoc"
# export GRPC_CROSS_LDOPTS="-DNDEBUG -DHAVE_STRUCT_TIMEVAL -L/usr/local/cross/lib"
export GRPC_CROSS_LDOPTS="-DNDEBUG -DHAVE_STRUCT_TIMEVAL"
export GRPC_CROSS_AROPTS="cr --target=elf32-littlearm"
export USE_BUILT_PROTOC=true

# make CFLAGS="-DNDEBUG -DHAVE_STRUCT_TIMEVAL -DHAVE_STRUCT_SOCKADDR_IN6 -DHAVE_WRITEV -DHAVE_RECV" HAS_PKG_CONFIG=false CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++ LD=arm-linux-gnueabihf-gcc LDXX=arm-linux-gnueabihf-g++ AR=arm-linux-gnueabihf-ar CPPFLAGS="-I/home/projects/embedded-grpc/grpc-arm/target/include -I./include -I./" LDFLAGS="-L/home/projects/embedded-grpc/grpc-arm/target/library" static
make CFLAGS="-DNDEBUG -DHAVE_WRITEV -DHAVE_STRUCT_TIMEVAL -DHAVE_STRUCT_SOCKADDR_IN6" \
    HAS_PKG_CONFIG=false \
    CC=arm-linux-gnueabihf-gcc \
    CXX=arm-linux-gnueabihf-g++ \
    LD=arm-linux-gnueabihf-gcc \
    LDXX=arm-linux-gnueabihf-g++ \
    AR=arm-linux-gnueabihf-ar \
    static

make HAS_PKG_CONFIG=false \
    CC=arm-linux-gnueabihf-gcc \
    CXX=arm-linux-gnueabihf-g++ \
    RANLIB=arm-linux-gnueabihf-ranlib \
    LD=arm-linux-gnueabihf-ld \
    LDXX=arm-linux-gnueabihf-g++ \
    AR=arm-linux-gnueabihf-ar \
    PROTOBUF_CONFIG_OPTS="--host=arm-linux-gnueabihf --with-protoc=protoc" \
    CPPFLAGS="-DNDEBUG -I./ -I./include -I./gens -I./third_partys/include" LDFLAGS="-L/home/projects/embedded-grpc/grpc-arm/third_partys/lib" \
    static    

#### build in x86######
git submodule update --init
mkdir -p cmake/build
pushd cmake/build
cmake \
    -DCMAKE_INSTALL_PREFIX=/home/projects/embedded-grpc/grpc/build \
    -DgRPC_CARES_PROVIDER=MODULE \
    -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
    -DgRPC_INSTALL=ON \
    -DgRPC_PROTOBUF_PROVIDER=package \
    -DgRPC_SSL_PROVIDER=package \
    -DgRPC_ZLIB_PROVIDER=package \
    -DBUILD_SHARED_LIBS=ON \
    /home/projects/embedded-grpc/grpc
make -j`nproc`
make install
popd    

#### build in arm######
git submodule update --init
mkdir -p cmake/build
pushd cmake/build
cmake \
    -DCMAKE_CROSSCOMPILING=true \
    -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
    -DCMAKE_AR=/home/projects/embedded-grpc/5G_android_standalone_toolchain/bin/arm-linux-gnueabihf-ar \
    -DCMAKE_STRIP=/home/projects/embedded-grpc/5G_android_standalone_toolchain/bin/arm-linux-gnueabihf-strip \
    -DCMAKE_LINKER=/home/projects/embedded-grpc/5G_android_standalone_toolchain/bin/arm-linux-gnueabihf-ld \
    -DCMAKE_OBJDUMP=/home/projects/embedded-grpc/5G_android_standalone_toolchain/bin/arm-linux-gnueabihf-objdump \
    -DCMAKE_RANLIB=/home/projects/embedded-grpc/5G_android_standalone_toolchain/bin/arm-linux-gnueabihf-ranlib \
    -DCMAKE_INSTALL_PREFIX=/home/projects/embedded-grpc/grpc/build \
    -DCMAKE_BUILD_TYPE=Release \
    -DgRPC_INSTALL=ON \
    -DgRPC_PROTOBUF_PROVIDER=MODULE \
    -DgRPC_SSL_PROVIDER=MODULE \
    -DgRPC_ZLIB_PROVIDER=MODULE \
    -DBUILD_SHARED_LIBS=ON \
    -DRUN_HAVE_STD_REGEX=0 \
    -D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=protoc \
    -D_gRPC_PROTOBUF_WELLKNOWN_INCLUDE_DIR=. \
    /home/projects/embedded-grpc/grpc
make -j`nproc`
make install
popd   

############build protobuf################
./autogen.sh
./configure --host=arm-linux-gnueabihf CC=arm-linux-gnueabihf-gcc --prefix=/home/projects/embedded-grpc/zoro-protobuf/release --with-protoc=/usr/bin/protoc CFLAGS="-fPIC -O2"  CXXFLAGS="-fPIC -O2"
make
make install


#**********************#
arm-linux-gnueabihf-ar qc lib/libcares.a CMakeFiles/c-ares.dir/ares__close_sockets.c.o CMakeFiles/c-ares.dir/ares__get_hostent.c.o CMakeFiles/c-ares.dir/ares__read_line.c.o CMakeFiles/c-ares.dir/ares__timeval.c.o CMakeFiles/c-ares.dir/ares_cancel.c.o CMakeFiles/c-ares.dir/ares_data.c.o CMakeFiles/c-ares.dir/ares_destroy.c.o CMakeFiles/c-ares.dir/ares_expand_name.c.o CMakeFiles/c-ares.dir/ares_expand_string.c.o CMakeFiles/c-ares.dir/ares_fds.c.o CMakeFiles/c-ares.dir/ares_free_hostent.c.o CMakeFiles/c-ares.dir/ares_free_string.c.o CMakeFiles/c-ares.dir/ares_getenv.c.o CMakeFiles/c-ares.dir/ares_gethostbyaddr.c.o CMakeFiles/c-ares.dir/ares_gethostbyname.c.o CMakeFiles/c-ares.dir/ares_getnameinfo.c.o CMakeFiles/c-ares.dir/ares_getsock.c.o CMakeFiles/c-ares.dir/ares_init.c.o CMakeFiles/c-ares.dir/ares_library_init.c.o CMakeFiles/c-ares.dir/ares_llist.c.o CMakeFiles/c-ares.dir/ares_mkquery.c.o CMakeFiles/c-ares.dir/ares_create_query.c.o CMakeFiles/c-ares.dir/ares_nowarn.c.o CMakeFiles/c-ares.dir/ares_options.c.o CMakeFiles/c-ares.dir/ares_parse_a_reply.c.o CMakeFiles/c-ares.dir/ares_parse_aaaa_reply.c.o CMakeFiles/c-ares.dir/ares_parse_mx_reply.c.o CMakeFiles/c-ares.dir/ares_parse_naptr_reply.c.o CMakeFiles/c-ares.dir/ares_parse_ns_reply.c.o CMakeFiles/c-ares.dir/ares_parse_ptr_reply.c.o CMakeFiles/c-ares.dir/ares_parse_soa_reply.c.o CMakeFiles/c-ares.dir/ares_parse_srv_reply.c.o CMakeFiles/c-ares.dir/ares_parse_txt_reply.c.o CMakeFiles/c-ares.dir/ares_platform.c.o CMakeFiles/c-ares.dir/ares_process.c.o CMakeFiles/c-ares.dir/ares_query.c.o CMakeFiles/c-ares.dir/ares_search.c.o CMakeFiles/c-ares.dir/ares_send.c.o CMakeFiles/c-ares.dir/ares_strcasecmp.c.o CMakeFiles/c-ares.dir/ares_strdup.c.o CMakeFiles/c-ares.dir/ares_strerror.c.o CMakeFiles/c-ares.dir/ares_timeout.c.o CMakeFiles/c-ares.dir/ares_version.c.o CMakeFiles/c-ares.dir/ares_writev.c.o CMakeFiles/c-ares.dir/bitncmp.c.o CMakeFiles/c-ares.dir/inet_net_pton.c.o CMakeFiles/c-ares.dir/inet_ntop.c.o CMakeFiles/c-ares.dir/windows_port.c.o
/home/projects/embedded-grpc/grpc/build/arm-linux-gnueabihf-ranlib lib/libcares.acd zoro

cd /home/projects/embedded-grpc/grpc && \
    protoc --grpc_out=/home/projects/embedded-grpc/grpc/build/gens \
    --cpp_out=/home/projects/embedded-grpc/grpc/build/gens \
    --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin \
    src/proto/grpc/reflection/v1alpha/reflection.proto