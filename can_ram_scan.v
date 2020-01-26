'timescale 1ns/1ps
//
//
//
//
module ram_ctrl(
  input rst_n , //复位信号
  input cmos_frame_clken,//数据有效使能信号
  input cmos_frame_vsync,//帧有效信号
  input cmos_frame_href,//行有效信号
  input hdmi_scan,//hdmi扫描信号
  
 // inout coms_frame_dat, //有效数据
  output [16:0]ram_addr,//ram地址信号
  output ram_clk,//ram地址时钟
  output ram_ctrl_0,//ram0选择信号
  output ram_ctrl_1//ram1选择信号
);
  reg [16:0]ram_add;//地址计数器
  reg ram_ctrl;
  
  //assign
  assign ram_addr = ram_add;
  assign ram_ctrl_0 = ram_ctrl;
  assign ram_ctrl_1 = ~ram_ctrl;
  always@(posedge cam_pclk or negedge rst_n)
    begin
    if(!rst_n)begin //复位
      ram_ctrl_0 <= 1'b0;
      ram_ctrl_1 <= 1'b0;
      ram_add <= 17'd0;
      else if( cmos_frame_vsync & cmos_frame_href) //信号有效
      ram_add <= ram_add + 17'd1;
    else
      ram_add <= 17'd0;
    end
    end
  
      
  always@(pesedge cmos_frame_vsync or negedge rst_n )
    begin
      if(!rst_n) begin //复位
        ram_ctrl <= 1'b0;
        else
          ram_ctrl <= ~ram_ctrl;
      end
    end
