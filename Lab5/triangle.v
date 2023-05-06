module triangle (clk, reset, nt, xi, yi, busy, po, xo, yo);

input clk, reset, nt;
input [2:0] xi, yi;

output reg busy, po;
output reg [2:0] xo, yo;

reg [5:0] co1, co2, co3;

reg [1:0] in_counter;
reg [5:0] out_counter;


reg en_in;  

reg [2:0]x_cnter, y_cnter; 

wire signed [2:0] d_x, d_y;
wire signed [2:0]xx, yy;

assign d_x = co3[5:3]-co2[5:3];
assign d_y = co3[2:0]-co2[2:0];
assign xx = co3[5:3]-xo;
assign yy = co3[2:0]-yo;

wire signed  [5:0] gg;


assign gg = ((co3[5:3]-co2[5:3])*(yo-co2[2:0])) - ((co3[2:0]-co2[2:0])*(xo-co2[5:3])) ;
wire if_gg;
assign if_gg = gg >=0;
always@(posedge clk or posedge reset)begin

	if(reset)
		in_counter <= 2'b00;
	else if(nt)
		in_counter <= 2'b01;
	else 
		in_counter <= (in_counter==2'b11)? in_counter : in_counter +1;
end

always@(posedge clk or posedge reset)begin
	if(reset)
		co1 <= 6'bxxxxxx;
		
	else if(in_counter == 2'b00)begin
		co1[5:3] <= xi;
		co1[2:0] <= yi;
	end
	
	else if(in_counter == 2'b01)begin
		co2[5:3] <= xi;
		co2[2:0] <= yi;
	end
	
	else if(in_counter == 2'b10)begin
		co3[5:3] <= xi;
		co3[2:0] <= yi;
	end
	
end


always@(posedge clk or posedge reset)begin
	
	if(reset)
		busy <= 1'b0;
	
	else if(xo==3'b111 && yo==3'b111)
		busy <= 1'b0;	
	else if(in_counter>2'b00)
		busy <= 1'b1;
	
end

always@(posedge clk or posedge reset)begin
	if(reset)
		x_cnter <= 3'b000;
	else if(busy)begin
		x_cnter <= (x_cnter == 3'b111) ? 3'b000 : x_cnter +1;
	end
end

always@(posedge clk or posedge reset)begin
	if(reset)
		y_cnter <= 3'b000;
	else if(busy)begin
		if(x_cnter == 3'b111)
			y_cnter <= (y_cnter == 3'b111) ? 3'b000 : y_cnter +1;
	end
end

always@(posedge clk or posedge reset)begin
	if(reset)
		xo <= 3'bxxx;
	else 
		xo <= x_cnter;
end	

always@(posedge clk or posedge reset)begin
	if(reset)
		yo <= 3'bxxx;
	else 
		yo <= y_cnter;
end	

always@(*)begin
	if( if_gg && xo>=co1[5:3] && yo>=co1[2:0] && xo<=co2[5:3] && yo <= co3[2:0])
		po <= 1'b1;
	else 
		po <= 1'b0;	
	
end


////

endmodule


	