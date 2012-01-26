`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:54 01/25/2012 
// Design Name: 
// Module Name:    manager_rx_fsm 
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
module Manager_RX_FSM(
	input CLK_50MHZ,
	input RST,
	input [7:0] RS_DATAOUT,
	input RS_DONE,
	output reg fl_trg,
	output reg cmd_rx,
	output reg [7:0] addr_rx,
	output reg [7:0] data_rx
   );
	
	reg cmd_rx_buf;
	
	reg [2:0] state_rx;
	localparam [2:0]	IDLE = 3'd0,
							RX_WAITING_CMD = 3'd1,
							RX_READING_CMD = 3'd2,
							RX_WAITING_ADDR = 3'd3,
							RX_READING_ADDR = 3'd4,
							RX_WAITING_DATA = 3'd5,
							RX_READING_DATA = 3'd6,
							RX_DONE = 3'd7;


	always @(posedge CLK_50MHZ) begin
		if(RST) state_rx <= IDLE;
		else begin
			case (state_rx)
				IDLE: begin
					state_rx <= RX_WAITING_CMD;
				end
				RX_WAITING_CMD: begin
					if( RS_DONE ) begin
						state_rx <= RX_READING_CMD;
					end
				end
				RX_READING_CMD: begin
					state_rx <= RX_WAITING_ADDR;
				end
				RX_WAITING_ADDR: begin
					if( RS_DONE ) begin
						state_rx <= RX_READING_ADDR;
					end
				end
				RX_READING_ADDR: begin
					state_rx <= RX_WAITING_DATA;
				end
				RX_WAITING_DATA: begin
					if( RS_DONE ) begin
						state_rx <= RX_READING_DATA;
					end
				end
				RX_READING_DATA: begin
					state_rx <= RX_DONE;
				end
				RX_DONE: begin
					state_rx <= RX_WAITING_CMD;
				end
			endcase
		end
	end


	always @(posedge CLK_50MHZ) begin
		fl_trg = 1'b0;
	
		case( state_rx )
			RX_WAITING_CMD: begin
				cmd_rx_buf = RS_DATAOUT;
			end
			RX_WAITING_ADDR: begin
				cmd_rx = cmd_rx_buf;
				addr_rx = RS_DATAOUT;
			end
			RX_WAITING_DATA: begin
				data_rx = RS_DATAOUT;
			end
			RX_DONE:
				fl_trg = 1'b1;				
		endcase
	end

endmodule
