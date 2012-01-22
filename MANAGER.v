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
module MANAGER(
    );
input CLK_50MHZ;
input RST;
output reg RS_FLOW;
output reg [7:0] RS_DATAIN;
input [7:0] RS_DATAOUT;
output reg RS_TRG_READ, RS_TRG_WRITE;
input RS_DONE;

	 
// WAIT FOR DATA FROM RS
// WRITE DATA TO FLASH
/*
 *	IDLE (reset)
 * WAITING_RS (waiting for data form RS)
 *	READING DATA (from RS)
 *	WRITING DATA (to FLASH)
 *	WAITING_FLASH (for FLASH to ack)
 *	STOP
												*/

endmodule
