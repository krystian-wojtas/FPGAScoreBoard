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
module UART_TESTBENCH(
    );

reg RST;
reg CLK_50MHZ;
wire TX;
wire TX_;
reg RX;
wire DONE;
reg TRG_READ;
reg TRG_WRITE;
reg [7:0] DATA_IN;
wire [7:0] DATA_OUT;
reg FLOW;
reg [7:0] rx_cnt;
reg [3:0] max_write_cnt;

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
	rx_cnt = 0;
	max_write_cnt = 6;
	
	/** RST CLOCKS **/
	RST = 1;
	#10;
	RST = 0;
	end
	
/*** INPUT DATA SIMULATION ***/
always @( posedge CLK_50MHZ )
	begin
	if( rx_cnt ) rx_cnt <= rx_cnt - 1;
	else rx_cnt = 100;
	if( rx_cnt == 1 )	RX = $random % 2;
	end
	
/*** OUTPUT DATA SIMULATION ***/
always @( posedge DONE )
	begin
	DATA_IN = DATA_OUT;
	TRG_READ = 1;
	if( max_write_cnt > 0 )
		begin
		TRG_WRITE = 1;
		max_write_cnt <= max_write_cnt - 1;
		end
	
	#500;
	TRG_READ = 0;
	TRG_WRITE = 0;
	end

/*** SIMULATION CLK 50 MHZ ***/
always
	begin
	#1;
	CLK_50MHZ = ~CLK_50MHZ;
	end
	
assign TX_ = ~TX;
	
endmodule
