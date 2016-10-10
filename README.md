# docker-spack

Build docker images by installing packages from source using 
[Spack](https://github.com/LLNL/spack).

Example `Dockerfile`:

```
FROM ivotron/spack

RUN $SPACK_ROOT/bin/spack install wget
ADD entrypoint.sh /root/
ENTRYPOINT ["/root/entrypoint.sh"]
```

And corresponding `entrypoint.sh`:

```
#!/bin/bash
source $SPACK_ROOT/share/spack/setup-env.sh
spack load wget
exec wget $@
```
