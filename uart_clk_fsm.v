`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:36 01/18/2012 
// Design Name: 
// Module Name:    uart_clk_fsm 
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
module uart_clk_fsm #(parameter K=1, N=1) (RST, CLK, CLK_RX, CLK_TX);
input RST, CLK;
output CLK_RX, CLK_TX;
wire CLK_RX, CLK_TX;

parameter [2:0] // synopsys enum code
					 IDLE = 3'd0,
						S1 = 3'd1,
						S2 = 3'd2;

reg [2:0] // synopsys state_vector state
				state, next;

reg [N-1:0] acc=0;
reg [3:0] cnt=0;
reg clk_1_16=0;

always @(posedge CLK) acc<=acc+K; //(1)

always @(posedge CLK_RX) //(2)
 if(cnt<4'd7) cnt<=cnt+1;
 else
 begin cnt<=0; clk_1_16<=~clk_1_16; end
 
assign CLK_RX=acc[N-1]; 
assign CLK_TX=clk_1_16;

endmodule