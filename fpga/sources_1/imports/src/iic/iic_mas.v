//------------------------------------------------------------------------
// Huaya Microelectronics, Inc Confidential
// File		: iic_mas.v
// Module	: iic_mas
// Function	: IIC Master
// Create	: 2001/12/08, Zhao Chunxiao
// Parent Module: iic_pro
//------------------------------------------------------------------------
// Revision history:
// 2002/01/24	: Zhaocx	: Nack at last read byte
// 2004/03/25	: Wang lixiang	: to remove counterdriver pin notice.
// 			to remove the chance of the master/slave at the meantime driver the SDA pad
// 			Although both drive it to 1'b0.
// 2004/01/19	: Chenli	: Add the Re_start state in read commend 
// 2004/07/29	: Wang lixiang	: Regular the reset scheme to standard asynchronous scheme.
// 2008/11/28	: Ji Yuping	: Modify for supporting clock streching;
//------------------------------------------------------------------------

module iic_master(
	reset_n			,
	clk			, 
	clk_ref			, 
	//cpu register
	slave_addr		,
	nword			, 
	cpu_command		, 
	cpu_time_out		,//added by yupingji, 20081120;
	cpu_clk_str_en		,//added by yupingji, 20081120;
        cpu_last_ack_en         ,
	mast_read_addr		,
	data_8032_2_iicm	, 
	data_iicm_2_8032	,
	cpu_info		, 
	mast_iic_rw1		, 
	mast_iic_rw2		, 
	mast_no_act		,
	master_stop		, 
	master_nack		,
        master_rw_done          ,
	stretch_time_out	,
        rel_mst_rw		,
	rel_mst_stop		, 
	rel_mst_nack		, 
	rel_time_out		, 
        data_num                ,
	//iic bus
	scl			,
	scl_in			, 
	sda_oe			, 
	sda_out			, 
	sda_in
	);

//------------------------------------------------------------------------
input 		reset_n			;
input 		clk			;
input 		clk_ref			;
output 		mast_no_act		;
input 	[ 7: 0] slave_addr		;
input 	[ 7: 0] nword			;
input 	[ 3: 0] cpu_command		;
input 	[15: 0] cpu_time_out		;//added by yupingji, 20081120;
input 		cpu_clk_str_en		;//added by yupingji, 20081120;
input           cpu_last_ack_en         ;
input	[15: 0]	mast_read_addr		;
input 	[ 7: 0] data_8032_2_iicm	;
output 	[ 7: 0] data_iicm_2_8032	;
output  [ 7: 0] data_num                ;
output 		cpu_info		;
output 		mast_iic_rw1		;
output 		mast_iic_rw2		;
output 		master_stop		;
output 		master_nack		;
output 		master_rw_done		;
output		stretch_time_out	;//added by yupingji, 20081120;
input 		rel_mst_rw		;
input 		rel_mst_stop		;
input 		rel_mst_nack		;
input 		rel_time_out		;
output 		scl			;
input 		scl_in			;
output 		sda_oe			;
output 		sda_out			;
input 		sda_in			;

reg		scl			;
reg		sda_oe			;
reg		sda_out			;
wire		mast_no_act		;
reg	[ 7: 0] data_iicm_2_8032	;
reg		cpu_info		;
wire		mast_iic_rw1		;
wire		mast_iic_rw2		;
reg		master_stop		;
wire		master_nack		;
reg             master_rw_done          ;
reg		stretch_time_out	;//added by yupingji, 20081120;
//------------------------------------------------------------------------
parameter	D 		= 1	;
parameter	IDLE		= 4'h0	;
parameter	START		= 4'h1	;
parameter	START_NEXT	= 4'h2	;
parameter	SLAVE_ADDR	= 4'h3	;
parameter	READ		= 4'h4	;
parameter	WRITE		= 4'h5	;
parameter	STOP		= 4'h6	;
parameter	STOP_NEXT	= 4'h7	;
parameter	RESTART 	= 4'h8	;
//------------------------------------------------------------------------
reg		clk_ref_d1		;
reg		clk_ref_d2		;

wire		clk_fall		;
wire		clk_rise		;
reg		clk_rise_dly0		;

