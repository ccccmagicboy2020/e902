module ir_rx(
    clk           ,
    rstn          ,
    sin           ,
    ir_int        ,
    ir_int_clr    ,
    ir_data       ,
    ir_repeat     ,
    ir_cmp_err    ,
    
    rf_ir_phase   ,
    rf_addr_cmp_en,
    rf_data_cmp_en,
    rf_cmp_clr    ,
    rf_noise_th   ,
    rf_edge_th    ,
    rf_9ms_cnt    ,
    rf_4p5_cnt    ,
//    rf_0p56_cnt   ,
    rf_1p69_cnt   ,
    rf_2p25_cnt    
);
parameter D = 1;
input            clk             ;
input            rstn            ;
input            sin             ;
output           ir_int          ;
input            ir_int_clr      ;
input            rf_ir_phase     ;
input  [ 7:0]    rf_noise_th     ;
input  [17:0]    rf_9ms_cnt      ;
input  [17:0]    rf_4p5_cnt      ;
//input  [17:0]    rf_0p56_cnt     ;
input  [17:0]    rf_1p69_cnt     ;
input  [17:0]    rf_2p25_cnt     ;

input  [12:0]    rf_edge_th      ;
output [31:0]    ir_data         ;
output           ir_repeat       ;
input            rf_addr_cmp_en  ;
input            rf_data_cmp_en  ;
input            rf_cmp_clr      ;
output           ir_cmp_err      ;


reg              ir_sync0        ;    
reg              ir_sync1        ; 
reg              ir_rmnoise      ;
reg              ir_rmnoise_d    ;
reg   [ 7: 0]    noise_cnt       ;
reg              ir_change       ;
reg              ir_change_d     ;
reg   [11: 0]    ir_edgedly_cnt  ;
reg              ir_int          ;

wire             edge_found      ;
wire             ir_wave_change  ;
reg   [23: 0]    change_dly_cnt  ;
reg   [7 : 0]    ir_cstate       ;
reg   [7 : 0]    ir_nstate       ;
reg   [5 : 0]    data_cnt        ;
reg   [31: 0]    ir_data         ;
reg              ir_repeat       ;
reg              ir_correct      ;
reg              ir_cmp_err      ;
parameter     IDLE     = 0;
parameter     LEAD_L   = 1;
parameter     LEAD_H   = 2;
parameter     REPEAT_L = 3;
parameter     DATA_H   = 4;
parameter     DATA_L   = 5;
parameter     INT      = 6;
parameter     WAIT     = 7;


//anti meta ,double sync
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
    begin
        ir_sync0 <= #D 1'b1;
        ir_sync1 <= #D 1'b1;
    end
    else
    begin
        ir_sync0 <= #D sin ;
        ir_sync1 <= #D ir_sync0;
    end
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
    begin
        ir_correct <= #D 1'b1;
    end
    else
    begin
        ir_correct <= #D rf_ir_phase ? ir_sync1 : ~ir_sync1;
    end
end

