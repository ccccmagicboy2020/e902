//------------------------------------------------------------------------
// Huaya Microelectronics, Inc Confidential
// File		: iic_slave.v
// Module	: iic_slave
// Function	: iic slave 
// Create	: 2001, Liu Xinghe
// Parent Module: iic_pro
//------------------------------------------------------------------------
// Revision history:
// 2001/11/28	: zhao chunxiao:  
// 2001/12/20	: Zhao Chunxiao: tw code update
// 2002/02/01	: zhao chunxiao: sda_oe, ddc addr update ,slv_rd/wr flag
// 		: change slave_addr INT to sub address INT
// 		: remove neg/pos glitch on scl and sda
// 2002/02/08	: zhao chunxiao: prog YE pulse change from 25us to 35 us
// 2002/02/21	: zhao cx : sync prog YE pulse to 200k clock,change flwr_r
// 		: from 7bits to 6bits to meet 35us
// 2002/06/19	: zhaocx : add prog puls control
// 2002/06/26	: zhaocx : fix ddc addresss Error
// 2002/07/17	: zhaocx : fix ISP READ Error
// 2002/10/18	: zhaocx : fix nack Error
// 2002/12/01	: zhaocx : add secure protect bit(use info mem address 00H)
// 2003/02/19	: tangyf : copy from zhaocx's sm602a
// 2003/03/03	: tangyf : check with zhaocx
// 2003/03/12	: tangyf : fix start and stop set condition
// ================================================================
// 2004/03/17	: wanglx : modify it for external flashROM ISP mode.
// *In this version, for the fashROM's capacity have enlarged(e.g.:1Mbyte per chip),
//  so the address for ISP must be 3 bytes long!
// *In this version, actually ISP_CMD/isp config cmd is used to transfer SR write data
// *In all the cases that SR's content isnot sure, SW should write SR to enable
//  flash writable before the mass/sector erase command is issued.
// *****The SW should follow the following steps to excute a correct ISP procedure
// 1) *Issue a ISP_CMD/ISP configure cmd to write/read or verify SR register
// 2) *Issue program cmd and  verify the flashROM data areas. 
// 3) *After the cases that ISP program/verification success, SW can write to SR once more
//  to protect flash from mis_erase.
// 4) *At last SW should issue ISP reset command to wake up the whole chip.
//
// 2004/07/14	: wlx
// When IICM RDSR in write procedure, we must feedback to BUSY==1'b1; 
// asctually we feedback with 8'hFF to IICM. Refer to line 1486.
// 2004/07/20	: wlx
// remove neg/pos glitch on scl and sda, when sys_clock become to 40-66Mhz, from 12Mhz in 007!.
// 2004/07/29	: wlx
// Regular all the FFs conforms the rule of aynchronous reset scheme.
// 2004/08/05	: wlx
// Modify the slaveB reset generate logic for SW in 009. Old slaveb_int issue  redundant int when address int issue.
// 2008.08/21	: Remove ISP control by yupingji ;
// ===================================================================
// Design notes
// *flash mode, used to reset all other module, when
// 1.chip_str trigger sec_bit_read, 
// 2.fnt sec_bit_read,
// 3.isp. in 007.
// In 009, no sec_bit no str_read yet, so use flash_mode_reg as flag.  //wlx comments
// *While ISP_RW_LENGTH
// In this implementation, ISP_RW_LENGTH is tightened to 0(In dtfh module, reset to 0, 
// When ISP : flashROM fetch/write a byte can be complete in 9 SCL cycle
// The first byte read out should be obseleted.  So when read SR, we can read twice
// if we didnot get the right SR data from the first byte read out.
//------------------------------------------------------------------------
//`define DDC
module iic_slave(
	clk			,
	reset_n			, 
	cpu_sda_out		, 
	cpu_scl_in		, 
	sda_data_in		, 
	slave_sda_oe		,
	//slaveB signals
	slave_addrb_sta		,
	slave_stopb_sta		, 
	slave_nackb_sta		, 
	slavedev		, 
	en_slavb		,
	slave_rw_sta		,
        slaveb_int              ,
	slaveb_addr		, 
	slaveb_data		, 
	slaveb_data_2_iic	,
	slave_rw_o		,// slave_rw_o: slave rd/wr flag
	msk_slb_rw		,
	msk_slb_addr		,
	msk_slb_stop		,
	msk_slb_nack            ,
        rel_slb_int             ,
	rel_slb_rw		,
	rel_slb_addr		,
	rel_slb_stop		,
	rel_slb_nack
	`ifdef DDC
	,
	//ddc signals
	ddc_addr_o		,
	ddc_addr		,
	ddc_rw_int		,
	ddc_addr_int		, 
	ddc_stop_int		, 
	ddc_nack_int		,
	rel_ddc_rw_out		, 
	rel_ddc_addr_out	, 
	rel_ddc_stop_out	, 
	rel_ddc_nack_out	,
	ddc_data_2_iic		, 
	ddc_ram_read		, 
	en_ddc_reg
  	`endif
	);