reg	[ 3: 0]	c_state			;
reg	[ 3: 0]	n_state			;
reg		st_idle			;
reg		st_start		;
reg		st_start_next		;
reg		st_slave_addr		;
reg		st_read			;
reg		st_write		;
reg		st_stop			;
reg		st_stop_next		;
reg		st_restart		;
wire		hold_count		;
reg	[15: 0]	stretch_cnt		;//added by yupingji, 20081120;
reg	[ 1: 0]	count			;
reg	[ 3: 0]	bit_count		;
wire		shift_carry		;
wire	[ 2: 0]	shift_bit		;
reg	[ 7: 0]	data_num		;
reg	[ 1: 0]	addr_num		;
reg             data_vld                ;
reg		nack_is			;
reg		read_ready		;
wire		iic_r_en		;
reg		end_byte		;
wire		last_bit		;//added by yupingji, 20081112;

wire		mast_iic_trans		;

wire	[ 7: 0] slave_addr_out		;

reg	[ 7: 0] data_read		;

//------------------------------------------------------------------------
always @(posedge clk or negedge reset_n)
      if (!reset_n) begin
	    clk_ref_d1 	<=#D 1'b0;
	    clk_ref_d2 	<=#D 1'b0;
      end
      else begin
	    clk_ref_d1 	<=#D clk_ref;
	    clk_ref_d2 	<=#D clk_ref_d1;
      end

assign clk_rise	= clk_ref_d1 & ~clk_ref_d2;
assign clk_fall	= ~clk_ref_d1 & clk_ref_d2;

always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    clk_rise_dly0	<=#D 1'b0;
      else
	    clk_rise_dly0 	<=#D clk_rise;

