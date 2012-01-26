   //////////////////////////////////////////////////////////////////////////////////
//
// Przykadowa aplikacja z portem UART
//
// (C) 2009 Zbigniew Hajduk
// http://zh.prz-rzeszow.pl
// e-mail: zhajduk@prz-rzeszow.pl
//
// Ten kod rdowy moe podlega wolnej redystrybucji i/lub modyfikacjom 
// na oglnych zasadach okrelonych licencj GNU General Public License.
//
// Autor wyraa nadziej, e kod wirtualnego komponentu bdzie uyteczny
// jednak nie udziela ADNEJ GWARANCJI dotyczcej jego sprawnoci
// oraz przydatnoci dla partykularnych zastosowa.
//
//////////////////////////////////////////////////////////////////////////////////


module uart_test(input CLK_50MHZ,
                input BTN_SOUTH,BTN_WEST,BTN_EAST,BTN_NORTH,
                output LCD_E,LCD_RS,LCD_RW,
		 inout [7:0] LCD_DB,
		 output [7:0] LED,
		 input RS232_DCE_RXD,
		 output RS232_DCE_TXD
		 );


reg [3:0] ss;
reg clk_1MHz,WR_EN;
reg [4:0] ct;
wire [7:0] LCD_BUS;
reg [8:0] DATA_IN;
wire [7:0] rx_data;
reg rd_ack,rx_rdy_sync;
wire CLK_RX,CLK_TX,rx_rdy;
reg tx_send;
wire [7:0] tx_data;
wire tx_done;
reg tx_done_sync;

//debouncer d1(.clk(CLK_50MHZ),.PB({BTN_SOUTH,BTN_WEST,BTN_EAST,BTN_NORTH}),
//                             .BUTTONS({sw1,sw2,sw3,sw4}));

assign sw1 = BTN_SOUTH;

lcd_putchar_8 d2(.CLK_1MHZ(clk_1MHz),.CLK_WR(CLK_50MHZ),.WR_EN(WR_EN),
                 .RST(~sw1),.BF(BUSY_FLAG),.DATA_IN(DATA_IN),.LCD_E(LCD_E),
                 .LCD_RS(LCD_RS),.LCD_RW(LCD_RW),.LCD_DB(LCD_BUS));
				 
SERIAL_CLOCK #(.K(2416),.N(16))
              c1(.CLK(CLK_50MHZ),.CLK_RX(CLK_RX),.CLK_TX(CLK_TX)); //(1)
				  
SERIAL_RX rx1(.CLK_RX(CLK_RX),.RST(~sw1),.RX(RS232_DCE_RXD),
              .RD_ACK(rd_ack),.DATA(rx_data),.RDY(rx_rdy));

SERIAL_TX tx1(.CLK_TX(CLK_TX),.RST(~sw1),.SEND(tx_send),
              .TX(RS232_DCE_TXD),.DONE(tx_done),.DATA(tx_data));


assign LCD_DB=LCD_RW?8'hzz:LCD_BUS;
assign BUSY_FLAG=LCD_DB[7];

always @(posedge CLK_50MHZ) 
begin
 rx_rdy_sync<=rx_rdy;
 tx_done_sync<=tx_done;
end

//reg [10][8] tablica = 'hello world'
//always
//	i=i+1 until < 10
//assign tx_data = 8'b01010101;
assign tx_data=rx_data;

always @(posedge CLK_50MHZ) //(2)
if(sw1) ss<=0;
else
 case(ss)
   0: begin WR_EN<=0; DATA_IN<=9'h001; ss<=1; tx_send<=0; end
   1: begin WR_EN<=1; ss<=2; end
   2: begin WR_EN<=0; ss<=3; end
   3: begin tx_send<=0; if(rx_rdy_sync) ss<=4; end
   4: begin DATA_IN<={1'b1,rx_data}; rd_ack<=1; ss<=5; end
   5: begin WR_EN<=1;  ss<=6; end
   6: begin WR_EN<=0; if(~rx_rdy_sync) ss<=7; end
   7: begin rd_ack<=0; tx_send<=1; ss<=8; end	
   8: begin if(~tx_done_sync) ss<=3; end	   
 endcase

assign LED=rx_data;

always @(posedge CLK_50MHZ) 
 if (ct<24) ct<=ct+1;
 else begin ct<=0; clk_1MHz<=~clk_1MHz; end

endmodule
