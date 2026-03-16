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
All RTL files inside `rtl/` are automatically compiled by the Makefile.

---

## Running Simulation

Move to the simulation directory:
```
cd sim
```
Run simulation:
```
make run
```
This command will:
- Compile all RTL files and the testbench
- Execute the simulation

---

## Run Complete Simulation Flow (Recommended)
```
make all
```
This command performs the full simulation flow:

1. Deletes previous simulation files (`sim.out`, `dump.vcd`)
2. Compiles RTL and testbench
3. Runs the simulation
4. Automatically opens the waveform in GTKWave

This is the recommended command to run a fresh simulation.

---

## Open Waveform
```
make wave
```
This opens the generated waveform file using **GTKWave**.

---

## Clean Generated Files
```
make clean
```
This removes generated files:
- `sim.out` → compiled simulation output
- `dump.vcd` → waveform dump file

---

## Commands Executed by the Makefile

Internally the Makefile runs:
```
iverilog -g2012 -o sim.out ../rtl/*.v tb.v  
vvp sim.out  
gtkwave dump.vcd
```
---

## Waveform Dump Requirement

The testbench must generate a waveform dump for GTKWave:
```
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end
```
Without this, waveform viewing will not work.
