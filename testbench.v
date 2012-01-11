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
    input CLK_5MHZ
    );

/*
module uart_test(input CLK_50MHZ,
                input BTN_SOUTH,BTN_WEST,BTN_EAST,BTN_NORTH,
                output LCD_E,LCD_RS,LCD_RW,
		 inout [7:0] LCD_DB,
		 output [7:0] LED,
		 input RS232_DCE_RXD,
		 output RS232_DCE_TXD);
*/

reg btn_south, btn_west, btn_east, btn_north;
reg lcd_e, lcd_rs, lcd_rw;
wire [7:0] lcd_db;
wire [7:0] led;
reg rs232_dce_rxd, rs232_dce_txd;

uart_test t(.BTN_SOUTH(btn_south), .BTN_WEST(btn_west), 
				.BTN_EAST(btn_east), .BTN_NORTH(btn_north),
				.LCD_E(lcd_e), .LCD_RS(lcd_rs), .LCD_RW(lcd_rw),
				.LCD_DB(lcd_db), .LED(led), .RS232_DCE_RXD(rs232_dce_rxd),
				.RS232_DCE_TXD(rs232_dce_txd) );

assign btn_south = 0;
assign btn_west = 0;
assign btn_east = 0;
assign btn_north = 0;
				
initial
begin
		#10;
		btn_south = 1;
		#10;
		btn_south = 0;
		#20;
		$stop;
end

endmodule
