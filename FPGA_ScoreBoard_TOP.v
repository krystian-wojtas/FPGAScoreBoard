`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:35 01/22/2012 
// Design Name: 
// Module Name:    FPGA_ScoreBoard_TOP 
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
module FPGA_ScoreBoard_TOP( 
				CLK_50MHZ, RS232_DCE_RXD, RS232_DCE_TXD, BTN_WEST,		// RS-232
				
    );
	
// RS-232	
input CLK_50MHZ;			// MAIN CLOCK
input RS232_DCE_RXD;		// RS INPUT (READ)
output RS232_DCE_TXD;	// RS OUTPUT (WRITE)
input BTN_WEST;			// RESET

wire RS_FLOW, RS_TRG_READ, RS_TRG_WRITE, RS_DONE;
wire [7:0] RS_DATAIN, RS_DATAOUT;

// FLASH
wire FL_FLOW, FL_STATUS, FL_TRG;
wire [7:0] FL_DATA, FL_ADDR;

// MODULE: UART (RS-232)
UART uart( 	.RST(BTN_WEST), .CLK_50MHZ(CLK_50MHZ), .TX(RS232_DCE_TXD), .RX(RS232_DCE_RXD),
				.FLOW(RS_FLOW), .DATA_IN(RS_DATAIN), .DATA_OUT(RS_DATAOUT), .TRG_READ(RS_TRG_READ),
				.TRG_WRITE(RS_TRG_WRITE), .DONE(RS_DONE)
	);

// MODULE: FLASH
Flash fl( 	.CLK_50MHZ(CLKL_50MHZ), .RST(RST), .addr(FL_ADDR), .data(FL_DATA), .fb_start(FL_TRG),
				.fb_done(FL_STATUS), .direction_rw(FL_FLOW)
			);

// MODULE: MANAGER
MANAGER mgr( 	.CLK_50MHZ(CLK_50MHZ), .RST(BTN_WEST), .RS_FLOW(RS_FLOW), .RS_DATAIN(RS_DATAIN),
					.RS_DATAOUT(RS_DATAOUT), .RS_TRG_READ(RS_TRG_READ), .RS_TRG_WRITE(RS_TRG_WRITE),
					.RS_DONE(RS_DONE),
					
					.FL_ADDR(FL_ADDR), .FL_DATA(FL_DATA), .FL_TRG(FL_TRG), .FL_STATUS(FL_STATUS),
					.FL_FLOW(FL_FLOW)
				);


*/



endmodule
