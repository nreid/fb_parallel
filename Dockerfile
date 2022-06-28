FROM ubuntu:impish
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER Gabriel Barrett <eaglesnatcher123@gmail.com>

RUN apt-get update && apt-get install --yes --no-install-recommends \
    nano \
    gcc \
    apt-utils \
    build-essential \
    cmake \
    freebayes \
    samtools \
    bedtools \
    tabix \
    git \
    libvcflib-tools \
    libvcflib-dev \
    bcftools

WORKDIR /usr/src

# install vcflib
#RUN git clone --recursive https://github.com/vcflib/vcflib.git \
#	&& cd vcflib && make

#RUN git config --global http.sslverify false &&\
#    git clone --recursive https://github.com/vcflib/vcflib.git && cd vcflib && mkdir -p build &&\
#    cd build && cmake -DCMAKE_BUILD_TYPE=Debug -DOPENMP=OFF .. &&\
#    cmake --build . &&\
#    cmake --install .

#ENV PATH=${PATH}:/usr/src/vcflib/build