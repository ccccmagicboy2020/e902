//aon 
//    1.sram
//    2.io
//    3.timer_wdg
//    4.bb
//    5.pmu
//    6.io_ctrl
//    7.apb
module aon_pmu_wrap(

    //GPIO   
    p2_in_0               ,
    p2_out_1              ,

    //afe
    ldo12_ready           ,//flag
    ldo_if_ready          ,//flag
    osc16m_ready          ,//signal & flag 
    osc32k_ready          ,//flag 
 
    //BG & Bias
    bg_trim12             ,//3'b100  bg 1.2 voltage trim
    en_temp12             ,//1'b0 internal temperature sensor enable 
    iref_trim12           ,//6'h28

    //LDO 
    ldo_b_en12            ,//1'b1 1.2v core ldo enable (PMU ctrl)
    ldo_s_vtrim12         ,//4'hc 1.2v pmu ldo trim 
    ldo_b_vtrim12         ,//4'h8 1.2v core ldo trim

    //OSC
    oc32k_trim12          ,//7'h54 osc32k freq trim 
    osc16m_trim12         ,//7'h59 osc16m freq trim 
    osc16m_en12           ,//1'b1 osc16m enable (PMU ctrl)

    //Switch
    sw_flash_pdn_en12     ,//1'b0 flash switch output pull down
    sw_flash_en12         ,//1'b1 flash switch enable 
    sw_core_pdn_en12      ,//1'b0 core switch output pull down
    sw_core_en12          ,//1'b1 core switch enable (PMU ctrl)

    //Watchdog
    wd_tsel12             ,//2'b01 watchdog interrupt time select(00~11:1s/2s/4s/8s) 
    wd_clrn12             ,//1'b0 watch dog clr,0-clear (PMU ctrl)  

    //IF
    if_ldo_en12           ,//1'b0 if ldo enable 
    if_ldocomp12          ,//1'b0 if ldo compensation 0:use external 1uF cap 1:without ext cap 
    if_filter_en12        ,//1'b1 if filter enable 
    if_vsel12             ,//2'b00 if ldo voltage select,power&Vref(00~11:2V/2.048V/2.5V/VDD) 
    if_vtrim12            ,//4'h8 if ldo voltage trim 
    if_vcm_sel12          ,//2'b00 if vcom select(00~11:50%,51.4%,48.6%,61.2% vref)  
    if_lna_gain12         ,//4'h8 if pre amp gain 
    if_hpf_bw12           ,//5'h10 if high-pass filter bandwidth           
    if_bwhp12             ,//1'b0 if hpf bypass 1:bypass
    if_lpf_bw_tune12      ,//5'h10 if low-pass filter bandwidth 
    if_lpf_q_tune12       ,//5'h09 if low-pass filter q factor 
    if_lpf_gm_tune12      ,//4'h01 if low-pass filter gm select 
    if_pga_gain12         ,//4'hb if post amp gain 
    if_lpf_hbw_en12       ,//1'b0 if lpf high bandwidth enable for DFT
    if_test_en12          ,//1'b0 if test enable for DFT 
    if_test_fsel12        ,//2'b00 if test signal select 
    if_lna_aon_en12       ,//1'b1 if pre amp enable always on
    if_lpf_aon_en12       ,//1'b1 if low-pass filter enable always on 
    if_pga_aon_en12       ,//1'b1 if pga enable always on 

    //ADC
    adc_clk_sel12         ,//1'b0 adc clock select(0-osc16m,1-external clock input)    
    adc_ch_mux12          ,//4'h0 adc chnnel mux(000~111:000-if,010-internal temp,011~111-gpio 
    adc_sample_cnt12      ,//6'h01 adc sample clock counter 
    adc_trigger12         ,//1'b0 adc sample trigger,posedge trigger (PMU ctrl)
    adc_mode12            ,//1'b0 adc work mode 0-trigger,1-continues sample 
    adc_en12_reg          ,//1'b0 adc analog enable 
    adc_reg_sel12         ,//1'b0 adc reg ctrl 0-normal work timer sample mode, 1-reg ctrl mode 

    //LDO
    ldo_rf_en_ctrl12      ,//1'b0 rf ldo enable ctrl 0-normal work,adc trigger rf enable, 1-ldo_rfx_en12 reg set 
    ldo_rf1_en12          ,//1'b0 rf ldo1 enable 
    ldo_rf2_en12          ,//1'b0 rf ldo2 enable 
    ldo_rf3_en12          ,//1'b0 rf ldo3 enable
    ldo_rf1_vtrim12       ,//3'b100 rf ldo1 output voltage trim 
    ldo_rf2_vtrim12       ,//3'b100 rf ldo2 output voltage trim
    ldo_rf3_vtrim12       ,//3'b100 rf ldo3 output voltage trim

    //Analog test
    tm_ana_en12           ,//1'b0 analog test mode enable 
    tm_ana_sel12          ,//1'b0 analog test mode function select 
    global_rstn12         ,

    //RF
    iref_rf_trim12        ,
    vco_cnt12             ,
    vco_sw12              ,
    vco_fsk12             ,
    vco_div_pd12          ,
    if_en_hold12          ,
    pa_cnt12              ,
    lna_cnt12             ,

    //ADC digital
    adc_done              ,//adc in ISO
    adc_data              ,//adc in ISO
    adc_dclk              ,//core in ISO
    adc_tclk              ,//core in ISO
    adc_clk_ext12         ,//out
    
    //CLK&RST
    cpu_soft_rst          ,//from core ISO   
    reset_wdg             ,//from core ISO
    reset_test_n          ,//to core	
    reset_cpu_n           ,//to core
    reset_bus_n	          ,//to core
    reset_had_n           ,//to core
    reset_jtag_n          ,//to core
    reset_spi_n           ,//to core  
    clk_16m               ,//to core
    clk_32k               ,

    //Low power
    cpu_wakeup_event      , 
    sysio_pad_lpmd_b      ,

    //APB
    penable               ,//from core ISO    
    psel                  ,//from core ISO   
    pwrite                ,//from core ISO   
    paddr                 ,//from core ISO   
    pwdata                ,//from core ISO   
    prdata                ,//from core ISO   
    pready                ,//to core
    pmu_iso               ,//to Analog
    pmu_int_irq           ,//to core

    //SRAM
    sram_sel              ,
    sram_cen              ,
    sram_wen              ,
    sram_addr             ,
    sram_din              ,
    sram_dout             
);
 
  //GPIO
  input          p2_in_0               ;
  output         p2_out_1              ;

  input          ldo12_ready           ;
  input          ldo_if_ready          ;
  input          osc16m_ready          ; 
  input          osc32k_ready          ; 

  output  [ 2:0] bg_trim12             ;
  output         en_temp12             ; 
  output  [ 5:0] iref_trim12           ;
  output         ldo_b_en12            ;
  output  [ 3:0] ldo_s_vtrim12         ; 
  output  [ 3:0] ldo_b_vtrim12         ;
  output  [ 6:0] oc32k_trim12          ; 
  output  [ 6:0] osc16m_trim12         ; 
  output         osc16m_en12           ;
  output         sw_flash_pdn_en12     ;
  output         sw_flash_en12         ; 
  output         sw_core_pdn_en12      ;
  output         sw_core_en12          ;

  output  [ 1:0] wd_tsel12             ;
  output         wd_clrn12             ;

  output         if_ldo_en12           ; 
  output         if_ldocomp12          ; 
  output         if_filter_en12        ; 
  output  [ 1:0] if_vsel12             ; 
  output  [ 3:0] if_vtrim12            ; 
  output  [ 1:0] if_vcm_sel12          ;  
  output  [ 3:0] if_lna_gain12         ; 
  output  [ 4:0] if_hpf_bw12           ;           
  output         if_bwhp12             ;
  output  [ 4:0] if_lpf_bw_tune12      ; 
  output  [ 4:0] if_lpf_q_tune12       ; 
  output  [ 3:0] if_lpf_gm_tune12      ; 
  output  [ 3:0] if_pga_gain12         ; 
  output         if_lpf_hbw_en12       ;
  output         if_test_en12          ; 
  output  [ 1:0] if_test_fsel12        ; 
  output         if_lna_aon_en12       ;
  output         if_lpf_aon_en12       ; 
  output         if_pga_aon_en12       ; 

  output         adc_clk_sel12         ;
  output  [ 3:0] adc_ch_mux12          ; 
  output  [ 5:0] adc_sample_cnt12      ; 
  output         adc_trigger12         ;
  output         adc_mode12            ; 
  output         adc_en12_reg          ; 
  output         adc_reg_sel12         ; 
  output         ldo_rf_en_ctrl12      ; 
  output         ldo_rf1_en12          ; 
  output         ldo_rf2_en12          ; 
  output         ldo_rf3_en12          ;
  output  [ 2:0] ldo_rf1_vtrim12       ; 
  output  [ 2:0] ldo_rf2_vtrim12       ;
  output  [ 2:0] ldo_rf3_vtrim12       ;
  output         tm_ana_en12           ; 
  output         tm_ana_sel12          ; 

  output  [ 3:0] iref_rf_trim12        ;
  output  [ 3:0] vco_cnt12             ;
  output  [ 2:0] vco_sw12              ;
  output  [ 1:0] vco_fsk12             ;
  output         vco_div_pd12          ;
  output         if_en_hold12          ;
  output  [ 2:0] pa_cnt12              ;
  output  [ 1:0] lna_cnt12             ;

  input          global_rstn12         ;

  input          adc_done              ;
  input   [11:0] adc_data              ;
  input          adc_dclk              ;
  input          adc_tclk              ;
  output         adc_clk_ext12         ;

  input   [ 1:0] cpu_soft_rst          ;
  input          reset_wdg             ;
  output         reset_test_n          ;
  output         reset_cpu_n           ;
  output         reset_bus_n	       ;
  output         reset_had_n           ;
  output         reset_jtag_n          ;
  output         reset_spi_n           ;  
  input          clk_16m               ;
  input          clk_32k               ;

  output         cpu_wakeup_event      ; 
  input   [ 1:0] sysio_pad_lpmd_b      ;

  input          penable               ;
  input          psel                  ;
  input          pwrite                ;
  input  [ 7:2]  paddr                 ;
  input  [31:0]  pwdata                ;
  output [31:0]  prdata                ;
  output         pready                ;
  output         pmu_iso               ;
  output         pmu_int_irq           ;

  output  [ 1:0] sram_sel              ;
  output  [31:0] sram_dout             ;
  input          sram_cen              ;
  input   [ 3:0] sram_wen              ;
  input   [11:2] sram_addr             ;
  input   [31:0] sram_din              ;

  //wire and regs
  wire           rstn_32k              ;
  wire           rstn_16m              ;

  wire           timer_en_32k          ;
  wire           timer_en_wakeup_32k   ;
  wire           timer_clrn            ;
  wire           timer_wakeup          ;
  wire           timer_clrn_16m        ;
  wire           adc_muxsel_32k        ;
  wire           bb_timer_en_32k       ;
  wire           pmu_sleep_32k         ;
  wire           pmu_sleepiso_32k      ;
  wire           pmu_sleep_end_32k     ;
  wire           pmu_suspend_32k       ;
  wire    [ 1:0] pmu_lpmd_sel_32k      ;
  wire           sleep_rst             ;

  wire           ldo_b_en_pmu          ;
  wire           osc16m_en_pmu         ;
  wire           sw_core_en_pmu        ;
  wire           ldo_b_en_mcu          ;
  wire           osc16m_en_mcu         ;
  wire           sw_core_en_mcu        ;
  wire           adc_trigger12_bb      ;
    
  wire    [ 2:0] p_bg_trim12           ;
  wire           p_en_temp12           ;
  wire    [ 5:0] p_iref_trim12         ;
  wire           ldo_b_en12            ;
  wire    [ 3:0] p_ldo_s_vtrim12       ;
  wire    [ 3:0] p_ldo_b_vtrim12       ;
  wire    [ 6:0] p_oc32k_trim12        ;
  wire    [ 6:0] p_osc16m_trim12       ;
  wire           osc16m_en12           ;
  wire           p_sw_flash_pdn_en12   ;
  wire           p_sw_flash_en12       ;
  wire           p_sw_core_pdn_en12    ;
  wire           sw_core_en12          ;
  wire    [ 1:0] p_wd_tsel12           ;
  wire           wd_clrn12             ;
  wire           p_if_ldo_en12         ;
  wire           p_if_ldocomp12        ;
  wire           p_if_filter_en12      ;
  wire    [ 1:0] p_if_vsel12           ;
  wire    [ 3:0] p_if_vtrim12          ;
  wire    [ 1:0] p_if_vcm_sel12        ;
  wire    [ 3:0] p_if_lna_gain12       ;
  wire    [ 4:0] p_if_hpf_bw12         ;
  wire           p_if_bwhp12           ;
  wire    [ 4:0] p_if_lpf_bw_tune12    ;
  wire    [ 4:0] p_if_lpf_q_tune12     ;
  wire    [ 3:0] p_if_lpf_gm_tune12    ;
  wire    [ 3:0] p_if_pga_gain12       ;
  wire           p_if_lpf_hbw_en12     ;
  wire           p_if_test_en12        ;
  wire    [ 1:0] p_if_test_fsel12      ;
  wire           p_if_lna_aon_en12     ;
  wire           p_if_lpf_aon_en12     ;
  wire           p_if_pga_aon_en12     ;
  wire           p_adc_clk_sel12       ;
  wire    [ 3:0] p_adc_ch_mux12        ;
  wire    [ 5:0] p_adc_sample_cnt12    ;
  wire           adc_trigger12_apb     ;
  wire           p_adc_mode12          ;
  wire           p_adc_en12_reg        ;
  wire           p_adc_reg_sel12       ;
  wire           p_ldo_rf_en_ctrl12    ;
  wire           p_ldo_rf1_en12        ;
  wire           p_ldo_rf2_en12        ;
  wire           p_ldo_rf3_en12        ;
  wire    [ 2:0] p_ldo_rf1_vtrim12     ;
  wire    [ 2:0] p_ldo_rf2_vtrim12     ;
  wire    [ 2:0] p_ldo_rf3_vtrim12     ;
  wire           p_tm_ana_en12         ;
  wire           p_tm_ana_sel12        ;
  wire    [23:0] t1_val                ;
  wire    [23:0] t2_val                ;
  wire    [ 5:0] io_pinmux             ;
  wire           io_int_en             ;
  wire           io_int_en_32k         ;
  wire           io_mux_sel            ;
  wire           io_sel                ;
  wire           io_val                ;
  wire           timer_sel             ;
  wire           timer_en              ;
  wire           timer_en_wakeup       ;
  wire    [17:0] timer_value           ;
  wire    [22:0] timer_value_wakeup    ;
  wire    [ 3:0] pmu_lpmd_sel          ;
  wire           pmu_suspend           ;
  wire           pmu_sleep             ;
  wire    [ 3:0] bb_wakeup_sel         ;
  wire    [ 3:0] bb_times_value        ;
  wire           bb_timer_en           ;
  wire           bb_adc_muxsel         ;
  wire    [21:0] bb_adc_thersh1        ;
  wire    [21:0] bb_adc_thersh2        ;
  wire    [11:0] bb_adc_dc_init        ;
  wire    [ 7:0] bb_timer_cnt          ;
  wire           bb_io_triger          ;
  wire           bb_wakeup             ;
  wire           io_value              ;
  wire    [ 7:0] p2_out_pmu            ;
  wire    [ 7:0] p2_oen_pmu            ;
  wire           p2_0_32k              ;
  wire    [ 1:0] adc_dc_force          ;
  wire    [ 1:0] adc_dc_force_32k      ;
  wire    [11:0] adc_dc                ;
  wire           adc_dc_upd            ;
  wire    [21:0] adc_ac_22bit          ;
  wire    [11:0] adc_ac_12bit          ;
  wire    [21:0] adc_dc_22bit          ;
  wire    [11:0] adc_dc_12bit1         ;
  wire    [11:0] adc_dc_12bit2         ;
  wire    [11:0] adc_dc_12bit3         ;
  wire    [11:0] adc_dc_12bit4         ;
  reg            adc_dc_upd_sync0      ;
  reg            adc_dc_upd_sync1      ;
  reg            adc_dc_upd_sync2      ;
  reg     [11:0] adc_dc_sync           ;
  reg     [21:0] adc_ac_22bit_sync     ;
  reg     [11:0] adc_ac_12bit_sync     ;
  reg     [21:0] adc_dc_22bit_sync     ;
  reg     [11:0] adc_dc_12bit1_sync    ;
  reg     [11:0] adc_dc_12bit2_sync    ;
  reg     [11:0] adc_dc_12bit3_sync    ;
  reg     [11:0] adc_dc_12bit4_sync    ;
  wire    [ 2:0] pmu_soft_rst          ;
  wire           pmu_int_clr_en        ;
  wire    [ 3:0] pmu_int_clr           ;
  wire    [11:0] pmu_int_trg           ;
  wire    [ 3:0] pmu_int_msk           ;
  wire    [ 3:0] pmu_int_sta           ;
  wire    [ 3:0] p_iref_rf_trim12      ;
  wire    [ 3:0] p_vco_cnt12           ;
  wire    [ 2:0] p_vco_sw12            ;
  wire    [ 1:0] p_vco_fsk12           ;
  wire           p_vco_div_pd12        ;
  wire           p_if_en_hold12        ;
  wire    [ 2:0] p_pa_cnt12            ;
  wire    [ 1:0] p_lna_cnt12           ;
  reg            adc_done_sync0        ;
  reg            adc_done_sync1        ;
  reg            adc_done_sync2        ;
  reg     [11:0] adc_data_sync         ;
  reg            pmu_sleep_16m_sync0   ;
  reg            pmu_sleep_16m_sync1   ;
  reg            pmu_sleep_16m_sync2   ;
  reg            pmu_sleep_16m_sync3   ;
  reg            pmu_sleep_16m_sync4   ;
  reg            pmu_sleep_16m_sync5   ;
  reg            pmu_iso               ;
  reg            cpu_wakeup_event      ;
  wire   [ 1:0]  sysio_pad_lpmd_b_32k  ;
  wire           pmu_wake_event_32k    ;
  reg            pmu_wake_event_sync1  ;
  reg            pmu_wake_event_sync2  ;
  reg            pmu_wake_event_sync3  ;
  reg            pmu_wake_event_sync4  ;

