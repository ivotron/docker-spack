# docker-spack

Build docker images by installing packages from source using 
[Spack](https://github.com/spack/spack). The `Dockerfile` templates 
are parameterized, so they produce ready-to-run images with packages 
installed using Spack. For example:

```bash
cp Dockerfile.alpine Dockerfile
sed -i "s/{{BASE_IMG}}/alpine:3.5/" Dockerfile

docker build \
  --build-arg SPACK_VERSION=develop \
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

The `build.sh` is a convenience wrapper for installing the same 
package `spec` on a bunch of distinct distros.
