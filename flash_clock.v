`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:44 01/11/2012 
// Design Name: 
// Module Name:    flash_clock 
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
module flash_clock
	(input CLK,
	 output CLK_F
	);
	
reg [3:0] cnt; //TODO czasy
reg clk;
	
always @(posedge CLK_F)
	if(cnt<4'd7) cnt<=cnt+1;
	else
	begin cnt<=0; clk<=~clk; end

assign CLK_F=clk;

endmodule
