
module ir (
    //signals to apb bus
    pclk        ,   
    presetn     ,   
    penable     ,    
    psel        ,   
    pwrite      ,   
    paddr       ,   
    pwdata      ,   
    prdata      ,   
    pready      ,   
    ir_int      ,   //interrupt 
    sin	            //serial input
    );
input                  pclk       ;
input                  presetn    ;
input                  penable    ;
input                  psel       ;
input                  pwrite     ;
input  [23:0]          paddr      ;
input  [31:0]          pwdata     ;
output [31:0]          prdata     ;
output                 pready     ;
output                 ir_int     ;
(*keep="true"*)(*mark_debug="true"*)input                  sin        ;    

wire   [31:0]          ir_data    ;
wire                   ir_cmp_err ;
wire                   ir_repeat  ;

wire                   rf_data_cmp_en  ;
wire                   rf_addr_cmp_en  ;
wire                   rf_ir_phase     ;
wire                   rf_cmp_clr      ;
wire                   rf_int_clr      ;
wire   [ 7: 0]         rf_niose_th     ;
wire   [12: 0]         rf_edge_th      ;
wire   [17: 0]         rf_9ms_cnt      ;
wire   [17: 0]         rf_4p5_cnt      ;
wire   [17: 0]         rf_1p69_cnt     ;
wire   [17: 0]         rf_2p25_cnt     ;




ir_rx u_ir_rx(
    .clk           (pclk          ),
    .rstn          (presetn       ),
    .sin           (sin           ),
    .ir_int        (ir_int        ),
    .ir_data       (ir_data       ),
    .ir_repeat     (ir_repeat     ),
    .ir_cmp_err    (ir_cmp_err    ),
    .rf_addr_cmp_en(rf_addr_cmp_en),
    .rf_data_cmp_en(rf_data_cmp_en),
    .rf_cmp_clr    (rf_cmp_clr    ),
    .ir_int_clr    (rf_int_clr    ),
    .rf_ir_phase   (rf_ir_phase   ),
    .rf_noise_th   (rf_niose_th   ),
    .rf_edge_th    (rf_edge_th    ),
    .rf_9ms_cnt    (rf_9ms_cnt    ),
    .rf_4p5_cnt    (rf_4p5_cnt    ),
    //.rf_0p56_cnt   ('d15000 ),
    .rf_1p69_cnt   (rf_1p69_cnt   ),
    .rf_2p25_cnt   (rf_2p25_cnt   ) 
);
apbreg_ir u_ir_apbreg(
    .pclk                 (pclk                 ),
    .prstn                (presetn              ),
    .psel                 (psel                 ),
    .penable              (penable              ),
    .pwrite               (pwrite               ),
    .paddr                (paddr                ),
    .pwdata               (pwdata               ),
    .prdata               (prdata               ),
    .pready               (pready               ),
    //input ports    
    .ir_cmp_err           (ir_cmp_err           ),
    .ir_repeat            (ir_repeat            ),
    .ir_int               (ir_int               ),
    .ir_data              (ir_data              ),
    //output ports   
    .rf_data_cmp_en       (rf_data_cmp_en       ),
    .rf_addr_cmp_en       (rf_addr_cmp_en       ),
    .rf_ir_phase          (rf_ir_phase          ),
    .rf_cmp_clr           (rf_cmp_clr           ),
    .rf_int_clr           (rf_int_clr           ),
    .rf_niose_th          (rf_niose_th          ),
    .rf_edge_th           (rf_edge_th           ),
    .rf_9ms_cnt           (rf_9ms_cnt           ),
    .rf_4p5_cnt           (rf_4p5_cnt           ),
    .rf_1p69_cnt          (rf_1p69_cnt          ),
    .rf_2p25_cnt          (rf_2p25_cnt          ) 
);



    




endmodule 

