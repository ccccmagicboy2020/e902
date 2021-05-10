module aon_bb(
    i_clk         ,//32kHz
    i_rstn        ,
    
    i_adc_data    ,
    o_adc_triger  ,
    i_timer_en    ,//must cdc
    i_timer_cnt   ,//128Hz min sample ==>7812500ns,32Khz==>31250ns,250 cycles
    i_times_value ,//600ms/1KHz==600
    i_adc_dc_init ,//initial dc value
    i_adc_thresh1 ,
    i_adc_thresh2 ,
    i_adc_dc_force,     
    i_wakeup_sel,
    o_adc_ac_22bit,
    o_adc_ac_12bit,
    o_adc_dc_22bit,
    o_adc_dc_12bit,
    o_adc_dc_d1   ,
    o_adc_dc_d2   ,
    o_adc_dc_d3   ,
    o_io_triger   ,
    o_bb_wakeup   ,
    o_dc_upd      ,
    o_dc_val      
);
input                           i_clk         ;//32kHz
input                           i_rstn        ;

input         [11:0]            i_adc_data    ;
output                          o_adc_triger  ;
input                           i_timer_en    ;//must cdc
input         [ 7:0]            i_timer_cnt   ;//128Hz min sample ==>7812500ns,32Khz==>31250ns,250 cycles
input         [ 3:0]            i_times_value ;//600ms/1KHz==600
input         [11:0]            i_adc_dc_init ;//initial dc value
input         [21:0]            i_adc_thresh1 ;
input         [21:0]            i_adc_thresh2 ;
input         [ 3:0]            i_wakeup_sel  ;
output        [21:0]            o_adc_ac_22bit;
output        [11:0]            o_adc_ac_12bit;
output        [21:0]            o_adc_dc_22bit;
output        [11:0]            o_adc_dc_12bit;
output        [11:0]            o_adc_dc_d1   ;
output        [11:0]            o_adc_dc_d2   ;
output        [11:0]            o_adc_dc_d3   ;

output                          o_io_triger   ;
output                          o_bb_wakeup   ;
output                          o_dc_upd      ;
output        [11:0]            o_dc_val      ;
input         [ 1:0]            i_adc_dc_force;




reg           [ 7:0]            sample_timer     ;
reg                             sample_triger    ;
reg           [ 9:0]            times_cnt        ;
reg           [21:0]            adc_dc_sum       ;
reg           [21:0]            adc_ac_sum       ;
wire signed   [12:0]            adc_ac           ;
wire          [11:0]            adc_abs          ;
reg           [11:0]            adc_dc           ;
wire          [ 9:0]            times_value      ;
reg                             adc_dc_force_d1  ;
wire                            update_en        ;
reg                             update_en_d1     ;
wire          [11:0]            adc_dc_cal_d     ;
wire          [11:0]            adc_ac_cal_d     ;
reg           [21:0]            o_adc_ac_22bit   ;
reg           [11:0]            o_adc_ac_12bit   ;
reg           [21:0]            o_adc_dc_22bit   ;
reg           [11:0]            o_adc_dc_12bit   ;
reg           [11:0]            o_adc_dc_d1      ;
reg           [11:0]            o_adc_dc_d2      ;
reg           [11:0]            o_adc_dc_d3      ;
reg                             o_io_triger      ;
reg                             o_bb_wakeup      ;

assign times_value = i_times_value == 4'd0 ? 10'd32 :
                     i_times_value == 4'd1 ? 10'd64 :
                     i_times_value == 4'd2 ? 10'd128 :
                     i_times_value == 4'd3 ? 10'd256 :
                     i_times_value == 4'd4 ? 10'd512 :
                                             10'd256;

always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        sample_timer <= #1 8'h0;
    else if(i_timer_en)
        sample_timer <= #1 ~(|sample_timer) ? i_timer_cnt : sample_timer -1'b1 ; 
    else
        sample_timer <= #1 8'h0;
end
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        sample_triger <= #1 1'b0;
    else if(i_timer_en)
        sample_triger <= #1 sample_timer == 8'd1 ; 
    else
        sample_triger <= #1 1'b0;
end

