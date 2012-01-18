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
module flash_clock //rename FlashTimer ??
	(input CLK_50MHZ,
	 inout ft_action
	);
	
	reg [3:0] cnt; //TODO czasy
	reg ft_action_;

	always @(posedge ft_action_)
	begin
		cnt = 0;
	end
		
	always @(posedge CLK_50MHZ)
		if(ft_action_) begin //TODO czy przejdzie? ft_action rowniez w module wyzej
			if(cnt<4'd7) cnt<=cnt+1;
			else
			begin
				cnt<=0;
				ft_action_<=0;
			end
		end

	assign ft_action = ft_action_;

endmodule
