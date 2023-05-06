module DT(
	input 			clk, 
	input			reset,
	output	reg		done ,
	output	reg		sti_rd ,
	output	reg 	[9:0]	sti_addr ,
	input		[15:0]	sti_di,
	output	reg		res_wr ,
	output	reg		res_rd ,
	output	reg 	[13:0]	res_addr ,
	output	reg 	[7:0]	res_do,
	input		[7:0]	res_di
	);


//STATE
parameter	INIT = 4'd0;
parameter	INIT_READ = 4'd1; 
parameter	INIT_WRITE = 4'd2;
parameter	INIT_COMPLETED = 4'd3;
parameter	FORWARD_READ = 4'd4;
parameter	FORWARD_PASS = 4'd5;
parameter	FORWARD_WRITE = 4'd6;
parameter	FORWARD_COMPLETED = 4'd7;
parameter	BACKWARD_READ = 4'd8;
parameter	BACKWARD_PASS = 4'd9;
parameter	BACKWARD_WRITE = 4'd10;
parameter	FINISH = 4'd11;

reg [3:0]state;
reg [3:0]next_state;
reg [3:0]cnt;//ROM 16bits data counter

reg [7:0]min;

always@(posedge clk or negedge reset)
begin
	if(!reset) 
		state <= INIT;
	else 
		state <= next_state;
end


