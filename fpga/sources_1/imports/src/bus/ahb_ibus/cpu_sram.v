//
// File name : cpu_sram.v
//
// Description : Code SRAM
//
// 

module cpu_sram (
	clk             ,      
        rst_n           ,  
	
	sram_cen	,
	sram_wen	,
	sram_addr	,
	sram_din	,
	sram_dout	
	
       `ifdef BIST
                        , 			 
	tst_done     	,
	fail_h       	,
	scan_out     	,
	hold_l       	,
	debugz       	,
	test_h       	,
	bist_clk     	,
	scan_en		,
	rst_l        	
       `endif
);
  //-----------------------------------------------------
  parameter     D = 0           ;

  input		clk	        ;
  input		rst_n		;		

  input		sram_cen	;
  input	 [ 3:0]	sram_wen        ;
  input	 [11:2]	sram_addr	;
  input	 [31:0]	sram_din	;
  output [31:0]	sram_dout	;
		
 `ifdef BIST 			 
  output	tst_done     	;
  output	fail_h       	;
  output	scan_out     	;
  input	        hold_l       	;
  input	        debugz       	;
  input	        test_h       	;
  input	        bist_clk     	;
  input	        scan_en         ;
  input	        rst_l           ;        	
 `endif

  //-----------------------------------------------------
  reg	 	sram_addr_d1	;

  wire	 [31:0] sram_dout1	;
  wire	 [31:0] sram_dout2	;

  //-----------------------------------------------------	

  RF1_512_32 u_mem1 
      (
       .CLK        (clk              ), 
       .CEN        (sram_cen         ), 
       .WEN        (sram_wen         ), 
       .Q          (sram_dout1       ),
       .A          (sram_addr[10:2]  ), 
       .D          (sram_din         )
`ifdef POWER_PINS
       ,
       .VDD(), 
       .VSS()
`endif
      );

  RF1_512_32 u_mem2 
      (
       .CLK        (clk              ), 
       .CEN        (sram_cen         ), 
       .WEN        (sram_wen         ), 
       .Q          (sram_dout2       ),
       .A          (sram_addr[10:2]  ), 
       .D          (sram_din         )
`ifdef POWER_PINS
       ,
       .VDD(), 
       .VSS()
`endif
      );
	
  always @(posedge clk or negedge rst_n) 
    if (!rst_n) 
      sram_addr_d1	<= #D 1'h0;
    else 
      sram_addr_d1	<= #D sram_addr[11];
	
  assign sram_dout = sram_addr_d1 ? sram_dout2 : sram_dout1;

endmodule

