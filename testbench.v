`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:11:51 01/12/2012 
// Design Name: 
// Module Name:    testbench 
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
module testbench(
    );

reg btn_south, btn_west, btn_east, btn_north;
reg rs232_dce_rxd, rs232_dce_txd;

reg CLK_50MHZ; 
reg [31:0] clk_cnt;
reg clk_input;
reg [3:0] clk_input_cnt;


uart_test t(.CLK_50MHZ(CLK_50MHZ),
				.BTN_SOUTH(btn_south), .BTN_WEST(btn_west), 
				.BTN_EAST(btn_east), .BTN_NORTH(btn_north),
				.RS232_DCE_RXD(rs232_dce_rxd),
				.RS232_DCE_TXD(rs232_dce_txd)
				);
	
/*  INITIAL  */
initial
begin
	// BUTTONS
	btn_west = 0;
	btn_east = 0;
	btn_north = 0;

	//rs232_dce_rxd = 0;
	rs232_dce_txd = 0; 
	
	CLK_50MHZ = 0;
	clk_cnt = 0;
	
	clk_input = 0;
	clk_input_cnt = 0;

	#10;
	btn_south = 1;
	#350;
	btn_south = 0;

end


// clock
always
	begin	
	#1;
	clk_cnt = clk_cnt + 1;	
	
	if( clk_cnt > 10 )
		begin
		clk_cnt = 0;
		CLK_50MHZ = ~ CLK_50MHZ;
		end
	end
	
always @(posedge CLK_50MHZ)
begin
	clk_input_cnt = clk_input_cnt + 1;
	if( clk_input_cnt > 4 )
		begin
		clk_input_cnt = 0;
		clk_input = ~ clk_input;
		rs232_dce_rxd = clk_input;
		end
end

endmodule
