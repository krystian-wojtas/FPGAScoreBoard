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
module uart_use(
    );

reg RST, RST2;
wire CLK_RX, CLK_TX;
reg RD_EN;
wire DATA_RDY;
wire [7:0] DATA;
reg RX;
reg data_timeout;

/*** SIMULATION CLK ***/
reg CLK_50MHZ;


/*** GIVES NO OUTPUT ***/
UART_CLOCK #(.K(2416),.N(16))
              c1(.RST(RST), .CLK(CLK_50MHZ),.CLK_RX(CLK_RX),.CLK_TX(CLK_TX));

/*** GETS NO CLK_RX ***/
SERIAL_RX_FIFO rx( 	.CLK_RX(CLK_RX),
							.RST(~RST2),
							.RX(RX),
							.CLK_RD(CLK_TX),
							.RD_EN(RD_EN),
							
							.DATA_RDY(DATA_RDY),
							.DATA(DATA)
						);
			
/*** INITIAL ***/			
initial
	begin
	CLK_50MHZ = 0;
	RST = 0;
	RD_EN = 0;
	
	/** RST CLOCKS **/
	RST = 1;
	#10;
	RST = 0;
	
	/** RST RX/TX **/
	RST2 = 1;
	#500;
	RST2 = 0;
	end


always @( posedge DATA_RDY )
	begin
	RD_EN = 1;
	data_timeout = 5;
	end

always @( posedge CLK_TX )
	begin
	RX = $random % 2;
	
	if( data_timeout > 0 )
		data_timeout <= data_timeout - 1;
	if( data_timeout == 1 )
		RD_EN = 0;
	end

/*** SIMULATION CLK 50 MHZ ***/
always
	begin
	#1;
	CLK_50MHZ = ~CLK_50MHZ;
	end

endmodule
