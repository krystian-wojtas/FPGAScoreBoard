   //////////////////////////////////////////////////////////////////////////////////
//
// Wirtualny komponent syntezera DDFS dla portu szeregowego
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


module SERIAL_CLOCK #(parameter K=1,N=1)
                     (input CLK,
                      output CLK_RX,CLK_TX);

reg [N-1:0] acc;
reg [3:0] cnt;
reg clk_1_16;

always @(posedge CLK) acc<=acc+K; //(1)
assign CLK_RX=acc[N-1];

always @(posedge CLK_RX) //(2)
 if(cnt<4'd7) cnt<=cnt+1;
 else
 begin cnt<=0; clk_1_16<=~clk_1_16; end
 
assign CLK_TX=clk_1_16;

endmodule