assign o_adc_triger = sample_triger;//sample must be reg out
assign update_en = (times_cnt == times_value)&(sample_timer == 8'd1);

always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        update_en_d1 <= #1 1'b0;
    else 
        update_en_d1 <= #1 update_en;
end

always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        times_cnt <= #1 10'd0;
    else if(i_timer_en)
    begin
        if(update_en)
            times_cnt <= #1 10'h1;
        else
            times_cnt <= #1 (sample_timer == 8'd1) ? times_cnt + 1'b1 :times_cnt; 
    end
    else
        times_cnt <= #1 10'h0;
end
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        adc_dc_force_d1 <= #1 1'b0;
    else 
        adc_dc_force_d1 <= #1 i_adc_dc_force[0];
end

assign adc_ac    = i_adc_data - adc_dc;//12bits+12bits = 13bits
assign adc_abs   = adc_ac[12]?(~adc_ac[11:0]+12'b1):adc_ac[11:0];

always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn) begin 
        adc_dc_sum  <= #1 22'h0;
        adc_ac_sum<= #1 22'h0;
    end
    else if (~i_timer_en) begin
        adc_dc_sum  <= #1 22'h0;
        adc_ac_sum  <= #1 22'h0;
    end
    else if (update_en) begin //next start
        adc_dc_sum  <= #1 22'h0;
        adc_ac_sum  <= #1 i_wakeup_sel[2] ? adc_ac_sum : 22'h0;
    end
    else begin
        adc_dc_sum <= #1 sample_triger ? adc_dc_sum + i_adc_data : adc_dc_sum;
        adc_ac_sum <= #1 sample_triger ? (i_wakeup_sel[2] ? adc_ac_sum - adc_ac_cal_d + adc_abs : adc_ac_sum + adc_abs)  : adc_ac_sum; 
    end
end

assign adc_dc_cal_d   = i_times_value == 4'd0 ? adc_dc_sum >>5:
                        i_times_value == 4'd1 ? adc_dc_sum >>6:
                        i_times_value == 4'd2 ? adc_dc_sum >>7:
                        i_times_value == 4'd3 ? adc_dc_sum >>8:
                        i_times_value == 4'd4 ? adc_dc_sum >>9: 
                                                adc_dc_sum >>8;
assign adc_ac_cal_d   = i_times_value == 4'd0 ? adc_ac_sum >>5:
                        i_times_value == 4'd1 ? adc_ac_sum >>6:
                        i_times_value == 4'd2 ? adc_ac_sum >>7:
                        i_times_value == 4'd3 ? adc_ac_sum >>8:
                        i_times_value == 4'd4 ? adc_ac_sum >>9: 
                                                adc_ac_sum >>8;

always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        adc_dc <= #1 12'h0;
    else if(i_adc_dc_force[1] | (i_adc_dc_force[0] & ~adc_dc_force_d1))
        adc_dc <= #1 i_adc_dc_init;
    else if (update_en)
        adc_dc <= #1 adc_ac_sum <= i_adc_thresh2 ? adc_dc_cal_d : adc_dc; 
end
 
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn) begin
        o_adc_ac_22bit   <= #1 22'h0;
        o_adc_ac_12bit   <= #1 12'h0;
        o_adc_dc_22bit   <= #1 22'h0;
        o_adc_dc_12bit   <= #1 12'h0;
        o_adc_dc_d1      <= #1 12'h0;
        o_adc_dc_d2      <= #1 12'h0;
        o_adc_dc_d3      <= #1 12'h0;
    end
    else if (update_en) begin
        o_adc_ac_22bit   <= #1 adc_ac_sum;
        o_adc_ac_12bit   <= #1 i_times_value == 4'd0 ? adc_ac_sum >>5:
                               i_times_value == 4'd1 ? adc_ac_sum >>6:
                               i_times_value == 4'd2 ? adc_ac_sum >>7:
                               i_times_value == 4'd3 ? adc_ac_sum >>8:
                               i_times_value == 4'd4 ? adc_ac_sum >>9:
                                                       adc_ac_sum >>8;
        o_adc_dc_22bit   <= #1 adc_dc_sum;
        o_adc_dc_12bit   <= #1 adc_dc_cal_d;
        o_adc_dc_d1      <= #1 o_adc_dc_12bit;
        o_adc_dc_d2      <= #1 o_adc_dc_d1;
        o_adc_dc_d3      <= #1 o_adc_dc_d2;
    end
end
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn) begin
        o_io_triger  <= #1 1'b0;
        o_bb_wakeup  <= #1 1'b0;
    end
    else begin
        o_io_triger <= #1 (adc_ac_sum >= i_adc_thresh1) & (update_en | i_wakeup_sel[3]);
        o_bb_wakeup <= #1 i_wakeup_sel[1] ? 1'b0 : (i_wakeup_sel[0] ? ((adc_ac_sum >= i_adc_thresh1) & (update_en | i_wakeup_sel[3])) : update_en);
    end
end

assign o_dc_val    = adc_dc;
assign o_dc_upd    = update_en_d1;

endmodule
