#!/usr/bin/env bash

BASE_IMAGE="norionomura/swift:base4"
ARCHIVE=swift-3.1.1-RELEASE-3f82132-with-sourcekit.tar.gz

if [ ! -f "${ARCHIVE}" ]; then
  curl -L https://github.com/norio-nomura/docker-sourcekit-builder/releases/download/311/$ARCHIVE -O
fi

cat <<-EOF | docker build -f - -t norionomura/sourcekit:311 .
FROM ${BASE_IMAGE}
ADD ${ARCHIVE} /
EOF
