/*******************************
 *
 * Module Name    : uart_intf
 * Funtionc       : UART interface
 *
 * Author         : Ding Zhanru
 *                  sn
 * Date           : 2007.06.08
 * Version        : 1.0
 *                  2020.12.10 version 1.1
 * ****************************/

module uart_intf(
    clk        ,
    reset_n        ,
    //cpu interface//
    reg_addr    ,
    reg_wr_n    ,
    reg_cs_n    ,
    reg_rd_n    ,
    reg_wdata   ,
    reg_rdata   ,
    rxd_in      ,
    txd_out     ,
    ri          ,
    ti          ,
    ext_uart_en   
);
parameter     D        = 1;

//register address map//
parameter    UART_CNF_ADDR    = 16'h0000,
             UART_PRT_ADDR    = 16'h0004,
             UART_RCV_ADDR    = 16'h0008,
             UART_TRS_ADDR    = 16'h000c,
             UART_INT_ADDR    = 16'h0010,
             UART_FSM_ADDR    = 16'h0014,
             UART_BRH_ADDR    = 16'h0018,
             UART_BRL_ADDR    = 16'h001c,
             UART_RDT_ADDR    = 16'h0020;





//-----------IO
//global signals//
input               clk        ;
input               reset_n    ;
//register map//
input    [15 :0]    reg_addr   ;    
input               reg_wr_n   ;
input               reg_cs_n   ;
input               reg_rd_n   ;
input    [ 7: 0]    reg_wdata  ;
output   [ 7: 0]    reg_rdata  ;

//rx tx//
input               rxd_in     ;
output              txd_out    ;
output              ext_uart_en;

wire                txd_out    ;
reg                 ext_uart_en;
reg      [ 7: 0]    reg_rdata  ;
//interrupt//
output              ri         ;
output              ti         ;


reg                 ri         ;
reg                 ti         ;


//-----------Local
reg    [ 3: 0]      baud_rate         ;
reg    [ 2: 0]      parity_ctrl       ;
reg                 big_endian        ;
reg                 rx_enable         ;
reg                 tx_enable         ;
reg    [15: 0]      baud_rate_param   ;
reg    [ 7: 0]      brh_ud            ;
reg    [ 7: 0]      brl_ud            ;
reg                 baud_rate_ud_en   ;



wire                rb8               ;
reg                 tb8               ;

wire                rx_disable        ;
wire                tx_disable        ;


wire                wr_cs             ;
wire                rd_cs             ;

wire                cnf_cs            ;
wire                rcv_cs            ;
wire                trs_cs            ;
wire                int_cs            ;
wire                prt_cs            ;
wire                fsm_cs            ;
wire                brh_cs            ;
wire                brl_cs            ;

reg                 tx_int_clear      ;
reg                 rx_int_clear      ;

reg                 trs_cs_d          ;
reg                 tx_ready          ;

reg                 stop_extra        ;
reg                 stop_half         ;

wire   [ 7: 0]      rx_data_reg       ;
reg    [ 7: 0]      tx_data_reg       ;

wire                tx_irq            ;
wire                rx_irq            ;

wire   [ 2: 0]      rx_state          ;
wire   [ 2: 0]      tx_state          ;


wire   [ 1: 0]      rx_error          ;
reg                 rxd_in_d1         ;
reg                 rxd_in_d2         ;

wire                uart_idle         ;
wire   [ 3: 0]      rdata_cnt         ;
reg                 fifo_rd           ;
reg                 fifo_clr          ;
//-----------Main code

assign wr_cs  = ~(reg_wr_n | reg_cs_n);
assign rd_cs  = ~(reg_rd_n | reg_cs_n);
assign cnf_cs = (reg_addr==UART_CNF_ADDR) & wr_cs;
assign prt_cs = (reg_addr==UART_PRT_ADDR) & wr_cs;
assign rcv_cs = (reg_addr==UART_RCV_ADDR) & wr_cs;
assign trs_cs = (reg_addr==UART_TRS_ADDR) & wr_cs;
assign int_cs = (reg_addr==UART_INT_ADDR) & wr_cs;
assign fsm_cs = (reg_addr==UART_FSM_ADDR) & wr_cs;
assign brh_cs = (reg_addr==UART_BRH_ADDR) & wr_cs;
assign brl_cs = (reg_addr==UART_BRL_ADDR) & wr_cs;
assign frd_cs = (reg_addr==UART_RDT_ADDR) & wr_cs;


