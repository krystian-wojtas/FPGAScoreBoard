   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent nadajnika portu UART z buforem FIFO
//
// (C) 2009 Zbigniew Hajduk
// http://zh.prz-rzeszow.pl
// e-mail: zhajduk@prz-rzeszow.pl
//
// Ten kod Ÿród³owy mo¿e podlegaæ wolnej redystrybucji i/lub modyfikacjom 
// na ogólnych zasadach okreœlonych licencj¹ GNU General Public License.
//
// Autor wyra¿a nadziejê, ¿e kod wirtualnego komponentu bêdzie u¿yteczny
// jednak nie udziela ¯ADNEJ GWARANCJI dotycz¹cej jego sprawnoœci
// oraz przydatnoœci dla partykularnych zastosowañ.
//
////////////////////////////////////////////////////////////////////////////////// 


module SERIAL_TX_FIFO
       #(parameter DEPTH=5)
       (input CLK_TX,RST,WR_EN,CLK_WR,
        output TX,
        input [7:0] DATA);

localparam N=2**DEPTH;
reg [7:0] FIFO [0:N-1];
reg [DEPTH-1:0] rd_cnt, wr_cnt;
wire [7:0] DATA_OUT;
reg [3:0] st;
reg tx_send;
wire tx_done;

SERIAL_TX uart_tx
          (.CLK_TX(CLK_TX),.RST(RST),.SEND(tx_send),
           .TX(TX),.DONE(tx_done),.DATA(DATA_OUT));

//rs232_tx uart_tx
//          (.CLK_TX(CLK_TX),.RST(RST),.WR_EN(tx_send),
//           .TX(TX),.DONE(tx_done),.DATA(DATA_OUT));

always @(posedge CLK_WR)
if(~RST) wr_cnt<=0;
else
 if(WR_EN) wr_cnt<=wr_cnt+1;


always @(posedge CLK_WR)
 if (WR_EN) FIFO[wr_cnt]<=DATA;


assign DATA_OUT=FIFO[rd_cnt];								
		
		
always @(posedge CLK_WR) //(1)
 if(~RST) st<=0;
 else
   case (st)
    0: begin tx_send<=0; rd_cnt<=0; st<=1; end
    1: if(wr_cnt!=rd_cnt) st<=2;else st<=1;
    2: begin tx_send<=1; if(~tx_done) st<=3; end
    3: begin tx_send<=0; if(tx_done) st<=4; end
    4: begin rd_cnt<=rd_cnt+1; st<=1; end
   endcase
									
endmodule




