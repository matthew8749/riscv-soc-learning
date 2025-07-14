# 02 simulation setup
# 02. 模擬環境建置與工具鏈設定


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

## 1. 基本模擬架構

```text
[ testbench.v ] → [ picorv32.v ] → [ firmware.elf / .hex ]
       ↓ trace                ↓ waveform
   showtrace.py           gtkwave

```

## 2. 測試方式說明
| make target     | 功能                                        |
| --------------- | ----------------------------------------- |
| `make test`     | 編譯 testbench.v 與 firmware.hex，生成 VCD      |
| `make test_ez`  | 使用 testbench\_ez.v，內建指令測試，不需 firmware.hex |
| `make test_vcd` | 額外輸出 trace（需 `showtrace.py` 解碼）           |

## 3. 工具鏈建置

使用指令安裝 RISC-V GCC 工具鏈（可參考 README.md 的 build-tools 說明）
安裝 Icarus Verilog / Verilator
安裝 gtkwave, python3 showtrace.py

## 4. 模擬常見錯誤與解法
| 問題描述                     | 解法                                |
| ------------------------ | ---------------------------------     |
| `VVP error...`           | Icarus 版本過舊，需升級到 github 最新     |
| `firmware.hex not found` | 忘記執行 `make firmware/firmware.hex`   |
| Trace log 顯示錯誤指令     | 核心未設定 Compressed ISA 或其他擴展     |

- 官方有提供文字化的trace方式，執行：  
```bash  
python3 showtrace.py testbench.trace firmware/firmware.elf  
```  