always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
    begin
        ir_rmnoise  <= #D 1'h1 ;
        ir_rmnoise_d<= #D 1'h1 ;
        noise_cnt   <= #D 8'b0;
    end
    else
    begin
        ir_rmnoise   <= #D (noise_cnt >= rf_noise_th)?ir_correct:ir_rmnoise;
        ir_rmnoise_d <= #D ir_rmnoise ;
        noise_cnt      <= #D (ir_rmnoise ^ ir_correct)? 'h0
                                                      : (noise_cnt == {8{1'b1}})? noise_cnt
                                                                                 : noise_cnt + 1 ;
    end
end
assign edge_found = ir_rmnoise ^ ir_rmnoise_d;
//ir_value is a carrier wave or no carrier wave,next step to remove carrier
//here we get the wave edge, remove the pulse which near appears as the carrier
reg              debug;
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
    begin
        ir_edgedly_cnt   <= #D {12{1'b1}};
        ir_change        <= #D 1;
        ir_change_d      <= #D 1;
    end
    else
    begin
        ir_edgedly_cnt   <= #D     (edge_found) ? 'h1 
                                : ir_edgedly_cnt == {12{1'b1}}? ir_edgedly_cnt
                                                               :ir_edgedly_cnt != 0 ? ir_edgedly_cnt + 1
                                                                                    : ir_edgedly_cnt ;
        //ir_change        <= #D ir_edgedly_cnt >= rf_edge_th;
        ir_change        <= #D debug;
        ir_change_d      <= #D ir_change;
    end
end
//debug used begin=====================
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        debug            <= #D 1;
    else if (edge_found)
        debug <= #D (ir_edgedly_cnt >= rf_edge_th)?1'b0:1'b1;
    else if (debug ==1 & ir_edgedly_cnt == rf_edge_th)
        debug <= #D 1'b0;
    else if (ir_edgedly_cnt >= rf_edge_th)
        debug <= #D 1'b1;
end

//debug used end=====================
assign ir_wave_change = ir_change & ~ir_change_d;
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        change_dly_cnt <= #D 0;
    else if ((ir_nstate == WAIT)&(ir_cstate == INT))
        change_dly_cnt <= #D 0;
    else if (ir_cstate == WAIT)
        change_dly_cnt <= #D change_dly_cnt != {24{1'b1}} ? change_dly_cnt + 1 : change_dly_cnt;
    else
        change_dly_cnt <= #D ir_wave_change ? 0: change_dly_cnt != {24{1'b1}} ? change_dly_cnt + 1 : change_dly_cnt;
end

always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        ir_cstate      <= #D IDLE;
    else
        ir_cstate      <= #D ir_nstate;
end
always @ (*)
begin
    ir_nstate = ir_cstate;
    case(ir_cstate)
        IDLE    : ir_nstate = ir_wave_change ? LEAD_H : IDLE;
        LEAD_H  : ir_nstate = ir_wave_change ? change_dly_cnt >= rf_9ms_cnt ? LEAD_L : IDLE : LEAD_H;
        LEAD_L  : ir_nstate = ir_wave_change ? change_dly_cnt >= rf_4p5_cnt ? DATA_H :
                                               change_dly_cnt >= rf_2p25_cnt? REPEAT_L:IDLE
                                              :LEAD_L;
        REPEAT_L: ir_nstate = ir_wave_change ? INT :REPEAT_L;
        DATA_H  : ir_nstate = ir_wave_change ? DATA_L : DATA_H;
        DATA_L  : ir_nstate = ir_wave_change ? data_cnt >= 'd31 ? INT : DATA_H:DATA_L;
        INT     : ir_nstate = WAIT;
        WAIT    : ir_nstate = change_dly_cnt[23:1] >= rf_9ms_cnt ? IDLE : WAIT;
    endcase
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        data_cnt  <= #D 0;
    else if(ir_cstate == INT)
        data_cnt  <= #D 'h0;
    else if((ir_cstate ==DATA_L) &(ir_nstate != DATA_L))
        data_cnt  <= #D data_cnt + 1;
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        ir_data  <= #D 0;
    else if((ir_cstate ==DATA_L) &(ir_nstate != DATA_L))
        ir_data  <= #D {(change_dly_cnt > rf_1p69_cnt), ir_data[31:1]};
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        ir_int  <= #D 0;
    else 
        ir_int  <= #D ir_cstate == INT ? 1'b1: ir_int_clr? 1'b0 : ir_int;
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        ir_repeat  <= #D 0;
    else 
        ir_repeat  <= #D ir_cstate == REPEAT_L ? 1'b1: ir_int_clr? 1'b0 : ir_repeat;
end
always @ (posedge clk or negedge rstn)
begin
    if(~rstn)
        ir_cmp_err  <= #D 0;
    else if(ir_cstate == INT)
        ir_cmp_err  <= #D (rf_addr_cmp_en? (ir_data[31:24] != ~ir_data[23:16]):0)
                         |(rf_data_cmp_en? (ir_data[15: 8] != ~ir_data[ 7: 0]):0);
    else if(rf_cmp_clr)
        ir_cmp_err  <= #D 0;
end


endmodule
  
