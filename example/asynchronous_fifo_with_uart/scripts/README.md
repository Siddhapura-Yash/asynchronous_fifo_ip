# UART FIFO Test Script

This script is used to **verify FPGA communication through UART using the Asynchronous FIFO/ Synchronous FIFO**.
It sends data from the host PC to the FPGA and checks if the **same data is received back correctly**.

The script automatically:

1. Generates test data
2. Sends data through UART
3. Receives data from FPGA
4. Compares transmitted and received data

This helps validate **FIFO buffering and data integrity**.

---

# Requirements

Install Python dependencies:

```id="q1j6o8"
pip install pyserial
```

---

# Configuration

The following parameters can be modified inside the script:

```python id="0i7q6h"
PORT = "/dev/ttyUSB0"
BAUD = 1000000

FIFO_DEPTH = 16384
DATA_WIDTH = 64
```

**PORT**
Serial port connected to the FPGA.

**BAUD**
UART baud rate.

**FIFO_DEPTH**
Number of entries in the FIFO.

**DATA_WIDTH**
Width of each FIFO word.

---

# Data Size Calculation

The script calculates the total number of bytes required:

```id="6j7ny2"
BYTES_PER_WORD = DATA_WIDTH // 8
TOTAL_BYTES = FIFO_DEPTH * BYTES_PER_WORD
```

It then generates **unique paragraph text** until the required number of bytes is reached.

---

# Generated Files

The script generates two files:

```
input.txt
output.txt
```

**input.txt**
Contains the data sent to the FPGA.

**output.txt**
Contains the data received back from the FPGA.

---

# Running the Script

Run the script from the project root or script folder:

```id="mkl3xa"
python3 send.py
```

---

# Script Flow

1. Generate unique text data
2. Save generated data to `input.txt`
3. Open UART connection
4. Send data to FPGA
5. Receive data from FPGA
6. Save received data to `output.txt`
7. Compare sent and received data
8. Print PASS / FAIL result

---

# Output Example

Successful run:

```
Generated 131072 bytes of unique paragraph text

Sending data...

Receiving data...

Comparing results...

PASS: All data matched

Config Used:
FIFO_DEPTH : 16384
DATA_WIDTH : 64 bits
TOTAL_BYTES: 131072
```

---

# Notes

* The FPGA design must send back the received data for comparison.
* The script assumes **FIFO depth and data width match the FPGA configuration**.
* UART baud rate must match the FPGA UART configuration.


