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
output hs,//行同步-高有效（似乎实际的是拉低）
output vs,//场同步-高有效
output de,//数据有效
output [16:0]addr//rom地址
);
parameter H_ACTIVE = 16'd1920; //行有效长度（像素时钟个数）
parameter H_FP = 16'd88; //行同步前肩长度 （每行像素点xxxxx一部分无效像素，下面的都是无效的）
parameter H_SYNC = 16'd44; //行同步长度
parameter H_BP = 16'd148;//行同步后肩长度
  
parameter V_ACTIVE =16'd1080; //场有效长度（行个数）
parameter V_FP = 16'd4; //场同步前肩长度
parameter V_SYNC =16'd5;//场同步长度
parameter V_BP = 16'd36; //场同步后肩长度
  
parameter H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;//行总长度·因为有数据周期和控制信号周期
parameter V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;//场总长度

parameter blackadd = 17'd6188;//输出黑色像素地址
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
  reg[11:0] addr_x;//x地址
  reg[11:0] addr_y;//y地址
reg h_active;//行图像有效
reg v_active;//场图像有效
wire video_active;//一帧图像有效区域 h_active&v_active
reg video_active_d0;//video_active一个时钟的延迟
  
assign hs = hs_reg_d0;//行同步信号取值为1/0->有效/无效，一直赋值至hs
assign vs = vs_reg_d0;//同上
  //hs_reg->hs_reg_d0
assign video_active = h_active & v_active;
assign de = video_active_d0; //video_active->video_active_d0->de
  assign addr_x = active_x/4;
  assign addr_y = active_y/4;
//一
//对时钟信号与复位信号上升沿反应，若rst高，hs,vs,de拉低，否则这些信号保持（依其他信号改变）
always@(posedge clk or posedge rst)
begin
  if(rst)
    begin
     hs_reg_d0 <= 1'b0;
     vs_reg_d0 <= 1'b0;
     video_active_d0 <= 1'b0;
    end
  else
    begin
      hs_reg_d0 <= hs_reg;
      vs_reg_d0 <= vs_reg;
      video_active_d0 <= video_active;
    end  
end
//二
//若rst，行计数器清零，否则判断是否最大值清零，没有就 行像素+1
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        h_cnt <= 12'd0;
      else if(h_cnt <= H_TOTAL - 1)//行计数器到最大值清零<已经扫描完该行>
        h_cnt <= 12'd0;
      else
        h_cnt <= h_cnt +12'd1;
    end
  //三
  //active_x有效像素坐标x
  //复位有效像素归零，如果h_cnt技术范围还在无效像素时，active_x保持，否则赋值为实际有效像素坐标
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        active_x <=12'd0;
      else if(h_cnt >= H_FP + H_SYNC + H_BP -1)//计算图像X坐标
        active_x <= h_cnt -(H_FP[11:0] + H_SYNC[11:0] + H_BP[11:0] - 12'd1);
      else
        active_x <= active_x;
    end
  //四
  //v_cnt;//用于场计数器（记行数）
  //H_FP = 16'd88; //行同步前肩长度 
  //处理v_cnt寄存器状态
  //①v_cnt复位②在每一行的行消隐某时刻，检查场技术器的行数（是否为本帧最后一行），是->清零
  //不是->V_cnt+1 ③非复位及行消隐时刻v_cnt保持
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        v_cnt <= 1'b0;
      else if(h_cnt == H_FP - 1)//在行计算器为H_FP - 1的时候场显示器+1或清零
        if(v_cnt == V_TOTAL -1 )//场计数器到最大值，清零
          v_cnt <= 12'd0;
        else
          v_cnt <= v_cnt +12'd1;//没到最大值，+1
      else
        v_cnt <= v_cnt;
    end
  //五
  //hs_reg;//行同步寄存器，行信号周期有行消隐期（包含：消隐前期、行同步期、消隐后期）和水平有效显示期
  //hs_reg置1表示行同步期，其余时期均为0（长度h_sync【行同步】时钟个数）
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        hs_reg <= 1'b0;
      else if(h_cnt == H_FP -1)//行同步开始了？
        hs_reg <= 1'b1;
      else if(h_cnt ==H_FP + H_SYNC-1)//行同步此时结束
        hs_reg <= 1'b0;
      else
        hs_reg <= hs_reg;
    end
  //六
  //行图像有效（1时有效？）
  //①清零②H_FP + H_SYNC + H_BP这三个时期为消隐期，过了为像素有效期，此时置1，过了有效期最后一个时刻后马上改为0，④什么都不是就保持
  always@(posedge clk or posedge rst)
    begin
      if(rst)
       h_active <= 1'b0;
      else if(h_cnt == H_FP + H_SYNC + H_BP -1)
       h_active <= 1'b1;
      else if(h_cnt == H_TOTAL - 1)
       h_active <= 1'b0;
      else
        h_active <= h_active;
    end
  //七
  //vs_reg列同步寄存器--列同步与行同步类似也有消隐期与数据有效期，其中列同步信号在消隐期，最后流到vs输出
  //同步信号由V_FP结束后的第一个V_SYNC的H_SYNC时刻到V_SYNY结束后的的第一个H_SYNC时刻
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        vs_reg <= 1'd0;
      else if((v_cnt ==V_FP - 1)&&(h_cnt == H_FP -1))
        vs_reg <= 1'b1;
      else if((v_cnt == V_FP + V_SYNC - 1)&&(h_cnt == H_FP - 1))
        vs_reg <= 1'b0;
      else
        vs_reg <= vs_reg;
    end
  //八
  //v_active;//场图像有效（1有效）
  //在场消隐期间与复位置0，像素有效时刻置1,过了有效期马上置零，其余时间保持
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        v_active <= 1'd0;
      else if((v_cnt == V_FP + V_SYNC + V_BP -1)&&(h_cnt == H_FP - 1))
        v_active <= 1'b1;
      else if((v_cnt == V_TOTAL -1)&&(h_cnt == H_FP -1))
        v_active <= 1'b0;
      else
        v_active <= v_active;
    end
//九
//active_y;//有效图像指标y 
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        active_y <= 12'd0;
      else if((v_cnt >= V_FP + V_SYNC + V_BP -1)&&(h_cnt == H_FP - 1))//计算图像y坐标
        active_y <= v_cnt - (V_FP[11:0] +V_SYNC[11:0] + V_BP[11:0] -12'd1);
    
      else
        active_y <= active_y;
    end        
//十
//生成有效地址输出至ran块
always@（posedge clk or posedge rst）
  begin
    if(rst)
      addr <= 17d'6188;//复位默认输出黑
    else if((addr_x<=320-1)&&(addr_y<=240-1))
      addr <= addr_y  * 320 + addr_x ;//
    else
      addr <= 17d'6188;
  end
    
    

endmodule