assign master_nack	= nack_is;
assign iic_r_en		= st_read | st_stop;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    read_ready 	<=#D 1'b0;
      else if (st_idle || st_stop) 
	    read_ready 	<=#D 1'b0;
      else if (st_write && cpu_command[1] && (!cpu_command[3] || cpu_command[3] && (addr_num == 2'h1))) 
	    read_ready 	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    addr_num	<=#D 2'h0;
      else if (st_idle) 
	    addr_num	<=#D 2'h0;
      else if (clk_rise && st_write && end_byte && cpu_command[3]) 
	    addr_num	<=#D addr_num + 2'h1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    master_stop <=#D 1'b0;
      else if (st_stop_next) 
	    master_stop <=#D 1'b1;
      else if (rel_mst_stop) 
	    master_stop <=#D 1'b0;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    master_rw_done<=#D 1'b0;
      else if (data_vld)
	    master_rw_done<=#D 1'b1;
      else if (rel_mst_rw)
            master_rw_done<=#D 1'b0;

assign mast_iic_trans	= st_slave_addr | st_read | st_write ;
assign mast_iic_rw1	= (data_num <= nword) & last_bit & 
			mast_iic_trans & (count == 2'h1) & (cpu_command[1:0] == 2'b01 | iic_r_en & cpu_command[1]);
assign mast_iic_rw2	= (data_num <= nword) & last_bit & 
			mast_iic_trans & (count == 2'h2) & (cpu_command[1:0] == 2'b01 | iic_r_en & cpu_command[1]);

assign hold_count	= cpu_clk_str_en ? scl & ~scl_in : 1'b0;//20081120;
//added by yupingji 20081120 begin
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    stretch_cnt<=#D 16'h0;
      else if (!hold_count)
	    stretch_cnt<=#D 16'h0;
      else if (clk_rise)
	    stretch_cnt<=#D stretch_cnt + 16'h1;

always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    stretch_time_out<=#D 1'b0;
      else if (rel_time_out||!cpu_clk_str_en||(cpu_time_out==16'h0))
	    stretch_time_out<=#D 1'b0;
      else if (stretch_cnt == cpu_time_out)
	    stretch_time_out<=#D 1'b1;
//end
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    count	<=#D 2'h0;
      else if (st_idle) 
	    count	<=#D 2'h0;
      //else if (clk_fall) 
      else if (!hold_count && clk_fall) 
	    count	<=#D count + 2'h1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    bit_count	<=#D 4'h0;
      else if (st_idle || st_start || st_start_next) 
	    bit_count	<=#D 4'h0;
      else if (clk_rise && (count == 2'h3)) 
	    bit_count	<=#D (last_bit)
      				? 4'h0
				: bit_count + 4'h1;

assign last_bit = (bit_count == 4'h8);
assign {shift_carry,shift_bit} = 4'h7 - bit_count;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    end_byte	<=#D 1'b0;
      else if (clk_rise) 
	    end_byte	<=#D (last_bit & (count == 2'h2));

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    scl	<=#D 1'b1;
      else if (st_idle) 
	    scl	<=#D 1'b1;
      else if (st_start) 
	    scl	<=#D 1'b1;
      else if (clk_rise && (count > 2'h0) && st_restart) 
	    scl	<=#D 1'b1;
      else if (st_start_next) 
	    scl	<=#D 1'b0;
      else if (clk_rise && st_stop && (count==2'h1)) 
	    scl	<=#D 1'b1;
      else if (st_stop_next) 
	    scl	<=#D 1'b1;
      else if (clk_rise && (count > 2'h0) && (count < 2'h3)) 
	    scl	<=#D 1'b1;
      else if (clk_rise)
	    scl	<=#D 1'b0;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    sda_oe	<=#D 1'b1;
      else if (st_idle) 
	    sda_oe	<=#D 1'b1;
      else if (clk_rise && st_stop) 
	    sda_oe	<=#D 1'b1;
      else if (clk_rise_dly0 && st_read && (bit_count < 4'h8)) 
	    sda_oe	<=#D 1'b0;
      //else if (clk_rise && last_bit)
      else if (clk_rise_dly0 && last_bit)  
	    sda_oe	<=#D st_read & (data_num <= nword);//wlx modify counterdriver pad.
      else if (clk_rise && !st_read && (bit_count < 4'h8) ) 
	    sda_oe	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    data_num	<=#D 8'h0;
      else if (st_idle || st_restart) 
	    data_num	<=#D 8'h0;
      else if (clk_rise && st_read && end_byte) 
	    data_num	<=#D data_num + 8'h1;
      else if (clk_rise && st_write && end_byte) 
	    data_num	<=#D data_num + 8'h1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    data_vld	<=#D 1'b0;
      else 
	    data_vld	<=#D clk_rise && end_byte && (st_write | st_read);

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    nack_is	<=#D 1'b0;
      else if (st_read) 
	    nack_is	<=#D 1'b0;
      else if (!sda_oe && scl && last_bit && (count == 2'h2)) 
	    nack_is	<=#D sda_in;
      else if (rel_mst_nack && (count == 2'h0) && (bit_count == 4'h0)) 
	    nack_is	<=#D 1'b0;

assign slave_addr_out	= read_ready || !cpu_command[0]
				? {slave_addr[7:1],1'b1}
				: {slave_addr[7:1],1'b0};

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    data_iicm_2_8032	<=#D 8'h0;
      else if (clk_rise && st_read && (bit_count == 4'h7) && (count == 2'h3)) 
	    data_iicm_2_8032	<=#D data_read;

always @(posedge clk or negedge reset_n)
      if (!reset_n) begin
	    sda_out	<=#D 1'b1;
	    data_read	<=#D 8'h0;
      end
      else if (clk_rise) begin
	    if (st_idle) begin
		  sda_out 	<=#D 1'b1;
		  data_read 	<=#D data_read;
	    end
	    else if (st_start) begin
		  sda_out 	<=#D 1'b0;
		  data_read 	<=#D data_read;
	    end
	    else if (st_start_next) begin
		  sda_out 	<=#D 1'b0;
		  data_read 	<=#D data_read;
	    end
	    else if (st_slave_addr) begin
		  data_read 	<=#D data_read;
		  if (bit_count < 4'h8)
			sda_out 	<=#D slave_addr_out[shift_bit];
		  else
			sda_out 	<=#D 1'b0;
	    end
	    else if (st_read) begin
		  if ((bit_count < 4'h8) && (count == 2'h2))
			data_read[shift_bit] <=#D sda_in;
		  else
			data_read	<=#D data_read;
		  if (last_bit) 
			sda_out		<=#D ~cpu_last_ack_en & (data_num == nword);
		  else 
			sda_out 	<=#D 1'b0;
	    end
	    else if (st_write) begin
		  data_read		<=#D data_read;
		  if (bit_count < 4'h8)
			sda_out 	<=#D !cpu_command[2]
						? data_8032_2_iicm[shift_bit]
						: (addr_num==2'h0)
							? mast_read_addr[shift_bit] 
							: mast_read_addr[15-bit_count[2:0]];
		  else 
			sda_out 	<=#D 1'b0;
	    end
	    else if (st_stop) begin
		  data_read 	<=#D data_read;
		  sda_out 	<=#D 1'b0;
	    end
	    else if (st_stop_next) begin
		  data_read 	<=#D data_read;
		  sda_out 	<=#D 1'b1;
	    end
	    else if (st_restart) begin
		  data_read 	<=#D data_read;
		  if (count==2'h0) 
			sda_out 	<=#D 1'b1;
		  else 
			sda_out 	<=#D sda_out;
	    end
	    else begin
		  data_read 	<=#D data_read;
		  sda_out 	<=#D 1'b1;
	    end
      end

always @(posedge clk or negedge reset_n)
begin : seq_iic_state
      if (!reset_n) 
	    c_state	<=#D IDLE;
      else if (clk_rise)
	    c_state	<=#D n_state;
end

always @(c_state or cpu_command or count or end_byte or nack_is or read_ready or data_num or nword)
begin : comb_iic_state
	st_idle		=	1'b0;
	st_start	=	1'b0;
	st_start_next	=	1'b0;
	st_slave_addr	=	1'b0;
	st_read		=	1'b0;
	st_write	=	1'b0;
	st_stop		=	1'b0;
	st_stop_next	=	1'b0;
	st_restart	=	1'b0;
	case(c_state)
	      	IDLE		:
		begin
		      st_idle		= 1'b1;
		      n_state		= (cpu_command != 4'h0)
					? START
					: IDLE;
		end
		START		:
		begin
		      st_start		= 1'b1;
		      n_state	 	= (count == 2'h2)
		  			? START_NEXT
					: START;
		end
		START_NEXT	:
		begin
		      st_start_next	= 1'b1;
		      n_state		= (count == 2'h3)
					? SLAVE_ADDR
					: START_NEXT;
		end
		SLAVE_ADDR	:
		begin
		      st_slave_addr	= 1'b1;
		      n_state		= end_byte
					? (nack_is
						? STOP
						: ((read_ready || !cpu_command[0])
							? READ
							: WRITE))
  					: SLAVE_ADDR;
		end
		READ		:
		begin
		      st_read		= 1'b1;
		      n_state		= end_byte
					? ((data_num == nword)
						? STOP
						: READ)
					: READ;
		end
		WRITE		:
		begin
		      st_write		= 1'b1;
		      n_state		= end_byte
					? (nack_is
						? STOP
						: (read_ready
							? RESTART
							: ((data_num == nword)
								? STOP
								: WRITE)))
					: WRITE;
		end
		STOP		:
		begin
		      st_stop		= 1'b1;
		      n_state		= (count == 2'h2)
					? STOP_NEXT
					: STOP;
		end
		STOP_NEXT	:
		begin
		      st_stop_next	= 1'b1;
		      n_state		= (count == 2'h0)
					? IDLE
					: STOP_NEXT;
		end
		RESTART		:
		begin
		      st_restart	= 1'b1;
		      n_state	 	= (count == 2'h3)
					? START
					: RESTART;
		end
		default		:
		      n_state 		= IDLE;
	  endcase
end

assign mast_no_act	= st_idle;

//output to reg_f8.v, reset cpu_command to 0;
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    cpu_info	<=#D 1'b0;
      else if (st_stop && (cpu_command != 4'h0) && (count < 2'h3)) 
	    cpu_info	<=#D 1'b1;
      else 
	    cpu_info	<=#D 1'b0;

endmodule
