
module apbreg_iic_slave(
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
    slaveb_addr          ,
    slaveb_data          ,
    slave_rw_o           ,
    slave_addrb          ,
    slave_stopb          ,
    slave_nackb          ,
    slave_rw             ,
    //output ports   
    slavedev             ,
    en_slaveb            ,
    slaveb_data_2_iic    ,
    msk_slb_addr         ,
    msk_slb_stop         ,
    msk_slb_nack         ,
    msk_slb_rw           ,  
    rel_slb_int          ,
    rel_slb_addr         ,
    rel_slb_stop         ,
    rel_slb_nack         ,
    rel_slb_rw        
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
    input    [15: 8]    slaveb_addr             ;
    input    [ 7: 0]    slaveb_data             ;
    input               slave_rw_o              ;
    input               slave_addrb             ;
    input               slave_stopb             ;
    input               slave_nackb             ;
    input               slave_rw                ;
    //output ports   
    output   [ 7: 0]    slavedev                ;
    output              en_slaveb               ;
    output   [ 7: 0]    slaveb_data_2_iic       ;
    output              msk_slb_addr            ;
    output              msk_slb_stop            ;
    output              msk_slb_nack            ;
    output              msk_slb_rw              ;
    output              rel_slb_int             ;
    output              rel_slb_addr            ;
    output              rel_slb_stop            ;
    output              rel_slb_nack            ;
    output              rel_slb_rw              ;

    reg      [ 7: 0]    slavedev                ;
    reg                 en_slaveb               ;
    reg      [ 7: 0]    slaveb_data_2_iic       ;
    reg                 msk_slb_addr            ;
    reg                 msk_slb_stop            ;
    reg                 msk_slb_nack            ;
    reg                 msk_slb_rw              ;
    reg                 rel_slb_int             ;
    reg                 rel_slb_addr            ;
    reg                 rel_slb_stop            ;
    reg                 rel_slb_nack            ;
    reg                 rel_slb_rw              ;

always @ (posedge pclk or negedge prstn)           
begin                                              
    if(~prstn)                                     
    begin                                          
        slavedev                  <= #D  8'haa          ;
        en_slaveb                 <= #D  1'h1           ;
        slaveb_data_2_iic         <= #D  8'h0           ;
        msk_slb_addr              <= #D  1'h0           ;
        msk_slb_stop              <= #D  1'h0           ;
        msk_slb_nack              <= #D  1'h0           ;
        msk_slb_rw                <= #D  1'h0           ;
        rel_slb_int               <= #D  1'h0           ;
        rel_slb_addr              <= #D  1'h0           ;
        rel_slb_stop              <= #D  1'h0           ;
        rel_slb_nack              <= #D  1'h0           ;
        rel_slb_rw                <= #D  1'h0           ;
    end                                            
    else                                           
    begin                                          
        slavedev                  <= #D (psel & pwrite & ~penable & paddr == 'h00) ? pwdata[7:0]       : slavedev                ;
        en_slaveb                 <= #D (psel & pwrite & ~penable & paddr == 'h04) ? pwdata[0]         : en_slaveb               ;
        slaveb_data_2_iic         <= #D (psel & pwrite & ~penable & paddr == 'h0c) ? pwdata[7:0]       : slaveb_data_2_iic       ;
        msk_slb_addr              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[11]        : msk_slb_addr            ;
        msk_slb_stop              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[10]        : msk_slb_stop            ;
        msk_slb_nack              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[9]         : msk_slb_nack            ;
        msk_slb_rw                <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[8]         : msk_slb_rw              ;
        rel_slb_int               <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[4]         : 1'b0                    ;        
        rel_slb_addr              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[3]         : 1'b0                    ;
        rel_slb_stop              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[2]         : 1'b0                    ;
        rel_slb_nack              <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[1]         : 1'b0                    ;
        rel_slb_rw                <= #D (psel & pwrite & ~penable & paddr == 'h14) ? pwdata[0]         : 1'b0                    ;
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
       'h00   : prdata_wire = {24'h0, slavedev }                                                                ;
       'h04   : prdata_wire = {31'h0, en_slaveb }                                                               ;
       'h08   : prdata_wire = {24'h0, slaveb_addr, slaveb_data }                                                ;
       'h0c   : prdata_wire = {24'h0, slaveb_data_2_iic }                                                       ;
       'h10   : prdata_wire = {27'h0, slave_rw_o, slave_addrb, slave_stopb, slave_nackb, slave_rw}         ;
       'h14   : prdata_wire = {20'h0, msk_slb_addr, msk_slb_stop, msk_slb_nack, msk_slb_rw, 3'h0, rel_slb_int, rel_slb_addr, rel_slb_stop, rel_slb_nack, rel_slb_rw};
        default:prdata_wire = 32'h0;               
    endcase                                        
end                                                
assign pready = 1'b1 ;
endmodule
