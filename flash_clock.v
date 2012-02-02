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
	
localparam [1:0]  IDLE = 3'd0,
						COUNTING = 3'd1,
						STOP = 3'd2;
reg [1:0] state, next;	
	
	reg [2:0] cnt, next_cnt; //TODO czasy
		
	always @(posedge CLK_50MHZ) begin
		if(RST) begin
			state <= IDLE;
		end else begin
			state <= next;
			cnt <= next_cnt;
		end
	end
		
	always @* begin	
		done = 0;
		next_cnt = 0;
		
		case(state) 
			IDLE: begin
				done = 0;
				if(start)	next = COUNTING;
				else 			next = IDLE;			
			end
			
			COUNTING: begin
				if(cnt > 4'd5) next = STOP;
				else begin				
						next = COUNTING;
						next_cnt = cnt + 1;
				end
			end
			
			STOP: begin
								next = IDLE;
				done = 1;
			end
		endcase
	end
	

endmodule
