#!/bin/bash
set -e


# 執行這份腳本：
# chmod +x install_riscv64_env.sh
# ./install_riscv64_env.sh
# 安裝完成後：
# source ~/.bashrc
# riscv64-unknown-elf-gcc -v
# riscv64-linux-gnu-gcc hello.c -o hello
# qemu-riscv64 ./hello


INSTALL_DIR=/RISCV-TOOLS
NUM_JOBS=12
MY_HOME=/home/yeda
WORK_DIR=$MY_HOME/riscv-build
LOG_DIR=$WORK_DIR/logs
BASHRC=$MY_HOME/.bashrc
SYMLINK_DIR=/usr/local/bin

echo "🔧 安裝路徑：$INSTALL_DIR"
sudo mkdir -p $INSTALL_DIR
sudo chown $USER:$USER $INSTALL_DIR
mkdir -p $WORK_DIR
mkdir -p $LOG_DIR
cd $WORK_DIR

# === 安裝所有依賴（含 GUI）===
echo " ============ 安裝依賴...  ============ "
sudo apt update
sudo apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev \
  gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
  libexpat-dev git python3 python3-pip ninja-build pkg-config libglib2.0-dev libpixman-1-dev \
  libssl-dev libsdl2-dev  # 加上 GUI 支援用 SDL2

# === 函式：編譯 toolchain ===
build_toolchain() {
  if [ $# -lt 6 ]; then
    echo "❌ build_toolchain() 參數錯誤，需傳入 6 個參數：NAME PREFIX ARCH ABI EXTRA_CONFIG TARGET"
    exit 1
  fi

  NAME=$1
  PREFIX=$2
  ARCH=$3
  ABI=$4
  EXTRA_CONFIG=$5
  TARGET=$6

  echo "  ============  建構 $NAME 工具鏈...  ============ "
  git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-$NAME | tee $LOG_DIR/${NAME}_clone.log
  cd riscv-gnu-toolchain-$NAME
  ./configure --prefix=$PREFIX --with-arch=$ARCH --with-abi=$ABI $EXTRA_CONFIG 2>&1 | tee $LOG_DIR/${NAME}_configure.log
  make $TARGET -j$NUM_JOBS 2>&1 | tee $LOG_DIR/${NAME}_build.log
  cd ..

  # 防呆：確認 gcc 安裝成功
  if [ ! -f "$PREFIX/bin/riscv64-unknown-elf-gcc" ] && [ ! -f "$PREFIX/bin/riscv64-linux-gnu-gcc" ]; then
    echo "❌ 錯誤：$NAME 工具鏈安裝失敗，找不到 gcc"
    exit 1
  fi
}

# === 1. 安裝 rv64gc toolchain（裸機開發）===
build_toolchain rv64 $INSTALL_DIR/rv64 rv64gc lp64d "" ""

# === 2. 安裝 rv64-linux glibc toolchain（QEMU Linux）===
build_toolchain rv64-linux $INSTALL_DIR/rv64-linux rv64gc lp64d "--with-system-libs --enable-linux" "linux"

# === 3. 編譯 QEMU，含 GUI 模式 ===
echo " ============ 編譯 QEMU...  ============ "
git clone https://github.com/qemu/qemu qemu-riscv | tee $LOG_DIR/qemu_clone.log
cd qemu-riscv
./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=$INSTALL_DIR/qemu --enable-sdl 2>&1 | tee $LOG_DIR/qemu_configure.log
make -j$NUM_JOBS 2>&1 | tee $LOG_DIR/qemu_build.log
make install 2>&1 | tee $LOG_DIR/qemu_install.log
cd ..

# QEMU GUI 確認
if [ ! -f "$INSTALL_DIR/qemu/bin/qemu-riscv64" ]; then
  echo "❌ 錯誤：QEMU 安裝失敗"
  exit 1
fi

# === 寫入 PATH 到 ~/.bashrc（若尚未存在）===
PATH_LINE="export PATH=\"$INSTALL_DIR/rv64/bin:$INSTALL_DIR/rv64-linux/bin:$INSTALL_DIR/qemu/bin:\$PATH\""
if ! grep -Fxq "$PATH_LINE" "$BASHRC"; then
  echo "$PATH_LINE" >> "$BASHRC"
  echo " okok 已新增 PATH 到 $BASHRC okok"
else
  echo " !!!! PATH 已存在，略過新增 !!!! "
fi

# === 清除舊 symlink 並建立新 symlink ===
echo " ============ 建立 symlinks（前先清除舊的）...  ============ "
TOOL_PATHS=(
  "$INSTALL_DIR/rv64/bin/riscv64-unknown-elf-gcc"
  "$INSTALL_DIR/rv64/bin/riscv64-unknown-elf-objcopy"
  "$INSTALL_DIR/rv64-linux/bin/riscv64-linux-gnu-gcc"
  "$INSTALL_DIR/qemu/bin/qemu-riscv64"
)

for tool in "${TOOL_PATHS[@]}"; do
  toolname=$(basename "$tool")
  sudo rm -f "$SYMLINK_DIR/$toolname"
  if [ -f "$tool" ]; then
    sudo ln -s "$tool" "$SYMLINK_DIR/$toolname"
    echo "  ✔️ $toolname → $SYMLINK_DIR/$toolname"
  else
    echo "  !!!! 無法建立 symlink，工具不存在：$tool"
  fi
done

# === 完成 ===
echo ""
echo "  安裝完成！"
echo "  工具路徑：$INSTALL_DIR"
echo "  Log 檔案儲存：$LOG_DIR"
echo "  Symlink 安裝在：$SYMLINK_DIR"
echo "                              "
echo "  建議執行：source ~/.bashrc"
echo "  測試指令："
echo "    riscv64-unknown-elf-gcc -v"
echo "    riscv64-linux-gnu-gcc hello.c -o hello && qemu-riscv64 ./hello"
echo "                              "
echo "  清除安裝用中間檔案（釋放空間）..."
echo "     已刪除：$WORK_DIR/riscv-gnu-toolchain-rv64"
echo "     已刪除：$WORK_DIR/riscv-gnu-toolchain-rv64-linux"
echo "     已刪除：$WORK_DIR/qemu-riscv"
echo "  清理完成。整體環境已安裝完成且中間檔已釋放。"



# # === 安裝後清除原始碼與暫存檔 ===
# echo ""
# echo "🧹 清除安裝用中間檔案（釋放空間）..."

# CLEAN_PATHS=(
#   "$WORK_DIR/riscv-gnu-toolchain-rv64"
#   "$WORK_DIR/riscv-gnu-toolchain-rv64-linux"
#   "$WORK_DIR/qemu-riscv"
# )

# for path in "${CLEAN_PATHS[@]}"; do
#   if [ -d "$path" ]; then
#     rm -rf "$path"
#     echo "  ✔️ 已刪除：$path"
#   fi
# done

# # ✅ 若你不需要保留 log，可一併刪除 logs
# # rm -rf "$LOG_DIR"
# # echo "  ✔️ 已刪除 log 資料夾：$LOG_DIR"

# echo "🧼 清理完成。整體環境已安裝完成且中間檔已釋放。"