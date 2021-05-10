
module apbreg_pmu(
    pclk                 ,
    prstn                ,
    psel                 ,
    penable              ,
    pwrite               ,
    paddr                ,
    pwdata               ,
    prdata               ,
    pready               ,
    //input ports    
    ldo12_ready12        ,
    ldo_if_ready12       ,
    osc32k_ready12       ,
    osc16m_ready12       ,
    adc_data12           ,
    adc_dc               ,
    adc_ac_22bit         ,
    adc_ac_12bit         ,
    adc_dc_22bit         ,
    adc_dc_12bit1        ,
    adc_dc_12bit2        ,
    adc_dc_12bit3        ,
    adc_dc_12bit4        ,
    
    //output ports   
    bg_trim12            ,
    en_temp12            ,
    iref_trim12          ,
    ldo_b_en12           ,
    ldo_s_vtrim12        ,
    ldo_b_vtrim12        ,
    oc32k_trim12         ,
    osc16m_trim12        ,
    osc16m_en12          ,
    sw_flash_pdn_en12    ,
    sw_flash_en12        ,
    sw_core_pdn_en12     ,
    sw_core_en12         ,
    wd_tsel12            ,
    wd_clrn12            ,
    if_ldo_en12          ,
    if_ldocomp12         ,
    if_filter_en12       ,
    if_vsel12            ,
    if_vtrim12           ,
    if_vcm_sel12         ,
    if_lna_gain12        ,
    if_hpf_bw12          ,
    if_bwhp12            ,
    if_lpf_bw_tune12     ,
    if_lpf_q_tune12      ,
    if_lpf_gm_tune12     ,
    if_pga_gain12        ,
    if_lpf_hbw_en12      ,
    if_test_en12         ,
    if_test_fsel12       ,
    if_lna_aon_en12      ,
    if_lpf_aon_en12      ,
    if_pga_aon_en12      ,
    adc_clk_sel12        ,
    adc_ch_mux12         ,
    adc_sample_cnt12     ,
    adc_trigger12        ,
    adc_mode12           ,
    adc_en12_reg         ,
    adc_reg_sel12        ,
    ldo_rf_en_ctrl12     ,
    ldo_rf1_en12         ,
    ldo_rf2_en12         ,
    ldo_rf3_en12         ,
    ldo_rf1_vtrim12      ,
    ldo_rf2_vtrim12      ,
    ldo_rf3_vtrim12      ,
    tm_ana_en12          ,
    tm_ana_sel12         ,
    t1_val               ,
    t2_val               ,
    io_pinmux            ,
    io_int_en            ,
    io_mux_sel           ,
    io_sel               ,
    io_val               ,
    timer_sel            ,
    timer_en             ,
    timer_value          ,
    pmu_lpmd_sel         ,
    pmu_suspend          ,
    pmu_sleep            ,
    bb_wakeup_sel        ,
    bb_times_value       ,
    bb_timer_en          ,
    bb_adc_muxsel        ,
    bb_adc_thersh1       ,
    bb_adc_thersh2       ,
    bb_adc_dc_init       ,
    bb_timer_cnt         ,
    adc_dc_force         ,
    pmu_boot_sel         ,
    pmu_soft_rst         ,
    pmu_int_msk          ,
    pmu_int_trg          ,
    pmu_int_clr          ,
    pmu_int_clr_en       ,
    pmu_int_sta          ,
    timer_en_wakeup      ,
    timer_value_wakeup   ,
    iref_rf_trim12       ,
    vco_cnt12            ,
    vco_sw12             ,
    vco_fsk12            ,
    vco_div_pd12         ,
    if_en_hold12         ,
    pa_cnt12             ,
    lna_cnt12             
);
parameter D = 1;
    input               pclk                    ;
    input               prstn                   ;
    input               psel                    ;
    input               penable                 ;
    input               pwrite                  ;
    input  [23: 0]      paddr                   ;
    input  [31: 0]      pwdata                  ;
    output [31: 0]      prdata                  ;
    output              pready                  ;
    input               ldo12_ready12           ;
    input               ldo_if_ready12          ;
    input               osc32k_ready12          ;
    input               osc16m_ready12          ;
    input    [11: 0]    adc_data12              ;
    input    [11: 0]    adc_dc                  ;
    input    [21: 0]    adc_ac_22bit            ;
    input    [11: 0]    adc_ac_12bit            ;
    input    [21: 0]    adc_dc_22bit            ;
    input    [11: 0]    adc_dc_12bit1           ;
    input    [11: 0]    adc_dc_12bit2           ;
    input    [11: 0]    adc_dc_12bit3           ;
    input    [11: 0]    adc_dc_12bit4           ;
   
    //output ports   
    output   [ 2: 0]    bg_trim12               ;
    output              en_temp12               ;
    output   [ 5: 0]    iref_trim12             ;
    output              ldo_b_en12              ;
    output   [ 3: 0]    ldo_s_vtrim12           ;
    output   [ 3: 0]    ldo_b_vtrim12           ;
    output   [ 6: 0]    oc32k_trim12            ;
    output   [ 6: 0]    osc16m_trim12           ;
    output              osc16m_en12             ;
    output              sw_flash_pdn_en12       ;
    output              sw_flash_en12           ;
    output              sw_core_pdn_en12        ;
    output              sw_core_en12            ;
    output   [ 1: 0]    wd_tsel12               ;
    output              wd_clrn12               ;
    output              if_ldo_en12             ;
    output              if_ldocomp12            ;
    output              if_filter_en12          ;
    output   [ 1: 0]    if_vsel12               ;
    output   [ 3: 0]    if_vtrim12              ;
    output   [ 1: 0]    if_vcm_sel12            ;
    output   [ 3: 0]    if_lna_gain12           ;
    output   [ 4: 0]    if_hpf_bw12             ;
    output              if_bwhp12               ;
    output   [ 4: 0]    if_lpf_bw_tune12        ;
    output   [ 4: 0]    if_lpf_q_tune12         ;
    output   [ 3: 0]    if_lpf_gm_tune12        ;
    output   [ 3: 0]    if_pga_gain12           ;
    output              if_lpf_hbw_en12         ;
    output              if_test_en12            ;
    output   [ 1: 0]    if_test_fsel12          ;
    output              if_lna_aon_en12         ;
    output              if_lpf_aon_en12         ;
    output              if_pga_aon_en12         ;
    output              adc_clk_sel12           ;
    output   [ 3: 0]    adc_ch_mux12            ;
    output   [ 5: 0]    adc_sample_cnt12        ;
    output              adc_trigger12           ;
    output              adc_mode12              ;
    output              adc_en12_reg            ;
    output              adc_reg_sel12           ;
    output              ldo_rf_en_ctrl12        ;
    output              ldo_rf1_en12            ;
    output              ldo_rf2_en12            ;
    output              ldo_rf3_en12            ;
    output   [ 2: 0]    ldo_rf1_vtrim12         ;
    output   [ 2: 0]    ldo_rf2_vtrim12         ;
    output   [ 2: 0]    ldo_rf3_vtrim12         ;
    output              tm_ana_en12             ;
    output              tm_ana_sel12            ;
    output   [23: 0]    t1_val                  ;
    output   [23: 0]    t2_val                  ;
    output   [ 5:0]     io_pinmux               ;
    output              io_int_en               ;
    output              io_mux_sel              ;
    output              io_sel                  ;
    output              io_val                  ;
    output              timer_sel               ;
    output              timer_en                ;
    output   [17: 0]    timer_value             ;
    output   [ 3: 0]    pmu_lpmd_sel            ;
    output              pmu_suspend             ;
    output              pmu_sleep               ;
    output   [ 3: 0]    bb_wakeup_sel           ;
    output   [ 3: 0]    bb_times_value          ;
    output              bb_timer_en             ;
    output              bb_adc_muxsel           ;
    output   [21: 0]    bb_adc_thersh1          ;
    output   [21: 0]    bb_adc_thersh2          ;
    output   [11: 0]    bb_adc_dc_init          ;
    output   [ 7: 0]    bb_timer_cnt            ;
    output   [ 1: 0]    adc_dc_force            ;
    output   [ 1: 0]    pmu_boot_sel            ;
    output   [ 2: 0]    pmu_soft_rst            ;
    output   [ 3: 0]    pmu_int_msk             ;
    output   [11: 0]    pmu_int_trg             ;
    output   [ 3: 0]    pmu_int_clr             ;
    output              pmu_int_clr_en          ;
    input    [ 3: 0]    pmu_int_sta             ;
    output              timer_en_wakeup         ;
    output   [22: 0]    timer_value_wakeup      ;
    output   [ 3: 0]    iref_rf_trim12          ;
    output   [ 3: 0]    vco_cnt12               ;
    output   [ 2: 0]    vco_sw12                ;
    output   [ 1: 0]    vco_fsk12               ;
    output              vco_div_pd12            ;
    output              if_en_hold12            ;
    output   [ 2: 0]    pa_cnt12                ;
    output   [ 1: 0]    lna_cnt12               ;
    reg      [ 2: 0]    bg_trim12               ;
    reg                 en_temp12               ;
    reg      [ 5: 0]    iref_trim12             ;
    reg                 ldo_b_en12              ;
    reg      [ 3: 0]    ldo_s_vtrim12           ;
    reg      [ 3: 0]    ldo_b_vtrim12           ;
    reg      [ 6: 0]    oc32k_trim12            ;
    reg      [ 6: 0]    osc16m_trim12           ;
    reg                 osc16m_en12             ;
    reg                 sw_flash_pdn_en12       ;
    reg                 sw_flash_en12           ;
    reg                 sw_core_pdn_en12        ;
    reg                 sw_core_en12            ;
    reg      [ 1: 0]    wd_tsel12               ;
    reg                 wd_clrn12               ;
    reg                 if_ldo_en12             ;
    reg                 if_ldocomp12            ;
    reg                 if_filter_en12          ;
    reg      [ 1: 0]    if_vsel12               ;
    reg      [ 3: 0]    if_vtrim12              ;
    reg      [ 1: 0]    if_vcm_sel12            ;
    reg      [ 3: 0]    if_lna_gain12           ;
    reg      [ 4: 0]    if_hpf_bw12             ;
    reg                 if_bwhp12               ;
    reg      [ 4: 0]    if_lpf_bw_tune12        ;
    reg      [ 4: 0]    if_lpf_q_tune12         ;
    reg      [ 3: 0]    if_lpf_gm_tune12        ;
    reg      [ 3: 0]    if_pga_gain12           ;
    reg                 if_lpf_hbw_en12         ;
    reg                 if_test_en12            ;
    reg      [ 1: 0]    if_test_fsel12          ;
    reg                 if_lna_aon_en12         ;
    reg                 if_lpf_aon_en12         ;
    reg                 if_pga_aon_en12         ;
    reg                 adc_clk_sel12           ;
    reg      [ 3: 0]    adc_ch_mux12            ;
    reg      [ 5: 0]    adc_sample_cnt12        ;
    reg                 adc_trigger12           ;
    reg                 adc_trigger12_raw       ;
    reg                 adc_trigger12_d1        ;
    reg                 adc_trigger12_d2        ;
    reg                 adc_mode12              ;
    reg                 adc_en12_reg            ;
    reg                 adc_reg_sel12           ;
    reg                 ldo_rf_en_ctrl12        ;
    reg                 ldo_rf1_en12            ;
    reg                 ldo_rf2_en12            ;
    reg                 ldo_rf3_en12            ;
    reg      [ 2: 0]    ldo_rf1_vtrim12         ;
    reg      [ 2: 0]    ldo_rf2_vtrim12         ;
    reg      [ 2: 0]    ldo_rf3_vtrim12         ;
    reg                 tm_ana_en12             ;
    reg                 tm_ana_sel12            ;
    reg      [23: 0]    t1_val                  ;
    reg      [23: 0]    t2_val                  ;
    reg      [ 5:0]     io_pinmux               ;
    reg                 io_int_en               ;
    reg                 io_mux_sel              ;
    reg                 io_sel                  ;
    reg                 io_val                  ;
    reg                 timer_sel               ;
    reg                 timer_en                ;
    reg      [17: 0]    timer_value             ;
    reg      [ 3: 0]    pmu_lpmd_sel            ;
    reg                 pmu_suspend             ;
    reg                 pmu_sleep               ;
    reg      [ 3: 0]    bb_wakeup_sel           ;
    reg      [ 3: 0]    bb_times_value          ;
    reg                 bb_timer_en             ;
    reg                 bb_adc_muxsel           ;
    reg      [21: 0]    bb_adc_thersh1          ;
    reg      [21: 0]    bb_adc_thersh2          ;
    reg      [11: 0]    bb_adc_dc_init          ;
    reg      [ 7: 0]    bb_timer_cnt            ;
    reg      [ 1: 0]    adc_dc_force            ;
    reg      [ 1: 0]    pmu_boot_sel            ;
    reg      [ 2: 0]    pmu_soft_rst            ;
    reg      [ 3: 0]    pmu_int_msk             ;
    reg      [11: 0]    pmu_int_trg             ;
    reg      [ 3: 0]    pmu_int_clr             ;
    reg                 pmu_int_clr_en          ;
    reg                 timer_en_wakeup         ;
    reg      [22: 0]    timer_value_wakeup      ;
    reg      [ 3: 0]    iref_rf_trim12          ;
    reg      [ 3: 0]    vco_cnt12               ;
    reg      [ 2: 0]    vco_sw12                ;
    reg      [ 1: 0]    vco_fsk12               ;
    reg                 vco_div_pd12            ;
    reg                 if_en_hold12            ;
    reg      [ 2: 0]    pa_cnt12                ;
    reg      [ 1: 0]    lna_cnt12               ;

