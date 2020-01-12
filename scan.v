//*************************************************************************\
//==========================================================================
//   Description:
//  320*240像素扫描-》1280*960显示-->1080P输出
//超过图片范围输出输出黑色ffffff--地址17'd6188
//输出地址到rom，rom显示对应颜色
//==========================================================================
//   Revision History:
//	Date		  By			Revision	Change Description
//--------------------------------------------------------------------------
//
//*************************************************************************/
module rom_scan(
input clk,
//像素时钟输入，1080P@1980*1080-148.5M，1280*720@60P-74.25M
input rst,//复位-高有效

output hs,//行同步-高有效
output vs,//场同步-高有效
output de,//数据有效
output [16:0]addr//rom地址

);
parameter H_ACTIVE = 16'd1920; //行有效长度（像素时钟个数）
parameter H_FP = 16'd88; //行同步前肩长度 （每行像素点）
parameter H_SYNC = 16'd44; //行同步长度
parameter H_BP = 16'd148;//行同步后肩长度
parameter V_ACTIVE =16'd1080; //场有效长度（行个数）
parameter V_FP = 16'd4; //场同步前肩长度
parameter V_SYNC =16'd5;//场同步长度
parameter V_BP = 16'd36; //场同步后肩长度
parameter H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;//行总长度·
parameter V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;
//场总长度
parameter blackadd = 17'd6188 //输出黑色像素地址

reg hs_reg;//定义一个寄存器，用于行同步
reg vs_reg;//定义一个寄存器，用于列同步

reg hs_reg_d0;//hs_reg一个时钟的延迟
//所有以_d0、_d1、_d2后缀为某寄存器延迟
reg vs_reg_d0;//vs_reg一个时钟的延迟
//s
reg[11:0] h_cnt;//用于行计数器
reg[11:0] v_cnt;//用于列计数器
reg[11:0] active_x;//有效像素坐标x
reg[11:0] active_y;//有效图像指标y
reg h_active;//行图像有效
reg v_active;//场图像有效
wire video_active;//一帧图像有效区域 h_active&v_active
reg video_active_d0;//video_active一个时钟的延迟
assign hs = hs_reg_d0;
assign vs = vs_reg_d0;
assign video_active = h_active;

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        h_cnt <= 12'd0;
      else if(h_cnt <= H_TOTAL - 1)//行计数器到最大值清零
        h_cnt <= 12'd0;
      else
        h_cnt <= h_cnt +12'd1;
    end
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        active_x <=12'd0;
      else if(h_cnt >= H_FP + H_SYNC + H_BP -1)//计算图像X坐标
        active_x <= h_cnt -(H_FP[11:0] + H_SYNC[11:0] + H_BP[11:0] - 12'd1);
      else
        active_x <= active_x;
    end
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        hs_reg <= 1'b0;
      else if(h_cnt == H_FP - 1)//在行计算器为H_FP - 1的时候场显示器+1或清零
      
      
endmodule







