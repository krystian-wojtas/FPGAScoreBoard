`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:36 01/18/2012 
// Design Name: 
// Module Name:    uart_clk_fsm 
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
module uart_clk_fsm #(parameter K=1, N=1) (RST, CLK, CLK_RX, CLK_TX);
input RST, CLK;
output CLK_RX, CLK_TX;
wire CLK_RX, CLK_TX;

parameter [2:0] // synopsys enum code
					 IDLE = 3'd0,
						S1 = 3'd1,
						S2 = 3'd2;

reg [2:0] // synopsys state_vector state
				state, next;

reg [N-1:0] acc;
reg [N-1:0] next_acc;
reg [3:0] cnt;
reg [3:0] next_clk;
reg clk_1_16, next_clk_1_16;


always @(posedge CLK) begin
	if( RST ) 	state <= IDLE;
	else begin
			state <= next;
			acc <= acc + K;
			clk_1_16 <= next_clk;
			if( cnt < 4'd7 ) cnt <= cnt + 1;
			else cnt <= 0;
		end
end



always @* begin
		next = 3'bx;
		
		case( state )
		
		IDLE: begin
						next = S1;
		end
		
		S1: begin /***********************/		
				if (cnt == 0 ) next = S2;
				else 	next = S1;				
			next_clk = clk_1_16;
		end
		
		S2: begin
						next = S1;						
			next_clk = ~clk_1_16;
		end
		
		endcase
end



assign CLK_RX=acc[N-1];
assign CLK_TX=clk_1_16;

endmodule