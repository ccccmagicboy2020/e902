
module apbreg_iic_master(
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
    iicm_2_data0         ,
    iicm_2_data1         ,
    master_rw_done        ,
    mast_no_act          ,
    master_timeout       ,
    master_nstop         ,
    master_nack          ,
    data_num             ,
    //output ports   
    slave_addr           ,
    nword                ,
    cpu_cmd_w            ,
    cpu_cmd              ,
    cpu_time_out         ,
    cpu_clk_str_en       ,
    cpu_last_ack_en      ,
    mast_read_addr       ,
    data_2_iicm0         ,
    data_2_iicm1         ,
    master_rw_int_en     ,
    master_timeout_en    ,
    master_nstop_en      ,
    master_nack_en       ,
    rel_mst_rw           ,
    rel_time_out         ,
    rel_mst_stop         ,
    rel_mst_nack         ,
    clk_div_cnt          ,
    clk_en                
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
    input    [31: 0]    iicm_2_data0            ;
    input    [31: 0]    iicm_2_data1            ;
    input               master_rw_done            ;
    input               mast_no_act             ;
    input               master_timeout          ;
    input               master_nstop            ;
    input               master_nack             ;
    input    [ 7:0]     data_num                ;        
    //output ports   
    output   [ 7: 0]    slave_addr              ;
    output   [ 7: 0]    nword                   ;
    output              cpu_cmd_w               ;
    output   [ 3: 0]    cpu_cmd                 ;
    output   [15: 0]    cpu_time_out            ;
    output              cpu_clk_str_en          ;
    output              cpu_last_ack_en         ;
    output   [15: 0]    mast_read_addr          ;
    output   [31: 0]    data_2_iicm0            ;
    output   [31: 0]    data_2_iicm1            ;
    output              master_rw_int_en        ;
    output              master_timeout_en       ;
    output              master_nstop_en         ;
    output              master_nack_en          ;
    output              rel_mst_rw              ;
    output              rel_time_out            ;
    output              rel_mst_stop            ;
    output              rel_mst_nack            ;
    output   [15: 0]    clk_div_cnt             ;
    output              clk_en                  ;
    reg      [ 7: 0]    slave_addr              ;
    reg      [ 7: 0]    nword                   ;
    reg                 cpu_cmd_w               ;
    reg      [ 3: 0]    cpu_cmd                 ;
    reg      [15: 0]    cpu_time_out            ;
    reg                 cpu_clk_str_en          ;
    reg                 cpu_last_ack_en         ;
    reg      [15: 0]    mast_read_addr          ;
    reg      [31: 0]    data_2_iicm0            ;
    reg      [31: 0]    data_2_iicm1            ;
    reg                 master_rw_int_en        ;
    reg                 master_timeout_en       ;
    reg                 master_nstop_en         ;
    reg                 master_nack_en          ;
    reg                 rel_mst_rw              ; 
    reg                 rel_time_out            ;
    reg                 rel_mst_stop            ;
    reg                 rel_mst_nack            ;
    reg      [15: 0]    clk_div_cnt             ;
    reg                 clk_en                  ;
always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
    begin                                          
        slave_addr                <= #D  8'hf           ;
        nword                     <= #D  8'hf           ;
        cpu_cmd_w                 <= #D  1'h0           ;
        cpu_cmd                   <= #D  4'h0           ;
        cpu_time_out              <= #D 16'h0           ;
        cpu_clk_str_en            <= #D  1'h0           ;
        cpu_last_ack_en           <= #D  1'b0           ;
        mast_read_addr            <= #D 16'hf           ;
        data_2_iicm0              <= #D 32'h0           ;
        data_2_iicm1              <= #D 32'h0           ;
        master_rw_int_en          <= #D  1'h0           ;
        master_timeout_en         <= #D  1'h0           ;
        master_nstop_en           <= #D  1'h0           ;
        master_nack_en            <= #D  1'h0           ;
        rel_mst_rw                <= #D  1'b0           ;
        rel_time_out              <= #D  1'h0           ;
        rel_mst_stop              <= #D  1'h0           ;
        rel_mst_nack              <= #D  1'h0           ;
        clk_div_cnt               <= #D 16'h10          ;
        clk_en                    <= #D  1'h0           ;
    end                                            
    else                                           
    begin                                          
        slave_addr                <= #D (psel & pwrite & ~penable & paddr == 'h00) ? pwdata[7:0]       : slave_addr              ;
        nword                     <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[7:0]       : nword                   ;
        cpu_cmd_w                 <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[4]         : 'h0                     ;//wc
        cpu_cmd                   <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[3:0]       : cpu_cmd                 ;
        cpu_time_out              <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[15:0]      : cpu_time_out            ;
        cpu_clk_str_en            <= #D (psel & pwrite & ~penable & paddr == 'h10) ? pwdata[0]         : cpu_clk_str_en          ;
        cpu_last_ack_en           <= #D (psel & pwrite & ~penable & paddr == 'h10) ? pwdata[1]         : cpu_last_ack_en         ;
        mast_read_addr            <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[15:0]      : mast_read_addr          ;
        data_2_iicm0              <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[31:0]      : data_2_iicm0            ;
        data_2_iicm1              <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[31:0]      : data_2_iicm1            ;
        master_rw_int_en          <= #D (psel & pwrite & ~penable & paddr == 'h2c) ? pwdata[3]         : master_rw_int_en        ;
        master_timeout_en         <= #D (psel & pwrite & ~penable & paddr == 'h2c) ? pwdata[2]         : master_timeout_en       ;
        master_nstop_en           <= #D (psel & pwrite & ~penable & paddr == 'h2c) ? pwdata[1]         : master_nstop_en         ;
        master_nack_en            <= #D (psel & pwrite & ~penable & paddr == 'h2c) ? pwdata[0]         : master_nack_en          ;
        rel_mst_rw                <= #D (psel & pwrite & ~penable & paddr == 'h30) ? pwdata[3]         : 1'b0                    ;
        rel_time_out              <= #D (psel & pwrite & ~penable & paddr == 'h30) ? pwdata[2]         : 1'b0                    ;
        rel_mst_stop              <= #D (psel & pwrite & ~penable & paddr == 'h30) ? pwdata[1]         : 1'b0                    ;
        rel_mst_nack              <= #D (psel & pwrite & ~penable & paddr == 'h30) ? pwdata[0]         : 1'b0                    ;
        clk_div_cnt               <= #D (psel & pwrite & ~penable & paddr == 'h34) ? pwdata[15:0]      : clk_div_cnt             ;
        clk_en                    <= #D (psel & pwrite & ~penable & paddr == 'h38) ? pwdata[0]         : clk_en                  ;
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
       'h00   : prdata_wire = {24'h0, slave_addr }                                                              ;
       'h04   : prdata_wire = {24'h0, nword }                                                                   ;
       'h08   : prdata_wire = {27'h0, cpu_cmd_w, cpu_cmd }                                                      ;
       'h0c   : prdata_wire = {16'h0, cpu_time_out }                                                            ;
       'h10   : prdata_wire = {30'h0, cpu_last_ack_en,cpu_clk_str_en }                                                          ;
       'h14   : prdata_wire = {16'h0, mast_read_addr }                                                          ;
       'h18   : prdata_wire =  data_2_iicm0                                                                     ;
       'h1c   : prdata_wire =  data_2_iicm1                                                                     ;
       'h20   : prdata_wire =  iicm_2_data0                                                                     ;
       'h24   : prdata_wire =  iicm_2_data1                                                                     ;
       'h28   : prdata_wire = {16'h0, data_num,3'h0,master_rw_done,mast_no_act, master_timeout, master_nstop, master_nack }                  ;
       'h2c   : prdata_wire = {28'h0, master_rw_int_en,master_timeout_en, master_nstop_en, master_nack_en }                      ;
       'h30   : prdata_wire = {28'h0, rel_mst_rw,rel_time_out, rel_mst_stop, rel_mst_nack }                                ;
       'h34   : prdata_wire = {16'h0, clk_div_cnt }                                                             ;
       'h38   : prdata_wire = {31'h0, clk_en }                                                                  ;
        default:prdata_wire = 32'h0;               
    endcase                                        
end                                                
assign pready = 1'b1 ;
endmodule
