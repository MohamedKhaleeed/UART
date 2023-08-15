`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 05:20:21 PM
// Design Name: 
// Module Name: top_uart_tb
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


module top_uart_tb();
    parameter n_timer = 10; 
    parameter n_data_bits = 8; 
    reg clk;
    reg reset;
    //timer
    reg [n_timer - 1 : 0] final_value;
    //tx
    reg wr_uart;
    reg [n_data_bits - 1 : 0] w_data;
    wire tx_full;
    //rx
    reg rd_uart;
    wire rx_empty;
    wire [n_data_bits - 1 : 0] r_data;
    
    top_uart# (.n_timer(n_timer),.n_data_bits(n_data_bits)) dut(
        .clk(clk),
        .reset(reset),
        .final_value(final_value),
        .wr_uart(wr_uart),
        .w_data(w_data),
        .tx_full(tx_full),
        .rd_uart(rd_uart),
        .rx_empty(rx_empty),
        .r_data(r_data)
    );
    
    localparam T = 10;
    always begin
        clk = 1'b0;
        #(T/2)
        clk = 1'b1;
        #(T/2);
    end
    
    initial begin
        reset = 1;
        #3
        reset = 0;
        final_value = 650;
        #5
        wr_uart = 1;
        rd_uart = 1;
        w_data = 100;
        #T
        w_data = 150;
        #T
        w_data = 200;
        #T
        w_data = 50;
        #T
        w_data = 40;
        #T
        w_data = 165;
        #T
        w_data = 66;
        #T
        w_data = 87;
        #T
        w_data = 255;
        #T
        w_data = 109;
        #T
        w_data = 60;
        #T
        w_data = 210;
        #T
        w_data = 265;
        #T
        w_data = 170;
        #T
        w_data = 180;
        #T
        w_data = 190;
        #T
        w_data = 200;
        #T
        w_data = 110;
        #T
        w_data = 120;
        #T
        w_data = 130;
        #(220*650*16*T)
        $finish;
    end
endmodule