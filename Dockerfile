FROM ubuntu:14.04
MAINTAINER Norio Nomura <norio.nomura@gmail.com>

# Install Dependencies

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      build-essential \
      clang-3.5 \
      curl \
      git \
      icu-devtools \
      libblocksruntime-dev \
      libbsd-dev \
      libcurl4-openssl-dev \
      libedit-dev \
      libicu-dev \
      libkqueue-dev \
      libncurses5-dev \
      libpython-dev \
      libsqlite3-dev \
      libtool \
      libxml2-dev \
      ninja-build \
      pkg-config \
      python \
      swig \
      systemtap-sdt-dev \
      uuid-dev \
      wamerican \
      && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.5 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.5 100 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Build and Install CMake
RUN export CMAKE_VERSION="3.6.1" && \
    curl -O https://cmake.org/files/v3.6/cmake-${CMAKE_VERSION}.tar.gz && \
    tar zxf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-${CMAKE_VERSION}

RUN groupadd -r swift-dev && useradd -r -g swift-dev swift-dev

# Setup Environment Variables

ENV REVISION="2576271" \
    OUTPUT_DIR="/swift" \
    WORK_DIR="/swift-dev"

ENV SRC_DIR=${WORK_DIR}/swift \
    TOOLCHAIN_VERSION="swift-3.0-PREVIEW-6-${REVISION}-with-sourcekit"
ENV ARCHIVE="${TOOLCHAIN_VERSION}.tar.gz"
ENV SWIFT_INSTALL_DIR="${WORK_DIR}/swift-nightly-install" \
    SWIFT_INSTALLABLE_PACKAGE="${OUTPUT_DIR}/${ARCHIVE}"

# Make ${OUTPUT_DIR} ${WORK_DIR}
RUN mkdir -p ${OUTPUT_DIR} && chown swift-dev:swift-dev ${OUTPUT_DIR} && \
    mkdir -p ${WORK_DIR} && chown swift-dev:swift-dev ${WORK_DIR}

# Clone & Check Out to ${WORK_DIR}
RUN sudo --user=swift-dev git clone https://github.com/norio-nomura/swift-dev.git && \

# Using commit hash will avoid caching by branch name.
    cd ${WORK_DIR} && \
    sudo --user=swift-dev git fetch && \
    sudo --user=swift-dev git checkout ${REVISION} && \
    sudo --user=swift-dev git submodule update --init --recursive && \

# Build Swift installer package at ${SWIFT_INSTALLABLE_PACKAGE}
    cd ${SRC_DIR} && \
    sudo --user=swift-dev utils/build-script \
      --preset-file="${WORK_DIR}/build-presets-for-sourcekit-linux.ini" \
      --preset="buildbot_linux_libdispatch" \
      install_destdir="${SWIFT_INSTALL_DIR}" && \
    sudo --user=swift-dev utils/build-script \
      --preset-file="${WORK_DIR}/build-presets-for-sourcekit-linux.ini" \
      --preset="buildbot_linux" \
      -- \
      --extra-cmake-options="-DSWIFT_BUILD_SOURCEKIT:BOOL=TRUE" \
      install_destdir="${SWIFT_INSTALL_DIR}" \
      installable_package="${SWIFT_INSTALLABLE_PACKAGE}" && \

# Install ${SWIFT_INSTALLABLE_PACKAGE} and remove ${WORK_DIR}
    cd / && \
    tar zxvf "${SWIFT_INSTALLABLE_PACKAGE}" -C / && \
    rm -rf ${WORK_DIR}

# Output ${OUTPUT_DIR} as build context
COPY Dockerfile-swift-14.04 ${OUTPUT_DIR}/Dockerfile
RUN echo "ADD ${ARCHIVE} /\nENV LD_LIBRARY_PATH /usr/lib/swift/linux/:\${LD_LIBRARY_PATH}\n">>${OUTPUT_DIR}/Dockerfile
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]