always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
    begin    
        adc_trigger12_d1     <= #D  1'h0           ;
        adc_trigger12_d2     <= #D  1'h0           ;
        adc_trigger12        <= #D  1'h0           ;
    end
    else
    begin
       adc_trigger12_d1     <= #D  adc_trigger12_raw ;
       adc_trigger12_d2     <= #D  adc_trigger12_d1  ;
       adc_trigger12        <= #D  adc_trigger12_raw | adc_trigger12_d1 | adc_trigger12_d2;
    end
end

always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
    begin                                          
        bg_trim12                 <= #D  3'h4           ;
        en_temp12                 <= #D  1'h0           ;
        iref_trim12               <= #D  6'h28          ;
        ldo_b_en12                <= #D  1'h1           ;
        ldo_s_vtrim12             <= #D  4'hc           ;
        ldo_b_vtrim12             <= #D  4'h8           ;
        oc32k_trim12              <= #D  7'h54          ;
        osc16m_trim12             <= #D  7'h59          ;
        osc16m_en12               <= #D  1'h1           ;
        sw_flash_pdn_en12         <= #D  1'h0           ;
        sw_flash_en12             <= #D  1'h1           ;
        sw_core_pdn_en12          <= #D  1'h0           ;
        sw_core_en12              <= #D  1'h1           ;
        wd_tsel12                 <= #D  2'h1           ;
        wd_clrn12                 <= #D  1'h0           ;
        if_ldo_en12               <= #D  1'h0           ;
        if_ldocomp12              <= #D  1'h0           ;
        if_filter_en12            <= #D  1'h1           ;
        if_vsel12                 <= #D  2'h0           ;
        if_vtrim12                <= #D  4'h8           ;
        if_vcm_sel12              <= #D  2'h0           ;
        if_lna_gain12             <= #D  4'h8           ;
        if_hpf_bw12               <= #D  5'h10          ;
        if_bwhp12                 <= #D  1'h0           ;
        if_lpf_bw_tune12          <= #D  5'h10          ;
        if_lpf_q_tune12           <= #D  5'h9           ;
        if_lpf_gm_tune12          <= #D  4'h1           ;
        if_pga_gain12             <= #D  4'hb           ;
        if_lpf_hbw_en12           <= #D  1'h0           ;
        if_test_en12              <= #D  1'h0           ;
        if_test_fsel12            <= #D  2'h0           ;
        if_lna_aon_en12           <= #D  1'h1           ;
        if_lpf_aon_en12           <= #D  1'h1           ;
        if_pga_aon_en12           <= #D  1'h1           ;
        adc_clk_sel12             <= #D  1'h0           ;
        adc_ch_mux12              <= #D  4'h0           ;
        adc_sample_cnt12          <= #D  6'h1           ;
        adc_trigger12_raw         <= #D  1'h0           ;
        adc_mode12                <= #D  1'h0           ;
        adc_en12_reg              <= #D  1'h0           ;
        adc_reg_sel12             <= #D  1'h0           ;
        ldo_rf_en_ctrl12          <= #D  1'h0           ;
        ldo_rf1_en12              <= #D  1'h0           ;
        ldo_rf2_en12              <= #D  1'h0           ;
        ldo_rf3_en12              <= #D  1'h0           ;
        ldo_rf1_vtrim12           <= #D  3'h4           ;
        ldo_rf2_vtrim12           <= #D  3'h4           ;
        ldo_rf3_vtrim12           <= #D  3'h4           ;
        tm_ana_en12               <= #D  1'h0           ;
        tm_ana_sel12              <= #D  1'h0           ;
        t1_val                    <= #D 24'hea600       ;
        t2_val                    <= #D 24'h17700       ;
        io_pinmux                 <= #D  6'h15          ;
        io_int_en                 <= #D  1'h0           ;
        io_mux_sel                <= #D  1'h0           ;
        io_sel                    <= #D  1'h0           ;
        io_val                    <= #D  1'h0           ;
        timer_sel                 <= #D  1'h0           ;
        timer_en                  <= #D  1'h0           ;
        timer_value               <= #D 18'h7d00        ;
        pmu_lpmd_sel              <= #D  4'h4           ;
        pmu_suspend               <= #D  1'h0           ;
        pmu_sleep                 <= #D  1'h0           ;
        bb_wakeup_sel             <= #D  4'h1           ;
        bb_times_value            <= #D  4'h0           ;
        bb_timer_en               <= #D  1'h0           ;
        bb_adc_muxsel             <= #D  1'h0           ;
        bb_adc_thersh1            <= #D 22'h2000        ;
        bb_adc_thersh2            <= #D 22'h1000        ;
        bb_adc_dc_init            <= #D 12'h26c         ;
        bb_timer_cnt              <= #D  8'h7           ;
        adc_dc_force              <= #D  2'h0           ;
        pmu_boot_sel              <= #D  2'h0           ;
        pmu_soft_rst              <= #D  3'h4           ;
        pmu_int_clr_en            <= #D  1'b0           ;
        pmu_int_clr               <= #D  4'h0           ;
        pmu_int_trg               <= #D 12'h0           ;
        pmu_int_msk               <= #D  4'h0           ;
        timer_en_wakeup           <= #D  1'h1           ;
        timer_value_wakeup        <= #D 23'h7d00        ;
        iref_rf_trim12            <= #D  4'h8           ;
        vco_cnt12                 <= #D  4'h8           ;
        vco_sw12                  <= #D  3'h4           ;
        vco_fsk12                 <= #D  2'h0           ;
        vco_div_pd12              <= #D  1'h1           ;
        if_en_hold12              <= #D  1'h1           ;
        pa_cnt12                  <= #D  3'h4           ;
        lna_cnt12                 <= #D  2'h2           ;
    end                                            
    else                                           
    begin                                          
        bg_trim12                 <= #D (psel & pwrite & ~penable & paddr == 'h00) ? pwdata[9:7]       : bg_trim12               ;
        en_temp12                 <= #D (psel & pwrite & ~penable & paddr == 'h00) ? pwdata[6]         : en_temp12               ;
        iref_trim12               <= #D (psel & pwrite & ~penable & paddr == 'h00) ? pwdata[5:0]       : iref_trim12             ;
        ldo_b_en12                <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[8]         : ldo_b_en12              ;
        ldo_s_vtrim12             <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[7:4]       : ldo_s_vtrim12           ;
        ldo_b_vtrim12             <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[3:0]       : ldo_b_vtrim12           ;
        oc32k_trim12              <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[14:8]      : oc32k_trim12            ;
        osc16m_trim12             <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[7:1]       : osc16m_trim12           ;
        osc16m_en12               <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[0]         : osc16m_en12             ;
        sw_flash_pdn_en12         <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[3]         : sw_flash_pdn_en12       ;
        sw_flash_en12             <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[2]         : sw_flash_en12           ;
        sw_core_pdn_en12          <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[1]         : sw_core_pdn_en12        ;
        sw_core_en12              <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[0]         : sw_core_en12            ;
        wd_tsel12                 <= #D (psel & pwrite & ~penable & paddr == 'h10) ? pwdata[2:1]       : wd_tsel12               ;
        wd_clrn12                 <= #D (psel & pwrite & ~penable & paddr == 'h10) ? pwdata[0]         : wd_clrn12               ;
        if_ldo_en12               <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[20]        : if_ldo_en12             ;
        if_ldocomp12              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[19]        : if_ldocomp12            ;
        if_filter_en12            <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[18]        : if_filter_en12          ;
        if_vsel12                 <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[17:16]     : if_vsel12               ;
        if_vtrim12                <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[15:12]     : if_vtrim12              ;
        if_vcm_sel12              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[11:10]     : if_vcm_sel12            ;
        if_lna_gain12             <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[9:6]       : if_lna_gain12           ;
        if_hpf_bw12               <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[5:1]       : if_hpf_bw12             ;
        if_bwhp12                 <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[0]         : if_bwhp12               ;
        if_lpf_bw_tune12          <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[24:20]     : if_lpf_bw_tune12        ;
        if_lpf_q_tune12           <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[19:15]     : if_lpf_q_tune12         ;
        if_lpf_gm_tune12          <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[14:11]     : if_lpf_gm_tune12        ;
        if_pga_gain12             <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[10:7]      : if_pga_gain12           ;
        if_lpf_hbw_en12           <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[6]         : if_lpf_hbw_en12         ;
        if_test_en12              <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[5]         : if_test_en12            ;
        if_test_fsel12            <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[4:3]       : if_test_fsel12          ;
        if_lna_aon_en12           <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[2]         : if_lna_aon_en12         ;
        if_lpf_aon_en12           <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[1]         : if_lpf_aon_en12         ;
        if_pga_aon_en12           <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[0]         : if_pga_aon_en12         ;
        adc_clk_sel12             <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[14]        : adc_clk_sel12           ;
        adc_ch_mux12              <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[13:10]     : adc_ch_mux12            ;
        adc_sample_cnt12          <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[9:4]       : adc_sample_cnt12        ;
        adc_trigger12_raw         <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[3]         : 1'b0                     ;//wc
        adc_mode12                <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[2]         : adc_mode12              ;
        adc_en12_reg              <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[1]         : adc_en12_reg            ;
        adc_reg_sel12             <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[0]         : adc_reg_sel12           ;
        ldo_rf_en_ctrl12          <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[12]        : ldo_rf_en_ctrl12        ;
        ldo_rf1_en12              <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[11]        : ldo_rf1_en12            ;
        ldo_rf2_en12              <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[10]        : ldo_rf2_en12            ;
        ldo_rf3_en12              <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[9]         : ldo_rf3_en12            ;
        ldo_rf1_vtrim12           <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[8:6]       : ldo_rf1_vtrim12         ;
        ldo_rf2_vtrim12           <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[5:3]       : ldo_rf2_vtrim12         ;
        ldo_rf3_vtrim12           <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[2:0]       : ldo_rf3_vtrim12         ;
        tm_ana_en12               <= #D (psel & pwrite & ~penable & paddr == 'h24) ? pwdata[1]         : tm_ana_en12             ;
        tm_ana_sel12              <= #D (psel & pwrite & ~penable & paddr == 'h24) ? pwdata[0]         : tm_ana_sel12            ;
        t1_val                    <= #D (psel & pwrite & ~penable & paddr == 'h30) ? pwdata[23:0]      : t1_val                  ;
        t2_val                    <= #D (psel & pwrite & ~penable & paddr == 'h34) ? pwdata[23:0]      : t2_val                  ;
        io_pinmux                 <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[13:8]      : io_pinmux               ;
        io_int_en                 <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[4]         : io_int_en               ;
        io_mux_sel                <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[3]         : io_mux_sel              ;
        io_sel                    <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[1]         : io_sel                  ;
        io_val                    <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[0]         : io_val                  ;
        timer_sel                 <= #D (psel & pwrite & ~penable & paddr == 'h3c) ? pwdata[19]        : timer_sel               ;
        timer_en                  <= #D (psel & pwrite & ~penable & paddr == 'h3c) ? pwdata[18]        : timer_en                ;
        timer_value               <= #D (psel & pwrite & ~penable & paddr == 'h3c) ? pwdata[17:0]      : timer_value             ;
        pmu_lpmd_sel              <= #D (psel & pwrite & ~penable & paddr == 'h40) ? pwdata[5:2]       : pmu_lpmd_sel            ;
        pmu_suspend               <= #D (psel & pwrite & ~penable & paddr == 'h40) ? pwdata[1]         : 1'b0                    ;//wc
        pmu_sleep                 <= #D (psel & pwrite & ~penable & paddr == 'h40) ? pwdata[0]         : 1'b0                    ;//wc
        bb_wakeup_sel             <= #D (psel & pwrite & ~penable & paddr == 'h44) ? pwdata[9:6]       : bb_wakeup_sel           ;
        bb_times_value            <= #D (psel & pwrite & ~penable & paddr == 'h44) ? pwdata[5:2]       : bb_times_value          ;
        bb_timer_en               <= #D (psel & pwrite & ~penable & paddr == 'h44) ? pwdata[1]         : bb_timer_en             ;
        bb_adc_muxsel             <= #D (psel & pwrite & ~penable & paddr == 'h44) ? pwdata[0]         : bb_adc_muxsel           ;
        bb_adc_thersh1            <= #D (psel & pwrite & ~penable & paddr == 'h48) ? pwdata[21:0]      : bb_adc_thersh1          ;
        bb_adc_thersh2            <= #D (psel & pwrite & ~penable & paddr == 'h4c) ? pwdata[21:0]      : bb_adc_thersh2          ;
        adc_dc_force              <= #D (psel & pwrite & ~penable & paddr == 'h50) ? pwdata[13:12]     : adc_dc_force            ;
        bb_adc_dc_init            <= #D (psel & pwrite & ~penable & paddr == 'h50) ? pwdata[11:0]      : bb_adc_dc_init          ;
        bb_timer_cnt              <= #D (psel & pwrite & ~penable & paddr == 'h54) ? pwdata[7:0]       : bb_timer_cnt            ;
        pmu_soft_rst              <= #D (psel & pwrite & ~penable & paddr == 'h58) ? pwdata[4:2]       : pmu_soft_rst            ;
        pmu_boot_sel              <= #D (psel & pwrite & ~penable & paddr == 'h58) ? pwdata[1:0]       : pmu_boot_sel            ;
        pmu_int_clr_en            <= #D (psel & pwrite & ~penable & paddr == 'h5c) & |pwdata[19:16]                              ;
        pmu_int_clr               <= #D (psel & pwrite & ~penable & paddr == 'h5c) ? pwdata[19:16]     : pmu_int_clr             ;
        pmu_int_trg               <= #D (psel & pwrite & ~penable & paddr == 'h5c) ? pwdata[15:4]      : pmu_int_trg             ;
        pmu_int_msk               <= #D (psel & pwrite & ~penable & paddr == 'h5c) ? pwdata[3:0]       : pmu_int_msk             ;
        timer_en_wakeup           <= #D (psel & pwrite & ~penable & paddr == 'h60) ? pwdata[23]        : timer_en_wakeup         ;
        timer_value_wakeup        <= #D (psel & pwrite & ~penable & paddr == 'h60) ? pwdata[22:0]      : timer_value_wakeup      ;
        iref_rf_trim12            <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[19:16]     : iref_rf_trim12          ;
        vco_cnt12                 <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[15:12]     : vco_cnt12               ;
        vco_sw12                  <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[11:9]      : vco_sw12                ;
        vco_fsk12                 <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[8:7]       : vco_fsk12               ;
        vco_div_pd12              <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[6]         : vco_div_pd12            ;
        if_en_hold12              <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[5]         : if_en_hold12            ;
        pa_cnt12                  <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[4:2]       : pa_cnt12                ;
        lna_cnt12                 <= #D (psel & pwrite & ~penable & paddr == 'h64) ? pwdata[1:0]       : lna_cnt12               ;
    end                                            
