`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:44 02/02/2012 
// Design Name: 
// Module Name:    rs232_tx 
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
module rs232_tx( CLK_TX, RST, TX, DATA, WR_EN, DONE
    );
	 
input CLK_TX;
input RST;
output TX;
input [7:0]DATA;
input WR_EN;
output reg DONE;

// --------------------

reg tx_;
assign TX = tx_;

reg [7:0] data_buf;
reg [3:0] data_left;


localparam [2:0]	IDLE = 0,
						WAITING_TRG = 1,
						SEND_START = 2,
						WAITING_WRITE = 3,
						DONE_WRITING = 4;

reg [2:0] state, next;


always @(posedge CLK_TX) begin
	if( ~RST ) state <= IDLE;
	else state <= next;
end


always @* begin
	if( ~RST )
		next = IDLE;
	else begin
		case( state )
			IDLE: begin 
								next = WAITING_TRG;
			end
			WAITING_TRG: begin 
				if( WR_EN )	next = SEND_START;
				else			next = WAITING_TRG;
			end
			SEND_START: begin
								next = WAITING_WRITE;
			end
			WAITING_WRITE: begin 
				if( data_left > 0 )
								next = WAITING_WRITE;
				else			next = DONE_WRITING;
			end
			DONE_WRITING: begin 
								next = IDLE;
			end
		endcase
	end
end


always @(posedge CLK_TX) begin
	if( ~RST ) begin
		DONE <= 1;
		tx_ <= 1;
	end else begin
		case( state )
			IDLE: begin end
			WAITING_TRG: begin 
				data_left <= 7;
				data_buf <= DATA;
				tx_ <= 1;
//				$display("waiting_trg"); 
			end
			SEND_START: begin
//				$display("SENDING START");
				tx_ <= 0;
				DONE <= 0;
			end
			WAITING_WRITE: begin 
				data_left <= data_left - 1;
				tx_ <= ~data_buf[0];
//				$display("SENDING BIT: %b", data_buf[0]);
				data_buf[7:0] <= {0, data_buf[7:1]};
			end
			DONE_WRITING: begin 			
//				$display("DONE");
				DONE <= 1;
				// HERE IS STOP-BIT
			end
		endcase
	end
end


endmodule
