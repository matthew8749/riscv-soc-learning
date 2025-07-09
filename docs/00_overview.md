# 00 overview SoC 學習背景與整體架構

## 1. 學習動機

- 為什麼選擇學習 RISC-V SoC 架構？
- 學習 SoC 與總線介面（AXI / AHB / APB）的目的？

## 2. 使用平台介紹

| 專案      | 描述                                                     |
| ------   | ------                                                   |
| PicoRV32 | 精簡化 RISC-V RV32IMC CPU，可選擇 Native / AXI / WB 介面   |
| picosoc  | PicoRV32 的最小 SoC 實作（具 SPI Flash boot）              |
| 模擬平台  | Icarus Verilog / Verilator + VCD / Trace                 |

## 3. 筆記架構與目標

| 筆記檔案                  | 主題                                  |
| ----------               | ------                               |
| `00_overview.md`         | 學習背景與筆記架構說明                  |
| `01_picorv32_notes.md`   | PicoRV32 核心架構分析與介面說明         |
| `02_simulation_setup.md` | 模擬環境建置、測試流程與工具鏈           |
| `03_bus_concepts.md`     | AXI / AHB / APB 概念與介面比較         |
| `04_custom_ip.md`        | 自訂 IP 與 Memory-Mapped IO 實作       |
| `05_debug_and_test.md`   | 除錯技巧與 waveform / trace 分析       |

## 4. 學習排程概覽

| 週次   | 主要任務                   | 重點筆記   |
| ------ | ----------               | ---------- |
| Week 1 | PicoRV32 架構分析與模擬    | `01`, `02` |
| Week 2 | 總線觀念 AXI / AHB / APB  | `03`       |
| Week 3 | 自訂 IP + 除錯技巧         | `04`, `05` |
