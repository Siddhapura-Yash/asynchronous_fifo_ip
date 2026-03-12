SIM = iverilog
RUN = vvp

RTL = $(wildcard ../rtl/*.v)
TB  = $(wildcard *.v)

OUT = sim.out

run:
	$(SIM) -g2012 -o $(OUT) $(RTL) $(TB)
	$(RUN) $(OUT)

wave:
	gtkwave dump.vcd

clean:
	rm -f $(OUT) dump.vcd
