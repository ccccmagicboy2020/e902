module iic_slave_wrap(
    pclk                 ,
    prstn                ,
    psel                 ,
    penable              ,
    pwrite               ,
    paddr                ,
    pwdata               ,
    prdata               ,
    pready               ,
    cpu_sda_out          ,
    slave_sda_oe         ,
    cpu_scl_in           ,
    sda_data_in          ,
    slave_rw_int             
);
    input               pclk               ;
    input               prstn              ;
    input               psel               ;
    input               penable            ;
    input               pwrite             ;
    input  [23: 0]      paddr              ;
    input  [31: 0]      pwdata             ;
    output [31: 0]      prdata             ;
    output              pready             ;

    output              cpu_sda_out        ;
    output              slave_sda_oe       ;
    input               cpu_scl_in         ;
    input               sda_data_in        ;
    output              slave_rw_int       ;

    wire    [ 7: 0]    slaveb_data             ;
    wire    [ 7: 0]    slaveb_addr             ;
    wire               slave_rw_o              ;
    wire               slave_addrb             ;
    wire               slave_stopb             ;
    wire               slave_nackb             ;
    wire               slave_rw                ;
    //output ports   
    wire    [ 7: 0]    slavedev                ;
    wire               en_slaveb               ;
    wire    [ 7: 0]    slaveb_data_2_iic       ;
    wire               msk_slb_addr         ;
    wire               msk_slb_stop         ;
    wire               msk_slb_nack         ;
    wire               msk_slb_rw           ; 
    wire               rel_slb_int          ;
    wire               rel_slb_addr            ;
    wire               rel_slb_stop            ;
    wire               rel_slb_nack            ;
    wire               rel_slb_rw              ;

apbreg_iic_slave u_apbreg_iic_slave(
    .pclk                 (pclk                 ),
    .prstn                (prstn                ),
    .psel                 (psel                 ),
    .penable              (penable              ),
    .pwrite               (pwrite               ),
    .paddr                (paddr                ),
    .pwdata               (pwdata               ),
    .prdata               (prdata               ),
    .pready               (pready               ),
    //input ports          
    .slaveb_data          (slaveb_data          ),
    .slaveb_addr          (slaveb_addr          ),
    .slave_rw_o           (slave_rw_o           ),
    .slave_addrb          (slave_addrb          ),
    .slave_stopb          (slave_stopb          ),
    .slave_nackb          (slave_nackb          ),
    .slave_rw             (slave_rw             ),
    //output ports         
    .slavedev             (slavedev             ),
    .en_slaveb            (en_slaveb            ),
    .slaveb_data_2_iic    (slaveb_data_2_iic    ),
    .msk_slb_addr         (msk_slb_addr         ),
    .msk_slb_stop         (msk_slb_stop         ),
    .msk_slb_nack         (msk_slb_nack         ),
    .msk_slb_rw           (msk_slb_rw           ), 
    .rel_slb_int          (rel_slb_int          ),
    .rel_slb_addr         (rel_slb_addr         ),
    .rel_slb_stop         (rel_slb_stop         ),
    .rel_slb_nack         (rel_slb_nack         ),
    .rel_slb_rw           (rel_slb_rw           ) 
);
iic_slave u_iic_slave(
    .clk                  (pclk               ),
    .reset_n              (prstn              ), 
    .cpu_sda_out          (cpu_sda_out        ), 
    .cpu_scl_in           (cpu_scl_in         ), 
    .sda_data_in          (sda_data_in        ), 
    .slave_sda_oe         (slave_sda_oe       ),
    //slaveB signals         
    .slave_addrb_sta      (slave_addrb        ),
    .slave_stopb_sta      (slave_stopb        ), 
    .slave_nackb_sta      (slave_nackb        ), 
    .slavedev             (slavedev[7:1]      ), 
    .en_slavb             (en_slaveb          ),
    .slave_rw_sta         (slave_rw           ),
    .slaveb_int           (slave_rw_int       ),
    .slaveb_data          (slaveb_data        ), 
    .slaveb_addr          (slaveb_addr        ), 
    .slaveb_data_2_iic    (slaveb_data_2_iic  ),
    .slave_rw_o           (slave_rw_o         ),// slave_rw_o: slave rd/wr flag
    .msk_slb_addr         (msk_slb_addr       ),
    .msk_slb_stop         (msk_slb_stop       ),
    .msk_slb_nack         (msk_slb_nack       ),
    .msk_slb_rw           (msk_slb_rw         ), 
    .rel_slb_int          (rel_slb_int        ),
    .rel_slb_rw           (rel_slb_rw         ),
    .rel_slb_addr         (rel_slb_addr       ),
    .rel_slb_stop         (rel_slb_stop       ),
    .rel_slb_nack         (rel_slb_nack       )
    );
endmodule
