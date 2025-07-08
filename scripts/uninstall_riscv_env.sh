#!/bin/bash
set -e

INSTALL_DIR=/RISVC-TOOLS
BASHRC=$HOME/.bashrc
SYMLINK_DIR=/usr/local/bin

# （完整卸載工具鏈與 symlink）
echo "🧹 開始卸載 RISCV 環境..."

# === 移除工具鏈安裝路徑 ===
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
  echo "✅ 移除工具目錄：$INSTALL_DIR"
else
  echo "⚠️ 工具目錄不存在：$INSTALL_DIR"
fi

# === 移除 symlink ===
echo "🔗 移除 symlinks..."
SYMLINKS=(
  riscv64-unknown-elf-gcc
  riscv64-unknown-elf-objcopy
  riscv64-linux-gnu-gcc
  qemu-riscv64
)
for name in "${SYMLINKS[@]}"; do
  if [ -L "$SYMLINK_DIR/$name" ]; then
    sudo rm -f "$SYMLINK_DIR/$name"
    echo "  ❌ 已刪除：$SYMLINK_DIR/$name"
  else
    echo "  ⚠️ 未找到 symlink：$SYMLINK_DIR/$name"
  fi
done

# === 移除 .bashrc 中的 PATH 行 ===
echo "📝 清除 .bashrc 中的 PATH..."
PATH_LINE="export PATH=\"$INSTALL_DIR/rv64/bin:$INSTALL_DIR/rv64-linux/bin:$INSTALL_DIR/qemu/bin:\$PATH\""
if grep -Fxq "$PATH_LINE" "$BASHRC"; then
  sed -i "\|$PATH_LINE|d" "$BASHRC"
  echo "✅ 已移除 PATH 設定"
else
  echo "⚠️ 未找到 PATH 設定，略過"
fi

echo ""
echo "✅ 卸載完成！請重新開啟終端或執行：source ~/.bashrc"
