
////////////////////////////////////////////////////////////////////////////////
// Company: <Company Name>
// Engineer: <Engineer Name>
//
// Create Date: <date>
// Design Name: <name_of_top-level_design>
// Module Name: <时钟分频>
// Target Device: <target device>
// Tool versions: <tool_versions>
// Description:
//    <对系统时间脉冲进行计数0.01秒反转一次>
// Dependencies:
//    <Dependencies here>
// Revision:
//    <Code_revision_information>
// Additional Comments:
//    <Additional_comments>
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module clock(
inout clock_in,
output reg[0:0] clock_out
);
reg[31:0] timer_cnt;
always@(posedge clock_in)//上上升沿触发
begin
if(timer_cnt>=32'd4_999_99)//0.01
begin

    clock_out<=~clock_out;//0.01秒clock信号翻转
    timer_cnt<=32'd0;//计数器计时到0.01秒计数器清零
end
else
begin
   clock_out<=clock_out;//CLOCK信号保持
   timer_cnt<=timer_cnt+32'd1; //计数器+1
end

end

endmodule
			
	