assign uart_idle = (rx_state==3'h0) & (tx_state==3'h0);

//trigger once UART_TRA_ADDR is written//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  trs_cs_d    <= #D 1'b0;
else
  trs_cs_d    <= #D trs_cs;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_ready    <= #D 1'b0;
else if(!trs_cs && trs_cs_d)
  tx_ready    <= #D 1'b1;
else
  tx_ready    <= #D 1'b0;    

//buad rate table//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  baud_rate_param        <= #D 16'h341;//9600@8Mhz 19200@16Mhz
else if(baud_rate_ud_en)
  baud_rate_param        <= #D {brh_ud,brl_ud};

always @(posedge clk or negedge reset_n)
if(!reset_n)
  {rxd_in_d2,rxd_in_d1}        <= #D 2'b11;
else if (rx_disable)  
  {rxd_in_d2,rxd_in_d1}        <= #D 2'b11;
else
  {rxd_in_d2,rxd_in_d1}        <= #D {rxd_in_d1,rxd_in};

//register write/read//
//config//

always @(posedge clk or negedge reset_n)
if(!reset_n)
  baud_rate        <= #D 4'h4;
else if(cnf_cs)
  baud_rate        <= #D reg_wdata[3:0];

always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_enable        <= #D 1'b1;
else if(cnf_cs)
  tx_enable         <= #D reg_wdata[4];

always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_enable        <= #D 1'b1;
else if(cnf_cs)
  rx_enable         <= #D reg_wdata[5];

always @(posedge clk or negedge reset_n)
if(!reset_n)
  big_endian        <= #D 1'b0;
else if(cnf_cs)
  big_endian        <= #D reg_wdata[6];

always @(posedge clk or negedge reset_n)
if(!reset_n)
  baud_rate_ud_en    <= #D 1'b0;
else if(cnf_cs)
  baud_rate_ud_en    <= #D reg_wdata[7];
  
//PARITY & STOP//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  stop_extra        <= #D 1'b0;
else if(prt_cs)
  stop_extra        <= #D reg_wdata[7];
  
always @(posedge clk or negedge reset_n)
if(!reset_n)
  stop_half         <= #D 1'b0;
else if(prt_cs)
  stop_half         <= #D reg_wdata[6];


always @(posedge clk or negedge reset_n)
if(!reset_n)
  tb8            <= #D 1'b0;
else if(prt_cs)
  tb8            <= #D reg_wdata[4];

always @(posedge clk or negedge reset_n)
if(!reset_n)
  parity_ctrl        <= #D 3'h3;
else if(prt_cs)
  parity_ctrl        <= #D reg_wdata[2:0];

//Receiver//

    
//trasmitter//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_data_reg        <= #D 8'b0;
else if (tx_disable)    
  tx_data_reg        <= #D 8'b0; 
else if(trs_cs)
  tx_data_reg        <= #D reg_wdata;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_int_clear        <= #D 1'b0;
else if (int_cs)
  rx_int_clear        <= #D reg_wdata[3]; 
  
//interrupt//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  ri            <= #D 1'b0;
else if (rx_disable)  
  ri            <= #D 1'b0; 
else if(rx_irq)
  ri            <= #D 1'b1;   
else if(rx_int_clear)
  ri            <= 1'b0;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_int_clear        <= #D 1'b0;
else if (int_cs)
  tx_int_clear        <= #D reg_wdata[1]; 
  
always @(posedge clk or negedge reset_n)
if(!reset_n)
  ti            <= #D 1'b0;
else if (tx_disable)  
  ti            <= #D 1'b0;
else if (trs_cs & tx_int_clear)
  ti            <= #D 1'b0;    
else if(int_cs & (~tx_int_clear))
  ti            <= reg_wdata[0];
