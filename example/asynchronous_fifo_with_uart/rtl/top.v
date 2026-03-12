module top #(
    parameter DEPTH = 8,
    parameter DATA_WIDTH = 8,
    parameter PROG_FULL_VALUE = 2,
    parameter PROG_EMPTY_VALUE = 3,
    parameter MODE = 0)(
           input wclk,wrst,
           input rclk,rrst,
           input data_in,
           input debug_start,
           output data_out
);

  parameter PTR_WIDTH = $clog2(DEPTH);

wire [DATA_WIDTH - 1 : 0]rx_out;
wire byte_done;

rx RX_DUT(.i_Clock(wclk),
          .i_Rx_Serial(data_in),
          .o_Rx_DV(byte_done),
          .o_Rx_Byte(rx_out) 
          );
    
wire [DATA_WIDTH - 1 : 0]async_out;

wire async_wen;
assign async_wen = byte_done;

wire async_prog_full;
wire async_half_full;
wire async_almost_full;
wire async_full;
wire async_empty;
wire rst_busy;
wire async_half_empty;
wire async_rd_valid;
wire async_underflow;
wire async_overflow;
wire async_prog_empty;
wire async_wr_ack;
wire async_almost_empty;
wire [PTR_WIDTH:0] async_data_count;

async_top #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH), .PROG_FULL_VALUE(PROG_FULL_VALUE), .PROG_EMPTY_VALUE(PROG_EMPTY_VALUE), .MODE(MODE))ASYNC_DUT(
            .wclk(wclk),
            .wrst(wrst),
            .rclk(rclk),
            .rrst(rrst),
            .w_en(async_wen),
            .r_en(async_ren),
            .data_in(rx_out),
            .data_out(async_out),
            .full(async_full),
            .empty(async_empty),
            .rst_busy(rst_busy),
            .half_empty(async_half_empty),
            .half_full(async_half_full),
            .rd_valid(async_rd_valid),
            .underflow(async_underflow),
            .overflow(async_overflow),
            .prog_full(async_prog_full),
            .prog_empty(async_prog_empty),
            .wr_ack(async_wr_ack),
            .almost_full(async_almost_full),
            .almost_empty(async_almost_empty),
            .data_count(async_data_count)
);

//After writing start reading from FIFO, so that we can see the data coming out of FIFO in the waveform.
reg start;

always@(posedge wclk or negedge wrst) begin
    if(!wrst) begin
        start <= 1'b0;
    end
    else begin
        if (async_data_count == DEPTH && start == 1'b0) begin
            start <= 1'b1;
        end 
        end
end

wire tx_done;
wire tx_active;
wire async_ren;

//------------------------- Logic for normal mode -------------------------
/*
assign async_ren = !async_empty && !tx_active && !tx_done && start;

// wire tx_out;
//wire i_Tx_DV;
//assign i_Tx_DV = !async_empty && !tx_active && !tx_done && start ;
// assign i_Tx_DV = !async_empty && !tx_active && !tx_done ;

uart_tx TX_DUT (
    .i_Clock(rclk),
    .i_Tx_DV(async_ren),
    .i_Tx_Byte(async_out),
    .o_Tx_Active(tx_active),
    .o_Tx_Serial(data_out),
    .o_Tx_Done(tx_done)
);
*/
//------------------------- end of normal mode logic -------------------------

//------------------------- Logic for FWFT mode -------------------------

wire tx_start;
assign tx_start = !async_empty && !tx_active && debug_start && !tx_done;

assign async_ren = tx_done;

uart_tx TX_DUT (
    .i_Clock(rclk),
    .i_Tx_DV(tx_start),
    .i_Tx_Byte(async_out),
    .o_Tx_Active(tx_active),
    .o_Tx_Serial(data_out),
    .o_Tx_Done(tx_done)
);

//------------------------- end of logic for FWFT mode -------------------------


assign full = async_full;
endmodule