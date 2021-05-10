/**********************
 *
 * Module Name	: uart_tx.v
 * Function	: UART transmitter 
 *  
 *                Programmable baud rate
 *                Programmable pairty mode
 *                support both big_endian and little endian
 *
 * Author	: Ding Zhanru
 * Date		: 2007.06.08
 * Version	: 1.0
 *
 * *******************/
`timescale 1ns/100ps
module uart_tx(
	clk,
	reset_n,
	baud_rate_param,
	parity_en,	
	parity_odd,	
	parity_mode,
	stop_extra,
	stop_half,
	tx_data_reg,
	tx_ready,
	tx_irq,
	tx_tb8,
	tx_state,
	txd_out,
	big_endian,
	uart_disable
);

//-----------Parameter
parameter D	= 1;

parameter TX_IDLE   = 3'b000,
	  TX_WAIT   = 3'b001,
	  TX_START  = 3'b010,
	  TX_DATA   = 3'b011,
	  TX_PARITY = 3'b100,
	  TX_STOP   = 3'b101,
	  TX_EXTRA  = 3'b110;



//-----------IO
//global signals//
input		clk;
input		reset_n;
//control register//
input	[15: 0]	baud_rate_param;
input		parity_en;
input		parity_odd;
input		parity_mode;
input		stop_extra;
input		stop_half;
input	[ 7: 0]	tx_data_reg;
input		tx_ready;
input		tx_tb8;
input		big_endian;
input		uart_disable;
output		tx_irq;
output	[ 2: 0]	tx_state;
output		txd_out;


reg		tx_irq;
reg	[ 2: 0]	tx_state;
reg		txd_out;

reg	[ 2: 0] current_txst;
reg 	[ 2: 0] next_txst;


//-----------Local
reg	[15: 0]	count;
reg	[ 2: 0] tx_cnt;

reg		parity_reg;
wire		parity;

wire		extra_end;
wire		data_end;

wire		count_max;
wire		count_half;
reg	[ 7: 0]	tx_shift_reg;

wire		true_end;
wire		c_tx_idle;
wire		c_tx_wait;
wire		c_tx_start;
wire		c_tx_data;
wire		c_tx_parity;
wire		c_tx_stop;
wire		c_tx_extra;
wire		n_tx_idle;
wire		n_tx_wait;
wire		n_tx_start;
wire		n_tx_data;
wire		n_tx_parity;
wire		n_tx_stop;
wire		n_tx_extra;

//-----------Main code
assign c_tx_idle   = (current_txst==TX_IDLE  );
assign c_tx_wait   = (current_txst==TX_WAIT  );
assign c_tx_start  = (current_txst==TX_START );
assign c_tx_data   = (current_txst==TX_DATA  );
assign c_tx_parity = (current_txst==TX_PARITY);
assign c_tx_stop   = (current_txst==TX_STOP  );
assign c_tx_extra  = (current_txst==TX_EXTRA );
assign n_tx_idle   = (   next_txst==TX_IDLE  );
assign n_tx_wait   = (   next_txst==TX_WAIT  );
assign n_tx_start  = (   next_txst==TX_START );
assign n_tx_data   = (   next_txst==TX_DATA  );
assign n_tx_parity = (   next_txst==TX_PARITY);
assign n_tx_stop   = (   next_txst==TX_STOP  );
assign n_tx_extra  = (   next_txst==TX_EXTRA );


assign extra_end   = c_tx_extra ? (stop_half ? count_half : count_max) : 1'b0;
assign data_end	   = c_tx_data ? ((&tx_cnt) & count_max) : 1'b0;

//counter bit of active data//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_cnt		<= #D 3'h0;
else if(c_tx_idle)
  tx_cnt		<= #D 3'h0;
else if(c_tx_data && count_max)
  tx_cnt		<= #D tx_cnt + 3'h1;

//counter sample within every bit//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  count			<= #D 16'h0;
else if(count_max)
  count			<= #D 16'h0;
else
  case(current_txst)
    TX_IDLE   :	count <= #D 16'h0;
    TX_WAIT   :	count <= #D 16'h0;
    TX_START  :	count <= #D count + 16'h1;
    TX_DATA   :	count <= #D count + 16'h1;
    TX_PARITY :	count <= #D count + 16'h1;
    TX_STOP   :	count <= #D count + 16'h1;
    TX_EXTRA  : if(stop_half && count_half)
	          count <= #D 16'h0;
		else
	          count <= count + 16'h1;
    default   :	count <= #D 16'h0;
  endcase
  
assign count_max  = (count==baud_rate_param);
assign count_half = (count==(baud_rate_param>>1));


//FSM//
always @(posedge clk or negedge reset_n)
if(!reset_n)
  current_txst		<= #D TX_IDLE;
else
  current_txst		<= #D next_txst;

always @(tx_ready or current_txst or uart_disable or parity_en or count_max or data_end or stop_extra or extra_end)
case(current_txst)
  TX_IDLE    :	if(tx_ready && !uart_disable)
	  	  next_txst = TX_WAIT;
		else
		  next_txst = TX_IDLE;
  TX_WAIT    :	  
      if (uart_disable)
        next_txst = TX_IDLE;
      else
        next_txst = TX_START;
  TX_START   :	
      if (uart_disable)
        next_txst = TX_IDLE;
      else if(count_max)
	     next_txst = TX_DATA;
		else
		  next_txst = TX_START;
  TX_DATA    :	
      if (uart_disable)
        next_txst = TX_IDLE;
      else if(!data_end)
	  	  next_txst = TX_DATA;
		else if(parity_en)
	     next_txst = TX_PARITY;
	  	else
		  next_txst = TX_STOP;
  TX_PARITY  :	
      if (uart_disable)
        next_txst = TX_IDLE;
      else if(count_max)
	     next_txst = TX_STOP;
		else
		  next_txst = TX_PARITY;
  TX_STOP    :	
      if (uart_disable)
        next_txst = TX_IDLE;
      else if(count_max)
	  	  next_txst = stop_extra ? TX_EXTRA : TX_IDLE;
	   else
		  next_txst = TX_STOP;
  TX_EXTRA   :
      if (uart_disable)
        next_txst = TX_IDLE;
      else if(extra_end)
	     next_txst = TX_IDLE;
	  	else
		  next_txst = TX_EXTRA;
  default    :	  next_txst = TX_IDLE;
endcase


always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_state		<= #D TX_IDLE;
else
  tx_state		<= #D current_txst;

/////////////////
always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_shift_reg		<= #D 8'h0;
else if(c_tx_wait)
  tx_shift_reg		<= #D tx_data_reg;
else if(c_tx_data && count_max)
  tx_shift_reg		<= #D big_endian ? {tx_shift_reg[6:0],tx_shift_reg[7  ]} 
  					 : {tx_shift_reg[  0],tx_shift_reg[7:1]};

assign parity = (tx_shift_reg[0] ^ tx_shift_reg[1]) ^
		(tx_shift_reg[2] ^ tx_shift_reg[3]) ^
		(tx_shift_reg[4] ^ tx_shift_reg[5]) ^
		(tx_shift_reg[6] ^ tx_shift_reg[7]) ;

always @(posedge clk or negedge reset_n)
if(!reset_n)
  parity_reg		<= #D 1'b0;
else if(parity_odd)
  parity_reg		<= #D parity;
else
  parity_reg		<= #D ~parity;


always @(posedge clk or negedge reset_n)
if(!reset_n)
  txd_out		<= #D 1'b1;
else
  case(current_txst)
    TX_IDLE   :	txd_out <= #D 1'b1;
    TX_WAIT   :	txd_out	<= #D 1'b1;
    TX_START  :	txd_out	<= #D 1'b0;
    TX_DATA   :	txd_out	<= #D big_endian ? tx_shift_reg[7] : tx_shift_reg[0];
    TX_PARITY :	txd_out	<= #D parity_mode ? tx_tb8 : parity_reg;
    TX_STOP   :	txd_out	<= #D 1'b1;
    TX_EXTRA  : txd_out	<= #D 1'b1;
    default   :	txd_out	<= #D 1'b1;
  endcase

assign true_end = stop_extra ? (c_tx_extra & n_tx_idle)
                             : (c_tx_stop  & n_tx_idle);

always @(posedge clk or negedge reset_n)
if(!reset_n)
  tx_irq		<= #D 1'b0;
else
  tx_irq		<= #D true_end;


endmodule
