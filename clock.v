`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:05 01/19/2012 
// Design Name: 
// Module Name:    clock 
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
module clock(
	  output reg CLK_50MHZ//,
	  //input RST
    );
	
	initial CLK_50MHZ = 0;
	 
	/*** SIMULATION CLK 50 MHZ ***/
	always
	begin
		#10;
		CLK_50MHZ = ~CLK_50MHZ;
	end

endmodule
