import serial
import time
import struct

PORT = "/dev/ttyUSB0"
BAUD = 1000000

FIFO_DEPTH = 16384      # number of FIFO entries
DATA_WIDTH = 64          # bits: 8, 16, 32

input_file = "input.txt"
output_file = "output.txt"

BYTES_PER_WORD = DATA_WIDTH // 8
TOTAL_BYTES = FIFO_DEPTH * BYTES_PER_WORD

lines = []
i = 1

while True:
    line = f"Line {i}: FPGA communication test using UART and FIFO buffering for reliable data transfer.\n"
    lines.append(line)
    text = "".join(lines)

    if len(text) >= TOTAL_BYTES:
        text = text[:TOTAL_BYTES]
        break

    i += 1

data = text.encode()

with open(input_file, "wb") as f:
    f.write(data)

print("Generated", len(data), "bytes of unique paragraph text")

ser = serial.Serial(PORT, BAUD, timeout=5)

time.sleep(2)

print("\nSending data...\n")
ser.write(data)

time.sleep(1)

print("Receiving data...\n")

rx = ser.read(len(data))

with open(output_file, "wb") as f:
    f.write(rx)

ser.close()

print("Comparing results...\n")

errors = 0

for i in range(len(data)):
    if i >= len(rx):
        print("Missing byte at index", i)
        errors += 1
        break

    if data[i] != rx[i]:
        print("Mismatch at index", i, "sent", data[i], "received", rx[i])
        errors += 1

if errors == 0:
    print("PASS: All data matched")
else:
    print("FAIL:", errors, "errors detected")

print("\nConfig Used:")
print("FIFO_DEPTH :", FIFO_DEPTH)
print("DATA_WIDTH :", DATA_WIDTH, "bits")
print("TOTAL_BYTES:", TOTAL_BYTES)

print("\nFiles generated:")
print("input.txt  -> data sent")
print("output.txt -> data received")
