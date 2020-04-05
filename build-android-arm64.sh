#!/bin/bash

set -e

if [[ -z ${GCC_COMPILER_PATH} ]];then
    GCC_COMPILER_PATH=/home/yhc/opts/ndk/ndk17b_toolchain_arm64_21
fi

if [[ -z ${BUILD_TYPE} ]];then
    # BUILD_TYPE=Debug
    BUILD_TYPE=Release
fi

ANDROID_NDK_PATH=/home/yhc/opts/ndk/android-ndk-r16b

ROOT_PWD=$( cd "$( dirname $0 )" && cd -P "$( dirname "$SOURCE" )" && pwd )

TARGET_PLATFORM=android_arm64

INSTALL_DIR=${ROOT_PWD}/install/${TARGET_PLATFORM}

BUILD_DIR=${ROOT_PWD}/build/build_${TARGET_PLATFORM}_${BUILD_TYPE}

if [[ ! -d "${BUILD_DIR}" ]]; then
  mkdir -p ${BUILD_DIR}
fi

if [[ -d "${INSTALL_DIR}" ]]; then
  rm -rf ${INSTALL_DIR}
fi

cd ${BUILD_DIR}
# cmake ../.. \
#     -DCMAKE_TOOLCHAIN_FILE=${ROOT_PWD}/config.cmake \
#     -DCMAKE_C_COMPILER=${GCC_COMPILER_PATH}/bin/aarch64-linux-android-gcc \
#     -DCMAKE_CXX_COMPILER=${GCC_COMPILER_PATH}/bin/aarch64-linux-android-g++ \
#     -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
#     -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

cmake ../.. \
    -DCMAKE_TOOLCHAIN_FILE=${ROOT_PWD}/config.cmake \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=21 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_STL_TYPE=c++_static \
    -DCMAKE_ANDROID_NDK=${ANDROID_NDK_PATH} \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

make VERBOSE=1 runtime -j4
#make install
cd -