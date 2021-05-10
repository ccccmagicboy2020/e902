/******************************************************************
  * Phosense Electronics, Inc Confidential	
  * module      : Reset Gen Unit
  * function    : Create all chip reset 
  * created     : 1/11/2021
	    copy right of Phosense      
*******************************************************************/

module rst_top 
       (
	test_en			,			
	reset_por_n		,//por in
	pad_jtag_n		,//pad in
        core_jtag_n             ,//normal mode in
	reset_wdg		,//high active

	clk_osc 		,//16MHz
        clk_cpu                 ,
        clk_spi                 ,

	cpu_soft_rst            ,//00:no rst 01:rst CPU only 10:rst sys 11:reserved		   
        cpu_rst_ctl	        ,//[0]:rst CPU only [1]:rst sys 
	pmu_rst_ctl             ,//default 1
		
        reset_i2c_n             ,	
	reset_cpu_n             ,
	reset_bus_n	        ,
        reset_had_n             ,
	reset_jtag_n            ,
        reset_spi_n     
       );

  //------------------------------------------------
  parameter D = 1		;
  parameter RST_CNT_DEFAULT = 10'h3FF; 

  //------------------------------------------------
  input		 test_en	;
  input		 reset_por_n	;
  input		 pad_jtag_n	;
  input          core_jtag_n    ;
  input		 reset_wdg	;
  
  input		 clk_osc 	;
  input 	 clk_cpu        ;
  input 	 clk_spi        ;

  input   [ 1:0] cpu_soft_rst   ;  
  input   [ 1:0] cpu_rst_ctl    ;
  input          pmu_rst_ctl    ;

  output         reset_i2c_n    ;
  output         reset_cpu_n    ;
  output	 reset_bus_n	;
  output         reset_had_n    ;
  output	 reset_jtag_n   ;  
  output         reset_spi_n    ;

  //------------------------------------------------
  wire		 rst_ext_n	;
  wire           reset_top_n    ;

  reg		 rst_wdg_n_sync1;
  reg		 rst_wdg_n_sync2;
  reg            rst_cpu_sync1	;
  reg            rst_cpu_sync2	;
  reg            rst_cpu_sync3	;
  reg            rst_sys_sync1	;
  reg            rst_sys_sync2	;
  reg            rst_sys_sync3	;
  wire           rst_cpu_rise   ;
  wire           rst_sys_rise   ;

  reg	  [ 9:0] rst_cnt0	;
  wire		 rst_cnt0_eq1	;
  wire		 rst_cnt0_eq2	;
  wire		 rst_cnt0_eq3	;
  wire		 rst_cnt0_eq4	;
  reg		 rst_val1_n	;
  reg		 rst_val2_n	;
  reg		 rst_val3_n	;
  reg		 rst_val4_n	;

  reg            rst_cnt1_0f	;
  reg            rst_cnt2_0f	;
  reg            rst_cnt2_1f	;
  reg	  [ 3:0] rst_cnt1	;
  reg	  [ 4:0] rst_cnt2	;
  wire		 sw1_rst_n	;
  wire		 sw2_rst_n	;
  wire		 sw3_rst_n	;

  reg            bus_rstb_sync1 ;
  reg            bus_rstb_sync2 ;
  reg            cpu_rstb_sync1 ;
  reg            cpu_rstb_sync2 ;
  reg            spi_rstb_sync1 ;
  reg            spi_rstb_sync2 ;
    
  //------------------------------------------------
  assign rst_ext_n = test_en ? pad_jtag_n : reset_por_n;

  //------------------------------------------------
  //double sync the reset signal from watchdog 
  //disable watchdog reset while trst_n is deactive(JTAG active)
  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
      rst_wdg_n_sync1	<= #D 1'b1;
      rst_wdg_n_sync2	<= #D 1'b1;
    end
    else begin
      rst_wdg_n_sync1	<= #D ~reset_wdg | core_jtag_n;
      rst_wdg_n_sync2	<= #D rst_wdg_n_sync1;
    end
  end
  
  //------------------------------------------------
  //double sync the reset signal from register
  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
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
      rst_sys_sync1	<= #D (~cpu_soft_rst[0] & cpu_soft_rst[1]) | cpu_rst_ctl[1];
      rst_sys_sync2	<= #D rst_sys_sync1;
      rst_sys_sync3	<= #D rst_sys_sync2;
    end
  end

  assign rst_cpu_rise = ~rst_cpu_sync3 & rst_cpu_sync2;
  assign rst_sys_rise = ~rst_sys_sync3 & rst_sys_sync2;

  //------------------------------------------------
  //global reset counter
  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
      rst_cnt0		<= #D RST_CNT_DEFAULT	;
    end
    else if (!rst_wdg_n_sync2) begin
      rst_cnt0		<= #D RST_CNT_DEFAULT	;
    end
    else begin
      rst_cnt0		<= #D rst_cnt0_eq4 ? 10'h0 : (rst_cnt0 - 1'b1);
    end
  end

  assign  rst_cnt0_eq1 = (rst_cnt0 == 10'h200);  
  assign  rst_cnt0_eq2 = (rst_cnt0 == 10'h100);
  assign  rst_cnt0_eq3 = (rst_cnt0 == 10'h080);
  assign  rst_cnt0_eq4 = (rst_cnt0 == 10'h000);

  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
      rst_val1_n	<= #D 1'b0	;
      rst_val2_n	<= #D 1'b0	;
      rst_val3_n	<= #D 1'b0	;
      rst_val4_n	<= #D 1'b0	;
    end
    else if (!rst_wdg_n_sync2) begin
      rst_val1_n	<= #D 1'b0	;
      rst_val2_n	<= #D 1'b0	;
      rst_val3_n	<= #D 1'b0	;
      rst_val4_n	<= #D 1'b0	;
    end
    else begin
      rst_val1_n	<= #D rst_cnt0_eq1 ? 1'b1 : rst_val1_n;
      rst_val2_n	<= #D rst_cnt0_eq2 ? 1'b1 : rst_val2_n;
      rst_val3_n	<= #D rst_cnt0_eq3 ? 1'b1 : rst_val3_n;
      rst_val4_n	<= #D rst_cnt0_eq4 ;
    end
  end

  //------------------------------------------------
  //reset counter
  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
      rst_cnt1_0f	<= #D 1'b0;
      rst_cnt2_0f	<= #D 1'b0;
      rst_cnt2_1f	<= #D 1'b0;
    end
    else begin
      rst_cnt1_0f	<= #D rst_cpu_rise ? 1'b1 : (rst_cnt1 == 4'hF)  ? 1'b0 : rst_cnt1_0f;
      rst_cnt2_0f	<= #D rst_sys_rise ? 1'b1 : (rst_cnt2 == 4'hF)  ? 1'b0 : rst_cnt2_0f;
      rst_cnt2_1f	<= #D rst_sys_rise ? 1'b1 : (rst_cnt2 == 5'h1F) ? 1'b0 : rst_cnt2_1f;
    end
  end

  always @(posedge clk_osc or negedge rst_ext_n) begin
    if (!rst_ext_n) begin
      rst_cnt1		<= #D 4'h0;
      rst_cnt2		<= #D 5'h0;
    end
    else begin
      rst_cnt1		<= #D rst_cnt1_0f ? (rst_cnt1 + 1'b1) : 4'h0;
      rst_cnt2		<= #D rst_cnt2_1f ? (rst_cnt2 + 1'b1) : 5'h0;
    end
  end

  assign sw1_rst_n = ~rst_cnt1_0f;
  assign sw2_rst_n = ~rst_cnt2_0f;
  assign sw3_rst_n = ~rst_cnt2_1f;

  //------------------------------------------------
  always @(posedge clk_cpu or negedge reset_top_n) begin   
    if (!reset_top_n) begin
      bus_rstb_sync1    <=#D 1'b0;
      bus_rstb_sync2    <=#D 1'b0;
      cpu_rstb_sync1    <=#D 1'b0;
      cpu_rstb_sync2    <=#D 1'b0;
      
    end
    else begin
      bus_rstb_sync1    <=#D rst_val3_n & sw2_rst_n & pmu_rst_ctl;
      bus_rstb_sync2    <=#D bus_rstb_sync1;
      cpu_rstb_sync1    <=#D rst_val4_n & sw1_rst_n & sw3_rst_n & pmu_rst_ctl;
      cpu_rstb_sync2    <=#D cpu_rstb_sync1;
    end
  end

  always @(posedge clk_spi or negedge reset_top_n) begin   
    if (!reset_top_n) begin
      spi_rstb_sync1    <=#D 1'b0;
      spi_rstb_sync2    <=#D 1'b0;
    end
    else begin
      spi_rstb_sync1    <=#D rst_val2_n & sw2_rst_n & cpu_rst_ctl[0] & pmu_rst_ctl;
      spi_rstb_sync2    <=#D spi_rstb_sync1;
    end
  end

  assign reset_top_n  = test_en ? pad_jtag_n : rst_val1_n;
  assign reset_i2c_n  = test_en ? pad_jtag_n : 1'b0;
  assign reset_had_n  = reset_top_n;
  assign reset_jtag_n = test_en ? pad_jtag_n : core_jtag_n & rst_val1_n;
  assign reset_bus_n  = test_en ? pad_jtag_n : bus_rstb_sync2; 
  assign reset_cpu_n  = test_en ? pad_jtag_n : cpu_rstb_sync2;
  assign reset_spi_n  = test_en ? pad_jtag_n : spi_rstb_sync2;  
   
endmodule

