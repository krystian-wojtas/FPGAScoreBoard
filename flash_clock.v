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
	(input CLK_50MHZ,
	 inout reg flash_timer_start,
	 output reg flash_timer_done
	);
	
reg [3:0] cnt; //TODO czasy
reg timer_count;

always @(posedge flash_timer_start)
begin
	timer_count = 1'b1;
	flash_timer_start = 1'b0;
	cnt = 0;
end
	
always @(posedge CLK_50MHZ)
	if(timer_count) begin
		if(cnt<4'd7) cnt<=cnt+1;
		else
		begin
			cnt<=0;
			flash_timer_done <= 1'b1;
		end
	end

endmodule
