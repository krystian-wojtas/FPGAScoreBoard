`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:31:02 01/14/2012 
// Design Name: 
// Module Name:    uart_use 
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
module uart_use2(
    );

reg RST, RST2;
wire CLK_RX, CLK_TX;
reg WR_EN;
reg [7:0] DATA;
wire TX;

reg [3:0] write_cnt;
reg [3:0] write_next;

/*** SIMULATION CLK ***/
reg CLK_50MHZ;


/*** GIVES NO OUTPUT ***/
UART_CLOCK #(.K(2416),.N(16))
              c1(.RST(RST), .CLK(CLK_50MHZ),.CLK_RX(CLK_RX),.CLK_TX(CLK_TX));

/*** GETS NO CLK_WX ***/			
SERIAL_TX_FIFO #(.DEPTH(1))
					tx( 	.CLK_TX(CLK_TX),
							.RST(~RST2),
							.WR_EN(WR_EN),
							.CLK_WR(CLK_TX),
							.TX(TX),
							.DATA(DATA)
						);
			
/*** INITIAL ***/			
initial
	begin
	CLK_50MHZ = 0;
	RST = 0;
	WR_EN = 0;
	
	DATA = 8'b01010101;
	
	/** RST CLOCKS **/
	RST = 1;
	#10;
	RST = 0;
	
	/** RST RX/TX **/
	RST2 = 1;
	#500;
	RST2 = 0;
	
	#5000;
	DATA = 8'b10000110;
	write_next = 1;
	#5000;
	DATA = 8'b10001100;
	write_next = 1;
	#5000;
	DATA = 8'b10001101;
	write_next = 1;
	#5000;
	DATA = 8'b10011010;
	write_next = 1;
	end
	
always @(negedge CLK_TX)
	if( write_cnt > 0 ) write_next <= write_next - 1;

always @(posedge CLK_TX)
	begin
	write_cnt = write_next;
	
	if(write_cnt > 0) WR_EN = 1;
	else WR_EN = 0;
	
	
	end

/*** SIMULATION CLK 50 MHZ ***/
always
	begin
	#1;
	CLK_50MHZ = ~CLK_50MHZ;
	end

endmodule
