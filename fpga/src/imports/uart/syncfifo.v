//`define LOG2(x) ((x< 2)? 1 :\
//                 (x< 4)? 2 :\
//                 (x< 8)? 3 :\
//                 (x<16)? 4 :\
//                 (x<32)? 5 :\
//                 (x<64)? 6 :\
//                         7)
module syncfifo(
    i_clk     ,
    i_rstn    ,
    i_sclr    ,
    i_rd      ,
    i_wr      ,
    i_data    ,
    o_data    ,
    o_cnt     ,
    o_nfull   ,
    o_nempty  ,
    o_full    ,
    o_empty     

);
parameter width       = 9                     ;
parameter depth       = 16                    ;
parameter nf_dep      = 1                     ;
parameter ne_dep      = 2                     ;
parameter nbits       = 4                     ;
parameter pbits       = 3                     ;
parameter D           = 1                     ;
input                           i_clk         ;
input                           i_rstn        ;
input                           i_sclr        ;
input                           i_rd          ;
input                           i_wr          ;
input   [width-1:0]             i_data        ;
output  [width-1:0]             o_data        ;
output  [nbits-1:0]             o_cnt         ;
output                          o_nfull       ;
output                          o_nempty      ;
output                          o_full        ;
output                          o_empty       ;

wire    [width-1:0]             ram_dout      ;
reg     [width-1:0]             o_data        ;
reg     [nbits-1:0]             rp            ;
reg     [nbits-1:0]             wp            ;
reg     [nbits-1:0]             cnt           ;
reg                             full          ;
reg                             empty         ;
reg                             nfull         ;
reg                             nempty        ;
reg     [width-1:0]             ram[depth-1:0];
wire    [nbits-1:0]             nrp           ;
wire                            fifo_oe       ;
reg                             emp_next      ;
reg                             nemp_next     ;
reg                             full_next     ;
reg                             nfull_next    ;
reg     [nbits-1:0]             cnt_next      ;
wire    [nbits-1:0]             rp_next       ;
always @ (posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
    begin
        cnt         <= #D {nbits{1'b0}}     ;
        empty       <= #D 1'b1              ;
        nempty      <= #D 1'b1              ;
        full        <= #D 1'b0              ;
        nfull       <= #D 1'b0              ;
    end
    else if (i_sclr)
    begin
        cnt         <= #D {nbits{1'b0}}     ;
        empty       <= #D 1'b1              ;
        nempty      <= #D 1'b1              ;
        full        <= #D 1'b0              ;
        nfull       <= #D 1'b0              ;
    end
    else
    begin
        cnt         <= #D cnt_next          ;
        empty       <= #D emp_next          ;
        nempty      <= #D nemp_next         ;
        full        <= #D full_next         ;
        nfull       <= #D nfull_next        ;
    end
end
always @ (*)
begin
    case({i_wr,i_rd})
    2'b01:
    begin
        cnt_next   = cnt == 0 ? 0 : cnt - 1;
        emp_next   = (cnt == 1)?1'b1:1'b0;
        nemp_next  = (cnt ==ne_dep)?1'b1:1'b0;
        nfull_next = (cnt ==depth-nf_dep)?1'b0:nfull;
        full_next  = 1'b0;
    end
    2'b10:
    begin
        cnt_next   = cnt == 4'hf ? 4'hf : cnt + 1;
        emp_next   = 1'b0;
        nemp_next  = (cnt ==ne_dep-1)?1'b0:nempty;
        nfull_next = (cnt ==depth-nf_dep-1)?1'b1:nfull;
        full_next  = cnt ==depth-1;
    end
    default:
    begin
        cnt_next   = cnt ;
        emp_next   = empty;
        nemp_next  = nempty;
        nfull_next = nfull;
        full_next  = full;
    end
    endcase
end
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        wp <= #D 0;
    else if(i_sclr)
        wp <= #D 0;
    else if(i_wr  )
    begin
        if(wp ==(depth-1))
            wp <= #D 0;
        else
            wp <= #D wp + 1;
    end
end
always @(posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        rp <= #D 0;
    else if(i_sclr)
        rp <= #D 0;
    else if(i_rd  )
    begin
        if(rp ==(depth-1))
            rp <= #D 0;
        else
            rp <= #D rp + 1;
    end
end
integer i;
always @ (posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
    for(i=0;i<depth;i=i+1)
    begin
        ram[i] <= #D 0;
    end
    else if (i_wr)
        ram[wp] <= #D i_data;
end

assign rp_next  = i_rd ? rp == depth -1 ? 0 : (rp+1) : rp;
assign ram_dout = ram[rp_next];
assign fifo_oe  = i_rd ? 1'b1 : i_wr & empty;
always @ (posedge i_clk or negedge i_rstn)
begin
    if(~i_rstn)
        o_data <= #D {width{1'b0}};
    else if(fifo_oe)
        o_data <= #D (empty|nempty&i_rd)? (i_wr?i_data:o_data) :ram_dout;
end
assign o_empty = empty;
assign o_cnt   = cnt  ;
endmodule
