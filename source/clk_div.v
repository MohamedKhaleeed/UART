`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:09 07/13/2023 
// Design Name: 
// Module Name:    clk_div 
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

module clk_div(
    input clk_fast,
    output reg clk_slow
    );

	reg [8:0] counter = 0;
	
	always @(posedge clk_fast) begin
		counter <= counter + 9'd1;
		if(counter == 9'd500) begin
			counter <= 0;
			clk_slow <= ~clk_slow;
		end
	end

endmodule