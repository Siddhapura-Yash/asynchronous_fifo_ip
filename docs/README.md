# Async FIFO IP – Configuration, Verification and Resource Utilization

This document summarizes the **default parameters, supported operating modes, verified clock domain combinations, and FPGA resource utilization** for the Asynchronous FIFO IP.

The implementation and timing results were generated using **Efinity targeting the Efinix Trion FPGA family**.

---

# Contents

* [Default Parameters](#default-parameters)
* [FIFO Depth Requirement](#fifo-depth-requirement)
* [FPGA Resource Utilization](#fpga-resource-utilization)
* [Timing Results](#timing-results)
* [Verified Clock Domain Operation](#verified-clock-domain-operation)
---

# Default Parameters

If parameters are not specified during instantiation, the FIFO uses the following defaults:

```
parameter DEPTH = 8;
parameter DATA_WIDTH = 8;
parameter PROG_FULL_VALUE = 2;
parameter PROG_EMPTY_VALUE = 3;
parameter MODE = 1;
```

### Parameter Description

**DEPTH**
Total number of entries stored in the FIFO.

**DATA_WIDTH**
Width of each data word.

**PROG_FULL_VALUE**
Threshold used to assert the `prog_full` signal.

**PROG_EMPTY_VALUE**
Threshold used to assert the `prog_empty` signal.

**MODE**

```
MODE = 1 → Normal FIFO Mode
MODE = 0 → FWFT (First Word Fall Through)
```

Explanation:

```
MODE = 1
Data appears at output only after read enable (r_en) is asserted.

MODE = 0
Data automatically appears at the output without requiring r_en.
This behavior is called First Word Fall Through (FWFT).
```

---

# FIFO Depth Requirement

FIFO depth must always be **a power of two**.

Valid examples:

```
2, 4, 8, 16, 32, 64, 128, ...
```

### Reason

The design uses **Gray-coded pointers** for clock domain crossing.
Pointer wrap-around and full/empty detection logic operate correctly only when the FIFO depth is **2ⁿ**.

---

# Verified Clock Domain Operation

The design was tested with multiple **independent clock domain combinations**.

## MODE = 1 (Normal FIFO)

Equal clock frequencies:

```
wclk = 100 MHz , rclk = 100 MHz → Working
wclk = 120 MHz , rclk = 120 MHz → Working
```

Different clock frequencies:

```
rclk = 80 MHz ,  wclk = 120 MHz → Working
rclk = 60 MHz ,  wclk = 120 MHz → Working
rclk = 40 MHz ,  wclk = 120 MHz → Working

wclk = 80 MHz ,  rclk = 120 MHz → Working
wclk = 40 MHz ,  rclk = 120 MHz → Working
```

---

## MODE = 0 (FWFT Mode)

Equal clock frequencies:

```
wclk = 100 MHz , rclk = 100 MHz → Working
wclk = 120 MHz , rclk = 120 MHz → Working
```

Different clock frequencies:

```
rclk = 80 MHz ,  wclk = 120 MHz → Working
rclk = 60 MHz ,  wclk = 120 MHz → Working
rclk = 40 MHz ,  wclk = 120 MHz → Working

wclk = 80 MHz ,  rclk = 120 MHz → Working
wclk = 40 MHz ,  rclk = 120 MHz → Working
```

All tested configurations operated correctly with **independent read and write clocks**.

---

# FPGA Resource Utilization

Resource utilization depends on **FIFO depth and data width**.

---

## Configuration 1 (Default Repository Configuration)

```
DEPTH      = 8
DATA_WIDTH = 8
Clock      = 100 MHz
```

| Resource       | Used | Available |
| -------------- | ---- | --------- |
| Logic Elements | 188  | 112128    |
| Memory Blocks  | 0    | 1056      |
| Multipliers    | 0    | 320       |

### Note

For **small FIFO sizes**, synthesis tools implement storage using **flip-flops (registers)** instead of block RAM.

Therefore:

```
Memory Blocks Used = 0
```

---

## Configuration 2 (Large FIFO)

```
DEPTH      = 16384
DATA_WIDTH = 64
```

| Resource       | Used | Available |
| -------------- | ---- | --------- |
| Logic Elements | 469  | 112128    |
| Memory Blocks  | 256  | 1056      |
| Multipliers    | 0    | 320       |

For large FIFO sizes the tool maps storage into **embedded FPGA block RAM (BRAM)**.

---
# Timing Results

## Configuration 1 (Default Repository Configuration)

```
DEPTH      = 8
DATA_WIDTH = 8
Clock      = 100 MHz
```

| Metric                     | Value    |
| -------------------------- | -------- |
| Worst Negative Slack (WNS) | 3.225 ns |
| Worst Hold Slack (WHS)     | 0.329 ns |

Maximum achievable frequencies:

| Clock | Maximum Frequency |
| ----- | ----------------- |
| wclk  | 147.601 MHz       |
| rclk  | 151.95 MHz        |

This configuration provides **~3.2 ns positive timing margin** when operating at **100 MHz**.

---

## Configuration 2

```
DEPTH      = 16384
DATA_WIDTH = 64
Clock      = 100 MHz
```

| Metric                     | Value    |
| -------------------------- | -------- |
| Worst Negative Slack (WNS) | 1.748 ns |
| Worst Hold Slack (WHS)     | 0.307 ns |

Maximum achievable frequencies:

| Clock | Maximum Frequency |
| ----- | ----------------- |
| wclk  | 123.411 MHz       |
| rclk  | 121.183 MHz       |

This configuration also meets timing requirements with **positive slack at 100 MHz operation**.

---

Clock constraints can be modified using the **Interface Designer / timing constraint settings** in the FPGA tool.


