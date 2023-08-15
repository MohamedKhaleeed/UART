`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 05:18:07 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter#(
    parameter n = 8)(
    input clk, reset,
    input tx_start,
    input s_tick,
    input [n-1 : 0] tx_din,
    output reg tx_done_tick,
    output tx
    );
    
    reg [3:0] ticks_next, ticks_reg;
    reg [2:0] nbits_next, nbits_reg;
    reg data_next, data_reg;
    reg [n-1 : 0] b_reg, b_next;
    reg [1:0] curr_state, next_state;
    localparam idle = 2'b00;
    localparam start = 2'b01;
    localparam data = 2'b10;
    localparam stop = 2'b11;
    
    always@(posedge clk, posedge reset)begin
        if(reset)begin
            curr_state <= 2'b00;
            ticks_reg <= 4'b0;
            nbits_reg <= 3'b0;
            data_reg <= 1'b1;
            b_reg <= 'b0;
        end
        else begin
            curr_state <= next_state;
            ticks_reg <= ticks_next;
            nbits_reg <= nbits_next;
            data_reg <= data_next;
            b_reg <= b_next;
        end
    end
    
    always@(*)begin
        next_state = curr_state;
        ticks_next = ticks_reg;
        nbits_next = nbits_reg;
        b_next = b_reg;
        data_next = data_reg;
        tx_done_tick = 1'b0;
        
        case(curr_state)
            idle: begin
                    data_next = 1'b1;
                    if(tx_start)begin
                        next_state = start;
                        ticks_next = 0;
                        b_next = tx_din;
                    end
                    else begin
                        next_state = idle;
                    end
            end
            
            start: begin
                    data_next = 1'b0;
                    if(s_tick)begin
                        if(ticks_reg == 15)begin
                            ticks_next = 0;
                            nbits_next = 0;
                            next_state = data;
                        end
                        else begin
                            ticks_next = ticks_reg + 1;
                            next_state = start;
                        end
                    end
                    else begin
                        ticks_next = ticks_reg;
                        next_state = start;
                    end
            end
            
            data: begin
                    data_next = b_reg[0];
                    if(s_tick)begin
                        if(ticks_reg == 15)begin
                            ticks_next = 0;
                            b_next = {1'b0, b_reg[n-1 : 1]};
                            if(nbits_reg == (n-1))begin
                                nbits_next = 0;
                                next_state = stop;
                            end
                            else begin
                                nbits_next = nbits_reg + 1;
                                next_state = data;
                            end
                        end
                        else begin
                            ticks_next = ticks_reg + 1;
                            next_state = data;
                        end
                    end
                    else begin
                        ticks_next = ticks_reg;
                        next_state = data;
                    end
            end
            
            stop: begin
                    data_next = 1'b1;
                    if(s_tick)begin
                        if(ticks_reg == 15)begin
                            ticks_next = 0;
                            next_state = idle;
                            tx_done_tick = 1'b1;
                        end
                        else begin
                            ticks_next = ticks_reg + 1;
                            next_state = stop;  
                        end
                    end
                    else begin
                        ticks_next = ticks_reg;
                        next_state = stop;
                    end
            end

            default: next_state = curr_state;
        endcase
    end
    
    assign tx = data_reg;
    
endmodule