else if(tx_irq)
  ti            <= #D 1'b1;  

//user defined baud rate//
always @(posedge clk or negedge reset_n)
if(!reset_n)    
  brh_ud        <= #D 8'h75;
else if(brh_cs)
  brh_ud        <= #D reg_wdata;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  brl_ud        <= #D 8'h2F;
else if(brl_cs)
  brl_ud        <= #D reg_wdata;

//////////////////
always @(posedge clk or negedge reset_n)
if(!reset_n)
  ext_uart_en        <= #D 1'b1;
else 
  ext_uart_en        <= #D rx_enable | tx_enable;
always @(posedge clk or negedge reset_n)
if(!reset_n)
  fifo_rd        <= #D 1'b0;
else if(frd_cs)
  fifo_rd        <= #D reg_wdata[4];
else
  fifo_rd        <= #D 1'b0;
always @(posedge clk or negedge reset_n)
if(!reset_n)
  fifo_clr        <= #D 1'b0;
else if(frd_cs)
  fifo_clr        <= #D reg_wdata[5];
else
  fifo_clr        <= #D 1'b0;

//read interface//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  reg_rdata        <= #D 8'h0;
else if(rd_cs)
  case(reg_addr)
    UART_CNF_ADDR:    reg_rdata <= #D {baud_rate_ud_en,big_endian,rx_enable,tx_enable,baud_rate};
    UART_PRT_ADDR:    reg_rdata <= #D {stop_extra,stop_half,rb8,tb8,1'b0,parity_ctrl};
    UART_RCV_ADDR:    reg_rdata <= #D rx_data_reg;
    UART_TRS_ADDR:    reg_rdata <= #D tx_data_reg;
    UART_INT_ADDR:    reg_rdata <= #D {1'b0,rx_error,ri,rx_int_clear,1'b0,tx_int_clear,ti};
    UART_FSM_ADDR:    reg_rdata <= #D {1'b0,rx_state,1'b0,tx_state};
    UART_BRH_ADDR:    reg_rdata <= #D brh_ud;
    UART_BRL_ADDR:    reg_rdata <= #D brl_ud;
    UART_RDT_ADDR:    reg_rdata <= #D {4'b0,rdata_cnt};
    default     :    reg_rdata <= #D 8'h00;
  endcase



assign tx_disable = ~tx_enable;
assign rx_disable = ~rx_enable;

  //////
uart_tx u_uart_tx(
    .clk            (clk            ),
    .reset_n        (reset_n        ),
    .parity_en      (parity_ctrl[0] ),
    .parity_odd     (parity_ctrl[1] ),
    .parity_mode    (parity_ctrl[2] ),
    .stop_extra     (stop_extra     ),
    .stop_half      (stop_half      ),
    .baud_rate_param(baud_rate_param),
    .big_endian     (big_endian     ),
    .uart_disable   (tx_disable     ),
    .tx_data_reg    (tx_data_reg    ),
    .tx_tb8         (tb8            ),
    .tx_ready       (tx_ready       ),
    .tx_irq         (tx_irq         ),
    .tx_state       (tx_state       ),
    .txd_out        (txd_out        )
);


uart_rx u_uart_rx(
    .clk            (clk            ),
    .reset_n        (reset_n        ),
    .parity_en      (parity_ctrl[0] ),
    .parity_odd     (parity_ctrl[1] ),
    .parity_mode    (parity_ctrl[2] ),
    .stop_extra     (stop_extra     ),
    .stop_half      (stop_half      ),
    .big_endian     (big_endian     ),
    .uart_disable   (rx_disable     ),
    .baud_rate_param(baud_rate_param),
    .rx_data_reg    (rx_data_reg    ),
    .rx_rb8         (rb8            ),
    .rx_error       (rx_error       ),
    .rx_irq         (rx_irq         ),
    .rx_state       (rx_state       ),
    .rxd_in         (rxd_in_d2      ),
    .rdata_cnt      (rdata_cnt      ),
    .fifo_rd        (fifo_rd        ),
    .fifo_clr       (fifo_clr       )
);


endmodule
