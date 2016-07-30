# `docker-sourcekit-builder` builds Swift Toolchain with `libsourcekitdInProc.so`

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:3020160729a https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160729a context | docker build -t norionomura/sourcekit:3020160729a -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160729a context|tar xv - "*.tar.gz"
x ./swift-DEVELOPMENT-SNAPSHOT-2016-07-29-a-1045162-with-sourcekit.tar.gz
```
