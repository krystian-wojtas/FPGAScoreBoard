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
	
	reg [1:0] state;
	localparam [1:0]  IDLE = 2'd0,
							COUNTING = 2'd1,
							STOP = 2'd2;
	
	reg [3:0] cnt; //TODO czasy
		
	always @(posedge CLK_50MHZ) begin	
		if(RST) begin
			state <= IDLE;
			cnt <= 0;
			done <= 0;
		end else begin
		
			case(state) 
				IDLE: begin
					if(start)	state <= COUNTING;
					cnt <= 0;			
					done <= 0;	
				end
				
				COUNTING: begin
					if(cnt > 4'd5) begin
						state <= STOP;
					end
					else begin				
							state <= COUNTING;
							cnt <= cnt + 1;
					end
				end
				
				STOP: begin
									state <= IDLE;
					done <= 1;
				end
			endcase
		
		end
	end
	

endmodule
