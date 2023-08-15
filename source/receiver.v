`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 05:17:31 PM
// Design Name: 
// Module Name: receiver
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


module receiver#(
    parameter n = 8)(
    input clk, reset,
    input rx,
    input fifo_full,
    input s_tick,
    output reg rx_done_tick,
    output [n-1 : 0] rx_dout
    );
    
    reg [3:0] ticks_next, ticks_reg;
    reg [2:0] nbits_next, nbits_reg;
    reg [n-1 : 0] data_next, data_reg;
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
            data_reg <= 'b0;
        end
        else if(fifo_full)begin
            curr_state <= 2'b00;
            ticks_reg <= 4'b0;
            nbits_reg <= 3'b0;
            data_reg <= 'b0;
        end
        else begin
            curr_state <= next_state;
            ticks_reg <= ticks_next;
            nbits_reg <= nbits_next;
            data_reg <= data_next;
        end
    end
    
    always@(*)begin
        next_state = curr_state;
        rx_done_tick = 1'b0;
        ticks_next = ticks_reg;
        nbits_next = nbits_reg;
        data_next = data_reg;
        
        case(curr_state)
            idle: if(rx)
                    next_state = idle;
                  else begin
                    next_state = start;
                    ticks_next = 0;
                  end
                   
            start: begin
                    if(s_tick)begin
                        if(ticks_reg == 7)begin
                            next_state = data;
                            ticks_next = 0;
                            nbits_next = 0;
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
                    if(s_tick)begin
                        if(ticks_reg == 15)begin
                            data_next = {rx, data_reg[n-1 : 1]};
                            ticks_next = 0;
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
                            ticks_next = ticks_reg +1;
                            next_state = data;
                        end   
                    end    
                    else begin
                        ticks_next = ticks_reg;
                        next_state = data;
                    end
            end
            
            stop: begin
                    if(s_tick)begin
                        if(ticks_reg == 15)begin
                            next_state = idle;
                            ticks_next = 0;
                            rx_done_tick = 1;
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
    assign rx_dout = data_reg;
endmodule