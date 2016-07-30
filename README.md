# docker-sourcekit-builder

## Build `sourcekit-builder` image
```console
docker build -t sourcekit-builder:3020160728a https://github.com/norio-nomura/docker-sourcekit-builder.git
```

## Build `sourcekit` image using context created by `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160728a context | docker build -t norionomura/sourcekit:3020160728a -
```

## Extract Installer Package from `sourcekit-builder`
```console
docker run --rm sourcekit-builder:3020160728a context|tar xv - "*.tar.gz"
x ./swift-DEVELOPMENT-SNAPSHOT-2016-07-28-a-e3209f9-with-sourcekit.tar.gz
```
