# Makefile Usage Guide

This directory contains a **Makefile used to compile and simulate the Asynchronous FIFO RTL**.

The Makefile automates compilation, simulation, waveform viewing, and cleaning of generated files.

---

## Tool Requirements

Install required tools:

```
sudo apt install iverilog gtkwave make
```

---

## Directory Assumption

The Makefile assumes the following structure:

```
async_ip/
│
├── rtl/        -> RTL source files
│
└── sim/
    ├── tb.v    -> testbench
    ├── Makefile
    └── README.md
```

All RTL files inside `rtl/` are automatically compiled.

---

## Running Simulation

Move to the simulation directory:

```
cd sim
```

Compile and run simulation:

```
make run
```

---

## Open Waveform

```
make wave
```

This opens the waveform using **GTKWave**.

---

## Clean Generated Files

```
make clean
```

This removes:

* compiled simulation file (`sim.out`)
* waveform dump (`dump.vcd`)

---

## Commands Executed by Makefile

The Makefile internally runs:

```
iverilog -g2012 -o sim.out ../rtl/*.v tb.v
vvp sim.out
gtkwave dump.vcd
```

---

## Waveform Dump Requirement

The testbench must generate a waveform dump:

```
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end
```

---

