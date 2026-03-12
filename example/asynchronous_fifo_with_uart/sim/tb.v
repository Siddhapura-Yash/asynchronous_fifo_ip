`timescale 1ns/1ps

`define CLKS_PER_BIT 120

module tb;

  reg wclk, rclk;
  reg wrst, rrst;

  reg  data_in;     // Serial RX line
  wire tx_out;      // Serial TX line
  reg debug_start = 0;

  integer i;
  integer clk_count;

  localparam  TB_DEPTH = 8;
  localparam TB_DATA_WIDTH = 8;
  localparam TB_MODE = 0;
  localparam PROG_FULL_VALUE = 3;
  localparam PROG_EMPTY_VALUE = 5;

  top #(TB_DEPTH,TB_DATA_WIDTH,PROG_FULL_VALUE,PROG_EMPTY_VALUE,TB_MODE)TOP_DUT (
      .wclk(wclk),
      .wrst(wrst),
      .rclk(rclk),
      .rrst(rrst),
      .data_in(data_in),
      .debug_start(debug_start),
      .data_out(tx_out)
        );

  initial begin
    wclk     = 0;
    rclk     = 0;
  end

  always #4  wclk     = ~wclk;       // Write clock
  always #5  rclk     = ~rclk;       // Read clock

  initial begin
    wrst = 0;
    rrst = 0;
    data_in = 1;   // UART idle HIGH

    repeat(20) @(posedge wclk);

    wrst = 1;
    rrst = 1;
    debug_start = 1'b0;
  #1000;
  end

  task send_bit;
    input bit_val;
    begin
      data_in = bit_val;

      for (clk_count = 0; clk_count < `CLKS_PER_BIT; clk_count = clk_count + 1)
        @(posedge wclk);
    end
  endtask


  task send_byte;
    input [7:0] data_byte;
    begin
      $display("Sending Byte = %h at time %0t", data_byte, $time);

      // START BIT
      send_bit(0);

      // DATA BITS (LSB FIRST)
      for (i = 0; i < 8; i = i + 1)
        send_bit(data_byte[i]);

      // STOP BIT
      send_bit(1);

      // Small idle gap between bytes
      send_bit(1);
    end
  endtask

  initial begin
    @(posedge wrst);

    send_byte(8'hA5);
    send_byte(8'h3C);
    send_byte(8'hF0);
    send_byte(8'hAC);

    send_byte(8'hAA);
    send_byte(8'hFC);
    send_byte(8'hA0);
    send_byte(8'h3A);

    #300;
    debug_start = 1'b1;
    
    #500000;
    $finish;
  end


  initial begin
    $monitor("T=%0t | RX=%b | TX=%b", $time, data_in, tx_out);
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
