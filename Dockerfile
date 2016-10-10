FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        python-minimal g++ make curl tar perl-base environment-modules && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -sL https://github.com/LLNL/spack/archive/develop.tar.gz | tar xz && \
    mv /spack-* /spack && \
    echo 'module() { eval `/usr/bin/modulecmd sh $*`; }' >> /spack/share/spack/setup-env.sh && \
    /spack/bin/spack install tree
ENV SPACK_ROOT=/spack
