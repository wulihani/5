`timescale 1ns/1ps

//二选一数据分配器
module mux_2(
  input en,
  input [15:0]in0,
  input [15:0]in1,
  input  sel,

  output reg[15:0] out);
  always@(sel or en or in0 or in1 )
  begin
    if(!en)out <=16'd0;
    else
      case(sel)
       0:out <= in0;
       1:out <= in1;
       default:out <=16'd0; 
      endcase
  end
endmodule
