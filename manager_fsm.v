`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:08:54 01/23/2012 
// Design Name: 
// Module Name:    manager_fsm 
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
module manager_fsm( CLK_50MHZ, RST, RS_DONE, FL_STATUS, state );
output state;
input RST, CLK_50MHZ;
input RS_DONE;
input FL_STATUS;

localparam [2:0]		IDLE = 3'd0,
							WAITING_RS = 3'd1,
							READING_RS = 3'd2,
							WRITING_FL = 3'd3,
							WAITING_FL = 3'd4,
							STOP = 3'd5;
	
reg [2:0] state, next;
	 
// WAIT FOR DATA FROM RS
// WRITE DATA TO FLASH

always @(posedge CLK_50MHZ) begin
	if( RST ) begin
		state <= IDLE;
	end else begin
		state <= next;
	end
end

/*
 *	IDLE (reset)
 * WAITING_RS (waiting for data form RS)
 *	READING DATA (from RS)
 *	WRITING DATA (to FLASH)
 *	WAITING_FLASH (for FLASH to ack)
 *	STOP
												*/
												
always @* begin
	// XXXX ALL OUTPUTS
	
	case( state )
		IDLE: begin
				next = WAITING_RS;
		end
		
		WAITING_RS: begin
				if( RS_DONE ) begin
					next = READING_RS;
				end else begin
					next = WAITING_RS;
				end
		end
		
		READING_RS: begin
					next = WRITING_FL;
		end
		
		WRITING_FL: begin
					next = WAITING_FL;		
		end
		
		WAITING_FL: begin
			if( FL_STATUS ) next = STOP;
			else	next = WAITING_FL;
		end
		
		STOP: begin
				next = STOP;
		end
	endcase
end

endmodule
