FROM ubuntu:15.10
MAINTAINER Norio Nomura <norio.nomura@gmail.com>

# Install Dependencies

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      clang \
      cmake \
      git \
      icu-devtools \
      libblocksruntime-dev \
      libbsd-dev \
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
      uuid-dev \
      && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup Environment Variables

ENV COMMIT="6d82fec" \
    OUTPUT_DIR="/swift" \
    WORK_DIR="/swift-dev"

ENV SRC_DIR=${WORK_DIR}/swift \
    TOOLCHAIN_VERSION="swift-3.0-PREVIEW-3-${COMMIT}-with-sourcekit"
ENV ARCHIVE="${TOOLCHAIN_VERSION}.tar.gz"
ENV SWIFT_INSTALL_DIR="${SRC_DIR}/swift-nightly-install" \
    SWIFT_INSTALLABLE_PACKAGE="${OUTPUT_DIR}/${ARCHIVE}"

# Make ${OUTPUT_DIR}
RUN mkdir -p ${OUTPUT_DIR}

# Clone & Check Out to ${WORK_DIR}
RUN git clone https://github.com/norio-nomura/swift-dev.git && \

# Using commit hash will avoid caching by branch name.
    cd ${WORK_DIR} && \
    git fetch && \
    git checkout ${COMMIT} && \
    git submodule update --init --recursive && \

# Build Swift installer package at ${SWIFT_INSTALLABLE_PACKAGE}
    cd ${SRC_DIR} && \
    utils/build-script --preset="buildbot_linux_libdispatch" \
      install_destdir="${SWIFT_INSTALL_DIR}" && \
    utils/build-script --preset="buildbot_linux" \
      install_destdir="${SWIFT_INSTALL_DIR}" \
      installable_package="${SWIFT_INSTALLABLE_PACKAGE}" && \

# Install ${SWIFT_INSTALLABLE_PACKAGE} and remove ${WORK_DIR}
    cd / && \
    tar zxvf "${SWIFT_INSTALLABLE_PACKAGE}" -C / && \
    rm -rf ${WORK_DIR}

# Output ${OUTPUT_DIR} as build context
COPY Dockerfile-swift-15.10 ${OUTPUT_DIR}/Dockerfile
RUN echo "ADD ${ARCHIVE} /\nENV LD_LIBRARY_PATH /usr/lib/swift/linux/:\${LD_LIBRARY_PATH}\n">>${OUTPUT_DIR}/Dockerfile
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]
