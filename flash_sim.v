`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:42 01/24/2012 
// Design Name: 
// Module Name:    flash_sim 
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
module Flash_sim(
	input [7:0] NF_A,
	inout [7:0] NF_D,
	input NF_CE, NF_BYTE, NF_OE, NF_WE, NF_RP, NF_WP,
	output reg NF_STS
	);
	
	reg [7:0] flash_storage [4:0];
	wire [7:0] NF_D_;
	reg [7:0] NF_D_driver;
	wire [7:0] NF_D = NF_D_driver[7:0]; //inout must be driven by a wire
	//assign NF_D[7:0] = NF_D_driver[7:0];
	
//	wire Read = NF_CE && NF_OE;
//	wire Write = NF_CE && NF_WE;
//	reg [7:0] data_out;
//	assign NF_D = Read ? data_out : 8'bz ;
	
//	always@(posedge clk) begin
//		  if (Write) flash_storage[NF_A] <= NF_D ;
//		  data_out <= flash_storage[NF_A] ;
//	end


	always @(negedge NF_WE) begin
		//deassign NF_D;
//		flash_storage[NF_A] <= NF_D ;
		flash_storage[NF_A][7:0] = NF_D[7:0];
		$display("%t [FLASH] Zapis pod adres 0x%b bajtu 0x%b", $time, NF_A[7:0], flash_storage[NF_A][7:0]);
	end

	always @(negedge NF_OE) begin
		//assign NF_D = NF_D_;
//		data_out <= flash_storage[NF_A] ;
		NF_D_driver[7:0] = flash_storage[NF_A][7:0];
		$display("%t [FLASH] Odczyt z adresu 0x%b bajtu 0x%b", $time, NF_A[7:0],  flash_storage[NF_A][7:0]);
	end

endmodule