//-----------------------------------------------------------------------
input 		clk			;
input 		reset_n			;
output 		cpu_sda_out		;
output 		slave_sda_oe		;
input 		cpu_scl_in		;
input 		sda_data_in		;
// slaveB.
input 	[6:0] 	slavedev		;
input 		en_slavb		;
output 	[7:0] 	slaveb_data		;
output 	[7:0] 	slaveb_addr		;
input 	[7:0] 	slaveb_data_2_iic	;
output 		slave_addrb_sta		;
output 		slave_stopb_sta		;
output 		slave_nackb_sta		;
output 		slave_rw_sta		;
output 		slaveb_int		;
output 		slave_rw_o		;
input 		rel_slb_int		;
input 		rel_slb_rw		;
input 		rel_slb_addr		;
input 		rel_slb_stop		;
input 		rel_slb_nack		;
input 		msk_slb_rw		;
input 		msk_slb_addr		;
input 		msk_slb_stop		;
input 		msk_slb_nack		;

`ifdef DDC
// ddc signals
output 	[ 7: 0] ddc_addr_o		;
input 	[ 7: 0] ddc_addr		;
input 	[ 7: 0] ddc_data_2_iic		;
output       	ddc_ram_read		;
output	     	ddc_rw_int		;
output       	ddc_addr_int		;
output       	ddc_stop_int		;
output       	ddc_nack_int		;
input        	rel_ddc_rw_out		;
input        	rel_ddc_addr_out	;
input        	rel_ddc_stop_out	;
input        	rel_ddc_nack_out	;
input        	en_ddc_reg		;
`endif

//-----------------------------------------------------------------------
parameter	D 		= 1	;
parameter	CI2C_IDLE    	= 3'b000;
parameter	CI2C_DEV	= 3'b001;
parameter	CI2C_WADDR	= 3'b011;
parameter	CI2C_WDT	= 3'b010;
parameter	CI2C_RDT	= 3'b101;
//-----------------------------------------------------------------------
reg  		sda_out			;
reg		scl_rise		;
reg		scl_fall		;
reg		sda_rise		;
reg		sda_fall		;
reg	[ 3: 0] bit_cnt			;
reg	[ 3: 0]	bit_dcnt		;
reg	[ 7: 0]	sda_data		;
reg	[ 2: 0] state			;

wire 		cpu_sda_out		;
wire 		end_byte		;

reg		scl_sync1		;
reg		scl_sync2		;
reg		scl_in			;
reg		scl_d1			;
reg		sda_sync1		;
reg		sda_sync2		;
reg		sda_in			;
reg		sda_d1			;

`ifdef DDC
wire 		ddc_match		;
wire 		en_ddc			;
reg		ddc_rw_int		;
reg		ddc_addr_int		;
reg		ddc_stop_int		;
reg		ddc_nack_int		;
reg		enable_ddc		;

wire 		read_end		;
wire		ddc_ram_read		;
wire		ddc_addr_read		;
wire		ddc_read		;
reg	[ 7: 0] ddc_addr_o		;

`endif

