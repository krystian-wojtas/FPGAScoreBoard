   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent nadajnik portu UART
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


module SERIAL_TX(input CLK_TX,RST,SEND,
                 output TX,DONE,
                 input [7:0] DATA);

(* INIT = "1" *) reg tx_;
(* INIT = "1" *) reg done_;
reg [3:0] cnt;
wire [3:0] ncnt;
reg [7:0] tx_data;
reg send_sync1,send_sync2;

assign ncnt=cnt+1; //(1)

always @(posedge CLK_TX) //(2)
begin
 send_sync1<=SEND;
 send_sync2<=send_sync1;
end

always @(posedge CLK_TX)
 if(~RST) 
	begin 
	done_<=1'b1; 
	tx_<=1'b1;
	end
 else
 begin
  if (send_sync2&done_)
  begin
    done_<=1'b0; cnt<=4'd0; tx_<=1'b0; tx_data<=DATA; //(3)
  end
  else
  begin
    if(~done_)
    begin
     cnt<=ncnt;
     if(ncnt<9)
     begin
      tx_<=tx_data[0]; //(4)
      tx_data<={tx_data[0],tx_data[7:1]}; //(5)
     end
     else
     if(ncnt==4'd9) tx_<=1'b1; //(6)
     else done_<=1'b1;
    end
  end 
 end

assign TX=tx_;
assign DONE=done_;

endmodule


