`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:09 01/25/2012 
// Design Name: 
// Module Name:    manager_flash_fsm 
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
module Manager_Flash_FSM(
	input CLK_50MHZ,
	input RST,
	input [7:0] cmd_rx,
	output reg FL_FLOW,
	output reg [7:0] FL_ADDR,
	inout [7:0] FL_DATA,
	input [7:0] addr_rx,
	input [7:0] data_rx,
	output reg fb_start,
	input fb_done,
	input fl_trg,
	output reg tx_trig
   );
	
	wire fl_flow;
	assign fl_flow = cmd_rx[0];
	
	reg [2:0] state_fl; //TODO 2bits
	localparam [2:0]	IDLE = 3'd0,
							FL_WAITING_TRIG = 3'd1,
							FL_RW = 3'd2,
							FL_WAITING_RW = 3'd3;
	
	always @(posedge CLK_50MHZ) begin
		if(RST) state_fl <= IDLE;
		else begin
			case (state_fl)
				IDLE:
					state_fl <= FL_WAITING_TRIG;
				FL_WAITING_TRIG:
					if(fl_trg) state_fl <= FL_RW;
				FL_RW:
					state_fl <= FL_WAITING_RW;
				FL_WAITING_RW:
					if(fb_done) state_fl <= FL_WAITING_TRIG;
			endcase
		end
	end


	always @* begin	
		case( state_fl )
			IDLE: begin
				fb_start = 1'b0;
				tx_trig = 1'b0;
			end
			FL_RW: begin
				FL_FLOW = fl_flow;
				FL_ADDR = addr_rx;
				FL_DATA = data_rx;
				fb_start = 1;
				tx_trig = 1'b1; //TODO nastepny takt
			end
			FL_WAITING_RW: begin
				fb_start = 0;
				tx_trig = 1'b0;
			end
		endcase
	end

endmodule