wire 		slv_match		;
wire 		en_slave		;

wire 		start			;
wire 		stop			;
wire 		end_byte_state		;

reg 		cpu_ack_in		;
reg 		specialdev		;

reg 		slave_addrb		;
reg 		slave_addrb_sta		;
reg 		slave_stopb_sta		;
reg 		slave_nackb_sta		;
reg 		slave_rw_sta		;
reg 		slaveb_int		;
reg 		slave_rw		;
reg		enable_slaveb		;
reg		slave_rw_o		; //1: slave read: 0 slave_write
wire            int_src                 ;

reg	[ 7: 0] slaveb_data		;
reg	[ 7: 0] slaveb_addr		;

reg	[ 7: 0] data_2_iic_buf		;
reg		iic_out_data		;
reg		slave_sda_oe		;

wire 		iic_bit_carry		;
wire [2:0]	iic_bit_cnt		;
//-----------------------------------------------------------------------
assign cpu_sda_out = sda_out;

always @(posedge clk or negedge reset_n)
      if (!reset_n) begin
	    scl_sync1 	<=#D 1'b1;
	    scl_sync2 	<=#D 1'b1;
	    scl_in	<=#D 1'b1;
	    scl_d1	<=#D 1'b1;
	    scl_rise  	<=#D 1'b0;
	    scl_fall  	<=#D 1'b0;
      end
      else begin
	    scl_sync1 	<=#D cpu_scl_in;
	    scl_sync2	<=#D scl_sync1;
	    scl_in	<=#D scl_sync2;
	    scl_d1	<=#D scl_in;
	    scl_rise 	<=#D ( scl_in & ~scl_d1);
	    scl_fall 	<=#D (~scl_in &  scl_d1);
      end

always @(posedge clk or negedge reset_n)
      if (!reset_n) begin
	    sda_sync1 	<=#D 1'b1;
	    sda_sync2 	<=#D 1'b1;
	    sda_in	<=#D 1'b1;
	    sda_d1	<=#D 1'b1;
	    sda_rise  	<=#D 1'b0;
	    sda_fall  	<=#D 1'b0;
      end
      else begin
	    sda_sync1 	<=#D sda_data_in;
	    sda_sync2	<=#D sda_sync1;
	    sda_in	<=#D sda_sync2;
	    sda_d1	<=#D sda_in;
	    sda_rise 	<=#D ( sda_in & ~sda_d1);
	    sda_fall 	<=#D (~sda_in &  sda_d1);
      end

//device matching 
assign slv_match	= (sda_data[7:1] == slavedev) & en_slavb;
assign en_slave		= (state == CI2C_DEV) & slv_match;

`ifdef DDC
assign ddc_match	= (sda_data[7:1] == ddc_addr[7:1]) & en_ddc_reg;
assign en_ddc		= (state == CI2C_DEV) & ddc_match;
`endif

assign start		= scl_d1 & sda_fall;
assign stop		= scl_d1 & sda_rise & (state != CI2C_IDLE);

