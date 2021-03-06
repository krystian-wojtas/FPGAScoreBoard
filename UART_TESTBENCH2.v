`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:54:54 01/15/2012 
// Design Name: 
// Module Name:    UART_TESTBENCH 
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
module UART_TESTBENCH2(
    );

reg RST;
reg CLK_50MHZ;
wire TX;
reg RX;
wire DONE;
reg TRG_READ;
reg TRG_WRITE;
reg [7:0] DATA_IN;
wire [7:0] DATA_OUT;
reg FLOW;
reg [7:0] LAST_RECEIVED;

UART u( 
		.RST(RST),
		.TX(TX),
		.RX(RX),
		.CLK_50MHZ(CLK_50MHZ),
		.FLOW(FLOW),
		.DATA_IN(DATA_IN),
		.DATA_OUT(DATA_OUT),
		.TRG_READ(TRG_READ),
		.TRG_WRITE(TRG_WRITE),
		.DONE(DONE)
		);

/*** INITIAL ***/			
initial
	begin
	CLK_50MHZ = 0;
	RST = 0;
	FLOW = 0;
	TRG_READ = 0;
	TRG_WRITE = 0;
	
	/** RST CLOCKS **/
	RST = 1;
	#100;
	RST = 0;
	#1000;
	
	DATA_IN = 8'b01010101;
	TRG_WRITE = 1;
	#100;
	TRG_WRITE = 0;
	end

always @(posedge DONE)
	begin
	LAST_RECEIVED = DATA_OUT;
	end

/*** SIMULATION CLK 50 MHZ ***/
always
	begin
	#1;
	CLK_50MHZ = ~CLK_50MHZ;
	end

always @(posedge CLK_50MHZ)
	begin
	RX = TX;
	end
	
endmodule
