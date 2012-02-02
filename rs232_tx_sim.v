`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:07 02/02/2012 
// Design Name: 
// Module Name:    rs232_tx_sim 
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
module rs232_tx_sim(
    );

reg CLK;
wire TX;
reg RST;
reg [7:0]DATA = 8'b11010010;
wire DONE;
reg TRG;

rs232_tx tx( .CLK_TX(CLK), .RST(RST), .TX(TX), .DATA(DATA), .TRG(TRG), .DONE(DONE) );

initial begin
	RST = 0;
	TRG = 0;
	CLK = 0;
	#30;
	RST = 1;
	#30;
	RST = 0;
	#30;
	TRG = 1;
	@(posedge DONE) TRG = 0;
end



always begin
	#10; CLK = ~CLK;
end


endmodule
