`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/23 19:26:35
// Design Name: 
// Module Name: xbr820_fpga_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module xbr820_fpga
(
input               ref_clk ,        //48M basic clkock;
input               rst_n,
input               soft_rst,

//JTAG IO 
input               pad_had_jtg_tclk       ,   //JTAG JTAG2a那?那㊣?車D?o?; 
inout               pad_had_jtg_tms        ,   //JTAG JTAG∩?DD那y?Y那?豕?那?3?D?o?           
input               pad_had_jtg_trstb     ,   //JTAG JTAG2a那??∩??D?o?;
     
//infrared io
input               pad_ir_in,  //

//uart 
input               uart1_rx,       //PA2
output              uart1_tx,       //PA3
input               uart2_rx,
output              uart2_tx,

//M_I2C
inout               m_scl,
inout               m_sda,

//S_I2C
input               s_scl,
inout               s_sda,
//spi io 
inout               spi_io0,        //SIO-->sin2 
input               spi_io1,        //So---->sin1
output              spi_csn,
output              spi_clk,
//output              spi_holdn,

/*
** ADC[9:0]
*/
input       [11:0]   pad_adc,
output               adc_int_pad,
//gpio 
inout               pin_gpio   ,
output              led_pad    ,

(*mark_debug="true"*)output wire [ 4:0]	pwm_out	   , 
(*mark_debug="true"*)output         p2_out_1              


);

parameter   DIV_FACTER=500;
/*
** clocks block , && reset logic 那㊣?車?㏒?谷㏒??∩?????-
*/
wire        clk_16M,locked;
wire        sys_rstn;
(*keep="true"*)wire        debug_clk64m;
clk_wiz_0 clk_gen_inst//﹞??米
   (
    // Clock out ports
    .clk_out1(clk_16M),     // output clk_out1
    .clk_out2(debug_clk64m),     // output clk_out2
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(ref_clk));      // input clk_in1




wire         test_en                 ;
wire		  clk_cpu			      ;
wire         clk_bus                 ;
wire         clk_spix2               ;

wire [ 1:0]  cpu_pad_soft_rst        ;    //豕赤?∩??                              
wire         pad_cpu_rst_b           ;  
wire         pad_had_rst_b           ;  
wire         pad_bus_rst_b		; 
wire         pad_spi_rst_b		;
wire         pad_had_jtg_trst_b     ;
  
assign  test_en     = 1'b0;
assign  clk_cpu     = clk_16M;
assign  clk_bus     = clk_16M;
assign  clk_spix2   = clk_16M;

(*mark_debug="true"*)wire        rst_n_comb ;
reg         rst_n_comb_f1,rst_n_comb_f2;
assign rst_n_comb = rst_n & pad_had_jtg_trstb & locked & (~soft_rst);
always@(posedge clk_16M or negedge rst_n_comb) begin
 if(!rst_n_comb) begin
        rst_n_comb_f1 <=1'b0;
        rst_n_comb_f2 <=1'b0;
 end
 else begin
        rst_n_comb_f1<=1'b1;
        rst_n_comb_f2<=rst_n_comb_f1;
  end
end


/*
**  CLK_32k GEN
*/
(*mark_debug="true"*)reg              clk_32k;
(*mark_debug="true"*)reg     [11:0]   div_cnt;
always@(posedge clk_16M or negedge rst_n_comb_f2) begin
    if(!rst_n_comb_f2)
        div_cnt <=12'h0;
    else if(div_cnt == DIV_FACTER-1'b1)   
        div_cnt <=12'h0;                  
    else                                  
        div_cnt <=div_cnt+1'b1;           
end
always@(posedge clk_16M or negedge rst_n_comb_f2) begin
    if(!rst_n_comb_f2)
        clk_32k <=1'b0;
    else if(div_cnt< 250)
        clk_32k <=1'b1;
    else
        clk_32k <=1'b0;
end

reg  rst_n_32k_f1,rst_n_32k_f2;

always@(posedge clk_32k or negedge rst_n_comb_f2) begin
 if(!rst_n_comb_f2) begin
        rst_n_32k_f1 <=1'b0;
        rst_n_32k_f2 <=1'b0;
 end
 else begin
        rst_n_32k_f1<=1'b1;
        rst_n_32k_f2<=rst_n_32k_f1;
  end
end

/*
** jtag io 
*/    
wire               pad_had_jtg_tms_i      ;                             
wire               had_pad_jtg_tms_o      ;                
wire               had_pad_jtg_tms_oe     ;   //JTAG∩?DD那y?Y那?3?車DD∫D?o?         

assign pad_had_jtg_tms = had_pad_jtg_tms_oe ? had_pad_jtg_tms_o:1'bz;
assign pad_had_jtg_tms_i =pad_had_jtg_tms;
/*
**UART IO 
*/

    //MASTER I2C
wire        m_scl_oe                ;
wire        m_scl_out               ;
wire        m_scl_in                ; 
wire        m_sda_oe                ; 
wire        m_sda_out               ; 
wire        m_sda_in                ;   	
assign m_scl = m_scl_oe ? m_scl_out: 1'bz;
assign m_scl_in = m_scl;

assign m_sda = m_sda_oe ? m_sda_out :1'bz;
assign m_sda_in = m_sda;

//SLAVE I2C
wire        s_sda_out               ;
wire        s_sda_oe                ;
wire        s_scl_in                ;
wire        s_sda_in                ;

assign s_scl_in = s_scl;
assign s_sda = s_sda_oe ? s_sda_out :1'bz;
assign s_sda_in = s_sda;
//
/*
**SPI IO 
*/
wire	   fr_spi_sin		;
wire	   fr_spi_sin2		;
wire	   to_spi_csn		;
wire	   to_spi_sck		;
wire	   to_spi_sout		;
wire	   to_spi_sout_oen	;


assign fr_spi_sin =spi_io1;
assign fr_spi_sin2 =  spi_io0 ;
assign spi_io0 = to_spi_sout_oen ? 1'bz :to_spi_sout; 
assign spi_csn =to_spi_csn ;
assign  spi_clk=to_spi_sck ;


 
/*
**GPIO 
*/
wire   [23:0]	gpio_in			;
wire   [23:0]	gpio_out		;
wire   [23:0]	gpio_oen		;

assign pin_gpio = gpio_oen[0] ? 1'bz: gpio_out[0];
assign gpio_in[0] = pin_gpio;
/*
** infrared in
*/
wire    ir_in;
assign ir_in = pad_ir_in;

/*
** LED
*/

assign  led_pad = locked;
/*
** others
*/

	        ;
(*mark_debug="true"*)wire	        wdg_out_rst		;

wire [31:0]	top_ctl1		;
wire [31:0]	top_ctl2		;
wire [31:0]	top_ctl3		;
wire [31:0]	top_ctl4		;

wire            pmu_int_irq             ;	
(*mark_debug="true"*)wire  [ 1:0]    pmu_sram_sel		;
wire            pmu_penable             ;              
wire            pmu_psel                ;                 
wire            pmu_pwrite              ;               
wire  [ 7:2]    pmu_paddr               ;                
wire  [31:0]    pmu_pwdata              ;               
wire  [31:0]    pmu_prdata              ;               
wire            pmu_pready              ;


wire            cpu_sram_cen    	;
wire  [ 3:0]    cpu_sram_wen    	;
wire  [11:2]    cpu_sram_addr   	;
wire  [31:0]    cpu_sram_din    	;
wire  [31:0]    cpu_sram_dout		;

wire            cpu_wakeup_event        ; 
wire  [ 1:0]    sysio_pad_lpmd_b        ;
/*
 assign pad_cpu_rst_b = rst_n_comb_f2 ;   
 assign pad_bus_rst_b = rst_n_comb_f2 ;
 assign pad_had_rst_b = rst_n_comb_f2 ;
 assign pad_had_jtg_trst_b = rst_n_comb_f2 ;
 assign pad_spi_rst_b = rst_n_comb_f2 ;
*/ 

aon_pmu_wrap u_aon_pmu_wrap(
    //GPIO   
    .p2_in_0               (1'b0),
    .p2_out_1              (p2_out_1),

    //afe
    .ldo12_ready           (1'b1),//flag
    .ldo_if_ready          (1'b1),//flag
    .osc16m_ready          (1'b1),//signal & flag 
    .osc32k_ready          (1'b1),//flag 
 
    //BG & Bias
    .bg_trim12             (),//3'b100  bg 1.2 voltage trim
    .en_temp12             (),//1'b0 internal temperature sensor enable 
    .iref_trim12           (),//6'h28

    //LDO 
    .ldo_b_en12            (),//1'b1 1.2v core ldo enable (PMU ctrl)
    .ldo_s_vtrim12         (),//4'hc 1.2v pmu ldo trim 
    .ldo_b_vtrim12         (),//4'h8 1.2v core ldo trim

    //OSC
    .oc32k_trim12          (),//7'h54 osc32k freq trim 
    .osc16m_trim12         (),//7'h59 osc16m freq trim 
    .osc16m_en12           (),//1'b1 osc16m enable (PMU ctrl)

    //Switch
    .sw_flash_pdn_en12     (),//1'b0 flash switch output pull down
    .sw_flash_en12         (),//1'b1 flash switch enable 
    .sw_core_pdn_en12      (),//1'b0 core switch output pull down
    .sw_core_en12          (),//1'b1 core switch enable (PMU ctrl)

    //Watchdog
    .wd_tsel12             (),//2'b01 watchdog interrupt time select(00~11:1s/2s/4s/8s) 
    .wd_clrn12             (),//1'b0 watch dog clr,0-clear (PMU ctrl)  

    //IF
    .if_ldo_en12           (),//1'b0 if ldo enable 
    .if_ldocomp12          (),//1'b0 if ldo compensation 0:use external 1uF cap 1:without ext cap 
    .if_filter_en12        (),//1'b1 if filter enable 
    .if_vsel12             (),//2'b00 if ldo voltage select,power&Vref(00~11:2V/2.048V/2.5V/VDD) 
    .if_vtrim12            (),//4'h8 if ldo voltage trim 
    .if_vcm_sel12          (),//2'b00 if vcom select(00~11:50%,51.4%,48.6%,61.2% vref)  
    .if_lna_gain12         (),//4'h8 if pre amp gain 
    .if_hpf_bw12           (),//5'h10 if high-pass filter bandwidth           
    .if_bwhp12             (),//1'b0 if hpf bypass 1:bypass
    .if_lpf_bw_tune12      (),//5'h10 if low-pass filter bandwidth 
    .if_lpf_q_tune12       (),//5'h09 if low-pass filter q factor 
    .if_lpf_gm_tune12      (),//4'h01 if low-pass filter gm select 
    .if_pga_gain12         (),//4'hb if post amp gain 
    .if_lpf_hbw_en12       (),//1'b0 if lpf high bandwidth enable for DFT
    .if_test_en12          (),//1'b0 if test enable for DFT 
    .if_test_fsel12        (),//2'b00 if test signal select 
    .if_lna_aon_en12       (),//1'b1 if pre amp enable always on
    .if_lpf_aon_en12       (),//1'b1 if low-pass filter enable always on 
    .if_pga_aon_en12       (),//1'b1 if pga enable always on 

    //ADC
    .adc_clk_sel12         (),//1'b0 adc clock select(0-osc16m,1-external clock input)    
    .adc_ch_mux12          (),//4'h0 adc chnnel mux(000~111:000-if,010-internal temp,011~111-gpio 
    .adc_sample_cnt12      (),//6'h01 adc sample clock counter 
    .adc_trigger12         (adc_int_pad),//1'b0 adc sample trigger,posedge trigger (PMU ctrl)
    .adc_mode12            (),//1'b0 adc work mode 0-trigger,1-continues sample 
    .adc_en12_reg          (),//1'b0 adc analog enable 
    .adc_reg_sel12         (),//1'b0 adc reg ctrl 0-normal work timer sample mode, 1-reg ctrl mode 

    //LDO
    .ldo_rf_en_ctrl12      (),//1'b0 rf ldo enable ctrl 0-normal work,adc trigger rf enable, 1-ldo_rfx_en12 reg set 
    .ldo_rf1_en12          (),//1'b0 rf ldo1 enable 
    .ldo_rf2_en12          (),//1'b0 rf ldo2 enable 
    .ldo_rf3_en12          (),//1'b0 rf ldo3 enable
    .ldo_rf1_vtrim12       (),//3'b100 rf ldo1 output voltage trim 
    .ldo_rf2_vtrim12       (),//3'b100 rf ldo2 output voltage trim
    .ldo_rf3_vtrim12       (),//3'b100 rf ldo3 output voltage trim

    //Analog test
    .tm_ana_en12           (),//1'b0 analog test mode enable 
    .tm_ana_sel12          (),//1'b0 analog test mode function select 
    .global_rstn12         (rst_n_comb),

    //RF
    .iref_rf_trim12        (),
    .vco_cnt12             (),
    .vco_sw12              (),
    .vco_fsk12             (),
    .vco_div_pd12          (),
    .if_en_hold12          (),
    .pa_cnt12              (),
    .lna_cnt12             (),

    //ADC digital
    .adc_done              (uart1_rx),//adc in ISO
    .adc_data              (pad_adc),//adc in ISO
    .adc_dclk              (1'b0),//core in ISO
    .adc_tclk              (1'b0),//core in ISO
    .adc_clk_ext12         (),//out
    
    //CLK&RST
    .cpu_soft_rst          (cpu_pad_soft_rst),//from core ISO   
    .reset_wdg             (wdg_out_rst),//from core ISO
    .reset_test_n          (),//to core	
    .reset_cpu_n           (pad_cpu_rst_b),//to core
    .reset_bus_n	   (pad_bus_rst_b)       ,//to core
    .reset_had_n           (pad_had_rst_b),//to core
    .reset_jtag_n          (pad_had_jtg_trst_b),//to core
    .reset_spi_n           (pad_spi_rst_b),//to core  
    .clk_16m               (clk_16M),//to core
    .clk_32k               (clk_32k),

    //Low power
    .cpu_wakeup_event      (cpu_wakeup_event), 
    .sysio_pad_lpmd_b      (sysio_pad_lpmd_b),

    //APB
    .penable               (pmu_penable),//from core ISO    
    .psel                  (pmu_psel),//from core ISO   
    .pwrite                (pmu_pwrite),//from core ISO   
    .paddr                 (pmu_paddr),//from core ISO   
    .pwdata                (pmu_pwdata),//from core ISO   
    .prdata                (pmu_prdata),//from core ISO   
    .pready                (pmu_pready),//to core
    .pmu_iso               (),//to Analog
    .pmu_int_irq           (pmu_int_irq),//to core

    //SRAM
    .sram_sel              (pmu_sram_sel),
    .sram_cen              (cpu_sram_cen),
    .sram_wen              (cpu_sram_wen),
    .sram_addr             (cpu_sram_addr),
    .sram_din              (cpu_sram_din),
    .sram_dout             (cpu_sram_dout)
);
 
   
xbr820_core  xbr820_inst
(
	// DFT   
   . test_en            (test_en           )  ,
                       
    // clk             (// clk            )
   . clk_cpu		    (clk_cpu		   ) ,
   . clk_bus            (clk_bus           )  ,
   . clk_spix2          (clk_spix2         )  ,
                        
    // Reset           (// Reset          )
   . cpu_pad_soft_rst   (cpu_pad_soft_rst  )  ,//out  [1 :0]                               
   . pad_cpu_rst_b      (pad_cpu_rst_b     )  ,  
   . pad_had_rst_b      (pad_had_rst_b     )  ,
   . pad_had_jtg_trst_b (pad_had_jtg_trst_b)  ,
   . pad_bus_rst_b	(pad_bus_rst_b	    ) , 
   . pad_spi_rst_b	(pad_spi_rst_b	    ) ,
                  
    // JTAG & Debug    (// JTAG & Debug   )        
   . pad_had_jtg_tclk   (pad_had_jtg_tclk  )  ,                    
   . pad_had_jtg_tms_i  (pad_had_jtg_tms_i )  ,//in                                   
   . had_pad_jtg_tms_o  (had_pad_jtg_tms_o )  ,//out                  
   . had_pad_jtg_tms_oe (had_pad_jtg_tms_oe)  ,//out              

    // Low power       (// Low power      )
   . pad_cpu_wakeup_event(cpu_wakeup_event)  ,//in 
   . sysio_pad_lpmd_b    (sysio_pad_lpmd_b),
   
    //                 (//                )
    . pmu_int_irq       (pmu_int_irq    ),
    . pmu_sram_sel      (pmu_sram_sel),
    . pmu_penable       (pmu_penable)    ,              
    . pmu_psel          (pmu_psel)    ,                 
    . pmu_pwrite        (pmu_pwrite)    ,               
    . pmu_paddr         (pmu_paddr)    ,                
    . pmu_pwdata        (pmu_pwdata)    ,               
    . pmu_prdata        (pmu_prdata)    ,               
    . pmu_pready        (pmu_pready)    ,

    . cpu_sram_cen    	(cpu_sram_cen),
    . cpu_sram_wen    	(cpu_sram_wen),
    . cpu_sram_addr   	(cpu_sram_addr),
    . cpu_sram_din    	(cpu_sram_din),
    . cpu_sram_dout	(cpu_sram_dout),

   // UART            (// UART           )
   . uart1_rx           (uart1_rx          )  ,  
   . uart1_tx           (uart1_tx          )  ,  
   . uart2_rx           (uart2_rx          )  ,  
   . uart2_tx           (uart2_tx          )  ,

    // Master I2C      (// Master I2C     )
   . m_scl_oe           (m_scl_oe          )  ,
   . m_scl_out          (m_scl_out         )  ,
   . m_scl_in           (m_scl_in          )  , 
   . m_sda_oe           (m_sda_oe          )  , 
   . m_sda_out          (m_sda_out         )  , 
   . m_sda_in           (m_sda_in          )  ,   		

    // Slave I2C       (// Slave I2C      )
   . s_sda_out          (s_sda_out         )  ,
   . s_sda_oe           (s_sda_oe          )  ,
   . s_scl_in           (s_scl_in          )  ,
   . s_sda_in           (s_sda_in          )  ,

    // IR              (// IR             )
   . ir_in              (ir_in             )  ,
 
    // SADC
   . fr_sadc_clk        (uart1_rx)   ,
   . fr_sadc_data       (pad_adc)   ,
   . vco_div            (1'b0),

    // Sflash			(// Sflash			()    )
   . fr_spi_sin         (fr_spi_sin        )  ,
   . fr_spi_sin2        (fr_spi_sin2       )  ,
   . to_spi_csn         (to_spi_csn         )  ,
   . to_spi_sck         (to_spi_sck        )  ,
   . to_spi_sout        (to_spi_sout       )  ,
   . to_spi_sout_oen    (to_spi_sout_oen    )  ,
  

   . pwm_out            (pwm_out           )  ,
 
   . gpio_in            (gpio_in           )  ,
   . gpio_out           (gpio_out          )  ,
   . gpio_oen           (gpio_oen          )  ,
   . wdg_out_rst	(wdg_out_rst	    ) ,

   . sys_info	        ({64'h0820_01_20210630_30}),
   . top_status	        (32'h0	      ),
   . top_ctl1           (top_ctl1          )  ,	 
   . top_ctl2           (top_ctl2          )  ,	 
   . top_ctl3           (top_ctl3          )  ,
   . top_ctl4           (top_ctl4          )  	
);


endmodule
