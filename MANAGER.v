`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:27 01/22/2012 
// Design Name: 
// Module Name:    MANAGER 
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
module MANAGER( CLK_50MHZ, RST, RS_FLOW, RS_DATAIN, RS_DATAOUT, RS_TRG_READ, RS_TRG_WRITE,
						RS_DONE, FL_DATA, FL_ADDR, FL_TRG, FL_STATUS, FL_FLOW );
input CLK_50MHZ;
input RST;
output reg RS_FLOW;
output reg [7:0] RS_DATAIN;
input [7:0] RS_DATAOUT;
output reg RS_TRG_READ, RS_TRG_WRITE;
input RS_DONE;

output reg [7:0] FL_DATA;
output reg [7:0] FL_ADDR = 8'b11001100; 
output reg FL_TRG;
input FL_STATUS;
output reg FL_FLOW;

reg [7:0] data;
wire [2:0] fsm_state;
	
localparam [2:0]		IDLE = 3'd0,
							WAITING_RS = 3'd1,
							READING_RS = 3'd2,
							WRITING_FL = 3'd3,
							WAITING_FL = 3'd4,
							STOP = 3'd5;
	
manager_fsm fsm(	.CLK_50MHZ(CLK_50MHZ), .RST(RST),
						.RS_DONE(RS_DONE), .state(fsm_state),
						.FL_STATUS(FL_STATUS)
					);		

always @* begin
	if( RST ) FL_FLOW = 1;
	
	RS_DATAIN = 8'bx;
	RS_TRG_READ = 1'bx;
	RS_TRG_WRITE = 1'bx;
	FL_TRG = 0;
	
	case( fsm_state )
		WAITING_RS: begin
			FL_DATA = RS_DATAOUT;
		end
		
		WRITING_FL: begin
			FL_FLOW = 0;
			FL_TRG = 1;
		end
		
		STOP: begin
			FL_TRG = 0;
		end
	endcase
end					

endmodule
