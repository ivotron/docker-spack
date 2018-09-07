# docker-spack

Build docker images by installing packages from source using 
[Spack](https://github.com/spack/spack). Example `Dockerfile`:

```Dockerfile
FROM ivotron/spack:v0.11.2-ubuntu-16.04

RUN spack install wget tree
ADD entrypoint.sh /root/

ENTRYPOINT ["/root/entrypoint.sh"]
```

And corresponding `entrypoint.sh`:

```bash
#!/bin/bash
source $SPACK_ROOT/share/spack/setup-env.sh

spack load wget tree

tree /
exec wget $@
```
