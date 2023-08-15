`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 05:16:10 PM
// Design Name: 
// Module Name: timer
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


module timer#(
    parameter n = 10)(
    input clk, reset, en,
    input [n-1 : 0] final_value,
    output timer_tick
    );
    
    reg [n-1 : 0] curr_state, next_state;
    always@(posedge clk, posedge reset)begin
        if(reset)
            curr_state <= 'b0;
        else if(en)
            curr_state <= next_state;
        else
            curr_state <= 'b0;
    end
    
    assign timer_tick = (curr_state == final_value);
    
    always@(*)begin
        if(timer_tick)
            next_state = 'b0;
        else
            next_state = curr_state + 1;
    end
endmodule
