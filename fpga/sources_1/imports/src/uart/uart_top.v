/*******************************
 *
 * Module Name    : uart_top
 * Funtionc       : UART interface
 *
 * Author         : sn
 * Date           : 2020.12.10
 * Version        : 1.0
 *
 * ****************************/
module uart_top(
    pclk          ,
    prstn         ,
    paddr         ,
    pwrite        ,
    penable       ,
    psel          ,
    pwdata        ,
    prdata        ,
    pready        ,
    uart_rx       , //uart_rx 
    uart_tx       , //uart_tx
    uart_ri       , //tx_int
    uart_ti       , //rx_int
    ext_uart_en
);
input                   pclk        ;
input                   prstn       ;
input  [31:0]           paddr       ;
input                   pwrite      ;
input                   penable     ;
input                   psel        ;
input  [31:0]           pwdata      ;
output [31:0]           prdata      ;
output                  pready      ;
input                   uart_rx     ;
output                  uart_tx     ;
output                  uart_ri     ;
output                  uart_ti     ;
output                  ext_uart_en ;

wire                    reg_wr_n    ;
wire                    reg_cs_n    ;
wire                    reg_rd_n    ;
wire   [ 7:0]           reg_wdata   ;
wire   [ 7:0]           reg_rdata   ;
assign reg_wdata = pwdata[7:0]      ;
assign prdata    = {24'h0,reg_rdata};
assign reg_wr_n  = ~(psel & ~penable &  pwrite);
assign reg_rd_n  = ~(psel & ~penable & ~pwrite);
assign reg_cs_n  = ~(psel & ~penable          );
uart_intf u_uart_inst(
    .clk          (pclk          ),
    .reset_n      (prstn         ),
    .reg_addr     (paddr[15:0]   ),
    .reg_wr_n     (reg_wr_n      ),
    .reg_cs_n     (reg_cs_n      ),
    .reg_rd_n     (reg_rd_n      ),
    .reg_wdata    (reg_wdata     ),
    .reg_rdata    (reg_rdata     ),
    .rxd_in       (uart_rx       ),
    .txd_out      (uart_tx       ),
    .ri           (uart_ri       ),
    .ti           (uart_ti       ),
    .ext_uart_en  (ext_uart_en   )
);
assign pready = 1'b1;










endmodule
