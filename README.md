# `docker-sourcekit-builder` builds Swift Toolchain for ubuntu 14.04 with `libsourcekitdInProc.so`

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:3020160829a https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160829a context | docker build -t norionomura/sourcekit:3020160829a -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160829a context|tar xv - "*.tar.gz"
x ./swift-DEVELOPMENT-SNAPSHOT-2016-08-29-a-<hash of commit in swift-dev>-with-sourcekit.tar.gz
```
