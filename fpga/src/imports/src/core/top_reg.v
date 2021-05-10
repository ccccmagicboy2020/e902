
module top_reg
       (
        tck                ,
        pclk               ,                 
        presetn            ,              
        penable            ,              
        psel               ,                 
        pwrite             ,               
        paddr              ,                
        pwdata             ,               
        prdata             ,               
        pready             ,   
   	
	sys_info           ,
        status             ,
	
  	outputreg4         ,
  	outputreg5         ,
  	outputreg6         ,
  	outputreg7         ,
  	outputreg8         ,
  	outputreg9         ,
  	outputrega         ,
  	outputregb         ,
  	outputregc         ,
  	outputregd         ,
  	outputrege         ,
  	outputregf         ,
        gpin               ,               
        gpout              ,               
        gpioen             ,               
             
        fr_sadc_clk        ,
        fr_sadc_data       ,
        vco_div            ,//10525M/8192=1.28M

        iu_pad_gpr_data    ,//out  [31:0]                   
        iu_pad_gpr_index   ,//out  [4 :0]                   
        iu_pad_gpr_we      ,//out                  
        iu_pad_inst_retire ,//out               
        iu_pad_inst_split  ,//out               
        iu_pad_retire_pc   ,//out  [31:0] 
        cp0_pad_mcause     ,//out  [31:0]                     
        cp0_pad_mintstatus ,//out  [31:0]                  
        cp0_pad_mstatus    ,//out  [31:0]                                       
        cpu_pad_lockup     ,//out
        had_pad_jdb_pm     ,  
        sysio_pad_lpmd_b   ,

	out_int           
       );

  parameter D = 0          ;

  input         tck        ;
  input         pclk       ;         
  input         presetn    ;      
  input         penable    ;      
  input         psel       ;         
  input         pwrite     ;       
  input  [11:2] paddr      ;        
  input  [31:0] pwdata     ;       
  output [31:0] prdata     ;        
  output        pready     ;   

  input  [31:0] status     ;       
  input	 [63:0] sys_info   ;

  input  [23:0] gpin       ;         
  output [23:0] gpout      ;        
  output [23:0] gpioen     ;       
  output [31:0] outputreg4 ;
  output [31:0] outputreg5 ;
  output [31:0] outputreg6 ;
  output [31:0] outputreg7 ;
  output [31:0] outputreg8 ;
  output [31:0] outputreg9 ;
  output [31:0] outputrega ;
  output [31:0] outputregb ;
  output [31:0] outputregc ;
  output [31:0] outputregd ;
  output [31:0] outputrege ;
  output [31:0] outputregf ;

  input         fr_sadc_clk;
  input  [11:0] fr_sadc_data;
  input         vco_div    ;

  input  [31:0] iu_pad_gpr_data;//out  [31:0]                   
  input  [ 4:0] iu_pad_gpr_index;//out  [4 :0]                   
  input         iu_pad_gpr_we;//out                  
  input         iu_pad_inst_retire;//out               
  input         iu_pad_inst_split;//out               
  input  [31:0] iu_pad_retire_pc;//out  [31:0] 
  input  [31:0] cp0_pad_mcause;//out  [31:0]                     
  input  [31:0] cp0_pad_mintstatus;//out  [31:0]                  
  input  [31:0] cp0_pad_mstatus;//out  [31:0]             
  input         cpu_pad_lockup;//out 
  input  [ 1:0] had_pad_jdb_pm;  
  input  [ 1:0] sysio_pad_lpmd_b;
     
  output 	out_int;
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  reg	 [23:0] gpin_sync0	;
  reg	 [23:0] gpin_sync1	;
  wire   [ 4:0] treg_int_clr    ;
  wire          treg_int_clr_en ;
  wire	 [ 4:0] treg_int_sta	;
  wire	 [ 4:0] treg_int_msk	;
  wire	 [14:0] treg_int_trg	;
  reg           sadc_clk_sync0  ;
  reg           sadc_clk_sync1  ;
  reg           sadc_clk_sync2  ;
  reg    [11:0] sadc_data_sync0 ;
  reg    [11:0] sadc_data_sync1 ; 
  reg    [11:0] sadc_data_sync2 ; 
  reg    [23:0] vco_cnt_sync1   ;  
  reg    [23:0] vco_cnt_sync2   ;
  reg           vco_div_sync0   ;
  reg           vco_div_sync1   ;
  reg           vco_div_sync2   ;
  reg           freq_det_en_sync0;
  reg           freq_det_en_sync1;
  reg           freq_det_en_sync2;
  wire          vco_div_redge   ;
  wire          freq_det_redge  ;
  reg           freq_det_gate   ;
  wire          freq_det_trig   ;
  reg    [23:0] tck_cnt         ;
  reg    [23:0] vco_cnt         ;
  wire   [31:0] vco_det_ctrl    ;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// GPIO In
