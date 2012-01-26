`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:23 01/14/2012 
// Design Name: 
// Module Name:    CLK_DIV_TEST 
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
module CLK_DIV_TEST(
    );


reg CLK, CLK2;
reg RST;

CLK_DIV  #(.K(10), .N(4))
			c(	.RST(RST),
				.CLK_IN(CLK),
				.CLK_OUT(CLK2)
				);

initial
	begin
	CLK = 0;
	RST = 1;
	#100;
	RST = 0;
	
	end

always
	begin
	#10;
	CLK = ~CLK;
	end

endmodule
