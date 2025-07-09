# RISC-V SoC 學習專案

本專案記錄從 PicoRV32 出發，學習 RISC-V SoC 架構與 AXI/AHB 總線介面的歷程與筆記。

# 📂 riscv-soc-learning 專案結構  
```
riscv-soc-learning/  
├── README.md                    # ✅ 專案簡介與目標說明  
├── progress.md                  # ✅ 階段式學習進度追蹤表（checklist + 練習）  
│
├── docs/                        # 📘 系統化整理的學習筆記  
│   ├── 00_overview.md           # SoC 學習背景與整體架構  
│   ├── 01_picorv32_notes.md     # PicoRV32 架構分析  
│   ├── 02_simulation_setup.md   # 模擬環境建置與工具鏈設定  
│   ├── 03_bus_concepts.md       # AXI / AHB / APB 總線觀念整理  
│   ├── 04_custom_ip.md          # 如何加入自訂 IP（LED, GPIO 等）  
│   └── 05_debug_and_test.md     # 模擬除錯與波形分析技巧  
│
├── weekly/                      # 📅 每週進度追蹤與心得回顧
│   └── week01_2025-07-04.md     # 第一週進度紀錄
│
├── notes/                       # 🗒️ 每日學習記錄、錯誤分析、debug log
│   └──（目前尚未建立具體筆記，可自行新增）
│
├── reference/                   # 📚 外部參考資源與規格書
│   ├── picorv32_datasheet.pdf   #（你可以放 datasheet 或 AXI 規格）
│   └── links.md                 # 有用連結整理
│
├── src/                         # 💾 RTL 原始碼區
│   ├── picorv32/                # 官方 clone 或 fork 的 PicoRV32 原始碼（如 picorv32.v）
│   ├── ip/                      # 自製 IP 模組（如 LED controller, UART 等）
│   └── top/                     # 最上層整合（包含記憶體 map 與連線）
│
├── sim/                         # 🧪 測試與模擬相關檔案
│   ├── testbench/               # 測試平台與 stimulus
│   ├── wave/                    # 波形檔（如 VCD, LXT）
│   └── logs/                    # 模擬 log 與 debug 輸出
│
├── scripts/                     # ⚙️ 工具與自動化腳本
│   ├── run_sim.sh               # 執行模擬的腳本
│   └── build_toolchain.sh       # 安裝/更新 RISC-V 工具鏈的腳本
