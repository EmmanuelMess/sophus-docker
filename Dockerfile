FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    git \
    build-essential libc++-dev libgflags-dev libsuitesparse-dev clang \
    libeigen3-dev \
    gdb && \
    rm -rf /var/lib/apt/lists/*

#install latest cmake
ADD https://cmake.org/files/v3.28/cmake-3.28.0-linux-x86_64.sh /tmp/cmake-3.28.0-linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /tmp/cmake-3.28.0-linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version

WORKDIR /tmp
RUN git clone https://ceres-solver.googlesource.com/ceres-solver ceres-solver
WORKDIR /tmp/ceres-solver
RUN git reset --hard 6a74af202d83cf31811ea17dc66c74d03b89d79e
WORKDIR /tmp/ceres-solver/build
RUN cmake -DMINIGLOG=On ..
RUN make -j$(nproc)
RUN make install

WORKDIR /tmp
RUN git clone https://github.com/strasdat/Sophus
WORKDIR /tmp/Sophus/build
RUN cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_COMPILE_WARNING_AS_ERROR=On ..
RUN make -j$(nproc)
RUN make install

RUN apt-get update && \
    apt-get install -y \
    libgl1-mesa-dev libwayland-dev libxkbcommon-dev wayland-protocols libegl1-mesa-dev \
    libc++-dev libepoxy-dev libglew-dev libeigen3-dev cmake g++ ninja-build \
    libjpeg-dev libpng-dev catch2 \
    libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev \
    ninja-build && \
    rm -rf /var/lib/apt/lists/*



WORKDIR /tmp
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
WORKDIR /tmp/Pangolin
RUN cmake -B build -GNinja
RUN cmake --build build
WORKDIR /tmp/Pangolin/build
RUN ninja install

ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash builder
USER builder