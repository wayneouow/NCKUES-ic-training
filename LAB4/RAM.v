
`timescale 1ns/10ps

module RAM (CK, A, WE, OE, D, Q);

  input         CK;
  input  [15:0]  A;
  input         WE;
  input         OE;
  input  [23:0] D;
  output [23:0] Q;
  reg    [23:0] Q;
  reg    [15:0]  latched_A;
  reg    [23:0] memory [0:65535];

  always @(posedge CK) begin
    if (WE) begin
      memory[A] <= D;
    end
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

