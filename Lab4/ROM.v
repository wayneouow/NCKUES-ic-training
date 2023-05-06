

`timescale 1ns/10ps
`define EDGE_INPUT "./in_log.dat"

module ROM (CK, A, OE, Q , reset);


  input         CK , reset;
  input  [13:0]  A;
  input         OE;
  output [23:0] Q;

  reg    [23:0] Q;
  reg    [13:0]  latched_A;
  reg    [23:0] memory [0:16383];
  
//////////////////////////////////////////////////////////////////////////////////
  always @(posedge CK) begin
    latched_A <= A;
  end

  
  always @(*) begin
    if (OE) begin
      Q = memory[latched_A];
    end
    else begin
      Q = 23'hz;  
    end
  end
  
  

  
endmodule
