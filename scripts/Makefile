INSTALL_DIR   := /RISCV-TOOLS
MY_HOME       := /home/yeda
WORK_DIR      := $(MY_HOME)/riscv-build
LOG_DIR       := $(WORK_DIR)/logs
BASHRC        := $(MY_HOME)/.bashrc
SYMLINK_DIR   := /usr/local/bin
NUM_JOBS      := 12
PATH_LINE     := export PATH="$(INSTALL_DIR)/rv64/bin:$(INSTALL_DIR)/rv64-linux/bin:$(INSTALL_DIR)/qemu/bin:$$PATH"

TOOLCHAIN_URL := https://github.com/riscv/riscv-gnu-toolchain
QEMU_URL      := https://github.com/qemu/qemu



.PHONY:help install install_toolchains install_qemu symlinks write_path clean uninstall check


help: Makefile
	@printf "\n🌱 RISCV TOOLCHAIN INSTALLER\n"
	@printf "Available targets:\n\n"
	@awk ' \
		/^[a-zA-Z0-9_-]+:/ { \
			helpMessage = match(lastLine, /^## (.*)/); \
			if (helpMessage) { \
				helpCommand = substr($$1, 1, length($$1) - 1); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH - 3); \
				printf "  \033[1;32m%-20s\033[0m # %s\n", helpCommand, helpMessage; \
			} \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)

all: install

## 安裝所有工具鏈與 QEMU
install: install_toolchains install_qemu symlinks write_path
	@echo "所有元件安裝完成"

create_build_floder:
	sudo mkdir /riscv-toolchain-build
	sudo chown yeda /riscv-toolchain-build
	sudo chmod -R 777 /riscv-toolchain-build
	cd /riscv-toolchain-build

install_toolchains:
	mkdir -p $(INSTALL_DIR) $(WORK_DIR) $(LOG_DIR)
	cd $(WORK_DIR) && git clone --recursive $(TOOLCHAIN_URL) riscv-gnu-toolchain-rv64
	cd $(WORK_DIR)/riscv-gnu-toolchain-rv64 && ./configure --prefix=$(INSTALL_DIR)/rv64 --with-arch=rv64gc --with-abi=lp64d > $(LOG_DIR)/rv64_configure.log 2>&1
	cd $(WORK_DIR)/riscv-gnu-toolchain-rv64 && make -j$(NUM_JOBS) > $(LOG_DIR)/rv64_build.log 2>&1

	cd $(WORK_DIR) && git clone --recursive $(TOOLCHAIN_URL) riscv-gnu-toolchain-rv64-linux
	cd $(WORK_DIR)/riscv-gnu-toolchain-rv64-linux && ./configure --prefix=$(INSTALL_DIR)/rv64-linux --with-arch=rv64gc --with-abi=lp64d --with-system-libs --enable-linux > $(LOG_DIR)/rv64linux_configure.log 2>&1
	cd $(WORK_DIR)/riscv-gnu-toolchain-rv64-linux && make linux -j$(NUM_JOBS) > $(LOG_DIR)/rv64linux_build.log 2>&1

install_qemu:
	cd $(WORK_DIR) && git clone $(QEMU_URL) qemu-riscv
	cd $(WORK_DIR)/qemu-riscv && ./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=$(INSTALL_DIR)/qemu --enable-sdl > $(LOG_DIR)/qemu_configure.log 2>&1
	cd $(WORK_DIR)/qemu-riscv && make -j$(NUM_JOBS) > $(LOG_DIR)/qemu_build.log 2>&1
	cd $(WORK_DIR)/qemu-riscv && make install > $(LOG_DIR)/qemu_install.log 2>&1

symlinks:
	@echo "建立 symlinks"
	@for bin in riscv64-unknown-elf-gcc riscv64-unknown-elf-objcopy riscv64-linux-gnu-gcc qemu-riscv64; do \
		sudo rm -f $(SYMLINK_DIR)/$$bin; \
		if [ -f $(INSTALL_DIR)/rv64/bin/$$bin ]; then sudo ln -s $(INSTALL_DIR)/rv64/bin/$$bin $(SYMLINK_DIR)/$$bin; fi; \
		if [ -f $(INSTALL_DIR)/rv64-linux/bin/$$bin ]; then sudo ln -s $(INSTALL_DIR)/rv64-linux/bin/$$bin $(SYMLINK_DIR)/$$bin; fi; \
		if [ -f $(INSTALL_DIR)/qemu/bin/$$bin ]; then sudo ln -s $(INSTALL_DIR)/qemu/bin/$$bin $(SYMLINK_DIR)/$$bin; fi; \
	done

write_path:
	@echo "寫入 PATH 到 $(BASHRC)"
	@grep -qxF '$(PATH_LINE)' $(BASHRC) || echo '$(PATH_LINE)' >> $(BASHRC)

check:
	@echo "檢查已安裝工具版本"
	@which riscv64-unknown-elf-gcc && riscv64-unknown-elf-gcc -v
	@which riscv64-linux-gnu-gcc && riscv64-linux-gnu-gcc -v
	@which qemu-riscv64 && qemu-riscv64 --version

clean:
	@echo "清除暫存與原始碼"
	rm -rf $(WORK_DIR)/riscv-gnu-toolchain-rv64
	rm -rf $(WORK_DIR)/riscv-gnu-toolchain-rv64-linux
	rm -rf $(WORK_DIR)/qemu-riscv
	# rm -rf $(LOG_DIR)  # 可選：也刪除 logs

uninstall:
	@echo "移除安裝內容"
	sudo rm -rf $(INSTALL_DIR)
	@for bin in riscv64-unknown-elf-gcc riscv64-unknown-elf-objcopy riscv64-linux-gnu-gcc qemu-riscv64; do \
	sudo rm -f $(SYMLINK_DIR)/$$bin; \
	done
	@echo "移除 PATH 設定（若存在）"
	sed -i "\|$(PATH_LINE)|d" $(BASHRC)