//------------------------------------------------------------------------------
  always @ (posedge pclk or negedge presetn)
    if (!presetn) begin
      gpin_sync0	<= #D 24'b0;
      gpin_sync1	<= #D 24'b0;
      sadc_clk_sync0    <= #D 1'b0;
      sadc_clk_sync1    <= #D 1'b0;
      sadc_clk_sync2    <= #D 1'b0;
      sadc_data_sync0   <= #D 12'h0;
      sadc_data_sync1   <= #D 12'h0; 
      sadc_data_sync2   <= #D 12'h0;
      vco_cnt_sync1     <= #D 24'h0;
      vco_cnt_sync2     <= #D 24'h0;
    end
    else begin
      gpin_sync0	<= #D gpin;
      gpin_sync1	<= #D gpin_sync0;
      sadc_clk_sync0    <= #D fr_sadc_clk;
      sadc_clk_sync1    <= #D sadc_clk_sync0;
      sadc_clk_sync2    <= #D sadc_clk_sync1;
      sadc_data_sync0   <= #D fr_sadc_data;
      sadc_data_sync1   <= #D sadc_data_sync0; 
      sadc_data_sync2   <= #D sadc_clk_sync1 & ~sadc_clk_sync2 ? sadc_data_sync1 : sadc_data_sync2;
      vco_cnt_sync1     <= #D vco_cnt;
      vco_cnt_sync2     <= #D vco_cnt_sync1;
    end

  always @ (posedge tck or negedge presetn)
    if (!presetn) begin
      vco_div_sync0     <= #D 1'b0;
      vco_div_sync1     <= #D 1'b0;
      vco_div_sync2     <= #D 1'b0;
      freq_det_en_sync0 <= #D 1'b0;
      freq_det_en_sync1 <= #D 1'b0;
      freq_det_en_sync2 <= #D 1'b0;
    end
    else begin
      vco_div_sync0     <= #D vco_div;
      vco_div_sync1     <= #D vco_div_sync0;
      vco_div_sync2     <= #D vco_div_sync1; 
      freq_det_en_sync0 <= #D vco_det_ctrl[24];
      freq_det_en_sync1 <= #D freq_det_en_sync0;
      freq_det_en_sync2 <= #D freq_det_en_sync1;
    end

  assign vco_div_redge  = freq_det_en_sync1 & ~freq_det_en_sync2;
  assign freq_det_redge = freq_det_en_sync1 & ~freq_det_en_sync2;

  always @ (posedge tck or negedge presetn)
    if (!presetn) 
      freq_det_gate     <= #D 1'b0;
    else if (freq_det_redge) 
      freq_det_gate     <= #D 1'b1;
    else if (vco_div_redge)
      freq_det_gate     <= #D 1'b0;

  assign freq_det_trig = freq_det_gate & vco_div_redge;

  always @ (posedge tck or negedge presetn)
    if (!presetn) begin
      tck_cnt           <= #D 24'h0;
      vco_cnt           <= #D 24'h0;
    end
    else if (freq_det_trig) begin 
      tck_cnt           <= #D 24'h1;
      vco_cnt           <= #D 24'h1;
    end
    else if (tck_cnt == vco_det_ctrl[23:0]) begin //8MHz->24'd8000
      tck_cnt           <= #D tck_cnt;
      vco_cnt           <= #D vco_cnt;
    end
    else begin
      tck_cnt           <= #D tck_cnt + 1'b1;
      vco_cnt           <= #D vco_div_redge ? vco_cnt + 1'b1 : vco_cnt;
    end

