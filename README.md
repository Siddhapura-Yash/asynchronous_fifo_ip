# Asynchronous FIFO IP

A **parameterizable asynchronous FIFO IP** implemented in Verilog for reliable data transfer between **independent clock domains**.
The design uses **Gray-coded pointers and synchronizers** to safely handle clock domain crossing.

---

## Repository Structure

```
asynchronous_fifo_ip/
│
├── rtl/    → FIFO IP RTL
├── sim/    → FIFO testbench
├── docs/   → IP documentation
│
├── examples/
│   └── asynchronous_fifo_with_uart/
│       ├── rtl/
│       ├── sim/
│       ├── docs/
│       └── scripts/
│
└── README.md
```

---

## Documentation

* [Async FIFO Configuration, Resource Utilization and Timing Results](docs/README.md)

* [UART ↔ Async FIFO Loopback Hardware Test](example/asynchronous_fifo_with_uart/README.md)

---

## Simulation

Run simulation from the `sim` directory:

```
cd sim
make run
```
---

## Hardware Verification

UART loopback testing script:

```
scripts/send.py
```

Run:

```
python3 scripts/send.py
```
---

## Additional Documentation

For script usage and configuration see:
[script README](example/asynchronous_fifo_with_uart/scripts/README.md)

For FIFO configuration, FPGA resource utilization and timing results see:
[Configuration & timing README](docs/README.md)