always@(*)
begin
	case(state)
		INIT:
		begin
			next_state=INIT_READ;
		end
		
        INIT_READ:
		begin
			next_state=INIT_WRITE;
		end
		
        INIT_WRITE: 
		begin
			if(res_addr == 14'd16383)
				next_state = INIT_COMPLETED;
			else if(cnt== 4'd0)
				next_state = INIT_READ;
			else
				next_state = INIT_WRITE;			
		end
		
        INIT_COMPLETED: 
		begin
			next_state = FORWARD_READ;
		end
		
        FORWARD_READ:
		begin
			if(res_di)
				next_state = FORWARD_PASS;
			else if(res_addr == 14'd16254)	//edge 16383-128-1
				next_state = FORWARD_COMPLETED;
			else 
				next_state = FORWARD_READ;
		
		end
		
        FORWARD_PASS: 
		begin
			if(cnt==4'd5)//window
				next_state = FORWARD_WRITE;
			else 
				next_state = FORWARD_PASS;
		end
		
        FORWARD_WRITE:
		begin
				next_state = FORWARD_READ;
		end
		
        FORWARD_COMPLETED:
		begin
			next_state = BACKWARD_READ;
		end
		
        BACKWARD_READ: 
		begin
			if(res_di)
				next_state = BACKWARD_PASS;
			else if(res_addr == 14'd129)	//edge 128+1
				next_state = FINISH;
			else 
				next_state = BACKWARD_READ;
		end
		
        BACKWARD_PASS:
		begin
			if(cnt==4'd5)//
				next_state = BACKWARD_WRITE;
			else 
				next_state = BACKWARD_PASS;
		end
		
        BACKWARD_WRITE: 
		begin
			if(res_addr == 14'd129)
				next_state = FINISH;
			else
				next_state = BACKWARD_READ;
		end
		
        FINISH:
		begin
			next_state = FINISH;
		end
		
		default:
			next_state = INIT;
		
	endcase
end


//sti_rd
always@(posedge clk or negedge reset)
begin
	if(!reset)
		sti_rd <= 1'd0;
	else if(next_state == INIT_READ)
		sti_rd <= 1'd1;
	else
		sti_rd <= 1'd0;
end

//sti_addr
always@(posedge clk or negedge reset)
begin
	if(!reset)
		sti_addr <= 10'd0;
	else if(state == INIT_READ)
		sti_addr <= sti_addr + 1'd1;
end

//res_rd
always@(posedge clk or negedge reset)
begin
	if(!reset)
		res_rd <= 1'b0;
	else if(next_state == FORWARD_READ || next_state == FORWARD_PASS || next_state == BACKWARD_READ || next_state == BACKWARD_PASS)
		res_rd <= 1'b1;
	else 
		res_rd <= 1'b0;	
end

//res_wr
always@(posedge clk or negedge reset)
begin		
	if(!reset)
		res_wr <= 1'b0;
	else if(state == INIT_WRITE || state == FORWARD_WRITE || state ==  BACKWARD_WRITE)
		res_wr <= 1'b1;
	else
		res_wr <= 1'b0;
end

//cnt
always@(posedge clk or negedge reset)
begin
	if(!reset)
		cnt <= 4'd0;
	else if(next_state == INIT_READ)
		cnt <= 4'd0;
	else if(next_state == INIT_WRITE)
		cnt <= cnt + 4'd1;
	else if(next_state == INIT_COMPLETED)
		cnt <= 4'd15;
	else if((next_state == FORWARD_PASS) || (next_state == BACKWARD_PASS))
		cnt <= cnt +4'd1;
	else if((next_state == FORWARD_WRITE) || (next_state == BACKWARD_WRITE))
		cnt <= 4'd0;
end

wire [13:0]NW_addr, N_addr, NE_addr, W_addr, Pf_addr;
assign NW_addr= res_addr - 14'd129;
assign N_addr = res_addr + 14'd1;
assign NE_addr= res_addr + 14'd1;		
assign W_addr = res_addr + 14'd126;
assign Pf_addr= res_addr + 14'd1;

wire [13:0]SE_addr, S_addr, SW_addr, E_addr, Pb_addr;
assign SE_addr= res_addr + 14'd129;
assign S_addr = res_addr - 14'd1;
assign SW_addr= res_addr - 14'd1;		
assign E_addr = res_addr - 14'd126;
assign Pb_addr= res_addr - 14'd1;





//res_addr
always@(posedge clk or negedge reset)
begin
	if(!reset)
		res_addr <= 14'd16383;

	else if(next_state == INIT_WRITE)
		res_addr <= res_addr+14'd1;
	else if(state == INIT_COMPLETED)
		res_addr <= 14'd128;
	else if(state == FORWARD_COMPLETED)
		res_addr <= 14'd16255;
		
	else if((next_state == FORWARD_PASS) || (state == FORWARD_PASS))
	begin
		case(cnt)
			4'd0: res_addr <= NW_addr;
			4'd1: res_addr <= N_addr ;
			4'd2: res_addr <= NE_addr;
			4'd3: res_addr <= W_addr ;
			4'd4: res_addr <= Pf_addr;
		endcase	
	end
	else if((next_state == BACKWARD_PASS)||(state == BACKWARD_PASS))
	begin
		case(cnt)
			4'd0: res_addr <= SE_addr;
			4'd1: res_addr <= S_addr ;
			4'd2: res_addr <= SW_addr;
			4'd3: res_addr <= E_addr ;
			4'd4: res_addr <= Pb_addr;
		endcase
	end
	else if((state == FORWARD_READ) || (state == FORWARD_WRITE))
		res_addr <= res_addr + 14'd1;
	else if((state == BACKWARD_READ) || (state == BACKWARD_WRITE))
		res_addr <= res_addr - 14'd1;	
	
end                          

//min
always@(posedge clk or negedge reset)
begin
	if(!reset)
		min <= 8'b0;
	else if(state == FORWARD_PASS)
	begin 
		if(cnt == 4'd1)//res_di output after next cnt
			min <= res_di;
		else if(res_di < min)
			min <= res_di;
	end
	
	else if(state == BACKWARD_READ)
		min <= res_di;
	else if(state == BACKWARD_PASS)
		if((res_di+8'd1) < min)
			min <= res_di+8'd1;
end

//res_do
always@(posedge clk or negedge reset)
begin
	if(!reset)
		res_do <= 8'd0;
	else if(next_state == INIT_WRITE)
		res_do <= sti_di[15-cnt];
	else if(next_state == FORWARD_WRITE) 
		res_do <= min + 8'd1;
	else if(next_state == BACKWARD_WRITE)
		res_do <= min;	
end

//done
always@(posedge clk or negedge reset)
begin
	if(!reset)
		done <= 1'b0;
	else if(state == FINISH)
		done <= 1'b1;	
end

endmodule
