`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:57:52 01/18/2012 
// Design Name: 
// Module Name:    uart_rst_fsm 
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
module uart_rst_fsm(CLK_RST, MOD_RST, RST, CLK);
output CLK_RST, MOD_RST;
reg CLK_RST, MOD_RST;
input RST, CLK;

parameter [2:0] //synopsys enum code
						IDLE = 3'd0,
				        S1 = 3'd1,
						  S2 = 3'd2,
						STOP = 3'd3,
					  ERROR = 3'd4;
						  
// synopsys state_vector state					  
reg [2:0] // synopsys enum code
				state, next;
				
reg [7:0] mod_cnt;



always @(posedge CLK or posedge RST) begin
	if( RST ) state <= IDLE;
	else begin 
		state <= next;
		if ( state == S1 ) mod_cnt <= 255;
		else if( mod_cnt ) 	mod_cnt <= mod_cnt - 1;
		//if( state == S2 ) mod_cnt <= 255;
	end
end



always @* begin
	next = 3'bx;
	CLK_RST = 0;
	MOD_RST = 0;
	
	case( state ) 
		IDLE: begin /**********************/
							next = S1;
			CLK_RST = 1;
			MOD_RST = 1;
		end
	
		S1: begin /**********************/
							next = S2;
			CLK_RST = 1;
			MOD_RST = 1;
			//mod_cnt = 255;
		end
		
		S2: begin /**********************/
			if( mod_cnt > 3'd0 ) next = S2;
			else 			next = STOP;
			MOD_RST = 1;
		end
		
		STOP: begin /**********************/
							next = STOP;
		end
		
		ERROR: begin
							next = ERROR;
		end		
	endcase
end

endmodule
