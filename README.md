# docker-sourcekit-builder

## Build `sourcekit` image
```sh
# Build `sourcekit-builder` image
$ docker build -t sourcekit-builder:3020160725a https://github.com/norio-nomura/docker-sourcekit-builder.git
# Build `sourcekit` image using context created by `sourcekit-builder`
$ docker run --rm sourcekit-builder:3020160725a context | docker build -t norionomura/sourcekit:3020160725a -
```
