`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:32 01/14/2012 
// Design Name: 
// Module Name:    CLK_DIV 
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


//		( BASE_FREQ * K ) / N

module CLK_DIV #(parameter K=1, N=1)
	(
	input RST,
   input CLK_IN,
   input CLK_OUT
   );

reg[N-1:0] acc;

always @(posedge CLK_IN or negedge CLK_IN)
	if( RST )
		begin
			acc = 0;
		end

always @(posedge CLK_IN)
	begin
		acc <= acc + K;
	end

assign CLK_OUT = acc[N-1];

endmodule
