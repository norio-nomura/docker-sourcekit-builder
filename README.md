# `docker-sourcekit-builder` builds Swift Toolchain for ubuntu 16.04 with `libsourcekitdInProc.so`

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:302p1 https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:302p1 context | docker build -t norionomura/sourcekit:302p1 -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:302p1 context|tar xv - "*.tar.gz"
x ./swift-3.0.2-PREVIEW-1-<hash of commit in swift-dev>-with-sourcekit.tar.gz
```
