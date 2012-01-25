`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:43 01/25/2012 
// Design Name: 
// Module Name:    rs232_sim_fsm 
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
module rs232_sim_fsm( CLK_50MHZ, RST, RX_DONE, state );
input CLK_50MHZ, RST;
input RX_DONE;
output state;

localparam [2:0]	IDLE 				 = 3'd0,
						WAITING_ADDRESS = 3'd1,
						WAITING_DATA 	 = 3'd2,
						DONE				 = 3'd3;

reg [2:0]	state, next;

always @(posedge CLK_50MHZ) begin
	if( RST )	state <= IDLE;
	else			state <= next;
end

always @* begin
		case( state )
		IDLE: begin
					next = WAITING_ADDRESS;
		end
		
		WAITING_ADDRESS: begin
			if( RX_DONE )
					next = WAITING_DATA;
			else 	next = WAITING_ADDRESS;
		end
		
		WAITING_DATA: begin
			if( RX_DONE )
					next = DONE;
			else 	next = WAITING_DATA;
		end
		
		DONE: begin
					next = WAITING_ADDRESS;
		end
	endcase
end


endmodule
