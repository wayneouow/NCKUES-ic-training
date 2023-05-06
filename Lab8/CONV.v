`timescale 1ns/10ps

module  CONV(clk,reset,cdata_rd,ready,idata,iaddr,cwr,caddr_wr,cdata_wr,crd,caddr_rd,busy,csel);

input clk;
input reset;
input [19:0] cdata_rd;
input ready;	
input signed [19:0] idata;	

output reg [11:0] iaddr;	
output reg cwr;
output reg [11:0] caddr_wr;
output reg [19:0] cdata_wr;
output reg crd;
output reg [11:0] caddr_rd;
output reg busy;
output reg [2:0] csel;
	
reg [1:0]counter;
reg[2:0] state, next_state;
reg[3:0] cnt;

parameter IDLE		= 4'd0;
parameter READ_DATA	= 4'd1;
parameter CONV    	= 4'd2;
parameter RELU   	= 4'd3;
parameter L0_OUTPUT = 4'd4;
parameter READ_L0   = 4'd5;
parameter L1_OUTPUT = 4'd6;
parameter FINISH  	= 4'd7;

	
parameter K_Q 	= 20'h0A89E;	//	 
parameter K_W 	= 20'h092D5;	//	 _______________
parameter K_E 	= 20'h06D43;	//	|				|
parameter K_A 	= 20'h01004;    //	|	Q	W	R	|
parameter K_S 	= 20'hF8F71;    //	|				|
parameter K_D 	= 20'hF6E54;    //	|	A	S	D	|
parameter K_Z 	= 20'hFA6D7;    //	|				|
parameter K_X 	= 20'hFC834;    //  |	Z	X	C	|
parameter K_C 	= 20'hFAC19;    //  |_______________|
parameter bias 	= 20'h01310; 	//
	

reg[5:0] x ,y;
reg signed [19:0] block_buf[0:8];
reg signed [19:0] target_px;
reg signed [19:0] kernel_px;
reg signed [43:0] conv_temp;//2^20 * 2^20 * 2^4

wire [5:0] x_b;
wire [5:0] x_f;
wire [5:0] y_b;
wire [5:0] y_f;

assign x_b = x-1;
assign x_f = x+1;
assign y_b = y-1;
assign y_f = y+1;

wire signed [20:0] temp_ans ;
assign temp_ans = conv_temp[35:15]+1;

reg pooled ;
wire [5:0] x_pool;
wire [5:0] y_pool;
assign x_pool = {x,counter[0]};
assign y_pool = {y[4:0],counter[1]};

always@(posedge clk or posedge reset)
begin
	if(reset)
		state <= IDLE;
	else 
		state <= next_state;
end

always@(*)
begin
	case(state)
		IDLE: 
		begin
			if(ready)
				next_state = READ_DATA;
			else
				next_state = IDLE;
		end
		
		READ_DATA:
		begin
			if(cnt == 4'd9)
				next_state = CONV;
			else
				next_state = READ_DATA;
		end
		
		CONV:
		begin
			if(cnt == 4'd9)
				next_state = RELU;
			else
				next_state = CONV;
		end	
		
		RELU:
			next_state = L0_OUTPUT ;
		
		L0_OUTPUT:
		begin
			if((x==6'd63)&&(y==6'd63))
				next_state = READ_L0;
			else
				next_state = READ_DATA;
		end
	
		READ_L0:
		begin
			if(pooled)
				next_state = L1_OUTPUT;
			else
				next_state = READ_L0;
		end	
		
		L1_OUTPUT:
		begin
			if((x==5'd31)&&(y==5'd31))
				next_state = FINISH;
			else
				next_state = READ_L0;
		end	
		
		FINISH:
			next_state = FINISH;
			
		default:
			next_state = IDLE;
			
	endcase
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		busy <= 0;
	else if(ready)
		busy <= 1;
	else if(state==FINISH)
		busy <= 0;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		crd <= 1'b0;
	else if(state==READ_L0)
		crd <= 1'b1;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
	cnt <= 4'd0;
	else if(cnt==4'd9)
	cnt <= 4'd0;
	else if((state==READ_DATA)||(state==CONV))
	cnt <= cnt+1;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		pooled <= 0;
	else if(counter==3)
		pooled <= 1;
	else
		pooled <= 0;
end

always@(*)
begin
	case(cnt)
		4'd0 	: target_px = block_buf[0] ;
		4'd1 	: target_px = block_buf[1] ;
		4'd2 	: target_px = block_buf[2] ;
		4'd3 	: target_px = block_buf[3] ;
		4'd4 	: target_px = block_buf[4] ;
		4'd5 	: target_px = block_buf[5] ;
		4'd6 	: target_px = block_buf[6] ;
		4'd7 	: target_px = block_buf[7] ;
		4'd8 	: target_px = block_buf[8] ;
		default : target_px = 20'd0 ;
	endcase
end

always@(*)
begin
	case(cnt)
		4'd0 	: kernel_px = K_Q;
		4'd1 	: kernel_px = K_W;
		4'd2 	: kernel_px = K_E;
		4'd3 	: kernel_px = K_A;
		4'd4 	: kernel_px = K_S;
		4'd5 	: kernel_px = K_D;
		4'd6 	: kernel_px = K_Z;
		4'd7 	: kernel_px = K_X;
		4'd8 	: kernel_px = K_C;
		default : kernel_px = 20'd0;
	endcase
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		conv_temp <= 44'd0;
	else if(state==CONV)
	begin
		if(cnt==4'd9)
		conv_temp <= conv_temp + {20'h01310,16'h0};
		else
		conv_temp <= conv_temp + (target_px*kernel_px);
	end
	else if(state==READ_DATA)
		conv_temp <= 44'd0;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		caddr_rd <= 12'd0;
	else if(state==READ_L0)
		caddr_rd <= {y_pool,x_pool};
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		counter <=2'd0;
	else if(state == READ_L0)
		counter <= counter+1;
	else if(state==L1_OUTPUT)
		counter <= 2'd0 ;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		cdata_wr <= 20'd0;
	else if(next_state==L0_OUTPUT)
	begin
		if(conv_temp[35])
			cdata_wr <= 20'd0;
		else
			cdata_wr <= temp_ans[20:1];
	end
	else if(state==READ_L0)
	begin
		if(counter==2'b01)
			cdata_wr <= cdata_rd ;
		else if(cdata_rd > cdata_wr)
			cdata_wr <= cdata_rd ;
	end
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		cwr <= 0 ;
	else if((next_state==L0_OUTPUT)||(state==L1_OUTPUT))
		cwr <= 1 ;
	else 
		cwr <= 0 ;
end



always@(posedge clk or posedge reset)
begin
	if(reset)
		caddr_wr <= 12'd0;
	else if(next_state==L0_OUTPUT)
		caddr_wr <= {y,x};
	else if(state==L1_OUTPUT) 
		caddr_wr <= {y[4:0],x[4:0]};
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		csel <= 3'b000;
	else if((next_state==L0_OUTPUT)||(state==READ_L0))
		csel <= 3'b001;
	else if(state==L1_OUTPUT)
		csel <= 3'b011;
end



always@(posedge clk or posedge reset)
begin
	if(reset)
		x <= 6'd0;
	else if(state==L0_OUTPUT)
		x <= (x==6'd63)? 6'd0 : x+1;
	else if(state==L1_OUTPUT)
		x <= (x==6'd31)? 6'd0 : x+1;
end

always@(posedge clk or posedge reset)
begin
	if(reset)
		y <= 6'd0 ;
	else if(state==L0_OUTPUT)
	begin
		if(x==6'd63)
			y <= y+1;
	end
	else if(state==L1_OUTPUT)
	begin
		if(x==6'd31)
			y <= y+1;
	end
end	

always@(posedge clk)
begin
	if(state==READ_DATA)
	begin
		case(cnt)
			4'd0 	: iaddr = {y_b	,x_b };
			4'd1 	: iaddr = {y_b	,x	 };
			4'd2 	: iaddr = {y_b	,x_f };
			4'd3 	: iaddr = {y	,x_b };
			4'd4 	: iaddr = {y	,x	 };
			4'd5 	: iaddr = {y	,x_f };
			4'd6 	: iaddr = {y_f	,x_b };
			4'd7 	: iaddr = {y_f	,x	 };
			4'd8	: iaddr = {y_f	,x_f };
			default	: iaddr = iaddr;
		endcase	
	end
end
///////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		block_buf[0] <= 20'd0;
		block_buf[1] <= 20'd0;
		block_buf[2] <= 20'd0;
		block_buf[3] <= 20'd0;
		block_buf[4] <= 20'd0;
		block_buf[5] <= 20'd0;
		block_buf[6] <= 20'd0;
		block_buf[7] <= 20'd0;
		block_buf[8] <= 20'd0;
	end	
	else if(state==READ_DATA)
	begin
		case(cnt)
			4'd1: 
				block_buf[0] <= ((y!=0)&&(x!=0))? idata : 20'd0;

			4'd2: 
				block_buf[1] <= (y!=0)? idata : 20'd0;

			4'd3: 
				block_buf[2] <= ((y!=0)&&(x!=6'd63))? idata : 20'd0;

			4'd4: 
				block_buf[3] <= (x!=6'd0)? idata : 20'd0;

			4'd5: 
				block_buf[4] <= idata;

			4'd6:
				block_buf[5] <= (x!=6'd63)? idata : 20'd0;

			4'd7:
				block_buf[6] <= ((y!=6'd63)&&(x!=6'd0))? idata : 20'd0;

			4'd8:
				block_buf[7] <= (y!=6'd63)? idata : 20'd0;

			4'd9:
				block_buf[8] <= ((y!=6'd63)&&(x!=6'd63))? idata : 20'd0;

		endcase
	end
end

endmodule