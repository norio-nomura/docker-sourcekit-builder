# `docker-sourcekit-builder` builds Swift Toolchain for ubuntu 14.04 with `libsourcekitdInProc.so`

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:301gc https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:301gc context | docker build -t norionomura/sourcekit:301gc -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:301gc context|tar xv - "*.tar.gz"
x ./swift-3.0.1-GM-CANDIDATE-<hash of commit in swift-dev>-with-sourcekit.tar.gz
```
