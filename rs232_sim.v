`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:31 01/24/2012 
// Design Name: 
// Module Name:    rs232_sim 
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
module rs232_sim( 
				input CLK_50MHZ, // MAIN CLOCK
				input RST, // RESET
				input RX, // RS INPUT (READ)
				output TX // RS OUTPUT (WRITE)
    );

wire DONE;
reg TRG_READ;
reg TRG_WRITE;
reg [7:0] DATA_IN;
wire [7:0] DATA_OUT;
reg FLOW;
//reg [7:0] LAST_RECEIVED;

reg [7:0] send_buff;

	
UART u( 
		.RST(RST),
		.TX(TX),
		.RX(RX),
		.CLK_50MHZ(CLK_50MHZ),
		.FLOW(FLOW),
		.DATA_IN(DATA_IN),
		.DATA_OUT(DATA_OUT),
		.TRG_READ(TRG_READ),
		.TRG_WRITE(TRG_WRITE),
		.DONE(DONE)
	);


initial begin
	FLOW = 1;
	TRG_READ = 0;
	TRG_WRITE = 0;
	send_buff = 8'b00000011;
	
	$display("%t [RS232] Initialized.", $time);
	$display("%t [RS232] Waiting before write.", $time);
	@(negedge RST) #10000;
	
	repeat(3) begin
		write( send_buff );
		send_buff = send_buff <<< 1;
		#100000;
	end
	
end



task write ( input [7:0] data	);
	begin
		DATA_IN = data;
		$display("%t [RS232] Writing '%b' - START.", $time, DATA_IN);	
		TRG_WRITE = 1;
		#100;
		TRG_WRITE = 0;
		$display("%t [RS232] Writing '%b' - DONE.", $time, DATA_IN);
	end
endtask

endmodule
