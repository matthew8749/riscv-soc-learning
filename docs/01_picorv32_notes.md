# 01. picorv32 notes 架構分析 

- picorv32  
  - Memory Interface  
  - Instruction Decoder
  - Main State Machine

- picorv32_regs

- picorv32_pcpi_mul               // A PCPI core that implements the MUL[H[SU|U]] instructions

- picorv32_pcpi_fast_mul          // A version of picorv32_pcpi_fast_mul using a single cycle multiplier

- picorv32_pcpi_div               // A PCPI core that implements the DIV[U]/REM[U] instructions

- picorv32_axi                    // The version of the CPU with AXI4-Lite interface

- picorv32_axi_adapter            // Adapter from PicoRV32 Memory Interface to AXI4-Lite

- picorv32_wb                     // The version of the CPU with Wishbone Master interface




## 1. 模組介紹與變體

| 模組名稱             | 描述                                  |
| ----------           | ------                                |
| picorv32             | 使用 native memory interface 的主 CPU |
| picorv32_axi         | 提供 AXI4-Lite master 介面的 CPU      |
| picorv32_axi_adapter | native memory ↔ AXI4 bridge           |
| picorv32_wb          | Wishbone master 介面                  |
| picorv32_pcpi_*      | 外接乘法 / 除法協同處理器             |

## 2. CPU Top-level Interface

| Signal          | Direction   | Description               |
| --------        | ----------- | -------------             |
| `clk`, `resetn` | input       | 時鐘與非同步 reset        |
| `mem_*`         | mixed       | native memory interface   |
| `mem_la_*`      | output      | look-ahead memory signals |
| `pcpi_*`        | mixed       | 外接協同處理器接口        |
| `irq`, `eoi`    | mixed       | 中斷處理相關              |

> 註：AXI / Wishbone 模式會包裝 picorv32 核心。

## 3. 狀態機與指令流程簡述

- FSM 定義位置：`state` enum 宣告處
- 每個狀態代表的行為：
  - `FETCH_INSTR`
  - `DECODE`
  - `EXECUTE`
  - `MEM_ACCESS`
  - `TRAP`, 等等

> 可搭配 waveform / trace log 分析每個狀態下的 bus 行為

## 4. 架構重點摘要

- 單指令 1 cycle commit？
- CPI 效能？
- 有哪些參數可設定？
- 是否支援 Compressed ISA、IRQ、PCPI？
