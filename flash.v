`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:21 01/11/2012 
// Design Name: 
// Module Name:    flash 
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
module flash(
	output NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP,
	input NF_STS,
	inout NF_A[7:0],
	inout NF_D[7:0],
	inout addr[7:0], //do polaczenia z pozostalymi modulami
	inout data[7:0], //jak wyzej
	input direction_rw, //kierunek odczyt lub zapis
	input do_rw, //wyzwalacz akcji zapisu lub odczytu
	output done, //czy juz wartosc zostala zapisana lub odczytana
	input rst, //linia musi dotrzec rowniez do flash_clocka
	input clk_f,
	output czasomierz_start,
	input czasomierz_done
	);
	
	assign NF_BYTE=1'b0; //8bit data
	assign NF_WP=1'b0; //Protect two outermost Flash boot blocks against all program and erase operations.
	assign NF_A[7:0] = addr[7:0];
	assign NF_D[7:0] = data[7:0];

	always @(posedge rst) // czy posedge
	begin
		//NF_RP = 1'b1; // czy 1
		NF_CE = 1'b1; //wylaczenie ukladu
		NF_WE = 1'b1; //wylaczenie zapisu
		NF_OE = 1'b1; //wylaczenie odczytu
	end


	localparam 	STATE_A = 3'd0,
			STATE_B = 3'd1,
			STATE_C = 3'd2,
			STATE_D = 3'd3;

	reg [2:0] state = STATE_A;
	reg [2:0] next_state = STATE_A;

	always @(posedge clk_f)
	begin
		if(rst) begin
			state <= STATE_A;
		end
		state <= next_state;
	end

	always @(posedge do_rw) //uklad nadrzedny nakazuje wykonanie akcji
	begin
		if(direction_rw == 1'b1)
		begin
			case(state)
			STATE_A: begin
					NF_CE <= 1'b0;
					NF_OE <= 1'b0;
					next_state <= STATE_B;
					czasomierz_startuj <= 1'b1;
				end
			STATE_B: begin
					if(czasomierz_done) begin
						next_state <= STATE_C;
					end
				end
			STATE_C: begin
					NF_CE <= 1'b1;
					NF_OE <= 1'b1;
				end
			endcase
		end
		else
		begin
			case(state)
			STATE_A: begin
				NF_CE <= 1'b0;
				NF_OE <= 1'b1;
				NF_WE <= 1'b0;
				next_state <= STATE_B;
				czasomierz_startuj <= 1'b1;
				end
			STATE_B: begin
					if(czasomierz_done) begin
						next_state <= STATE_C;
					end
				end
			STATE_C: begin
				NF_CE <= 1'b1;
				NF_WE <= 1'b1;
				end
			endcase
		end
	end

endmodule