//------------------------------------------------------------------------------
// Top Reg APB
//------------------------------------------------------------------------------

  top_reg_apb u_top_reg_apb 
   (
    .pclk		(pclk		   ),
    .presetn		(presetn	   ),
    .penable		(penable	   ),
    .psel		(psel		   ),
    .pwrite		(pwrite		   ),
    .prdata		(prdata		   ),
    .pready		(pready		   ),
   
    .paddr		(paddr[11:2]	   ),
    .pwdata		(pwdata		   ),
    .gpin		(gpin_sync1	   ),
    .gpout		(gpout		   ),
    .gpioen		(gpioen		   ),
    
    .sys_info		(sys_info	   ),
    .status		(status		   ),
			    
    .outputreg4		(outputreg4	   ),
    .outputreg5		(outputreg5	   ),
    .outputreg6		(outputreg6	   ),
    .outputreg7		(outputreg7	   ),
    .outputreg8		(outputreg8	   ),
    .outputreg9		(outputreg9	   ),
    .outputrega		(outputrega	   ),
    .outputregb		(outputregb	   ),
    .outputregc		(outputregc	   ),
    .outputregd		(outputregd	   ),
    .outputrege		(outputrege	   ),
    .outputregf		(outputregf	   ),
    .outputreg10	(vco_det_ctrl	   ),
	
    .sadc_data          (sadc_data_sync2   ),
    .vco_cnt            (vco_cnt_sync2     ),

    .iu_pad_gpr_data    (iu_pad_gpr_data   ),//out  [31:0]                   
    .iu_pad_gpr_index   (iu_pad_gpr_index  ),//out  [4 :0]                   
    .iu_pad_gpr_we      (iu_pad_gpr_we     ),//out                  
    .iu_pad_inst_retire (iu_pad_inst_retire),//out               
    .iu_pad_inst_split  (iu_pad_inst_split ),//out               
    .iu_pad_retire_pc   (iu_pad_retire_pc  ),//out  [31:0] 
    .cp0_pad_mcause     (cp0_pad_mcause    ),//out  [31:0]                     
    .cp0_pad_mintstatus (cp0_pad_mintstatus),//out  [31:0]                  
    .cp0_pad_mstatus    (cp0_pad_mstatus   ),//out  [31:0]          
    .cpu_pad_lockup     (cpu_pad_lockup    ),//out
    .had_pad_jdb_pm     (had_pad_jdb_pm    ),  
    .sysio_pad_lpmd_b   (sysio_pad_lpmd_b  ),
 		    
    .treg_int_clr	(treg_int_clr      ),
    .treg_int_clr_en	(treg_int_clr_en   ),
    .treg_int_sta	(treg_int_sta	   ),
    .treg_int_msk	(treg_int_msk	   ),
    .treg_int_trg	(treg_int_trg	   )
   );

//------------------------------------------------------------------------------
//treg INT module
//------------------------------------------------------------------------------

  defparam pic_inst.PIC_INT_NUM	= 5;

  pic pic_inst
    (
     .gresetn		(presetn	   ),
     .gclk		(pclk		   ),
     .presetn         	(presetn	   ),
     .pclk            	(pclk		   ),
     .pclk_phase	(1'b1		   ),

     // source of interrput
     .src_int00		({sadc_clk_sync2,gpin_sync1[11:8]}),//adc,P2.0-P2.3

     // int clear
     .int_clr_en	(treg_int_clr_en   ),
     .clr_ints		(treg_int_clr      ),

     // registers
     .int_sub00_msk	(treg_int_msk	   ),
     .int_sub00_trg	(treg_int_trg	   ),
     .int_sub00_sta	(treg_int_sta	   ),

     // Output interrupt
     .out_int		(out_int	   )
    );
  
endmodule
