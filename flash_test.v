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
	reg [7:0] data;	reg [7:0] addr;

	reg direction_rw;
	reg fb_start = 0;
	wire fb_done;
	//czasomierz flasha
	
	//reg [7:0] NF_A_;
	//reg [7:0] NF_D_;
	//reg [7:0] addr_;
	//reg [7:0] data_;
//	reg fb_start_;
//	reg fb_done_;
//	reg fb_action_;
//	assign NF_A = NF_A_;
//	assign NF_D = NF_D_;
//	assign addr = addr_;
//	assign data = data_;
//	assign fb_start = fb_start_;
//	assign fb_done = fb_done_;
//	assign fb_action = fb_action_;	
	
	
	clock clk(CLK_50MHZ);
	Flash fl(RST, CLK_50MHZ, NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP, NF_STS, NF_A[7:0], NF_D[7:0], addr[7:0], data[7:0], direction_rw, fb_start, fb_done);
	Flash_sim fl_sim(
		.NF_A(NF_A),
		.NF_D(NF_D), //TODO inout
		.NF_CE(NF_CE), .NF_BYTE(NF_BYTE), .NF_OE(NF_OE), .NF_RP(NF_RP), .NF_WE(NF_WE), .NF_WP(NF_WP),
		.NF_STS(NF_STS)
	 );
	 
	task flash_read(
		input reg [7:0] addr2,
		input reg [7:0] data2
	);
	begin
		addr[7:0] = addr2;
		data[7:0] = data2;
		direction_rw = 1'b1;
		#50;
		fb_start = 1;
		@(negedge CLK_50MHZ) fb_start = 0;
	end
	endtask
	 
	task flash_write(
		input reg [7:0] addr2,
		input reg [7:0] data2
	);
	begin
		addr[7:0] = addr2;
		data[7:0] = data2;
		direction_rw = 1'b0;
		#50;
		fb_start = 1;
		@(negedge CLK_50MHZ) fb_start = 0;
	end
	endtask
		
	reg [7:0] addr3;
	reg [7:0] data3;
	
	initial
	begin	
		#50;
		RST = 0; //TODO reset odwrotnie
		#50;
		RST = 1;
		#50;
		RST = 0;
		#50;
		
		$display("$time [FLASH] test zapisu", $time);
		addr3 = 0;
		data3 = 1;
		repeat( 7 ) 
		begin 
			addr3 = addr3 + 1;
			data3 = data3 << 1'b1;
			flash_write(addr3, data3);
			@(negedge fb_done);
			@(negedge CLK_50MHZ);
			@(negedge CLK_50MHZ);
		end 
		
		$display("$time [FLASH] test odczytu", $time);
		addr3 = 0;
		data3 = 1;
		repeat( 7 ) 
		begin 
			addr3 = addr3 + 1;
			data3 = data3 << 1'b1;
			flash_read(addr3, data3);
			@(negedge fb_done);
			@(negedge CLK_50MHZ);
			@(negedge CLK_50MHZ);
		end 
	
	end
	
	//always @(posedge fb_done)
	//	fb_start = 0;
	
endmodule
