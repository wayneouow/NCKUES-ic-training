//*************************************************
//** Description: Mix color of two pixels
//*************************************************

`timescale 1ns/10ps
module MixColor (color_in1, color_in2, color_out);

  input  [23:0] color_in1;
  input  [23:0] color_in2;
  output [23:0] color_out;
	assign color_out=color_in1^color_in2;

endmodule
