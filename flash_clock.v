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
module FlashTimer //rename FlashTimer ??
	(input CLK_50MHZ,
	 input RST,
	 input start,
	 output reg done
	);
	
	reg [3:0] cnt; //TODO czasy
	reg counting;

	always @(posedge start)
	begin
		cnt = 0;
		done = 0;
		counting = 1;
	end

	always @(posedge RST)
	begin
		done = 0;
		counting = 0;
	end
		
	always @(posedge CLK_50MHZ)
		if(counting) begin //TODO czy przejdzie? ft_action rowniez w module wyzej
			if(cnt<4'd7)
				cnt<=cnt+1; //TODO zakres
			else
				done<=1;
		end
	
	always @(posedge done)
		counting = 0;

endmodule
