`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:58 07/07/2023 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input RX,
    input rst,
	 //input clk,
    input clkp,
	 input clkn,
    output [7:0] data_out,
    output error
    );
	 
	wire sys_clk_sig;

	clk clk_ins
   (// Clock in ports
    .CLK_IN1_P(clkp),    // IN
    .CLK_IN1_N(clkn),    // IN
    // Clock out ports
    .CLK_OUT1(sys_clk_sig),     // OUT
    // Status and control signals
    .RESET(rst));       // IN
 
	clk_div instance_name (
    .clk_fast(sys_clk_sig), 
    .clk_slow(clk_slow)
    );
 
	fsm fsm_ins (
    .RX(RX), 
    .rst(rst), 
    .sys_clk(clk_slow), 
    .data_out(data_out), 
    .error(error)
    );
	

endmodule
