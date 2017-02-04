# `docker-sourcekit-builder` builds Swift Toolchain for ubuntu 16.04 with `libsourcekitdInProc.so`

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:3120170131a https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3120170131a context | docker build -t norionomura/sourcekit:3120170131a -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3120170131a context|tar xv - "*.tar.gz"
x ./swift-3.1-DEVELOPMENT-SNAPSHOT-2017-01-31-a-<hash of commit in swift-dev>-with-sourcekit.tar.gz
```
