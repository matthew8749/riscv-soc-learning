#!/bin/bash
set -e

NUM_JOBS=8


# ubuntu 24.04 LTS 以上版本
# === 安裝所需套件 ===
echo "[1/5] Installing dependencies..."
sudo apt update
sudo apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
    gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
    libexpat-dev git python3
sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev \
     gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build

# === 建立工作資料夾 ===
sudo mkdir riscv-toolchain-build
sudo chown yeda riscv-toolchain-build
sudo chmod -R 777 riscv-toolchain-build
cd /riscv-toolchain-build


# === 安裝 rv32imc 工具鏈 (picorv32) ===
echo "[2/5] Cloning rv32imc toolchain..."
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32
cd riscv-gnu-toolchain-rv32
./configure --prefix=/opt/riscv32imc --with-arch=rv32imc --with-abi=ilp32
echo "[3/5] Building rv32imc toolchain..."
make -j$NUM_JOBS
cd ..

# === 安裝 rv64gc 工具鏈 (rocket-chip) ===
echo "[4/5] Cloning rv64gc toolchain..."
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv64
cd riscv-gnu-toolchain-rv64
./configure --prefix=/opt/riscv64 --with-arch=rv64gc --with-abi=lp64d
echo "[5/5] Building rv64gc toolchain..."
make -j$NUM_JOBS
cd ..

echo ""
echo "✅ RISC-V toolchains installed successfully!"
echo ""
echo "👉 Add the following to your ~/.bashrc or ~/.zshrc:"
echo '    export PATH=/opt/riscv32/bin:/opt/riscv64/bin:$PATH'
echo ""
echo "然後執行 'source ~/.bashrc'（或重啟 terminal）以套用設定。"
