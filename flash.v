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
module Flash( //rename FlashBridge?
	input RST, //linia musi dotrzec rowniez do flash_clocka
	input CLK_50MHZ,
	output reg NF_CE, NF_BYTE, NF_OE, NF_RP, NF_WE, NF_WP,
	input NF_STS,
	output [7:0] NF_A,
	output [7:0] NF_D,
	input [7:0] addr, //do polaczenia z pozostalymi modulami
	input [7:0] data, //jak wyzej
	input direction_rw, //kierunek odczyt lub zapis
	input fb_start, //podnoszac linie z zew jest wyzwalaczem akcji zapisu lub odczytu; obnizajac z wew informuje ze akcja zostala wykonana
	output reg fb_done
	);
	
		assign NF_A[7:0] = addr[7:0]; //TODO czy dziala w obie strony ??
		assign NF_D[7:0] = data[7:0]; //TODO jak wyzej ??
	
//	always @* begin
//		NF_A[7:0] = addr[7:0]; //TODO czy dziala w obie strony ??
//		NF_D[7:0] = data[7:0]; //TODO jak wyzej ??
//	end
//	reg NF_CE_;
//	reg NF_WE_;
//	reg NF_OE_;
//	assign NF_CE = NF_CE_;
//	assign NF_WE = NF_WE_;
//	assign NF_OE = NF_OE_;
		
//	reg direction_rw_;
//	reg fb_action_;
//	reg ft_action_;
//	assign direction_rw = direction_rw_;
//	assign fb_action = fb_action_;
//	assign ft_action = ft_action_;

//	always @(posedge RST) // czy posedge
//	begin
//		//NF_RP = 1'b1; // czy 1
//		NF_CE = 1'b1; //wylaczenie ukladu
//		NF_WE = 1'b1; //wylaczenie zapisu
//		NF_OE = 1'b1; //wylaczenie odczytu
//		NF_BYTE=1'b0; //8bit data
//		NF_WP=1'b0; //Protect two outermost Flash boot blocks against all program and erase operations.
//	end

	
	reg ft_start;
	wire ft_done;
	FlashTimer fl_timer(.CLK_50MHZ(CLK_50MHZ), .RST(RST), .start(ft_start), .done(ft_done));

	localparam 	IDLE = 3'd0,
			RW = 3'd1,
			WAITING = 3'd2,
			DONE = 3'd3;

	reg [2:0] state;
	reg [2:0] next_state;

	always @(posedge CLK_50MHZ)
	begin
		if(RST) begin
			//NF_RP = 1'b1; // czy 1
			NF_CE = 1'b1; //wylaczenie ukladu
			NF_WE = 1'b1; //wylaczenie zapisu
			NF_OE = 1'b1; //wylaczenie odczytu
			NF_BYTE=1'b0; //8bit data
			NF_WP=1'b0; //Protect two outermost Flash boot blocks against all program and erase operations.
		end
	end
	
	always @(posedge CLK_50MHZ)
		if(RST) 
			state <= IDLE;
		else
			state <= next_state;

	always @*
	begin
		if(RST) begin
			fb_done = 0;
			ft_start = 0;
		end else	begin
			next_state = 3'dx;
			case(state)
				IDLE:
					if(fb_start == 1'b1) //uklad nadrzedny nakazal wykonanie akcji
						next_state = RW;
					else
						next_state = IDLE;
				RW: 			
					next_state = WAITING;
				WAITING:
					if(ft_done)
						next_state = DONE;
					else
						next_state = WAITING;
				DONE:
					next_state = IDLE;
			endcase
		end
	end
	
	
	always @*
	begin
		case(state)
			IDLE: begin
				NF_CE <= 1'b1;
				NF_OE <= 1'b1;
				NF_WE <= 1'b1;
				ft_start <= 1'b0;
				fb_done <= 1'b0;
			end
			RW: begin
				if(direction_rw) begin
					NF_CE <= 1'b0;
					NF_OE <= 1'b0;
					ft_start <= 1'b1;
				end
				else begin
					NF_CE <= 1'b0;
					NF_WE <= 1'b0;
					ft_start <= 1'b1;
				end
			end
			WAITING:
				ft_start <= 0;
			DONE:
				fb_done <= 1;
		endcase
	end
	

endmodule
