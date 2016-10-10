# docker-spack

Base image to install packages from source using Spack.

Example `Dockerfile`:

```
FROM ivotron/spack:develop

RUN $SPACK_ROOT/bin/spack install wget
```

And corresponding `entrypoint.sh`:

```
#!/bin/bash
source $SPACK_ROOT/share/spack/setup-env.sh
spack load wget
exec wget $@
```
