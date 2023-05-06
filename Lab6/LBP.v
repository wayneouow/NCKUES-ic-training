
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;

input   		gray_ready;
input   [7:0] 	gray_data;

output  [13:0] 	gray_addr;
output         	gray_req;

output  [13:0] 	lbp_addr;
output  		lbp_valid;
output  [7:0] 	lbp_data;
output  		finish;
//====================================================================
reg 	[13:0] 	gray_addr;
reg 			gray_req;
reg 	[13:0] 	lbp_addr;
reg 			lbp_valid;
reg 	[7:0] 	lbp_data;
reg 			finish;

reg 	[2:0] state, next_state;
parameter IDLE 	 =	3'b000;
parameter SCAN 	 =	3'b001;
parameter GET_GP =	3'b010;
parameter RETURN = 	3'b011;
parameter FINSH  =  3'b100;

reg 	[6:0] x;//128
reg 	[6:0] y;//128

//	scanning sequence :
// *without outer frame
//
//		  (0) x=1 - - - - - - - - > x=126 (127)
//		(0)
//		y=1	  g[0]	g[1]  g[2]
//		 |
//		 |	  g[3]	g[c]  g[4]
//		 |
//		 |    g[5]	g[6]  g[7]
//		 |
//		 |
//		 |
//		 |
//		 V
//  	y=126
//		(127)
//
//		{y, x}
//		valid coordinate x: 1 ~ 126, y: 1 ~ 126
//
//		valid address: 129 ~ 16254
//
wire	[6:0] x_s, x_p, y_s, y_p;
assign x_s = x - 1;
assign x_p = x + 1;
assign y_s = y - 1;
assign y_p = y + 1;

reg [13:0] gc_addr;
reg [7:0] gc_data;

wire [13:0] g [0:7];
assign g[0] = {y_s,	 x_s};
assign g[1] = {y_s,	 x};
assign g[2] = {y_s,	 x_p};
assign g[3] = {y,	 x_s};
assign g[4] = {y,	 x_p};
assign g[5] = {y_p,	 x_s};
assign g[6] = {y_p,  x};
assign g[7] = {y_p,  x_p};
reg 	[3:0] g_cnt;

wire en;

always@(*)
begin
    case(state)

		IDLE:
		begin
			if(gray_ready == 1'd1)
				next_state = SCAN;
			else
				next_state = IDLE;
		end
		SCAN:
			next_state = GET_GP;

		GET_GP:
		begin
			if(g_cnt == 4'd8)
				next_state = RETURN;
			else
				next_state = GET_GP;
		end

		RETURN:
		begin
			if(gc_addr == 14'd16254)
				next_state = FINSH;
			else
				next_state = SCAN;
		end

		FINSH:
			next_state = FINSH;

		default: next_state = IDLE;

	endcase
end

always@(posedge clk or posedge reset)
begin
    if(reset)
		state <= IDLE;
    else
		state <= next_state;
end



always@(posedge clk or posedge reset)
begin
    if(reset)
		x <= 7'd1;
    else if(x == 7'd126 && next_state == RETURN)
		x <= 7'd1;
    else if(next_state == RETURN)
		x <= x + 7'd1;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		y <= 7'd1;
    else if(x == 7'd126 && next_state == RETURN)
		y <= y + 7'd1;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		g_cnt <= 4'd0;
    else if(next_state == GET_GP)
		g_cnt <= g_cnt + 4'd1;
    else if(state == RETURN)
		g_cnt <= 4'd0;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		gc_addr <= 14'd129;
    else if(next_state == SCAN)
		gc_addr <= {y, x};
end

assign en =  (next_state == GET_GP);

always@(posedge clk or posedge reset)
begin
    if(reset)
		gray_addr <= 14'dx;
    else if(next_state == SCAN)
		gray_addr <= {y, x};
	else if(en)
		begin
			case(g_cnt)
			4'd0: gray_addr <= g[0];
			4'd1: gray_addr <= g[1];
			4'd2: gray_addr <= g[2];
			4'd3: gray_addr <= g[3];
			4'd4: gray_addr <= g[4];
			4'd5: gray_addr <= g[5];
			4'd6: gray_addr <= g[6];
			4'd7: gray_addr <= g[7];
			endcase
		end
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		lbp_addr <= 14'dx;
    else if(next_state == RETURN)
		lbp_addr <= gc_addr;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		begin
			lbp_data <= 8'd0;
			gc_data <= 8'dx;
		end
    else if(state == SCAN)
		gc_data <= gray_data;
    else if(state == GET_GP)
		begin
			if(gray_data>=gc_data)
				lbp_data <= lbp_data + ( 8'b00000001 << g_cnt-1 );
		end
    else if(state == RETURN)
		lbp_data <= 8'd0;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		gray_req <= 1'b0;
    else if(next_state == SCAN || next_state == GET_GP )
		gray_req <= 1'b1;
    else
		gray_req <= 1'b0;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		lbp_valid <= 1'b0;
    else if(next_state == RETURN)
		lbp_valid <= 1'b1;
    else
		lbp_valid <= 1'b0;
end


always@(posedge clk or posedge reset)
begin
    if(reset)
		finish <= 1'b0;
    else if(state == FINSH)
		finish <= 1'b1;
	else
		finish <= 1'b0;
end

//====================================================================
endmodule