//1.sram
(*mark_debug="true"*)wire            adc_trigger12         ;
(*mark_debug="true"*)wire            adc_done              ;
(*mark_debug="true"*)wire    [11:0]  adc_data              ;

 spram # (8,10) cpu_byte0_sram
(
.clk    (clk_16m      ), 
.addr   (sram_addr        ),
.cen    (sram_cen      ), 
.wen    (sram_wen[0]   ), 
.din    (sram_din[7:0]   ), 
.dout   (sram_dout[7:0]   )
);

 spram # (8,10) cpu_byte1_sram
(
.clk    (clk_16m      ), 
.addr   (sram_addr        ),
.cen    (sram_cen      ), 
.wen    (sram_wen[1]   ), 
.din    (sram_din[15:8]   ), 
.dout   (sram_dout[15:8]   )
);
 spram # (8,10) cpu_byte2_sram
(
.clk    (clk_16m      ), 
.addr   (sram_addr        ),
.cen    (sram_cen      ), 
.wen    (sram_wen[2]   ), 
.din    (sram_din[23:16]   ), 
.dout   (sram_dout[23:16]   )
);
 spram # (8,10) cpu_byte3_sram
(
.clk    (clk_16m      ), 
.addr   (sram_addr        ),
.cen    (sram_cen      ), 
.wen    (sram_wen[3]   ), 
.din    (sram_din[31:24]   ), 
.dout   (sram_dout[31:24]   )
);
/*
cpu_sram u_cpu_sram
(
    .clk           (clk_16m             ),      
    .rst_n         (rstn_16m            ),  

    .sram_cen	   (sram_cen   	        ),
    .sram_wen	   (sram_wen            ),
    .sram_addr	   (sram_addr[11:2]     ),
    .sram_din	   (sram_din		),
    .sram_dout	   (sram_dout		)	
);
*/
//4.rstgen
assign sleep_rst = pmu_lpmd_sel[3] ? pmu_sleepiso_32k : pmu_sleep_end_32k;

