//*************************************************
//Don't touch this file    by Rookie Teng
//*************************************************

`timescale 1ns/10ps

	`define PERIOD 20.0
	`define PIC128 "Mask128.bmp"
	`define PIC256 "Pic256.bmp"
	`define EDGE_OUTPUT "out_log.dat"
	`define EDGE_INPUT "in_log.dat"
	`define EDGE_INPUT1 "in1_log.dat"
	`define End_CYCLE  100000000  


/*
`ifdef ENCRYPT
  `define PIC256 "Pic256.bmp"
`endif



`ifdef DECRYPT
  `define PIC256 "Encrypt.bmp"
`endif
*/

`include "RAM.v"
`include "ROM.v"
`include "system.v"


/*
`ifdef syn
`include "/usr/cad/CBDK/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v"
`include "system_syn.v"
`else
`include "system.v"
`endif
*/



module system_tb;

  reg         clk;
  reg         rst;

  wire [13:0] ROM_A;
  wire        ROM_OE;
  wire [23:0] ROM_Q;
  wire [15:0] RAM_A;
  wire        RAM_WE;
  wire        RAM_OE;
  wire [23:0] RAM_D;
  wire [23:0] RAM_Q;
  wire        done;
  reg         real_done , chk;
  
  integer temp , in_log ,in1_log, out_log;
  integer ifile1, ifile2, ofile, pointer;
  integer i, j , err;
  reg [7:0] header [0:53];
  
  reg [23:0] exp_pat , rel_pat ;
  
  reg [23:0] exp_pass [0:65535] ;
  initial	$readmemh (`EDGE_OUTPUT, exp_pass);
  
  system sys1 (
    .clk(clk),
    .rst(rst), .ROM_Q(ROM_Q), .RAM_Q(RAM_Q), .ROM_A(ROM_A),
  .ROM_OE(ROM_OE), .RAM_A(RAM_A), .RAM_WE(RAM_WE), .RAM_OE(RAM_OE), .RAM_D(RAM_D), .done(done)
  );
  

  ROM rom1 (
    .CK(clk),
     .A(ROM_A), .OE(ROM_OE), .Q(ROM_Q) 
  );

  RAM ram1 (
    .CK(clk),
     .A(RAM_A), .WE(RAM_WE), .OE(RAM_OE), .D(RAM_D), .Q(RAM_Q)
  );

  always #(`PERIOD/2) clk = ~clk;
  always @(posedge clk) real_done <= done;
/*
  `ifdef syn
  initial $sdf_annotate("system_syn.sdf", sys1);
  `endif
*/
  initial begin
       clk = 0; rst = 0;
    #5 rst = 1;
    #5 rst = 0;
  end


  
  
    initial begin
	@ (negedge rst) $readmemh (`EDGE_INPUT , rom1.memory);
	end
  
	initial begin
	@ (negedge rst) $readmemh (`EDGE_INPUT1 , ram1.memory);
	end
  
  /*

  initial begin
    ifile1 = $fopen(`PIC128, "rb");
    ifile2 = $fopen(`PIC256, "rb");
	
  //`ifdef ENCRYPT

    ofile = $fopen("Encrypt.bmp", "wb");
 // `endif



 
  `ifdef DECRYPT
    ofile = $fopen("Decrypt.bmp", "wb");
  `endif
	
	
	
	
	
    pointer = $fread(header, ifile1);
    pointer = $fread(header, ifile2);
    pointer = $fread(rom1.memory, ifile1);
    pointer = $fread(ram1.memory, ifile2);
    $fclose(ifile1);
    $fclose(ifile2);
	end


  initial begin in1_log = $fopen(`EDGE_INPUT1, "wd"); end   
   initial begin
	for(i = 0; i < 65536; i = i + 1) begin
	$fwrite(in1_log, "%h\n", ram1.memory[i]);
	end
	$fclose(in1_log);
	end

  initial begin in_log = $fopen(`EDGE_INPUT, "wd"); end   
   initial begin
	wait (real_done) ;
	for(i = 0; i < 16384; i = i + 1) begin
	$fwrite(in_log, "%h\n", rom1.memory[i]);
	end
	$fclose(in_log);
	end
*/




    //   wait (real_done)
	
	
	
	
/*
    for (i=0; i<54; i=i+1) begin
      $fwrite(ofile, "%c", header[i]);
    end
    for (i=0; i<256*256; i=i+1) begin
      temp = ram1.memory[i];
      for (j=2; j>=0; j=j-1)
        $fwrite(ofile, "%c", temp[j*8+:8]);
    end
    $fclose(ofile);
    $finish;
  end
  */
  
  
  /////////////////////////////////////////////////////////////////////
  /*
  initial begin out_log = $fopen(`EDGE_OUTPUT, "wd"); end   
   
   initial begin
	wait (real_done) ;
	for(i = 0; i < 65536; i = i + 1) begin
	$fwrite(out_log, "%h\n", ram1.memory[i]);
	end
	$fclose(out_log);
	end
	*/
  /////////////////////////////////////////////////////////////////////
  /*
    initial begin
	wait (real_done) ;
	$display("GOOD!!!!!\n");
	end
  */
  
  
  
  initial begin
	#(`End_CYCLE);
	$display("-----------------------------------------------------\n");
	$display("Error!!! There is something wrong with your code ...!\n");
 	$display("------The test result is .....FAIL ------------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
  end
  
  
  
  
  initial begin // PASS result compare
	chk = 0;
	#(`PERIOD*3);
	wait( real_done ) ;
	chk = 1;
	err = 0;
	for (i=0; i <65536 ; i=i+1) begin
				exp_pat = exp_pass[i]; 
				rel_pat = ram1.memory[i];
				if (exp_pat == rel_pat) begin
				        err = err;
				end
				else begin 
					err = err+1;
					if (err <= 30) $display(" Output pixel %d are wrong!the real output is %h, but expected result is %h", i, rel_pat, exp_pat);
					if (err == 31) begin $display(" Find the wrong pixel reached a total of more than 30 !, Please check the code .....\n");  end
				end
				if( ((i%1000) === 0) || (i == 65535))begin  
					if ( err === 0)
      					$display(" Output pixel: 0 ~ %d are correct!\n", i);
					else
					$display(" Output Pixel: 0 ~ %d are wrong ! The wrong pixel reached a total of %d or more ! \n", i, err);
					
  				end					
	end
end


initial begin
      @(posedge chk)  #1;    
      if( err == 0 ) begin
            $display("-------------------------------------------------------------\n");
	    $display("Congratulations!!! All data have been generated successfully!\n");
            $display("---------- The test result is ..... PASS --------------------\n");
	    $display("                                                     \n");
         end
	/*else if ( fw_err == 0) begin
	    $display("Forward-Pass PASS! but Back-Pass FAIL, There are %d errors at back-pass run\n", bc_err);
	    $display("--------------- The test result is .....FAIL ----------------\n");
         end*/
       else begin
	    //$display("FAIL! There are %d errors at forward-pass run!\n", fw_err);
	    $display("FAIL! There are %d errors at functional simulation !\n", err);
	    $display("---------- The test result is .....FAIL -------------\n");
         end
	 $display("-----------------------------------------------------\n");
      #(`PERIOD/3); $finish;
end

  


  initial begin
    $fsdbDumpfile("system.fsdb");
    $fsdbDumpvars;
    $fsdbDumpMDA();
  end

  
  
endmodule

