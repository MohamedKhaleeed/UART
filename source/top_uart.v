`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 05:18:55 PM
// Design Name: 
// Module Name: top_uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_uart#(
    parameter n_data_bits = 8,
    parameter n_timer = 10)(
    input clk, reset,
    //timer
    input [n_timer-1 : 0] final_value,
    //tx
    input wr_uart,
    input [n_data_bits - 1 : 0] w_data,
    output tx_full,
    //rx
    input rd_uart,
    output rx_empty,
    output [n_data_bits - 1 : 0] r_data
    );
    
    wire timer_tick;
    timer#(.n(n_timer)) timer(
        .clk(clk),
        .reset(reset),
        .en(1),
        .final_value(final_value),
        .timer_tick(timer_tick)
    );
    
    wire connect, fifo_rx_full, rx_done_tick;
    wire [n_data_bits - 1 : 0] rx_dout;
    receiver#(.n(n_data_bits)) receiver(
        .clk(clk), 
        .reset(reset),       
        .rx(connect),               
        .fifo_full(fifo_rx_full),        
        .s_tick(timer_tick),           
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );
    
    fifo_generator_0 fifo_rx (
        .clk(clk),      // input wire clk
        .srst(reset),    // input wire srst
        .din(rx_dout),      // input wire [7 : 0] din
        .wr_en(rx_done_tick),  // input wire wr_en
        .rd_en(rd_uart),  // input wire rd_en
        .dout(r_data),    // output wire [7 : 0] dout
        .full(fifo_rx_full),    // output wire full
        .empty(rx_empty)  // output wire empty
    );
    
    wire tx_done_tick, tx_empty;
    wire [n_data_bits - 1 : 0] tx_din;
    transmitter#(.n(n_data_bits)) transmitter(
        .clk(clk), 
        .reset(reset),          
        .tx_start(~tx_empty),         
        .s_tick(timer_tick),           
        .tx_din(tx_din), 
        .tx_done_tick(tx_done_tick),
        .tx(connect)           
    );
    
    fifo_generator_0 fifo_tx (
        .clk(clk),      // input wire clk
        .srst(reset),    // input wire srst
        .din(w_data),      // input wire [7 : 0] din
        .wr_en(wr_uart),  // input wire wr_en
        .rd_en(tx_done_tick),  // input wire rd_en
        .dout(tx_din),    // output wire [7 : 0] dout
        .full(tx_full),    // output wire full
        .empty(tx_empty)  // output wire empty
    );
endmodule