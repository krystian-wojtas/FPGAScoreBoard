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
module flash_test;
	 
	//output czasomierz_start,
	//input czasomierz_done	
	wire CLK_50MHZ;
	reg RST;	
	//linie flasha
	wire NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP;
	reg NF_STS;
//	reg NF_CE;
//	reg NF_BYTE;
//	reg NF_OE;
//	reg NF_RP;
//	reg NF_WE;
//	reg NF_WP;
//	reg NF_STS;
	wire [7:0] NF_A;
	wire [7:0] NF_D;
	//interfejs modulu
	wire [7:0] addr;
	wire [7:0] data;
	reg direction_rw;
	wire fb_start;
	wire fb_done;
	//czasomierz flasha
	
	reg [7:0] NF_A_;
	reg [7:0] NF_D_;
	reg [7:0] addr_;
	reg [7:0] data_;
	reg fb_start_;
	reg fb_done_;
//	reg fb_action_;
	assign NF_A = NF_A_;
	assign NF_D = NF_D_;
	assign addr = addr_;
	assign data = data_;
	assign fb_start = fb_start_;
	assign fb_done = fb_done_;
//	assign fb_action = fb_action_;	
	
	
	clock clk(CLK_50MHZ);
	Flash fl(RST, CLK_50MHZ, NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP, NF_STS, NF_A[7:0], NF_D[7:0], addr[7:0], data[7:0], direction_rw, fb_start, fb_done);

	
	initial
	begin
		fb_start_ = 0;
		fb_done_ = 0;
	
		#10;
		RST = 0; //TODO reset odwrotnie
		#10;
		RST = 1;
		#10;
		RST = 0;
		
		#20;
		NF_A_[7:0] = 8'dx;
		NF_D_[7:0] = 8'dx;
		#40;
		addr_[7:0] = 8'b00110101;
		data_[7:0] = 8'b11001001;
		direction_rw = 1'b1; //read
		#40;
		fb_start_ = 1;
		
		#100;
		fb_done_ = 1;
	end
	
endmodule