end                                                
reg     [31:0] prdata_wire                        ;
reg     [31:0] prdata                             ;
always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
        prdata <= #D 32'h0;                        
    else if (psel & ~penable & ~pwrite)            
        prdata <= #D prdata_wire;                  
end                                                
always @ (*)                                       
begin                                              
    prdata_wire = prdata;                          
    case(paddr)                                    
       'h00   : prdata_wire = {22'h0, bg_trim12, en_temp12, iref_trim12 }                                       ;
       'h04   : prdata_wire = {23'h0, ldo_b_en12, ldo_s_vtrim12, ldo_b_vtrim12 }                                ;
       'h08   : prdata_wire = {17'h0, oc32k_trim12, osc16m_trim12, osc16m_en12 }                                ;
       'h0c   : prdata_wire = {28'h0, sw_flash_pdn_en12, sw_flash_en12, sw_core_pdn_en12, sw_core_en12 }        ;
       'h10   : prdata_wire = {29'h0, wd_tsel12, wd_clrn12 }                                                    ;
       'h14   : prdata_wire = {11'h0, if_ldo_en12, if_ldocomp12, if_filter_en12, if_vsel12, if_vtrim12, if_vcm_sel12, if_lna_gain12, if_hpf_bw12, if_bwhp12 } ;
       'h18   : prdata_wire = {7'h0, if_lpf_bw_tune12, if_lpf_q_tune12, if_lpf_gm_tune12, if_pga_gain12, if_lpf_hbw_en12, if_test_en12, if_test_fsel12, if_lna_aon_en12, if_lpf_aon_en12, if_pga_aon_en12 } ;
       'h1c   : prdata_wire = {17'h0, adc_clk_sel12, adc_ch_mux12, adc_sample_cnt12, adc_trigger12_raw, adc_mode12, adc_en12_reg, adc_reg_sel12 } ;
       'h20   : prdata_wire = {19'h0, ldo_rf_en_ctrl12, ldo_rf1_en12, ldo_rf2_en12, ldo_rf3_en12, ldo_rf1_vtrim12, ldo_rf2_vtrim12, ldo_rf3_vtrim12 } ;
       'h24   : prdata_wire = {30'h0, tm_ana_en12, tm_ana_sel12 }                                               ;
       'h28   : prdata_wire = {16'h0, ldo12_ready12, ldo_if_ready12, osc32k_ready12, osc16m_ready12, adc_data12 } ;
       'h30   : prdata_wire = {8'h0, t1_val }                                                                   ;
       'h34   : prdata_wire = {8'h0, t2_val }                                                                   ;
       'h38   : prdata_wire = {18'h0, io_pinmux, 3'h0, io_int_en, io_mux_sel, 1'b0, io_sel, io_val }                 ;
       'h3c   : prdata_wire = {12'h0, timer_sel, timer_en, timer_value }                          ;
       'h40   : prdata_wire = {26'h0, pmu_lpmd_sel, pmu_suspend, pmu_sleep }                                                  ;
       'h44   : prdata_wire = {22'h0, bb_wakeup_sel, bb_times_value, bb_timer_en, bb_adc_muxsel }              ;
       'h48   : prdata_wire = {10'h0, bb_adc_thersh1 }                                                          ;
       'h4c   : prdata_wire = {10'h0, bb_adc_thersh2 }                                                          ;
       'h50   : prdata_wire = {4'h0, adc_dc,2'h0,adc_dc_force,bb_adc_dc_init }                                                          ;
       'h54   : prdata_wire = {24'h0, bb_timer_cnt }                                                            ;
       'h58   : prdata_wire = {27'h0,pmu_soft_rst,pmu_boot_sel}                   ;
       'h5c   : prdata_wire = {8'h0,pmu_int_sta, pmu_int_clr,pmu_int_trg,pmu_int_msk}                                ;
       'h60   : prdata_wire = {8'h0, timer_en_wakeup, timer_value_wakeup }                                      ;
       'h64   : prdata_wire = {12'h0, iref_rf_trim12, vco_cnt12, vco_sw12, vco_fsk12, vco_div_pd12, if_en_hold12, pa_cnt12, lna_cnt12 } ;
       'h70   : prdata_wire = {10'h0, adc_ac_22bit};
       'h74   : prdata_wire = {20'h0, adc_ac_12bit};
       'h78   : prdata_wire = {10'h0, adc_dc_22bit};
       'h7c   : prdata_wire = {4'h0, adc_dc_12bit2, 4'h0, adc_dc_12bit1};
       'h80   : prdata_wire = {4'h0, adc_dc_12bit4, 4'h0, adc_dc_12bit3};
        default:prdata_wire = 32'h0;               
    endcase                                        
end                                                
assign pready = 1'b1 ;
endmodule
