# 🧠 RISC-V SoC 學習計畫（含 AXI/AHB 總線）

> 計畫起始日：2025/07/09  
> 學習主題：PicoRV32 + SoC 架構 + AXI/AHB 匯流排整合  
> 每日投入：平日每日 6~8 小時，含筆記撰寫；假日彈性，不安排正式任務  

---

## 📁 專案結構（`riscv-soc-learning/`）

- `docs/`：系統化整理的學習筆記
- `weekly/`：每週進度與回顧
- `notes/`：每日學習紀錄、debug log
- `src/`：RTL 原始碼（picorv32、自製 IP、SoC Top）
- `sim/`：模擬、testbench、波形輸出
- `scripts/`：模擬與工具鏈安裝自動化腳本
- `firmware/`：RISC-V 程式測試自訂 IP 行為
- `progress.md`：學習 checklist

---

## 📆 四週學習週計畫總覽

| 週次   | 時間區間     | 主題                         |    任務重點                          |
| ------ | ----------- | ------                      |    -----------                      |
| 第1週  | 7/9–7/12    | PicoRV32 架構分析            |    模擬 trace、FSM 分析、指令對照觀察  |
| 第2週  | 7/15–7/19   | SoC 架構與 AXI 總線導入       |    AMBA 匯流排理解、分析 AXI channel  |
| 第3週  | 7/22–7/26   | AXI-Lite 模組實作            |    自製 AXI LED IP、整合測試          |
| 第4週  | 7/29–8/2    | AXI IP 整合與 firmware 控制   |    IP 掛載進 SoC、firmware 驗證與除錯 |

---

## 🗓 第1週每日任務（7/9–7/12）

### 7/9（二） PicoRV32 架構導覽
- 閱讀 `picorv32.v` 架構與頂層介面
- 條列 signal 意義、狀態機流程
- 初次模擬與工具設定（Verilator）
- 📝筆記：`docs/01_picorv32_notes.md`, `notes/2025-07-09.md`

### 7/10（三） Firmware trace 分析
- 對照 `firmware.S` 與 `trace.vcd` 分析
- 建立 trace 解讀流程
- 📝筆記：`notes/2025-07-10.md`

### 7/11（四） FSM 與狀態轉移理解
- 分析 `mem_valid`, `mem_ready`, `trap` 狀態轉移
- 製作 FSM 狀態圖
- 📝筆記：`notes/2025-07-11.md`

### 7/12（五） 補強與結構整理
- 製作 PicoRV32 Block Diagram
- 統整 signal/FSM 對照表
- 📝筆記：`weekly/week01_2025-07-12.md`

---

## 🗓 第2週每日任務（7/15–7/19）

### 7/15（一） PicoSoC 架構導覽
- 分析 `picosoc/` 架構與 ROM/UART 整合方式
- 製作 Block Diagram
- 📝筆記：`docs/00_overview.md`, `weekly/week02_2025-07-15.md`

### 7/16（二） AMBA 架構總覽
- AMBA Spec 閱讀、AXI/AHB/APB 區別
- AXI-Lite vs AXI4 差異
- 📝筆記：`docs/03_bus_concepts.md`

### 7/17（三） AXI channel 詳解
- 分析 handshake 時序與 channel 對應
- trace 波形對應 `awvalid`, `wready` 等行為
- 📝筆記：`docs/03_bus_concepts.md`, `notes/2025-07-17.md`

### 7/18（四） AXI-Lite slave 撰寫（1）
- 撰寫 LED controller 初版（state, handshake）
- 📝筆記：`docs/04_custom_ip.md`, `src/ip/axi_led.v`

### 7/19（五） AXI-Lite slave 測試（2）
- 撰寫 testbench 驗證
- 模擬成功與波形觀察
- 📝筆記：`sim/testbench/`, `docs/05_debug_and_test.md`

---

## 🗓 第3週每日任務（7/22–7/26）

### 7/22（一） AXI channel 深入理解
- 每個 channel 功能與順序拆解
- 📝筆記：`docs/03_bus_concepts.md`, `notes/2025-07-22.md`

### 7/23（二） 模擬觀察現成 IP 波形
- trace write/read channel 順序與錯誤情況
- 📝筆記：`sim/wave/`, `docs/05_debug_and_test.md`

### 7/24（三） AXI-Lite 模組撰寫（持續）
- 建立 state machine 架構
- 📝筆記：`src/ip/axi_led.v`, `docs/04_custom_ip.md`

### 7/25（四） 測試整合 AXI LED
- testbench 測試 LED IP 是否反應正確
- 📝筆記：`sim/testbench/axi_led_tb.v`

### 7/26（五） 整合記錄與反思
- 製作 AXI LED block diagram + 指令流程
- 📝筆記：`weekly/week03_2025-07-26.md`

---

## 🗓 第4週每日任務（7/29–8/2）

### 7/29（一） AXI IP 整合與記憶體映射
- 設計 AXI IP memory map
- top-level SoC 整合
- 📝筆記：`src/top/top_with_axi.v`, `notes/2025-07-29.md`

### 7/30（二） firmware 控制 AXI IP
- 撰寫 C 程式控制 LED
- 📝筆記：`firmware/axi_led_test.c`, `notes/2025-07-30.md`

### 7/31（三） 測試 SoC 模擬與除錯
- 確認握手正確與 LED 寫入成功
- 📝筆記：`docs/05_debug_and_test.md`

### 8/1（四） trace 對照與 debug 指南
- 整理 AXI 寫入常見問題與解法
- 📝筆記：`docs/05_debug_and_test.md`

### 8/2（五） 完整整合 + 本週總結
- 系統性整合過程筆記
- 撰寫下一步延伸計畫（UART, GPIO）
- 📝筆記：`weekly/week04_2025-08-02.md`

---

## 📌 其他建議

- 每週五晚間 or 週末，撰寫 `weekly/` 回顧與 `progress.md` 勾選
- 每個 IP 模組設計流程盡可能記錄 FSM、地址、trace
- 建議使用 block diagram + 手畫 handshake 流程輔助理解

---

*產出時間：2025-07-08*

