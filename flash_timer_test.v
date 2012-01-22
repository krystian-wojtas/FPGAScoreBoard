`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:25 01/19/2012 
// Design Name: 
// Module Name:    flash_timer_test 
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
module flash_timer_test;
	 
	wire CLK_50MHZ;
	clock clk(CLK_50MHZ);
	
	reg RST = 0;
	reg start = 0;
	wire done = 0;
	FlashTimer fl_t( CLK_50MHZ, RST,	start, done	);
	
	initial
	begin
		#4;
		RST = 1;
		#4;
		RST = 0;
		
		#4;
		start = 1;
	end

endmodule
