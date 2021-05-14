
module apbreg_ir(
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
    ir_cmp_err           ,
    ir_repeat            ,
    ir_int               ,
    ir_data              ,
    //output ports   
    rf_data_cmp_en       ,
    rf_addr_cmp_en       ,
    rf_ir_phase          ,
    rf_cmp_clr           ,
    rf_int_clr           ,
    rf_niose_th          ,
    rf_edge_th           ,
    rf_9ms_cnt           ,
    rf_4p5_cnt           ,
    rf_1p69_cnt          ,
    rf_2p25_cnt           
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
    input               ir_cmp_err              ;
    input               ir_repeat               ;
    input               ir_int                  ;
    input    [31: 0]    ir_data                 ;
    //output ports   
    output              rf_data_cmp_en          ;
    output              rf_addr_cmp_en          ;
    output              rf_ir_phase             ;
    output              rf_cmp_clr              ;
    output              rf_int_clr              ;
    output   [ 7: 0]    rf_niose_th             ;
    output   [12: 0]    rf_edge_th              ;
    output   [17: 0]    rf_9ms_cnt              ;
    output   [17: 0]    rf_4p5_cnt              ;
    output   [17: 0]    rf_1p69_cnt             ;
    output   [17: 0]    rf_2p25_cnt             ;
    reg                 rf_data_cmp_en          ;
    reg                 rf_addr_cmp_en          ;
    reg                 rf_ir_phase             ;
    reg                 rf_cmp_clr              ;
    reg                 rf_int_clr              ;
    reg      [ 7: 0]    rf_niose_th             ;
    reg      [12: 0]    rf_edge_th              ;
    reg      [17: 0]    rf_9ms_cnt              ;
    reg      [17: 0]    rf_4p5_cnt              ;
    reg      [17: 0]    rf_1p69_cnt             ;
    reg      [17: 0]    rf_2p25_cnt             ;
always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
    begin                                          
        rf_data_cmp_en            <= #D  1'h0           ;
        rf_addr_cmp_en            <= #D  1'h0           ;
        rf_ir_phase               <= #D  1'h1           ;
        rf_cmp_clr                <= #D  1'h0           ;
        rf_int_clr                <= #D  1'h1           ;
        rf_niose_th               <= #D  8'h5           ;
        rf_edge_th                <= #D 13'h1f4         ;
        rf_9ms_cnt                <= #D 18'h222e0       ;
        rf_4p5_cnt                <= #D 18'h11170       ;
        rf_1p69_cnt               <= #D 18'h3a98        ;
        rf_2p25_cnt               <= #D 18'h84d0        ;
    end                                            
    else                                           
    begin                                          
        rf_data_cmp_en            <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[2]         : rf_data_cmp_en          ;
        rf_addr_cmp_en            <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[1]         : rf_addr_cmp_en          ;
        rf_ir_phase               <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[0]         : rf_ir_phase             ;
        rf_cmp_clr                <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[1]         : 'h0                     ;//wc
        rf_int_clr                <= #D (psel & pwrite & ~penable & paddr == 'h08) ? pwdata[0]         : 'h0                     ;//wc
        rf_niose_th               <= #D (psel & pwrite & ~penable & paddr == 'h10) ? pwdata[7:0]       : rf_niose_th             ;
        rf_edge_th                <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[12:0]      : rf_edge_th              ;
        rf_9ms_cnt                <= #D (psel & pwrite & ~penable & paddr == 'h18) ? pwdata[17:0]      : rf_9ms_cnt              ;
        rf_4p5_cnt                <= #D (psel & pwrite & ~penable & paddr == 'h1c) ? pwdata[17:0]      : rf_4p5_cnt              ;
        rf_1p69_cnt               <= #D (psel & pwrite & ~penable & paddr == 'h20) ? pwdata[17:0]      : rf_1p69_cnt             ;
        rf_2p25_cnt               <= #D (psel & pwrite & ~penable & paddr == 'h24) ? pwdata[17:0]      : rf_2p25_cnt             ;
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
       'h00   : prdata_wire = {29'h0, ir_cmp_err, ir_repeat, ir_int }                                           ;
       'h04   : prdata_wire = {29'h0, rf_data_cmp_en, rf_addr_cmp_en, rf_ir_phase }                             ;
       'h08   : prdata_wire = {30'h0, rf_cmp_clr, rf_int_clr }                                                  ;
       'h0c   : prdata_wire =  ir_data                                                                          ;
       'h10   : prdata_wire = {24'h0, rf_niose_th }                                                             ;
       'h14   : prdata_wire = {19'h0, rf_edge_th }                                                              ;
       'h18   : prdata_wire = {14'h0, rf_9ms_cnt }                                                              ;
       'h1c   : prdata_wire = {14'h0, rf_4p5_cnt }                                                              ;
       'h20   : prdata_wire = {14'h0, rf_1p69_cnt }                                                             ;
       'h24   : prdata_wire = {14'h0, rf_2p25_cnt }                                                             ;
        default:prdata_wire = 32'h0;               
    endcase                                        
end                                                
assign pready = 1'b1 ;
endmodule
