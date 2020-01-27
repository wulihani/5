'timescale 1ns/ips

//二选一数据分配器
module mux_2(
input EN,
  input [15:0]in0,
  input [15:0]in1,
input sel,

  output reg[15:0] out);
  aways@(sel or en or in1 or in2 )
  begin
    if(!en)out <=16'd0;
    else
      case（sel）
       0:out <= in0;
       1:out <= in1;
       default:out <=16'd0; 
      endcase
  end
endmodule
