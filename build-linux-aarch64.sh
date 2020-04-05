#!/bin/bash

set -e

if [[ -z ${GCC_COMPILER_PATH} ]];then
    GCC_COMPILER_PATH=/home/yhc/workspace/lion/rk1808_linux/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/
fi

if [[ -z ${BUILD_TYPE} ]];then
    # BUILD_TYPE=Debug
    BUILD_TYPE=Release
fi

ROOT_PWD=$( cd "$( dirname $0 )" && cd -P "$( dirname "$SOURCE" )" && pwd )

TARGET_PLATFORM=linux_aarch64

INSTALL_DIR=${ROOT_PWD}/install/${TARGET_PLATFORM}

BUILD_DIR=${ROOT_PWD}/build/build_${TARGET_PLATFORM}_${BUILD_TYPE}

if [[ ! -d "${BUILD_DIR}" ]]; then
  mkdir -p ${BUILD_DIR}
fi

if [[ -d "${INSTALL_DIR}" ]]; then
  rm -rf ${INSTALL_DIR}
fi

cd ${BUILD_DIR}
cmake ../.. \
    -DCMAKE_TOOLCHAIN_FILE=${ROOT_PWD}/config.cmake \
    -DCMAKE_C_COMPILER=${GCC_COMPILER_PATH}/bin/aarch64-linux-gnu-gcc \
    -DCMAKE_CXX_COMPILER=${GCC_COMPILER_PATH}/bin/aarch64-linux-gnu-g++ \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
make runtime -j4
#make install
cd -
