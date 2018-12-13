# Docker Spack

Build docker images by installing packages from source using
[Spack](https://github.com/spack/spack). The `Dockerfile` templates
are parameterized, so they produce ready-to-run images with packages
installed using Spack. For example:

```bash
cp Dockerfile.alpine Dockerfile
sed -i "s/{{BASE_IMG}}/alpine:3.5/" Dockerfile

docker build \
  --build-arg CMD_NAME=lulesh2.0 \
  --build-arg PKG_SPEC='lulesh~mpi' \
  -t ivotron/lulesh:alpine-3.5 .
```

The above creates an image called `ivotron/lulesh:alpine-3.5` with
`lulesh~mpi` installed inside and having `lulesh2.0` as the
entrypoint. So after this, we can run:

```bash
docker run --rm ivotron/lulesh:alpine-3.5 -s 10 -i 100
```


### The build.sh wrapper

`build.sh` is a convenience wrapper for installing the same
package `spec` on a bunch of distinct distros.

```bash
./build.sh lulesh~mpi lulesh2.0 ivotron/lulesh
```


### Getting spack specifications of a package

After building the docker image we can create a container and copy
the spack specifications file present in the form of a yaml file.

```bash
docker run --name lulesh-alpine-3.5 ivotron/lulesh:alpine-3.5 -s 10 -i 100
docker cp lulesh-alpine-3.5:/root/spec.yaml spack_specifications.yaml
docker rm lulesh-alpine-3.5
```


### Getting runtime dependencies of a package

```bash
cp Dockerfile.alpine Dockerfile
sed -i "s/{{BASE_IMG}}/alpine:3.5/" Dockerfile

docker build \
  --build-arg CMD_NAME=lulesh2.0 \
  --build-arg PKG_SPEC='lulesh~mpi' \
  --build-arg LOCATION='/bin/lulesh2.0' \
  -t ivotron/lulesh:alpine-3.5 .
```

After this we can create a container using the image and copy
the dependencies present in the form of a yaml file.

```bash
docker run --name lulesh-alpine-3.5 ivotron/lulesh:alpine-3.5 -s 10 -i 100
docker cp lulesh-alpine-3.5:/root/runtime_applications.yaml runtime_applications.yaml
docker rm lulesh-alpine-3.5
```

The `build.sh` wrapper also accepts a fourth argument for providing the
location.

```bash
./build.sh lulesh~mpi lulesh2.0 ivotron/lulesh /bin/lulesh2.0
```
