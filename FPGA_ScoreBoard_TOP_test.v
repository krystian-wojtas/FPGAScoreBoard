`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:21:49 01/23/2012 
// Design Name: 
// Module Name:    FPGA_ScoreBoard_TOP_test 
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
module FPGA_ScoreBoard_TOP_test(
    );
	 
	 wire CLK_50MHZ;
	 reg RST;
	 //reg RS232_DCE_RXD;
	 wire RS232_DCE_RXD;
	 wire RS232_DCE_TXD;
	 reg TRG_READ, TRG_WRITE;
	 reg RS_FLOW;
	 reg [7:0] DATA_IN;
	 wire [7:0] NF_A;
	 wire [7:0] NF_D;
	 wire NF_CE, NF_BYTE, NF_OE, NF_WE, NF_RP, NF_WP;
	 reg NF_STS = 0;
	 
	 reg [7:0] rx_cnt = 0;
	 
	 clock clk(.CLK_50MHZ(CLK_50MHZ));
	 
	 FPGA_ScoreBoard_TOP top(
	 			.CLK_50MHZ(CLK_50MHZ), // MAIN CLOCK
				.BTN_WEST(RST), // RESET
				//RS
				.RS232_DCE_RXD(RS232_DCE_RXD), // RS INPUT (READ)
				.RS232_DCE_TXD(RS232_DCE_TXD), // RS OUTPUT (WRITE)
				//FLASH
				.NF_A(NF_A),
				.NF_D(NF_D), //TODO inout
				.NF_CE(NF_CE), .NF_BYTE(NF_BYTE), .NF_OE(NF_OE), .NF_RP(NF_RP), .NF_WE(NF_WE), .NF_WP(NF_WP),
				.NF_STS(NF_STS)
	 );
	 
	flash_sim fl_sim(
		.NF_A(NF_A),
		.NF_D(NF_D), //TODO inout
		.NF_CE(NF_CE), .NF_BYTE(NF_BYTE), .NF_OE(NF_OE), .NF_RP(NF_RP), .NF_WE(NF_WE), .NF_WP(NF_WP),
		.NF_STS(NF_STS)
	 );
	 
	 
	 // RS SIMULATION
	 rs232_sim rs_sim(
	 			.CLK_50MHZ(CLK_50MHZ), // MAIN CLOCK
				.RST(RST), // RESET
				.TX(RS232_DCE_RXD), // RS INPUT (READ)
				.RX(RS232_DCE_TXD) // RS OUTPUT (WRITE)		
	 );
	 
	 initial
	 begin
			RST = 0;
			RS_FLOW = 0;
			TRG_READ = 0;
			TRG_WRITE = 0;
			
			/** RST CLOCKS **/
			RST = 1;
			#100;
			RST = 0;
			#1000;
	 end

endmodule
