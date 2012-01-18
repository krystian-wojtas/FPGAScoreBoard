`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:31:42 01/12/2012 
// Design Name: 
// Module Name:    flash_test 
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
module flash_test();
	 
	//output czasomierz_start,
	//input czasomierz_done	
	reg CLK_50MHZ;
	reg RST;	
	//linie flasha
	//reg NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP, NF_STS;
	reg NF_CE;
	reg NF_BYTE;
	reg NF_OE;
	reg NF_RP;
	reg NF_WE;
	reg NF_WP;
	reg NF_BYTE;
	reg NF_STS;
	reg NF_A[7:0];
	reg NF_D[7:0];
	//interfejs modulu
	reg addr[7:0];
	reg data[7:0];
	wire direction_rw;
	wire fb_action;
	//czasomierz flasha
	wire ft_action;
	
	
	flash_clock fl_c(CLK_50MHZ, ft_action);
	flash fl(RST, CLK_50MHZ, NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP, NF_STS, NF_A[7:0], NF_D[7:0], addr[7:0], data[7:0], direction_rw, fb_action, ft_action);

	
	initial
	begin	
		#20;
		NF_A[7:0] = 8'b11111000;
		NF_D[7:0] = 8'b00011111;
		#40;
		addr[7:0] = 8'b00110101;
		data[7:0] = 8'b11001001;
		direction_rw = 1'b1; //write
		#40;
		fb_action = 1;
	end
	
endmodule
