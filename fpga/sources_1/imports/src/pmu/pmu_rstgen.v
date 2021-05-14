/******************************************************************
  * Phosense Electronics, Inc Confidential	
  * module      : Reset Gen Unit
  * function    : Create all chip reset 
  * created     : 1/11/2021
	    copy right of Phosense      
*******************************************************************/

module pmu_rstgen 
       (
	test_en			,			
	global_rstn		,//por in
	trst_n		        ,//pad in
        trst_n_en               ,//normal mode in
	reset_wdg		,//high active
        sleep_rst               ,

        clk_32k                 ,
	clk_16m 		,

	cpu_soft_rst            ,//00:no rst 01:rst CPU only 10:rst sys 11:reserved		   
        cpu_rst_ctl	        ,//[0]:rst CPU only [1]:rst sys
	
        rstn_32k                ,//pmu
	rstn_16m                ,//pmu
        reset_i2c_n             ,	
	reset_cpu_n             ,
	reset_bus_n	        ,
        reset_had_n             ,
	reset_jtag_n            ,
        reset_spi_n     
       );

  //------------------------------------------------
  parameter D = 1		;

  //------------------------------------------------
  input		 test_en	;
  input		 global_rstn    ;
  input		 trst_n	        ;
  input          trst_n_en      ;
  input		 reset_wdg	;
  input          sleep_rst      ;

  input		 clk_16m 	;
  input          clk_32k        ;

  input   [ 1:0] cpu_soft_rst   ;  
  input   [ 2:0] cpu_rst_ctl    ;

  output         rstn_32k       ;
  output         rstn_16m       ;
  output         reset_i2c_n    ;
  output         reset_cpu_n    ;
  output	 reset_bus_n	;
  output         reset_had_n    ;
  output	 reset_jtag_n   ;
  output         reset_spi_n    ;

  //------------------------------------------------
  wire		 glb_rstn 	   ;
  reg            glb_rstn_32k_sync1;
  reg            glb_rstn_32k_sync2;
  reg            rstn_16m_sync1    ;
  reg            rstn_16m_sync2    ;

  reg            rst_cpu_sync1	;
  reg            rst_cpu_sync2	;
  reg            rst_cpu_sync3	;
  reg            rst_sys_sync1	;
  reg            rst_sys_sync2	;
  reg            rst_sys_sync3	;
  wire           rst_cpu_rise   ;
  wire           rst_sys_rise   ;

  reg            rst_cnt1_0f	;
  reg            rst_cnt2_0f	;
  reg	  [ 3:0] rst_cnt1	;
  reg	  [ 3:0] rst_cnt2	;
  wire		 sw1_rst_n	;
  wire		 sw2_rst_n	;
  reg            sw2_rst_n_d1   ;
  reg            sw2_rst_n_d2   ;
  reg            sw2_rst_n_d3   ;
  reg            sw2_rst_n_d4   ;
 
  wire           rstn_hd        ;
  reg            bus_rstb_sync1 ;
  reg            bus_rstb_sync2 ;
  reg            cpu_rstb_sync1 ;
  reg            cpu_rstb_sync2 ;
  reg            cpu_rstb_sync3 ;
  reg            cpu_rstb_sync4 ;
  reg            spi_rstb_sync1 ;
  reg            spi_rstb_sync2 ;
  reg            had_rstb_sync1 ;
  reg            had_rstb_sync2 ;
    
  //----------------------------------------------------------------------------------
  assign glb_rstn  = test_en ? trst_n : global_rstn;

  always @ (posedge clk_32k or negedge glb_rstn)
    if (!glb_rstn) begin
      glb_rstn_32k_sync1 <= 1'b0;
      glb_rstn_32k_sync2 <= 1'b0;
    end
    else begin
      glb_rstn_32k_sync1 <= 1'b1              ;
      glb_rstn_32k_sync2 <= glb_rstn_32k_sync1;
    end

  assign rstn_32k = test_en ? trst_n : glb_rstn_32k_sync2;

  always @ (posedge clk_16m or negedge rstn_32k)
    if (!rstn_32k) begin
      rstn_16m_sync1 <= 1'b0;
      rstn_16m_sync2 <= 1'b0;
    end
    else begin
      rstn_16m_sync1 <= 1'b1              ;
      rstn_16m_sync2 <= rstn_16m_sync1;
    end

  assign rstn_16m = test_en ? trst_n : rstn_16m_sync2;

  //----------------------------------------------------------------------------------
  //soft reset 
  always @(posedge clk_16m or negedge rstn_16m) begin
    if (!rstn_16m) begin
      rst_cpu_sync1	<= #D 1'b0;
      rst_cpu_sync2	<= #D 1'b0;
      rst_cpu_sync3	<= #D 1'b0;
      rst_sys_sync1	<= #D 1'b0;
      rst_sys_sync2	<= #D 1'b0;
      rst_sys_sync3	<= #D 1'b0;
    end
    else begin
      rst_cpu_sync1	<= #D (~cpu_soft_rst[1] & cpu_soft_rst[0]) | cpu_rst_ctl[0];
      rst_cpu_sync2	<= #D rst_cpu_sync1;
      rst_cpu_sync3	<= #D rst_cpu_sync2;
      rst_sys_sync1	<= #D (~cpu_soft_rst[0] & cpu_soft_rst[1]) | cpu_rst_ctl[1] | reset_wdg;
      rst_sys_sync2	<= #D rst_sys_sync1;
      rst_sys_sync3	<= #D rst_sys_sync2;
    end
  end

  assign rst_cpu_rise = ~rst_cpu_sync3 & rst_cpu_sync2;
  assign rst_sys_rise = ~rst_sys_sync3 & rst_sys_sync2;

  always @(posedge clk_16m or negedge rstn_16m) begin
    if (!rstn_16m) begin
      rst_cnt1_0f	<= #D 1'b0;
      rst_cnt2_0f	<= #D 1'b0;
    end
    else begin
      rst_cnt1_0f	<= #D rst_cpu_rise ? 1'b1 : (rst_cnt1 == 4'hF)  ? 1'b0 : rst_cnt1_0f;
      rst_cnt2_0f	<= #D rst_sys_rise ? 1'b1 : (rst_cnt2 == 4'hF)  ? 1'b0 : rst_cnt2_0f;
    end
  end

  always @(posedge clk_16m or negedge rstn_16m) begin
    if (!rstn_16m) begin
      rst_cnt1		<= #D 4'h0;
      rst_cnt2		<= #D 4'h0;
    end
    else begin
      rst_cnt1		<= #D rst_cnt1_0f ? (rst_cnt1 + 1'b1) : 4'h0;
      rst_cnt2		<= #D rst_cnt2_0f ? (rst_cnt2 + 1'b1) : 4'h0;
    end
  end

  assign sw1_rst_n = ~rst_cnt1_0f;//for cpu only
  assign sw2_rst_n = ~rst_cnt2_0f;//for sys

  always @(posedge clk_16m or negedge rstn_16m) begin
    if (!rstn_16m) begin
      sw2_rst_n_d1      <= #D 1'b0;
      sw2_rst_n_d2      <= #D 1'b0;
      sw2_rst_n_d3      <= #D 1'b0;
      sw2_rst_n_d4      <= #D 1'b0;
    end
    else begin
      sw2_rst_n_d1      <= #D sw2_rst_n;
      sw2_rst_n_d2      <= #D sw2_rst_n_d1;
      sw2_rst_n_d3      <= #D sw2_rst_n_d2;
      sw2_rst_n_d4      <= #D sw2_rst_n_d3;
    end
  end

  //----------------------------------------------------------------------------------
  assign rstn_hd = test_en ? trst_n : rstn_16m & ~sleep_rst;

  always @(posedge clk_16m or negedge rstn_hd) begin   
    if (!rstn_hd) begin
      cpu_rstb_sync1    <=#D 1'b0;
      cpu_rstb_sync2    <=#D 1'b0;
      cpu_rstb_sync3    <=#D 1'b0;
      cpu_rstb_sync4    <=#D 1'b0;
      bus_rstb_sync1    <=#D 1'b0;
      bus_rstb_sync2    <=#D 1'b0;
      spi_rstb_sync1    <=#D 1'b0;
      spi_rstb_sync2    <=#D 1'b0;
      had_rstb_sync1    <=#D 1'b0;
      had_rstb_sync2    <=#D 1'b0;
    end
    else begin
      cpu_rstb_sync1    <=#D 1'b1;
      cpu_rstb_sync2    <=#D cpu_rstb_sync1; 
      cpu_rstb_sync3    <=#D cpu_rstb_sync2;
      cpu_rstb_sync4    <=#D cpu_rstb_sync3 & sw1_rst_n & sw2_rst_n_d4;
      bus_rstb_sync1    <=#D 1'b1;
      bus_rstb_sync2    <=#D bus_rstb_sync1 & sw2_rst_n;
      spi_rstb_sync1    <=#D 1'b1;
      spi_rstb_sync2    <=#D spi_rstb_sync1 & sw2_rst_n & cpu_rst_ctl[2];
      had_rstb_sync1    <=#D 1'b1;
      had_rstb_sync2    <=#D had_rstb_sync1 & sw2_rst_n;
    end
  end

  assign reset_i2c_n  = test_en ? trst_n : 1'b0;
  assign reset_had_n  = test_en ? trst_n : had_rstb_sync2;
  assign reset_jtag_n = test_en ? trst_n : (trst_n_en ? trst_n : 1'b1) & glb_rstn_32k_sync2;
  assign reset_bus_n  = test_en ? trst_n : bus_rstb_sync2; 
  assign reset_cpu_n  = test_en ? trst_n : cpu_rstb_sync4;
  assign reset_spi_n  = test_en ? trst_n : spi_rstb_sync2;  
   
endmodule

