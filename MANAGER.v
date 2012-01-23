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

inout [7:0] FL_DATA;
output reg [7:0] FL_ADDR = 8'b11001100; 
output FL_TRG;
input FL_STATUS;
output FL_FLOW;

reg [7:0] data;
	
manager_fsm fsm(	.CLK_50MHZ(CLK_50MHZ), .RST(RST),
						.RS_DONE(RS_DONE)
					);					

endmodule
