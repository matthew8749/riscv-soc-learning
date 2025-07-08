# 02 simulation setup

從[官網](https://github.com/riscv-collab/riscv-gnu-toolchain)安裝toolchain

Getting the sources
------------------------------------------
This repository uses submodules, but submodules will fetch automatically on demand, so `--recursive` or git submodule update `--init --recursive` is not needed.


```bash
git clone https://github.com/riscv/riscv-gnu-toolchain

```
*Warning: git clone takes around 6.65 GB of disk and download size*

Prerequisites
------------------------------------------
Several standard packages are needed to build the toolchain.

- On *Ubuntu*, executing the following command should suffice:

```bash
sudo apt-get install autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev

```

- On *Fedora/CentOS/RHEL OS*, executing the following command should suffice:

```bash
sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel libslirp-devel

```

Installation (Newlib)
------------------------------------------

```bash
./configure --prefix=/opt/riscv32 --with-arch=rv32imc --with-abi=ilp32

sudo make -j12

```

