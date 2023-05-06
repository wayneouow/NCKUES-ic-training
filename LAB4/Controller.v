//*************************************************
//** Description: System controller
//*************************************************

`timescale 1ns/10ps

module Controller (clk, rst, ROM_A, ROM_OE, RAM_A, RAM_WE, RAM_OE, done);

  
  // You should complete this part

input         clk;
input         rst;
output reg[13:0] ROM_A;  //ROM address
output reg       ROM_OE; //RAM address
output reg[15:0] RAM_A;
output reg       RAM_WE;
output reg       RAM_OE;
output reg       done;


parameter INIT  = 2'b00;
parameter READ  = 2'b01;
parameter WRITE = 2'b10;
parameter FINAL  = 2'b11;

reg [1:0] curr_state;
reg [1:0] next_state;

reg a_valid;

reg [15:0] RAM_A_buffer;

wire state_loop; //1-> WRITE to READ
				 //0-> WRITE to FINAL				
				
always@(posedge clk or posedge rst)begin
  if(rst)
    curr_state <= INIT;
  else
    curr_state <= next_state;
end

always@(*)begin
	case (curr_state)
	
		INIT : 
			next_state = READ;
		
		READ : 
			next_state = WRITE;
				
		WRITE :
		
			if(state_loop==1'b1)
				next_state = READ;
				
			else if(state_loop==1'b0)
				next_state = FINAL;
				
		FINAL : 
			next_state = FINAL;
		
	endcase
end

assign state_loop = (RAM_A !=16'hffff)? 1'b1 : 1'b0;


always@(*)begin

  case(curr_state)
 
    INIT : 
		ROM_OE <= 1'b0;
	
	READ : 
		ROM_OE <= 1'b1;
			
	WRITE :
		ROM_OE <= 1'b1;
		
	FINAL : 
		ROM_OE <= 1'b0;
	default :
		ROM_OE <= 1'bx;
		
  endcase

end

always@(*)begin

  case(curr_state)
 
    INIT : 
		RAM_WE <= 1'b0;
	
	READ : 
		RAM_WE <= 1'b0;
			
	WRITE :
		RAM_WE <= 1'b1;
		
	FINAL : 
		RAM_WE <= 1'b0;
		
	default :
		RAM_WE <= 1'bx;
		
  endcase

end

always@(*)begin

  case(curr_state)
 
    INIT : 
		RAM_OE <= 1'b0;
	
	READ : 
		RAM_OE <= 1'b1;
			
	WRITE :
		RAM_OE <= 1'b1;
		
	FINAL : 
		RAM_OE <= 1'b0;
		
	default :
		RAM_OE <= 1'bx;
		
  endcase

end

always@(*)begin

  case(curr_state)
 
    INIT : 
		done <= 1'b0;
	
	READ : 
		done <= 1'b0;
			
	WRITE :
		done <= 1'b0;
		
	FINAL : 
		done <= 1'b1;
		
  endcase

end

always@(*)begin
	
	if(RAM_OE && ROM_OE)
		a_valid <= 1'b1;
	else
		a_valid <= 1'b0;
		
end


always@(negedge RAM_WE or posedge rst)begin
	
	if((RAM_A < 16'hFFFF) && a_valid )begin
		RAM_A <= RAM_A + 16'h1;
	end
	
	else if(rst)
		RAM_A <= 16'h0000;

end
/////////////


always@(*)begin

	ROM_A [13:7] = RAM_A [15:8] /2;

end

always@(*)begin

	ROM_A [6:0]  = RAM_A [7:0]  /2;

end

endmodule