pmu_rstgen u_pmu_rstgen
(
    .test_en	         (1'b0                ),					
    .global_rstn         (global_rstn12       ),
    .trst_n	         (1'b1                ),
    .trst_n_en           (1'b0                ),
    .reset_wdg	         (reset_wdg           ),//high active
    .sleep_rst           (sleep_rst           ),

    .clk_32k             (clk_32k 	      ),
    .clk_16m             (clk_16m             ),

    .cpu_soft_rst        (cpu_soft_rst        ),//00:no rst 01:rst CPU only 10:rst sys 11:reserved		   
    .cpu_rst_ctl         (pmu_soft_rst	      ),//[0]:rst CPU only [1]:rst sys [2]:rst flash
	
    .rstn_32k            (rstn_32k            ),//pmu
    .rstn_16m            (rstn_16m            ),//pmu
    .reset_i2c_n         (reset_test_n        ),	
    .reset_cpu_n         (reset_cpu_n         ),
    .reset_bus_n         (reset_bus_n	      ),
    .reset_had_n         (reset_had_n         ),
    .reset_jtag_n        (reset_jtag_n        ),
    .reset_spi_n         (reset_spi_n         )  
);

//5.time_wdg
levelsync_dffin #(.W(1)) u_time_en        (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (timer_en       ), .o_data(timer_en_32k       )); 
levelsync_dffin #(.W(1)) u_time_wakeup_en (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (timer_en_wakeup), .o_data(timer_en_wakeup_32k)); 

aon_timer_wdg u_aon_timer_wdg
(
    .i_clk               (clk_32k             ),
    .i_rstn              (rstn_32k            ),
    .i_value             (timer_value         ),
    .i_timer_en          (timer_en_32k        ),
    .o_clrn              (timer_clrn          ) 
);

aon_timer_wakeup u_aon_timer_wakeup
(
    .i_clk               (clk_32k             ),
    .i_rstn              (rstn_32k            ),
    .i_value             (timer_value_wakeup  ),
    .i_timer_en          (timer_en_wakeup_32k ),
    .o_wakeup            (timer_wakeup        ) 
);

//6.bb
levelsync_dffin #(.W(1)) u_adc_sel    (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (bb_adc_muxsel), .o_data(adc_muxsel_32k )); 
levelsync_dffin #(.W(1)) u_bbtimer_en (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (bb_timer_en  ), .o_data(bb_timer_en_32k)); 
levelsync_dffin #(.W(1)) u_bbdc_en0   (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (adc_dc_force[0]), .o_data(adc_dc_force_32k[0])); 
levelsync_dffin #(.W(1)) u_bbdc_en1   (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (adc_dc_force[1]), .o_data(adc_dc_force_32k[1])); 

aon_bb u_aon_bb
(
    .i_clk               (clk_32k             ),//32kHz
    .i_rstn              (rstn_32k            ),

    .i_adc_data          (adc_data            ),
    .i_timer_en          (bb_timer_en_32k     ),//must cdc
    .i_timer_cnt         (bb_timer_cnt        ),//128Hz min sample ==>7812500ns,32Khz==>31250ns,250 cycles
    .i_times_value       (bb_times_value      ),//600ms/1KHz==600
    .i_adc_dc_init       (bb_adc_dc_init      ),//initial dc value
    .i_adc_thresh1       (bb_adc_thersh1      ),
    .i_adc_thresh2       (bb_adc_thersh2      ),
    .i_wakeup_sel        (bb_wakeup_sel       ),
    .i_adc_dc_force      (adc_dc_force_32k    ),
    .o_adc_triger        (adc_trigger12_bb    ),
    .o_adc_ac_22bit      (adc_ac_22bit        ),
    .o_adc_ac_12bit      (adc_ac_12bit        ),
    .o_adc_dc_22bit      (adc_dc_22bit        ),
    .o_adc_dc_12bit      (adc_dc_12bit1       ),
    .o_adc_dc_d1         (adc_dc_12bit2       ),
    .o_adc_dc_d2         (adc_dc_12bit3       ),
    .o_adc_dc_d3         (adc_dc_12bit4       ),
    .o_io_triger         (bb_io_triger        ),
    .o_bb_wakeup         (bb_wakeup           ),
    .o_dc_upd            (adc_dc_upd          ),
    .o_dc_val            (adc_dc              )
);

//7.pmu_ctrl
levelsync_dffin #(.W(1)) u_clk_16m_rdy   (.i_oclk (clk_32k), .i_orstn(rstn_32k  ), .i_data (osc16m_ready), .o_data(clk_16m_rdy));
pulsesync u_sleep_sync  ( .iclk (clk_16m), .irstn(rstn_16m), .idata(pmu_sleep   ), .oclk(clk_32k), .orstn(rstn_32k), .odata(pmu_sleep_32k  ));
pulsesync u_suspend_sync( .iclk (clk_16m), .irstn(rstn_16m), .idata(pmu_suspend ), .oclk(clk_32k), .orstn(rstn_32k), .odata(pmu_suspend_32k));

levelsync_dffin #(.W(1)) u_lpmd_sel0_sync (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (pmu_lpmd_sel[0]), .o_data(pmu_lpmd_sel_32k[0]));
levelsync_dffin #(.W(1)) u_lpmd_sel1_sync (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (pmu_lpmd_sel[1]), .o_data(pmu_lpmd_sel_32k[1]));
 
levelsync_dffin #(.W(1)) u_io_int     (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (p2_in_0), .o_data(p2_0_32k     )); 
levelsync_dffin #(.W(1)) u_io_int_en  (.i_oclk (clk_32k), .i_orstn(rstn_32k), .i_data (io_int_en), .o_data(io_int_en_32k)); 

levelsync_dffin #(.W(2)) u_sysio_pad_lpmd_b (.i_oclk (clk_32k), .i_orstn(rstn_32k  ), .i_data (sysio_pad_lpmd_b), .o_data(sysio_pad_lpmd_b_32k));

aon_pmu_ctrl u_aon_pmu_ctrl
(
    .rstn_32k            (rstn_32k            ),//from rstg
    .clk_32k             (clk_32k             ),//from ckg
    .osc_16m_rdy         (1'b1                ),//32k sync 

    .i_sleep             (pmu_sleep_32k       ),
    .i_suspend           (pmu_suspend_32k     ),
    .i_wakeup            (bb_wakeup | (p2_0_32k & io_int_en_32k) | timer_wakeup),
    .i_lpmd_sel          (pmu_lpmd_sel_32k    ),
    .sysio_pad_lpmd_b    (sysio_pad_lpmd_b_32k),

    .ldo_b_en12          (ldo_b_en_pmu        ),
    .osc16m_en12         (osc16m_en_pmu       ),
    .sw_core_en12        (sw_core_en_pmu      ),

    .pmu_sleep_32k       (pmu_sleepiso_32k    ),
    .pmu_sleep_end_32k   (pmu_sleep_end_32k   ),
    .pmu_wake_event      (pmu_wake_event_32k  )
);

//8.io_ctrl
aon_io_ctrl u_aon_io_ctrl
(
    .iclk                (clk_32k             ),
    .irstn               (rstn_32k            ),
    .i_triger            (bb_io_triger        ),
    .i_t1_val            (t1_val              ),
    .i_t2_val            (t2_val              ),
    .i_iosel             (io_sel              ),
    .i_ioval             (io_val              ),
    .o_ioval             (io_value            )  
);

//9.apb
apbreg_pmu u_apbreg_pmu
(
    .pclk                (clk_16m             ),
    .prstn               (rstn_16m            ),
    .psel                (psel                ),
    .penable             (penable             ),
    .pwrite              (pwrite              ),
    .paddr               ({16'b0,paddr,2'b0}  ),
    .pwdata              (pwdata              ),
    .prdata              (prdata              ),
    .pready              (pready              ),

    //input ports    
    .ldo12_ready12       (ldo12_ready         ),
    .ldo_if_ready12      (ldo_if_ready        ),
    .osc32k_ready12      (osc32k_ready        ),
    .osc16m_ready12      (osc16m_ready        ),
    .adc_data12          (adc_data_sync       ),

    //output ports   
    .bg_trim12           (p_bg_trim12         ),//pmu_aip_ctl1[9:7]
    .en_temp12           (p_en_temp12         ),//pmu_aip_ctl1[6]
    .iref_trim12         (p_iref_trim12       ),//pmu_aip_ctl1[5:0]
    .ldo_b_en12          (ldo_b_en_mcu        ),//pmu_aip_ctl2[8]
    .ldo_s_vtrim12       (p_ldo_s_vtrim12     ),//pmu_aip_ctl2[7:4]
    .ldo_b_vtrim12       (p_ldo_b_vtrim12     ),//pmu_aip_ctl2[3:0]
    .oc32k_trim12        (p_oc32k_trim12      ),//pmu_aip_ctl3[14:8]
    .osc16m_trim12       (p_osc16m_trim12     ),//pmu_aip_ctl3[7:1]
    .osc16m_en12         (osc16m_en_mcu       ),//pmu_aip_ctl3[0]
    .sw_flash_pdn_en12   (p_sw_flash_pdn_en12 ),//pmu_aip_ctl4[3]
    .sw_flash_en12       (p_sw_flash_en12     ),//pmu_aip_ctl4[2]
    .sw_core_pdn_en12    (p_sw_core_pdn_en12  ),//pmu_aip_ctl4[1]
    .sw_core_en12        (sw_core_en_mcu      ),//pmu_aip_ctl4[0]
    .wd_tsel12           (p_wd_tsel12         ),//pmu_aip_ctl5[2:1]
    .wd_clrn12           (timer_clrn_16m      ),//pmu_aip_ctl5[0]
    .if_ldo_en12         (p_if_ldo_en12       ),//pmu_aip_ctl6[20]
    .if_ldocomp12        (p_if_ldocomp12      ),//pmu_aip_ctl6[19]
    .if_filter_en12      (p_if_filter_en12    ),//pmu_aip_ctl6[18]
    .if_vsel12           (p_if_vsel12         ),//pmu_aip_ctl6[17:16]
    .if_vtrim12          (p_if_vtrim12        ),//pmu_aip_ctl6[15:12]
    .if_vcm_sel12        (p_if_vcm_sel12      ),//pmu_aip_ctl6[11:10]
    .if_lna_gain12       (p_if_lna_gain12     ),//pmu_aip_ctl6[9:6]
    .if_hpf_bw12         (p_if_hpf_bw12       ),//pmu_aip_ctl6[5:1]
    .if_bwhp12           (p_if_bwhp12         ),//pmu_aip_ctl6[0]
    .if_lpf_bw_tune12    (p_if_lpf_bw_tune12  ),//pmu_aip_ctl7[24:20]
    .if_lpf_q_tune12     (p_if_lpf_q_tune12   ),//pmu_aip_ctl7[19:15]
    .if_lpf_gm_tune12    (p_if_lpf_gm_tune12  ),//pmu_aip_ctl7[14:11]
    .if_pga_gain12       (p_if_pga_gain12     ),//pmu_aip_ctl7[10:7]
    .if_lpf_hbw_en12     (p_if_lpf_hbw_en12   ),//pmu_aip_ctl7[6]
    .if_test_en12        (p_if_test_en12      ),//pmu_aip_ctl7[5]
    .if_test_fsel12      (p_if_test_fsel12    ),//pmu_aip_ctl7[4:3]
    .if_lna_aon_en12     (p_if_lna_aon_en12   ),//pmu_aip_ctl7[2]
    .if_lpf_aon_en12     (p_if_lpf_aon_en12   ),//pmu_aip_ctl7[1]
    .if_pga_aon_en12     (p_if_pga_aon_en12   ),//pmu_aip_ctl7[0]
    .adc_clk_sel12       (p_adc_clk_sel12     ),//pmu_aip_ctl8[14]
    .adc_ch_mux12        (p_adc_ch_mux12      ),//pmu_aip_ctl8[13:10]
    .adc_sample_cnt12    (p_adc_sample_cnt12  ),//pmu_aip_ctl8[9:4]
    .adc_trigger12       (adc_trigger12_apb   ),//pmu_aip_ctl8[3]
    .adc_mode12          (p_adc_mode12        ),//pmu_aip_ctl8[2]
    .adc_en12_reg        (p_adc_en12_reg      ),//pmu_aip_ctl8[1]
    .adc_reg_sel12       (p_adc_reg_sel12     ),//pmu_aip_ctl8[0]
    .ldo_rf_en_ctrl12    (p_ldo_rf_en_ctrl12  ),//pmu_aip_ctl9[12]
    .ldo_rf1_en12        (p_ldo_rf1_en12      ),//pmu_aip_ctl9[11]
    .ldo_rf2_en12        (p_ldo_rf2_en12      ),//pmu_aip_ctl9[10]
    .ldo_rf3_en12        (p_ldo_rf3_en12      ),//pmu_aip_ctl9[9]
    .ldo_rf1_vtrim12     (p_ldo_rf1_vtrim12   ),//pmu_aip_ctl9[8:6]
    .ldo_rf2_vtrim12     (p_ldo_rf2_vtrim12   ),//pmu_aip_ctl9[5:3]
    .ldo_rf3_vtrim12     (p_ldo_rf3_vtrim12   ),//pmu_aip_ctl9[2:0]
    .tm_ana_en12         (p_tm_ana_en12       ),//pmu_aip_ctl10[1]
    .tm_ana_sel12        (p_tm_ana_sel12      ),//pmu_aip_ctl10[0]
    .t1_val              (t1_val              ),
    .t2_val              (t2_val              ),
    .io_pinmux           (io_pinmux           ),
    .io_int_en           (io_int_en           ),
    .io_mux_sel          (io_mux_sel          ),
    .io_sel              (io_sel              ),
    .io_val              (io_val              ),
    .timer_sel           (timer_sel           ),
    .timer_en            (timer_en            ),
    .timer_value         (timer_value         ),
    .pmu_lpmd_sel        (pmu_lpmd_sel        ),
    .pmu_suspend         (pmu_suspend         ),
    .pmu_sleep           (pmu_sleep           ),
    .bb_wakeup_sel       (bb_wakeup_sel       ),
    .bb_times_value      (bb_times_value      ),
    .bb_timer_en         (bb_timer_en         ),
    .bb_adc_muxsel       (bb_adc_muxsel       ),
    .bb_adc_thersh1      (bb_adc_thersh1      ),
    .bb_adc_thersh2      (bb_adc_thersh2      ),
    .bb_adc_dc_init      (bb_adc_dc_init      ),
    .bb_timer_cnt        (bb_timer_cnt        ),
    .timer_en_wakeup     (timer_en_wakeup     ),
    .timer_value_wakeup  (timer_value_wakeup  ),
    .pmu_soft_rst        (pmu_soft_rst        ),
    .pmu_boot_sel        (sram_sel            ),
    .pmu_int_clr_en      (pmu_int_clr_en      ),
    .pmu_int_clr         (pmu_int_clr         ),
    .pmu_int_trg         (pmu_int_trg         ),
    .pmu_int_msk         (pmu_int_msk         ),
    .pmu_int_sta         (pmu_int_sta         ),
    .adc_ac_22bit        (adc_ac_22bit_sync   ),
    .adc_ac_12bit        (adc_ac_12bit_sync   ),
    .adc_dc_22bit        (adc_dc_22bit_sync   ),
    .adc_dc_12bit1       (adc_dc_12bit1_sync  ),
    .adc_dc_12bit2       (adc_dc_12bit2_sync  ),
    .adc_dc_12bit3       (adc_dc_12bit3_sync  ),
    .adc_dc_12bit4       (adc_dc_12bit4_sync  ),
    .adc_dc              (adc_dc_sync         ),//from bb current dc
    .adc_dc_force        (adc_dc_force        ),
    .iref_rf_trim12      (p_iref_rf_trim12    ),//pmu_aip_ctl11[19:16]
    .vco_cnt12           (p_vco_cnt12         ),//pmu_aip_ctl11[15:12]
    .vco_sw12            (p_vco_sw12          ),//pmu_aip_ctl11[11:9]
    .vco_fsk12           (p_vco_fsk12         ),//pmu_aip_ctl11[8:7]
    .vco_div_pd12        (p_vco_div_pd12      ),//pmu_aip_ctl11[6]
    .if_en_hold12        (p_if_en_hold12      ),//pmu_aip_ctl11[5]
    .pa_cnt12            (p_pa_cnt12          ),//pmu_aip_ctl11[4:2]
    .lna_cnt12           (p_lna_cnt12         ) //pmu_aip_ctl11[1:0]
);

//10.interrupt

defparam pic_inst.PIC_INT_NUM	= 4;

pic pic_inst
   (
    .gresetn		 (rstn_16m	   ),
    .gclk		 (clk_16m	   ),
    .presetn         	 (rstn_16m	   ),
    .pclk            	 (clk_16m	   ),
    .pclk_phase	         (1'b1		   ),

    .src_int00		 ({2'h0,adc_dc_upd_sync2,adc_done_sync2}),

    .int_clr_en	         (pmu_int_clr_en   ),
    .clr_ints		 (pmu_int_clr      ),

    .int_sub00_msk	 (pmu_int_msk	   ),
    .int_sub00_trg	 (pmu_int_trg	   ),
    .int_sub00_sta	 (pmu_int_sta	   ),

    .out_int		 (pmu_int_irq	   )
);

  always @ (posedge clk_16m or negedge rstn_16m)
    if (!rstn_16m) begin
      adc_done_sync0    <= 1'b0;
      adc_done_sync1    <= 1'b0;
      adc_done_sync2    <= 1'b0;
      adc_data_sync     <= 12'h0;
      adc_dc_upd_sync0  <= 1'b0;
      adc_dc_upd_sync1  <= 1'b0;
      adc_dc_upd_sync2  <= 1'b0;
      adc_dc_sync       <= 12'h0;
      adc_ac_22bit_sync <= 22'h0;
      adc_ac_12bit_sync <= 12'h0;
      adc_dc_22bit_sync <= 22'h0;
      adc_dc_12bit1_sync<= 12'h0;
      adc_dc_12bit2_sync<= 12'h0;
      adc_dc_12bit3_sync<= 12'h0;
      adc_dc_12bit4_sync<= 12'h0;
    end
    else begin
      adc_done_sync0    <= adc_done;
      adc_done_sync1    <= adc_done_sync0;
      adc_done_sync2    <= adc_done_sync1;
      adc_data_sync     <= adc_done_sync1 & ~adc_done_sync2 ? adc_data : adc_data_sync;
      adc_dc_upd_sync0  <= adc_dc_upd;
      adc_dc_upd_sync1  <= adc_dc_upd_sync0;
      adc_dc_upd_sync2  <= adc_dc_upd_sync1;
      adc_dc_sync       <= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc        : adc_dc_sync;
      adc_ac_22bit_sync <= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_ac_22bit  : adc_ac_22bit_sync;
      adc_ac_12bit_sync <= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_ac_12bit  : adc_ac_12bit_sync;
      adc_dc_22bit_sync <= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc_22bit  : adc_dc_22bit_sync;
      adc_dc_12bit1_sync<= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc_12bit1 : adc_dc_12bit1_sync;
      adc_dc_12bit2_sync<= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc_12bit2 : adc_dc_12bit2_sync;
      adc_dc_12bit3_sync<= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc_12bit3 : adc_dc_12bit3_sync;
      adc_dc_12bit4_sync<= adc_dc_upd_sync1 & ~adc_dc_upd_sync2 ? adc_dc_12bit4 : adc_dc_12bit4_sync;
    end

always @ (posedge clk_16m or negedge rstn_16m)
begin
    if(~rstn_16m)
    begin
        pmu_sleep_16m_sync0 <= #1 1'b0;
        pmu_sleep_16m_sync1 <= #1 1'b0;
        pmu_sleep_16m_sync2 <= #1 1'b0;
        pmu_sleep_16m_sync3 <= #1 1'b0;
        pmu_sleep_16m_sync4 <= #1 1'b0;
        pmu_sleep_16m_sync5 <= #1 1'b0;
        pmu_iso             <= #1 1'b0;
        pmu_wake_event_sync1 <= #1 1'b0;
        pmu_wake_event_sync2 <= #1 1'b0;
        pmu_wake_event_sync3 <= #1 1'b0;
        pmu_wake_event_sync4 <= #1 1'b0;
        cpu_wakeup_event     <= #1 1'b0;
    end
    else 
    begin
        pmu_sleep_16m_sync0 <= #1 pmu_sleepiso_32k;
        pmu_sleep_16m_sync1 <= #1 pmu_sleep_16m_sync0;
        pmu_sleep_16m_sync2 <= #1 pmu_sleep_16m_sync1;
        pmu_sleep_16m_sync3 <= #1 pmu_sleep_16m_sync2;
        pmu_sleep_16m_sync4 <= #1 pmu_sleep_16m_sync3;
        pmu_sleep_16m_sync5 <= #1 pmu_sleep_16m_sync4;
        pmu_iso             <= #1 pmu_sleep_16m_sync1|pmu_sleep_16m_sync2|pmu_sleep_16m_sync3|pmu_sleep_16m_sync4|pmu_sleep_16m_sync5;
        pmu_wake_event_sync1 <= #1 pmu_wake_event_32k;
        pmu_wake_event_sync2 <= #1 pmu_wake_event_sync1;
        pmu_wake_event_sync3 <= #1 pmu_wake_event_sync2;
        pmu_wake_event_sync4 <= #1 pmu_wake_event_sync3;
        cpu_wakeup_event     <= #1 pmu_wake_event_sync4;
    end
end

assign bg_trim12         = p_bg_trim12;//pmu_aip_ctl1[9:7]
assign en_temp12         = p_en_temp12;//pmu_aip_ctl1[6]
assign iref_trim12       = p_iref_trim12;//pmu_aip_ctl1[5:0]

assign ldo_b_en12        = (adc_reg_sel12 ? ldo_b_en_mcu  : ldo_b_en_pmu);//pmu_aip_ctl2[8]
assign ldo_s_vtrim12     = p_ldo_s_vtrim12;//pmu_aip_ctl2[7:4]
assign ldo_b_vtrim12     = p_ldo_b_vtrim12;//pmu_aip_ctl2[3:0]

assign oc32k_trim12      = p_oc32k_trim12;//pmu_aip_ctl3[14:8]
assign osc16m_trim12     = p_osc16m_trim12;//pmu_aip_ctl3[7:1]
assign osc16m_en12       = (adc_reg_sel12 ? osc16m_en_mcu : osc16m_en_pmu);//pmu_aip_ctl3[0]
   
assign sw_flash_pdn_en12 = p_sw_flash_pdn_en12;//pmu_aip_ctl4[3]
assign sw_flash_en12     = p_sw_flash_en12;//pmu_aip_ctl4[2]
assign sw_core_pdn_en12  = p_sw_core_pdn_en12;//pmu_aip_ctl4[1]
assign sw_core_en12      = (adc_reg_sel12 ? sw_core_en_mcu: sw_core_en_pmu);//pmu_aip_ctl4[0]

assign wd_tsel12         = p_wd_tsel12;//pmu_aip_ctl5[2:1]
assign wd_clrn12         = (timer_sel ? timer_clrn_16m : timer_clrn);//pmu_aip_ctl5[0]

assign if_ldo_en12       = p_if_ldo_en12;//pmu_aip_ctl6[20]
assign if_ldocomp12      = p_if_ldocomp12;//pmu_aip_ctl6[19]
assign if_filter_en12    = p_if_filter_en12;//pmu_aip_ctl6[18]
assign if_vsel12         = p_if_vsel12;//pmu_aip_ctl6[17:16]
assign if_vtrim12        = p_if_vtrim12;//pmu_aip_ctl6[15:12]
assign if_vcm_sel12      = p_if_vcm_sel12;//pmu_aip_ctl6[11:10]
assign if_lna_gain12     = p_if_lna_gain12;//pmu_aip_ctl6[9:6]
assign if_hpf_bw12       = p_if_hpf_bw12;//pmu_aip_ctl6[5:1]
assign if_bwhp12         = p_if_bwhp12;//pmu_aip_ctl6[0]
assign if_lpf_bw_tune12  = p_if_lpf_bw_tune12;//pmu_aip_ctl7[24:20]
assign if_lpf_q_tune12   = p_if_lpf_q_tune12;//pmu_aip_ctl7[19:15]
assign if_lpf_gm_tune12  = p_if_lpf_gm_tune12;//pmu_aip_ctl7[14:11]
assign if_pga_gain12     = p_if_pga_gain12;//pmu_aip_ctl7[10:7]
assign if_lpf_hbw_en12   = p_if_lpf_hbw_en12;//pmu_aip_ctl7[6]
assign if_test_en12      = p_if_test_en12;//pmu_aip_ctl7[5]
assign if_test_fsel12    = p_if_test_fsel12;//pmu_aip_ctl7[4:3]
assign if_lna_aon_en12   = p_if_lna_aon_en12;//pmu_aip_ctl7[2]
assign if_lpf_aon_en12   = p_if_lpf_aon_en12;//pmu_aip_ctl7[1]
assign if_pga_aon_en12   = p_if_pga_aon_en12;//pmu_aip_ctl7[0]
assign adc_clk_sel12     = p_adc_clk_sel12;//pmu_aip_ctl8[14]
assign adc_ch_mux12      = p_adc_ch_mux12;//pmu_aip_ctl8[13:10]
assign adc_sample_cnt12  = p_adc_sample_cnt12;//pmu_aip_ctl8[9:4]
assign adc_trigger12     = (adc_muxsel_32k ? adc_trigger12_apb : adc_trigger12_bb);//pmu_aip_ctl8[3]
assign adc_mode12        = p_adc_mode12;//pmu_aip_ctl8[2]
assign adc_en12_reg      = p_adc_en12_reg;//pmu_aip_ctl8[1]
assign adc_reg_sel12     = p_adc_reg_sel12;//pmu_aip_ctl8[0]
assign ldo_rf_en_ctrl12  = p_ldo_rf_en_ctrl12;//pmu_aip_ctl9[12]
assign ldo_rf1_en12      = p_ldo_rf1_en12;//pmu_aip_ctl9[11]
assign ldo_rf2_en12      = p_ldo_rf2_en12;//pmu_aip_ctl9[10]
assign ldo_rf3_en12      = p_ldo_rf3_en12;//pmu_aip_ctl9[9]
assign ldo_rf1_vtrim12   = p_ldo_rf1_vtrim12;//pmu_aip_ctl9[8:6]
assign ldo_rf2_vtrim12   = p_ldo_rf2_vtrim12;//pmu_aip_ctl9[5:3]
assign ldo_rf3_vtrim12   = p_ldo_rf3_vtrim12;//pmu_aip_ctl9[2:0]
assign tm_ana_en12       = p_tm_ana_en12;//pmu_aip_ctl10[1]
assign tm_ana_sel12      = p_tm_ana_sel12;//pmu_aip_ctl10[0]
assign iref_rf_trim12    = p_iref_rf_trim12;//pmu_aip_ctl11[19:16]
assign vco_cnt12         = p_vco_cnt12;//pmu_aip_ctl11[15:12]
assign vco_sw12          = p_vco_sw12;//pmu_aip_ctl11[11:9]
assign vco_fsk12         = p_vco_fsk12;//pmu_aip_ctl11[8:7]
assign vco_div_pd12      = p_vco_div_pd12;//pmu_aip_ctl11[6]
assign if_en_hold12      = p_if_en_hold12;//pmu_aip_ctl11[5]
assign pa_cnt12          = p_pa_cnt12;//pmu_aip_ctl11[4:2]
assign lna_cnt12         = p_lna_cnt12;//pmu_aip_ctl11[1:0]

assign adc_clk_ext12     = adc_dclk | adc_tclk;
    
assign p2_out_1          = io_value;
            
endmodule
