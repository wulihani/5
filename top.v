//=======================================================
// Module name: 顶层文件
// 描述: 测试Bram使用1.做一个0.1秒计数器2.一个加法计数器，使能时+，不使能是清零
//=========================================================
`timescale 1ns/1ps

module top(
input sys_clk,

output reg[3:0] led

);
//clock&cnt&r_clk&ILA_clk
wire clk_out;
//w_clk&
wire cnt_out5;
wire cnt_out10;

wire [3:0]r_cnt;

//swich-in

always@(clk_out)
begin
led[1:0]<=douta[1:0];
led[3:2]<=doutb[1:0];
end
(*MARK_DEBUG="TRUE"*) wire [3:0]w_add;
(*MARK_DEBUG="TRUE"*) wire[3:0]r_add;
//swich-out&ram
wire clka;
wire ena;
wire wea;
wire web;//b_wea
wire clkb;
wire [3:0]addra;//!!
wire [3:0]addrb;//!!
//rom&ram
(*MARK_DEBUG="TRUE"*)wire[7:0] din;




(*MARK_DEBUG="TRUE"*) wire [7:0]douta;//ILA
(*MARK_DEBUG="TRUE"*) wire [7:0]doutb;//ILA



clock clock(
.clock_in(sys_clk),
.clock_out(clk_out)
);

cnt5 cnt5(
.clock_in(clk_out),//input0.01S
.clock_out(cnt_out5),//OUT 0.05S
.timer_cnt(w_add)
);
cnt10 cnt10(
.clock_in(clk_out),//input0.01S
.clock_out(cnt_out10),//OUT 0.1S
.timer_cnt(r_add)
);

//add(
//.clock_in(cnt_out5),
//.timer_cnt(w_add)
//);
///
swich swich(
.clock_in(sys_clk),

.w_clk(cnt_out5),
.r_clk(clk_out),
.w_add(w_add),
.r_add(r_add),

.swich_ctrl(cnt_out10),

.a_clk(clka),
. b_clk(clkb),
.a_wea(wea),
.b_wea(web),
.ena(ena),
. a_add(addra),
. b_add(addrb)
);
rom rom(
.add(w_add),
.rom_w(din)
);

//ila_0 ila_0(
//	.clk(clk_out), // input wire clk


//	.probe0(din[0]), // input wire [0:0]  probe0  
//	.probe1(din[1]), // input wire [0:0]  probe1 
//	.probe2(din[2]), // input wire [0:0]  probe2 
//	.probe3(din[3]), // input wire [0:0]  probe3 
//	.probe4(din[4]), // input wire [0:0]  probe4 
//	.probe5(din[5]), // input wire [0:0]  probe5 
//	.probe6(din[6]), // input wire [0:0]  probe6 
//	.probe7(din[7]), // input wire [0:0]  probe7 
//	.probe8(douta[0]), // input wire [0:0]  probe8 
//	.probe9(douta[1]), // input wire [0:0]  probe9 
//	.probe10(douta[2]), // input wire [0:0]  probe10 
//	.probe11(douta[3]), // input wire [0:0]  probe11 
//	.probe12(douta[4]), // input wire [0:0]  probe12 
//	.probe13(douta[5]), // input wire [0:0]  probe13 
//	.probe14(douta[6]), // input wire [0:0]  probe14 
//	.probe15(douta[7]), // input wire [0:0]  probe15 
//	.probe16(doutb[0]), // input wire [0:0]  probe16 
//	.probe17(doutb[1]), // input wire [0:0]  probe17 
//	.probe18(doutb[2]), // input wire [0:0]  probe18 
//	.probe19(doutb[3]), // input wire [0:0]  probe19 
//	.probe20(doutb[4]), // input wire [0:0]  probe20 
//	.probe21(doutb[5]), // input wire [0:0]  probe21 
//	.probe22(doutb[6]), // input wire [0:0]  probe22 
//	.probe23(doutb[7]), // input wire [0:0]  probe23 
//	.probe24(w_add[0]), // input wire [0:0]  probe24 
//	.probe25(w_add[1]), // input wire [0:0]  probe25 
//	.probe26(w_add[2]), // input wire [0:0]  probe26 
//	.probe27(w_add[3]), // input wire [0:0]  probe27 
//	.probe28(r_add[0]), // input wire [0:0]  probe28 
//	.probe29(r_add[1]), // input wire [0:0]  probe29 
//	.probe30(r_add[2]), // input wire [0:0]  probe30 
//	.probe31(r_add[3]) // input wire [0:0]  probe31
//);
blk1 blk1(
  .clka(clkb),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addrb),  // input wire [3 : 0] addra
  .dina(din),    // input wire [15 : 0] dina
  .douta(doutb)  // output wire [15 : 0] douta
);

blk0 blk0(
  .clka(clka),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [3 : 0] addra
  .dina(din),    // input wire [7 : 0] dina
  .douta(douta)  // output wire [7 : 0] douta
);
endmodule
