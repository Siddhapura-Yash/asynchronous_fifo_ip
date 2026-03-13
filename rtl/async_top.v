module async_top #(parameter DEPTH = 8, DATA_WIDTH = 8, PROG_FULL_VALUE = 2, PROG_EMPTY_VALUE = 3, MODE = 1)
  (input wclk,wrst,
   input rclk,rrst,
   input w_en,r_en,
   input [DATA_WIDTH - 1 : 0]data_in,
   output reg [DATA_WIDTH - 1 : 0]data_out,
   output full,
   output empty,
   output rst_busy,
   output half_empty,
   output half_full,
   output rd_valid,
   output underflow,
   output overflow,
   output prog_full,
   output prog_empty,
   output wr_ack,
   output almost_full,
   output almost_empty,
   output [PTR_WIDTH:0] data_count
   );
  
  parameter PTR_WIDTH = $clog2(DEPTH);
  
  reg [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  reg [PTR_WIDTH:0] b_wptr, b_rptr;
  reg [PTR_WIDTH:0] g_wptr, g_rptr;

  wire [PTR_WIDTH-1:0] waddr, raddr;

  wire [$clog2(DEPTH+1)-1:0]read_data_count;
  wire [$clog2(DEPTH+1)-1:0]write_data_count;
  
  sync #(PTR_WIDTH) sync_wptr (rclk, rrst, g_wptr, g_wptr_sync); //write pointer 
  sync #(PTR_WIDTH) sync_rptr (wclk, wrst, g_rptr, g_rptr_sync); //read pointer  
  
  wptr_handler #(PTR_WIDTH,DEPTH) wptr_h(wclk, wrst, w_en,g_rptr_sync,PROG_FULL_VALUE,b_wptr,g_wptr,full,half_full,prog_full,almost_full);
  rptr_handler #(PTR_WIDTH,DEPTH) rptr_h(rclk, rrst, r_en,g_wptr_sync,PROG_EMPTY_VALUE,b_rptr,g_rptr,empty,half_empty,prog_empty,almost_empty);
  memory #(.DATA_WIDTH(DATA_WIDTH),.DEPTH(DEPTH),.PTR_WIDTH(PTR_WIDTH)) mem(rclk,rrst,MODE, wclk,wrst, w_en,r_en, full, empty, b_wptr, b_rptr, data_in,data_out,rd_valid,overflow,underflow,wr_ack,data_count);

  assign rst_busy = !rrst || ~wrst;

endmodule