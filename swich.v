`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/07 16:43:32
// Design Name: 
// Module Name: swich
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 控制两片ram乒乓读写，输入信号为w-clk%w-add/r-clk&r-add
//使用swich_ctrl控制两组信号交叉输出至ramA/ranB
//具体控制情况为swichctrl为0时w-clk%w-add输出至a-clk&a-add,r-clk&r-add输出至b_clk&b_add
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module swich(
input clock_in,
input w_clk,
input r_clk,
input [3:0] w_add,
input [3:0] r_add,
input swich_ctrl,
output reg[0:0] a_clk,
output reg[0:0] b_clk,
output reg[0:0]a_wea,
output reg[0:0]b_wea,
output reg[0:0]ena=1'b1,
output reg[3:0] a_add,
output reg[3:0] b_add
);


//mparameter    ena1 = 1'b1;

always@(r_clk)
begin
if(swich_ctrl)
begin
a_clk<=w_clk;
a_add<=w_add;
b_clk<=r_clk;
b_add<=r_add;
a_wea<=1'b1;
b_wea<=1'b0;
end
else
begin
a_clk<=r_clk;
a_add<=r_add;
b_clk<=w_clk;
b_add<=w_add;
a_wea<=1'b0;
b_wea<=1'b1;
end
end
endmodule
