# docker-sourcekit-builder

## Build `sourcekit` image
```sh
# Build `sourcekit-builder` image
$ docker build -t sourcekit-builder https://github.com/norio-nomura/docker-sourcekit-builder.git
# Build `sourcekit` image using context created by `sourcekit-builder`
$ docker run --rm sourcekit-builder context | docker build -t sourcekit:30p2 -
```
