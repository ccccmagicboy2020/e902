/**********************
 *
 * Module Name	: uart_rx.v
 * Function	: UART receiver
 *   
 *                Programmable baud rate
 *                Programmable pairty mode
 *                support both big_endian and little endian
 *
 * Author	: Ding Zhanru
 * Date		: 2007.06.08
 * Version	: 1.0
 *
 * Date		: 2008.05.08
 * Version	: 1.1
 * 		  change receive condition from rxd_in_fall to rxd_in,
 * 		  because the rxd_in_fall is only one cycle, sometimes it
 * 		  is not sampled in some special condition..
 * Date		: 2009.02.17
 * Version	: 1.2
 * 		  Adapt for baud rate difference 
 * version      : 1.3
 *                add fifo for read data buffer /by sn
 * Date         : 2021.04.11
 * *******************/
`timescale 1ns/100ps
module uart_rx(
	clk,
	reset_n,
	baud_rate_param,
	parity_en,
	parity_odd,
	parity_mode,
	stop_extra,
	stop_half,
	rx_rb8,
	big_endian,
	uart_disable,
	rx_error,
	rx_data_reg,
	rx_irq,
	rx_state,
	rxd_in,
        rdata_cnt,
        fifo_rd  ,
        fifo_clr     
);

//-----------Parameter
parameter	 D	= 1;

parameter RX_IDLE 	= 3'b000,
	  RX_START	= 3'b001,
	  RX_DATA	= 3'b010,
	  RX_PARITY 	= 3'b011,
	  RX_STOP	= 3'b100,
	  RX_ERROR	= 3'b101,
	  RX_EXTRA	= 3'b110;



//-----------IO
//global signals//
input		clk;
input		reset_n;
//control register//
input	[15: 0]	baud_rate_param;
input		parity_odd;
input		parity_en;
input		parity_mode;
input		stop_extra;
input		stop_half;
input		big_endian;
input		uart_disable;
output	[ 7: 0]	rx_data_reg;
output		rx_irq;
output	[ 2: 0]	rx_state;
output	[ 1: 0]	rx_error;
input		rxd_in;
output		rx_rb8;
output  [ 3: 0] rdata_cnt;
input           fifo_rd  ;
input           fifo_clr ;
//reg	[ 7: 0]	rx_data_reg;
reg	[ 7: 0]	ori_rx_data_reg;
//reg		rx_irq;
reg		ori_rx_irq;
reg	[ 2: 0]	rx_state;
reg	[ 1: 0]	rx_error;
//sn reg		rx_rb8;
reg		ori_rx_rb8;





//-----------Local
reg	[15: 0]	count;


reg	[ 2: 0] current_rxst;
reg	[ 2: 0] next_rxst;
reg	[ 2: 0] rx_cnt;

wire		count_max;
wire		count_quarter;
wire		count_eighth;
wire		count_half;
wire		count_upper;
wire		extra_upper;

reg		start_sample;
reg		parity_sample;
reg		stop_sample;
reg		extra_sample;
wire		parity_cal;
wire		parity_false;
wire		data_end;
wire		extra_end;

reg	[ 7: 0]	rx_shift_reg;
//reg		rxd_in_d;
//wire		rxd_in_fall;


wire		true_end;
wire		parity_error;
wire		stop_error;


wire		c_rx_idle;
wire		c_rx_start;
wire		c_rx_data;
wire		c_rx_parity;
wire		c_rx_stop;
wire		c_rx_error;
wire		c_rx_extra;
wire		n_rx_idle;
wire		n_rx_start;
wire		n_rx_data;
wire		n_rx_parity;
wire		n_rx_stop;
wire		n_rx_error;
wire		n_rx_extra;

wire	[15: 0]	param_q1;
wire	[15: 0]	param_q2;
wire	[15: 0]	param_q3;
//fifo signals
wire            fifo_wr ;
wire            fifo_rd ;
wire    [ 8: 0] fifo_idata;
wire    [ 8: 0] fifo_odata;
wire    [ 3: 0] fifo_cnt  ;
wire            fifo_empty;
//-----------Main code
//always @(posedge clk or negedge reset_n)
//if(!reset_n)
//  rxd_in_d		<= #D 1'b1;
//else
//  rxd_in_d		<= #D rxd_in;

//assign rxd_in_fall = ~rxd_in & rxd_in_d;

assign count_max     = (count== baud_rate_param    );
assign count_eighth  = (count==(baud_rate_param>>3));
assign count_quarter = (count==(baud_rate_param>>2));
assign count_half    = (count==(baud_rate_param>>1));
assign data_end      = c_rx_data ? (&rx_cnt && count_max) : 1'b0;
assign extra_end     = c_rx_extra ? (stop_half ? count_half : count_max) : 1'b0;

assign count_upper   = (count >= param_q3) & (!count_max);
assign extra_upper   = stop_half ? ((count >= param_q1) & (count < param_q2))
				 : count_upper;
assign param_q1	     = baud_rate_param >>2 ;
assign param_q2	     = baud_rate_param >>1 ;
assign param_q3	     = param_q1 + param_q2;

assign c_rx_idle	= (current_rxst==RX_IDLE  );
assign c_rx_start	= (current_rxst==RX_START );
assign c_rx_data	= (current_rxst==RX_DATA  );
assign c_rx_parity	= (current_rxst==RX_PARITY);
assign c_rx_stop	= (current_rxst==RX_STOP  );
assign c_rx_error	= (current_rxst==RX_ERROR );
assign c_rx_extra	= (current_rxst==RX_EXTRA );
assign n_rx_idle	= (   next_rxst==RX_IDLE  );
assign n_rx_start	= (   next_rxst==RX_START );
assign n_rx_data	= (   next_rxst==RX_DATA  );
assign n_rx_parity	= (   next_rxst==RX_PARITY);
assign n_rx_stop	= (   next_rxst==RX_STOP  );
assign n_rx_error	= (   next_rxst==RX_ERROR );
assign n_rx_extra	= (   next_rxst==RX_EXTRA );



//baud counter//

always @(posedge clk or negedge reset_n)
if(!reset_n)
  count			<= #D 16'h0;
else if(count_max)
  count			<= #D 16'h0;
else
  case(current_rxst)
    RX_IDLE   :	  count	<= #D 16'h0;
    RX_START  :	  count	<= #D count + 16'h1;
    RX_DATA   :	  count	<= #D count + 16'h1;
    RX_PARITY :	  count	<= #D count + 16'h1;
    RX_STOP   :	  count	<= #D count + 16'h1;
    RX_EXTRA  : if(count_half && stop_half)
	          count <= #D 16'h0;
		else
		  count <= #D count + 16'h1;
    RX_ERROR  :	  count	<= #D 16'h0;
    default   :	  count	<= #D 16'h0;
  endcase

//data receive counter//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_cnt		<= #D 3'h0;
else if(c_rx_idle)
  rx_cnt		<= #D 3'h0;
else if(c_rx_data && count_max)
  rx_cnt		<= #D rx_cnt + 3'h1;
  
//start 3 sample//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  start_sample		<= #D 1'b0;
else if(c_rx_idle)
  start_sample		<= #D 1'b0;
else if(c_rx_start && (count_eighth || count_quarter || count_half))
  start_sample		<= #D rxd_in;
  
//data shift//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_shift_reg		<= #D 8'h0;
else if(c_rx_idle)
  rx_shift_reg		<= #D 8'h0;
else if(c_rx_data && count_half)
  rx_shift_reg		<= big_endian ? {rx_shift_reg[6:0],rxd_in} 
  				      : {rxd_in,rx_shift_reg[7:1]};

assign parity_cal = (rx_shift_reg[0] ^ rx_shift_reg[1]) ^
		    (rx_shift_reg[2] ^ rx_shift_reg[3]) ^
		    (rx_shift_reg[4] ^ rx_shift_reg[5]) ^
		    (rx_shift_reg[6] ^ rx_shift_reg[7]) ;
//parity sample//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  parity_sample		<= #D 1'b0;
else if(c_rx_parity && count_half)
  parity_sample		<= #D rxd_in;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  //sn rx_rb8		<= #D 1'b0;
  ori_rx_rb8		<= #D 1'b0;
else if(c_rx_parity && count_max)
  //rx_rb8		<= #D parity_sample;
  ori_rx_rb8		<= #D parity_sample;

assign parity_false = parity_odd ? (parity_cal ^  parity_sample)
			         : (parity_cal ~^ parity_sample);
//stop sample//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  stop_sample		<= #D 1'b1;
else if(c_rx_idle)
  stop_sample		<= #D 1'b1;
else if(c_rx_stop && count_half)
  stop_sample		<= #D rxd_in;

	
//stop extra sample//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  extra_sample		<= #D 1'b1;
else if(c_rx_idle)
  extra_sample		<= #D 1'b1;
else if(c_rx_extra && stop_half && count_quarter)
  extra_sample		<= #D rxd_in;
else if(c_rx_extra && !stop_half && count_half)
  extra_sample		<= #D rxd_in;

//FSM//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  current_rxst		<= #D RX_IDLE;
else
  current_rxst		<= #D next_rxst;


//always @(current_rxst or rxd_in or uart_disable or parity_en or start_sample or stop_sample or data_end or parity_false or count_max or parity_mode or stop_extra or extra_end or extra_sample)
always @(current_rxst or rxd_in or uart_disable or parity_en or start_sample or stop_sample or data_end or parity_false or count_max or parity_mode or stop_extra or extra_end or extra_sample or count_upper or extra_upper)
case(current_rxst)
  RX_IDLE    :	
      if(rxd_in || uart_disable)
	  	  next_rxst = RX_IDLE;
		else
		  next_rxst = RX_START;
  RX_START   : 
      if (uart_disable)	
        next_rxst = RX_IDLE ;
      else if(start_sample)
	  	  next_rxst = RX_ERROR;
		else if(count_max)
		  next_rxst = RX_DATA;
	  	else 
		  next_rxst = RX_START;
  RX_DATA    :
      if (uart_disable)
        next_rxst = RX_IDLE;
      else if(!data_end)
	     next_rxst = RX_DATA;
		else if(parity_en)
	  	  next_rxst = RX_PARITY;
		else 
		  next_rxst = RX_STOP;
  RX_PARITY  :	
      if (uart_disable)
        next_rxst = RX_IDLE;
      else if(!count_max)
	  	  next_rxst = RX_PARITY;
		else if(parity_false && !parity_mode)
	  	  next_rxst =RX_ERROR;
		else
		  next_rxst = RX_STOP;
  RX_STOP    :
      if (uart_disable)
        next_rxst = RX_IDLE;
      else if(count_max)
	  	  next_rxst = ~stop_sample ? RX_ERROR : stop_extra ? RX_EXTRA : RX_IDLE;
		else if(count_upper)
		  next_rxst = rxd_in ? RX_STOP : stop_extra ? RX_ERROR : RX_IDLE;
	  	else
		  next_rxst = RX_STOP;
  RX_EXTRA   :
      if (uart_disable)
        next_rxst = RX_IDLE;
      else if(extra_end)
	  	  next_rxst = ~extra_sample ? RX_ERROR : RX_IDLE;
		else if(extra_upper)
		  next_rxst = rxd_in ? RX_EXTRA : RX_IDLE;
	  	else
		  next_rxst = RX_EXTRA;

	  /*
  RX_STOP    :	if(!count_max)
	  	  next_rxst = RX_STOP;
		else if(stop_sample)
	  	  next_rxst = stop_extra ? RX_EXTRA : RX_IDLE;
	  	else
	  	  next_rxst = RX_ERROR;
  RX_EXTRA   :  if(!extra_end)
	  	  next_rxst = RX_EXTRA;
		else if(extra_sample)
	          next_rxst = RX_IDLE;
	  	else
		  next_rxst = RX_ERROR;
	  */
  RX_ERROR   :	  next_rxst = RX_IDLE;
  default    :	  next_rxst = RX_IDLE;
endcase

assign parity_error = c_rx_parity & n_rx_error;
assign stop_error   = c_rx_stop   & n_rx_error;
assign true_end     = stop_extra ? (c_rx_extra & n_rx_idle)
                                 : (c_rx_stop  & n_rx_idle);

always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_state		<= #D RX_IDLE;
else
  rx_state		<= #D current_rxst;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  //sn rx_irq		<= #D 1'b0;
  ori_rx_irq		<= #D 1'b0;
else 
  //sn rx_irq		<= #D true_end;
  ori_rx_irq		<= #D true_end;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  //sn rx_data_reg		<= #D 8'h0;
  ori_rx_data_reg		<= #D 8'h0;
else if(true_end)
  //rx_data_reg		<= #D rx_shift_reg;
  ori_rx_data_reg		<= #D rx_shift_reg;


always @(posedge clk or negedge reset_n)
if(!reset_n)
  rx_error		<= #D 2'b00;
else if(true_end)
  rx_error		<= #D 2'b00;
else if(stop_error)
  rx_error		<= #D 2'b10;
else if(parity_error)
  rx_error		<= #D 2'b01;

syncfifo 
#(.width(9),
  .depth(16)
)
u_syncfifo(
    .i_clk     (clk       ),
    .i_rstn    (reset_n   ),
    .i_sclr    (fifo_clr  ),
    .i_rd      (fifo_rd   ),
    .i_wr      (fifo_wr   ),
    .i_data    (fifo_idata),
    .o_data    (fifo_odata),
    .o_cnt     (fifo_cnt  ),
    .o_nfull   (          ),
    .o_nempty  (          ),
    .o_full    (          ),
    .o_empty   (fifo_empty)  

);
assign fifo_wr = ori_rx_irq ;
assign fifo_idata = {ori_rx_rb8,ori_rx_data_reg};
assign rx_irq     = ~fifo_empty;
assign rx_rb8     = fifo_odata[8];
assign rx_data_reg= fifo_odata[7:0];
assign rdata_cnt  = fifo_cnt       ;
endmodule
