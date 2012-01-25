`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:46:27 01/22/2012 
// Design Name: 
// Module Name:    MANAGER 
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
module MANAGER( CLK_50MHZ, RST, RS_FLOW, RS_DATAIN, RS_DATAOUT, RS_TRG_READ, RS_TRG_WRITE,
						RS_DONE, FL_DATA, FL_ADDR, FL_TRG, FL_STATUS, FL_FLOW );
input CLK_50MHZ;
input RST;
output reg RS_FLOW;
output reg [7:0] RS_DATAIN;
input [7:0] RS_DATAOUT;
output reg RS_TRG_READ, RS_TRG_WRITE;
input RS_DONE;

output reg [7:0] FL_DATA;
output reg [7:0] FL_ADDR = 8'b11001100; 
output reg FL_TRG;
input FL_STATUS;
output reg FL_FLOW;

reg [7:0] data;
wire [3:0] state_rx, state_fl, state_tx;
	
localparam [3:0]		IDLE = 4'd0,
							RX_WAITING_CMD = 4'd1,
							RX_READING_CMD = 4'd2,
							RX_WAITING_ADDR = 4'd3,
							RX_READING_ADDR = 4'd4,
							RX_WAITING_DATA = 4'd5,
							RX_READING_DATA = 4'd6,
							FL_RW = 4'd9,
							FL_WAITING = 4'd10,
							TX_WRITING_DATA = 4'd11,
							TX_WAITING_DATA = 4'd12;
							
reg [7:0] cmd_rx;
reg [7:0] addr_rx, addr_tx;
reg [7:0] data_rx, data_tx;

reg fl_trg, tx_trg;


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
				state_rx <= RX_WAITING_CMD;
			end
		endcase
	end
end


always @* begin	
	case( state_rx )
		IDLE: begin
			fl_trg = 1'b0;
			tx_trg = 1'b0;
		end
		RX_READING_CMD: begin
			fl_trg = 1'b0;
			cmd_rx = RS_DATAOUT;
		end
		RX_READING_ADDR: begin
			addr_rx = RS_DATAOUT;
		end
		RX_READING_DATA: begin
			fl_trg = 1'b1;
			data_rx = RS_DATAOUT;
			addr_tx = addr_rx;
			data_tx = data_rx;
		end
	endcase
end


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
				if(FL_STATUS) state_fl <= FL_WAITING_TRIG;
		endcase
	end
end


always @* begin	
	case( state_fl )
		IDLE: begin
			FL_TRG = 1'b0;
			tx_trig = 1'b0;
		end
		FL_RW: begin
			FL_FLOW = cmd_rx[0];
			FL_ADDR = addr_rx;
			FL_DATA = data_rx;
			FL_TRG = 1;
			tx_trig = 1'b1;
		end
		FL_WAITING_RW: begin
			FL_TRG = 0;
			tx_trig = 1'b0;
		end
	endcase
end


always @(posedge CLK_50MHZ) begin
	if(RST) state_tx <= IDLE; // przebieg jalowy dla ustalenia sie state_tx w procesie flasha stanu idle
	else begin
		case (state_tx)
			IDLE: begin
				state_tx <= TX_WAITING_TRIG;
			end
			TX_WAITING_TRIG:
				if( tx_trig )
					state_tx <= TX_WRITING_ADDR;
			TX_WRITING_ADDR:
				state_tx <= TX_WRITING_ADDR_TRG;
			TX_WRITING_ADDR_TRG:
				state_tx <= TX_WAITING_DATA;				
			TX_WAITING_DATA:
					state_tx <= TX_WRITING_ADDR_TRG;
			TX_WRITING_ADDR_TRG:
				state_tx <= TX_WAITING_TRIG;
		endcase
	end
end


always @* begin	
	case( state_tx )
		IDLE:
			RS_TRG_WRITE = 1'b0;
		TX_WRITING_ADDR: begin
			RS_DATAIN = addr_tx;
			RS_TRG_WRITE = 1'b1;
		end
		TX_WRITING_ADDR_TRG:
			RS_TRG_WRITE = 1'b0;
		TX_WAITING_DATA: begin
			RS_DATAIN = data_tx;
			RS_TRG_WRITE = 1'b1;
		end
		TX_WRITING_ADDR_TRG:
			RS_TRG_WRITE = 1'b0;
	endcase
end






//always @(posedge CLK_50MHZ) begin
//	if( RST ) begin
//		state <= IDLE;
//	end else begin
//		state <= next;
//	end
//end
//
//	
//always @* begin
//	// XXXX ALL OUTPUTS
//	
//	case( state )
//		IDLE: begin
//				next = RX_WAITING_CMD;
//		end
//		
//		WAITING_RS: begin
//				if( RS_DONE ) begin
//					next = READING_RS;
//				end else begin
//					next = WAITING_RS;
//				end
//		end
//		
//		READING_RS: begin
//					next = WRITING_FL;
//		end
//		
//		WRITING_FL: begin
//					next = WAITING_FL;		
//		end
//		
//		WAITING_FL: begin
//			if( FL_STATUS ) next = STOP;
//			else	next = WAITING_FL;
//		end
//		
//		STOP: begin
//				next = IDLE;
//		end
//	endcase
//end
//
//
//always @* begin
//	if( RST ) FL_FLOW = 1;
//	
//	RS_DATAIN = 8'bx;
//	RS_TRG_READ = 1'bx;
//	RS_TRG_WRITE = 1'bx;
//	FL_TRG = 0;
//	
//	case( fsm_state )
//		WAITING_RS: begin
//			FL_DATA = RS_DATAOUT;
//		end
//		
//		WRITING_FL: begin
//			FL_FLOW = 0;
//			FL_TRG = 1;
//		end
//		
//		STOP: begin
//			FL_TRG = 0;
//		end
//	endcase
//end					

endmodule
