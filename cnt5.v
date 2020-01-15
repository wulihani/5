`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/07 16:43:32
// Design Name: 
// Module Name: cnt10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cnt5(
inout clock_in,//input0.01S
output reg[0:0] clock_out,//OUT 0.05S
output reg[3:0] timer_cnt

);


always@(posedge clock_in)//上上升沿触发
begin
if(timer_cnt>=4'd4)//0.05
begin

    clock_out<=~clock_out;//0.05秒clock信号翻转
    timer_cnt<=4'd0;//计数器计时到0.05秒计数器清零
end
else
begin
   clock_out<=clock_out;//CLOCK信号保持
   timer_cnt<=timer_cnt+4'd1; //计数器+1
end

end
endmodule
