`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		A. Janusz
// 
// Create Date:    00:33:38 01/15/2012 
// Design Name: 
// Module Name:    UART 
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
module UART(
				input RST,
				input CLK_50MHZ,
				output TX,
				input RX,
				input FLOW,						// REMEMBERED "FLOW" WHILE RESETING
				input [7:0] DATA_IN,
				output [7:0] DATA_OUT,
				input TRG_READ,
				input TRG_WRITE,
				output DONE
				);

wire RST_CLK;				// CLK RESET
wire MOD_RST;				// RX/TX MODULE RESET
reg [7:0] INIT_MOD_CNT = 8'b0;	// COUNTS HOLDING MODULES RESET
wire CLK_RX, CLK_TX;		// MODULES CLK (DIVIDED IN "UART_CLOCK")
reg DATAFLOW = 0;				// FLOW IS STORED HERE (WHILE RESET)

/*** MAIN CLOCK DIVIDER ***/
UART_CLOCK #(.K(2416),.N(16)) clk(.RST(RST_CLK), .CLK(CLK_50MHZ),.CLK_RX(CLK_RX),.CLK_TX(CLK_TX));

/*** READING MODULE ***/
SERIAL_RX_FIFO #(.DEPTH(2))
					mod_rx( 	.CLK_RX(CLK_RX),
							.RST(~MOD_RST),
							.CLK_RD(CLK_50MHZ),			// FIXME: ANOTHER CLOCK?
							.RD_EN(DONE),
							.RX(RX),
							
							.DATA_RDY(DONE),
							.DATA(DATA_OUT)
						);
						
SERIAL_TX_FIFO #(.DEPTH(1))
					mod_tx( 	.CLK_TX(CLK_TX),
							.RST(~MOD_RST),
							.CLK_WR(CLK_50MHZ),
							.WR_EN(TRG_WRITE),							
							.TX(TX),
							
							.DATA(DATA_IN)
						);

uart_rst_fsm fsm( .CLK_RST(RST_CLK),
						.MOD_RST(MOD_RST),
						.RST(RST),
						.CLK(CLK_50MHZ)
						);

endmodule