assign end_byte		= scl_rise & (bit_dcnt == 4'h9);
assign end_byte_state	= scl_fall & (bit_dcnt == 4'h9);

always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    specialdev	<=#D 1'b0;
      else if (scl_fall && (state == CI2C_DEV) && (bit_dcnt == 4'h8)) 
	    `ifdef DDC
	    specialdev	<=#D (slv_match || (ddc_match && en_ddc_reg)); 
      `else
	    specialdev	<=#D slv_match; 
      `endif
      else if (state != CI2C_DEV) 
	    specialdev	<=#D 1'b0;

// bit counter
always @( posedge clk or negedge reset_n)
      if (!reset_n)
	    bit_cnt	<=#D 4'h0;
      else if ((state ==CI2C_IDLE) || start)
	    bit_cnt	<=#D 4'h0;
      else if (scl_fall)
	    bit_cnt	<=#D (bit_cnt == 4'h9) ? 4'h1 : (bit_cnt + 4'h1);

//The IIC operator		
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    bit_dcnt	<=#D 4'h0;
      else
	    bit_dcnt	<=#D bit_cnt;

//slaveb----------------------------------------------------------------------
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    enable_slaveb	<=#D 1'b0;
      else if (stop || (state == CI2C_IDLE)||start) 
	    enable_slaveb	<=#D 1'b0;
      else if (en_slave && end_byte) 
	    enable_slaveb	<=#D 1'b1;

//slave_addrb int : interrupt when iic sub address is received
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_addrb	<=#D 1'b0;
      else if ((state == CI2C_WADDR) && enable_slaveb && end_byte_state) 
	    slave_addrb	<=#D 1'b1;
      else 
	    slave_addrb	<=#D 1'b0;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_addrb_sta	<=#D 1'b0;
      else if (msk_slb_addr | rel_slb_addr) 
	    slave_addrb_sta	<=#D 1'b0;
      else if ((state == CI2C_WADDR) && enable_slaveb && end_byte_state) 
	    slave_addrb_sta	<=#D 1'b1;// int at end of fall

//slave rd/wr flag
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_rw_o	<=#D 1'b1;
      else if (en_slave && end_byte) 
	    slave_rw_o	<=#D sda_data[0];

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_stopb_sta<=#D 1'b0;
      else if (msk_slb_stop) 
	    slave_stopb_sta<=#D 1'b0;
      else if (stop && enable_slaveb) 
	    slave_stopb_sta<=#D 1'b1;
      else if (rel_slb_stop) 
	    slave_stopb_sta<=#D 1'b0;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_nackb_sta<=#D 1'b0;
      else if (msk_slb_nack | rel_slb_nack) 
	    slave_nackb_sta<=#D 1'b0;
      else if ((state == CI2C_RDT) && end_byte_state && cpu_ack_in && enable_slaveb) 
	    slave_nackb_sta<=#D 1'b1;

//wlx modify for 009, register address enlarge to 16 bits
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_rw_sta<=#D 1'b0;
      else if (msk_slb_rw | rel_slb_rw) 
	    slave_rw_sta	<=#D 1'b0;
      else if ((state == CI2C_WDT ||state == CI2C_RDT) && enable_slaveb && end_byte_state)
	    slave_rw_sta	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_rw	<=#D 1'b0;
      else if ((state == CI2C_WDT ||state == CI2C_RDT) && enable_slaveb && end_byte_state)
	    slave_rw	<=#D 1'b1;
      else 
            slave_rw	<=#D 1'b0;

assign int_src = (~msk_slb_addr & (state == CI2C_WADDR) & enable_slaveb & end_byte_state) | 
                 (~msk_slb_nack & (state == CI2C_RDT)   & enable_slaveb & end_byte_state & cpu_ack_in) |
                 (~msk_slb_rw   & (state == CI2C_WDT ||state == CI2C_RDT) & enable_slaveb & end_byte_state) |
                 (~msk_slb_stop & stop & enable_slaveb);

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slaveb_int	<=#D 1'b0;
      else if (rel_slb_int)
	    slaveb_int	<=#D 1'b0;
      else if (int_src)
            slaveb_int	<=#D 1'b1;

`ifdef DDC
//interrupt for ddc
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    enable_ddc	<=#D 1'b0;
      else if (state == CI2C_IDLE||stop) 
	    enable_ddc	<=#D 1'b0;
      else if (en_ddc && end_byte) 
	    enable_ddc	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    ddc_addr_int	<=#D 1'b0;
      else if (rel_ddc_addr_out) 
	    ddc_addr_int	<=#D 1'b0;
      else if ((state == CI2C_DEV) && en_ddc && end_byte_state) 
	    ddc_addr_int	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    ddc_stop_int	<=#D 1'b0;
      else if (stop && enable_ddc) 
	    ddc_stop_int	<=#D 1'b1;
      else if (rel_ddc_stop_out) 
	    ddc_stop_int	<=#D 1'b0;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    ddc_nack_int	<=#D 1'b0;
      else if (rel_ddc_nack_out) 
	    ddc_nack_int	<=#D 1'b0;
      else if ((state == CI2C_RDT) && end_byte_state && cpu_ack_in && enable_ddc) 
	    ddc_nack_int	<=#D 1'b1;

always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    ddc_rw_int	<=#D 1'b0;
      else if (rel_ddc_rw_out) 
	    ddc_rw_int	<=#D 1'b0;
      else if (((state == CI2C_WADDR) || (state == CI2C_WDT) || (state == CI2C_RDT)) && enable_ddc && end_byte_state) 
	    ddc_rw_int	<=#D 1'b1;

//ddc Read write control signals
assign read_end		= scl_fall & (bit_dcnt == 4'h8);
assign ddc_addr_read	= read_end & en_ddc;
assign ddc_read		= end_byte & enable_ddc;
assign ddc_ram_read	= (ddc_addr_read|ddc_read) & en_ddc_reg;

//ddc address logic
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    ddc_addr_o	<=#D 8'h0;
      else if(enable_ddc && ((state == CI2C_RDT) && end_byte )) 
	    ddc_addr_o	<=#D ddc_addr_o + 8'h1;
      else if(enable_ddc && (state == CI2C_WADDR) && (bit_dcnt==4'h8) && scl_fall)
	    ddc_addr_o	<=#D sda_data;

`endif

always @(posedge clk  or negedge reset_n)
      if (!reset_n) 
	    slaveb_data	<=#D 8'h0;
      else if (end_byte && enable_slaveb && ( state ==CI2C_WDT))  
	    slaveb_data	<=#D sda_data;
always @(posedge clk  or negedge reset_n)
      if (!reset_n) 
	    slaveb_addr	<=#D 8'h0;
      else if (end_byte && enable_slaveb && (state ==CI2C_WADDR))  
	    slaveb_addr	<=#D sda_data;

//add a buffer to make INT process not time critical
always@(posedge clk or negedge reset_n) //load data @ end of trans, INT @ same time
      if (!reset_n) 
	    data_2_iic_buf	<=#D 8'h0;
      else if (end_byte_state) 
	    data_2_iic_buf	<=#D slaveb_data_2_iic;

assign	{iic_bit_carry, iic_bit_cnt} = 4'h8 - bit_cnt;
      
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    iic_out_data	<=#D 1'b0;
      else if (bit_cnt > 4'h8) 
	    iic_out_data	<=#D 1'b0;
      else if ((state == CI2C_RDT) && enable_slaveb)
	    iic_out_data	<=#D data_2_iic_buf[iic_bit_cnt];//zcx jan.09,2003 slaveb_data_2_iic[8-bit_cnt];
      `ifdef DDC
      else if ((state == CI2C_RDT) && enable_ddc)
	    iic_out_data	<=#D ddc_data_2_iic[iic_bit_cnt];
      `endif

// sda_oe : 1 valid, to allow sda_out output to IIC MASTER
always @(posedge clk or negedge reset_n)
      if (!reset_n) 
	    slave_sda_oe	<=#D 1'b0;
      else if (state == CI2C_IDLE) 
	    slave_sda_oe	<=#D 1'b0;
      else if ((state == CI2C_DEV) && (bit_dcnt == 4'h9) && (specialdev && sda_data[0]) )// the first read bit oe
	    slave_sda_oe	<=#D 1'b1;	
      else if (scl_fall && (bit_dcnt != 4'h8))
	    slave_sda_oe	<=#D (state == CI2C_RDT); 
      else if (scl_fall && (state == CI2C_DEV) && (bit_dcnt == 4'h8)) 
	    `ifdef DDC
	    slave_sda_oe	<=#D (!slave_addrb & !slave_rw & slv_match) | ddc_match ;
      `else
	    slave_sda_oe	<=#D (!slave_addrb & !slave_rw & slv_match);
      `endif
      else if (scl_fall && (state != CI2C_RDT) && (bit_dcnt == 4'h8))
	    `ifdef DDC
	    slave_sda_oe	<=#D enable_slaveb | enable_ddc;//1;
      `else
	    slave_sda_oe	<=#D enable_slaveb;//1;
      `endif
      else if (scl_fall) 
	    slave_sda_oe	<=#D 1'b0;//should be no use just double surety

// iic bus operate
always @(posedge clk or negedge reset_n)
      if (!reset_n) begin
	    sda_out	<=#D 1'b1; 
	    sda_data	<=#D 8'h0;
      end
      else begin 
	    case (state)
		  CI2C_IDLE	:
		  begin
			sda_out	<=#D 1'b1;
			sda_data<=#D 8'h0;
		  end
		  CI2C_DEV	:
		  begin
			sda_out	<=#D (specialdev && (bit_cnt==4'h9)) ? 1'b0 : 1'b1;
			sda_data<=#D ((bit_cnt != 4'h9) && scl_rise)
					? {sda_data[6:0], sda_data_in}
					: sda_data;
		  end
		  CI2C_WADDR	:
		  begin
			sda_out	<=#D (bit_cnt != 4'h9);
			sda_data<=#D ((bit_cnt != 4'h9) && scl_rise)
					? {sda_data[6:0], sda_data_in}
					: sda_data;  
		  end
		  CI2C_WDT	:
		  begin
			sda_out	<=#D (bit_cnt != 4'h9)||((slave_addrb||slave_rw)&&enable_slaveb);
			sda_data<=#D ((bit_cnt != 4'h9) && scl_rise)
					? {sda_data[6:0], sda_data_in}
					: sda_data;
		  end
		  CI2C_RDT	: 
		  begin
			sda_out	<=#D (bit_dcnt < 4'h9)
					? iic_out_data
					: 1'b1; 
			sda_data<=#D sda_data;
		  end
		  default	:
		  begin
			sda_out	<=#D 1'b1;
			sda_data<=#D sda_data;
		  end
	    endcase
      end

always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    cpu_ack_in	<=#D 1'b1;
      else if ((bit_dcnt == 4'h9) && (state==CI2C_RDT) && end_byte) 
	    cpu_ack_in	<=#D sda_data_in;
      else if (bit_cnt != 4'h9) 
	    cpu_ack_in	<=#D 1'b0;

//IIC FSM 
//synop sys state_vector state
always @(posedge clk or negedge reset_n)
      if (!reset_n)
	    state	<=#D CI2C_IDLE;
      else begin
	    case (state) 
		  CI2C_IDLE	:
		  begin
			if (start)
			      state <=#D CI2C_DEV ;   //even when ISP erase, iicslave should aloow wake up other slave's 
			else
			      state <=#D CI2C_IDLE; 
		  end
		  CI2C_DEV	:
		  begin
			if (stop)
			      state <=#D CI2C_IDLE;
			else if (end_byte_state && specialdev ) 
			      state <=#D sda_data[0]
						? CI2C_RDT
						: CI2C_WADDR;   //sda_data[0]: 1'b1:read 1'b0:write
			else if (end_byte_state) 
			      state <=#D CI2C_IDLE;
			else
			      state <=#D CI2C_DEV;
		  end
		  CI2C_WADDR	:
		  begin
			if (stop) 
			      state <=#D CI2C_IDLE;
			else if (start) 
			      state <=#D CI2C_DEV;
			else if (end_byte_state)
			      state <=#D CI2C_WDT;
			else
			      state <=#D CI2C_WADDR;
		  end
		  CI2C_WDT	:
		  begin
			if (stop) 
			      state <=#D CI2C_IDLE;
			else if (start) 
			      state <=#D CI2C_DEV;
			else 
			      state <=#D CI2C_WDT;
		  end
		  CI2C_RDT	:
		  begin
			if (stop) 
			      state <=#D CI2C_IDLE;
			else if (end_byte_state && cpu_ack_in) 
			      state <=#D CI2C_IDLE;
			else if (end_byte_state && !cpu_ack_in) 
			      state <=#D CI2C_RDT;
			else if (start) 
			      state <=#D CI2C_DEV;
			else 
			      state <=#D CI2C_RDT;
		  end
		  default	:
			state	<=#D CI2C_IDLE;
	    endcase
      end
	
endmodule 
