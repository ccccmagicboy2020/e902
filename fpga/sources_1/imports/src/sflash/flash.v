//
// File name : flash.v
//
// Description : flash serial control
//
// 

module flash (
	rst_spi_n	,
	presetn		,
	pclk		,
	spix2_clk	,
	
	penable		,
        psel		,
        pwrite		,
        paddr		,
        pwdata		,
        prdata		,
        pready		,
	
	fr_spi_sin	,
	fr_spi_sin2	,
	to_spi_cs	,
	to_spi_sck	,
	to_spi_hold	,
	to_spi_sout_en	,
	to_spi_sout
);
  //-----------------------------------------------------
  parameter     D = 1           ;

  input		rst_spi_n	;
  input		presetn		;
  input		pclk		;
  input		spix2_clk	;		

  input		penable		;
  input		psel		;
  input		pwrite		;
  input	 [21:0]	paddr		;
  input	 [31:0]	pwdata		;
	
  output	pready		;
  output [31:0]	prdata		;
	
  input		fr_spi_sin	;
  input		fr_spi_sin2	;
  output	to_spi_cs	;
  output	to_spi_sck	;
  output	to_spi_hold	;
  output	to_spi_sout_en	;
  output	to_spi_sout	;

  //-----------------------------------------------------
  reg		pready		;
  reg	 [31:0]	prdata		;

  wire		apb_valid	;
  wire		cpu_rd	 	;
  wire		cpu_wr	 	;
		
  reg	 [ 3:0]	fla_cstate	;
  reg	 [ 3:0]	fla_nstate	;

  wire	        fla_cs_idle	;
  wire	        fla_cs_ctrl	;
  wire	        fla_cs_wrt1	;
  wire	        fla_cs_wrt2	;
  wire	        fla_cs_wrt3	;
  wire	        fla_cs_rdsr	;
  wire	        fla_cs_read	;
  wire	        fla_cs_pspi	;
  wire	        fla_cs_perr	;
				 
  wire	        fla_ns_idle	;
  wire	        fla_ns_ctrl	;
  wire	        fla_ns_wrt1	;
  wire	        fla_ns_wrt2	;
  wire	        fla_ns_wrt3	;
  wire	        fla_ns_rdsr	;
  wire	        fla_ns_read	;
  wire	        fla_ns_pspi	;
  wire	        fla_ns_perr	;

  wire	        cpu_rd_redge	;
  wire	        cpu_wr_redge	;
  wire	        fla_lv_idle	;//leave idle state
  wire	        fla_ent_idle	;//enter idle state
  wire	        fla_para_err	;
  reg	        fla_para_err_lat;
  reg	        cpu_rd_d1	;
  reg	        cpu_wr_d1	;
  reg	        cpu_rd_lat	;
  reg	        cpu_wr_lat	;
  reg	 [21:0]	cpu_addr_lat	;
  reg	 [31:0]	cpu_wdata_lat	;
  reg	        fla_en		;
  reg	        fla_lop		;//last operation , "1" finish the CS
  reg	        fla_hold_md	;//hold mode , "0" stop clock , "1" generate the hold signal
  reg	        fla_dual_md	;//dual mode , "0" single mode , "1" dual mod while reading
  reg	        fla_cpol	;
  reg	        fla_cpha	;
  reg	        fla_rdsr_flag	;
  reg	        fla_cmd_st	;
  reg	 [ 3:0]	fla_data_tlen	;
  reg	 [ 2:0]	fla_data_dlen	;
  reg	        fla_data_rw	;
  reg	 [ 7:0]	fla_cmd0	;
  reg	 [ 7:0]	fla_cmd1	;
  reg	 [ 7:0]	fla_cmd2	;
  reg	 [ 7:0]	fla_cmd3	;
  reg	 [ 7:0]	fla_cmd4	;
  reg	 [ 7:0]	fla_cmd5	;
  reg	 [ 7:0]	fla_cmd6	;
  reg	 [ 7:0]	fla_cmd7	;
  reg	 [ 7:0]	fla_cmd8	;
  reg	 [ 7:0]	fla_cmd9	;
  reg	 [ 7:0]	fla_cmd10	;

  reg	 [ 7:0]	spi_rdata0	;
  reg	 [ 7:0]	spi_rdata1	;
  reg	 [ 7:0]	spi_rdata2	;
  reg	 [ 7:0]	spi_rdata3	;
	
  reg	        spi_cmd_done	;
  reg	        cmd_st_ak	;
  reg	        cmd_st_ak_sync0	;
  reg	        cmd_st_ak_sync1	;
  reg	        spi_cmd_done_sync0;
  reg	        spi_cmd_done_sync1;
  reg	        spi_cmd_done_sync2;
  reg	        spi_cmd_done_sync3;
  reg	        fla_cmd_done_ak	;
  reg	        fla_cmd_done_sync0;
  reg	        fla_cmd_done_sync1;
  reg	        fla_cmd_done_sync2;
  wire	        fla_cmd_done_f	;
  reg	        fla_cmd_done_f_d1;

  wire	        spi_cmd_st_f	;
  reg	        spi_cmd_st_f_d1	;
  reg	        spi_cmd_st_f_d2	;
  reg	        fla_cmd_st_sync0;
  reg	        fla_cmd_st_sync1;
  reg	        fla_cmd_st_sync2;
  reg	        fla_cmd_st_sync3;
  reg	 [ 3:0]	spi_data_tlen	;
  reg	 [ 2:0]	spi_data_dlen	;
  reg	        spi_data_rw	;
  reg	 [ 7:0]	spi_cmd0	;
  reg	 [ 7:0]	spi_cmd1	;
  reg	 [ 7:0]	spi_cmd2	;
  reg	 [ 7:0]	spi_cmd3	;
  reg	 [ 7:0]	spi_cmd4	;
  reg	 [ 7:0]	spi_cmd5	;
  reg	 [ 7:0]	spi_cmd6	;
  reg	 [ 7:0]	spi_cmd7	;
  reg	 [ 7:0]	spi_cmd8	;
  reg	 [ 7:0]	spi_cmd9	;
  reg	 [ 7:0]	spi_cmd10	;
  reg	        fla_en_sync0	;
  reg	        fla_en_sync1	;
  reg	        fla_cpol_sync0	;
  reg	        fla_cpol_sync1	;
  reg	        fla_cpha_sync0	;
  reg	        fla_cpha_sync1	;
  wire	        spi_en		;
  reg	        spi_lop		;
  reg	        spi_dual_md	;
  reg	        spi_hold_md	;
  wire	        spi_cpol	;
  wire	        spi_cpha	;
  reg	 [ 1:0]	last_spi_state 	;
  reg	 [ 1:0]	spi_state  	;
  reg	 [ 2:0]	spi_bcnt   	;
  reg	 [ 4:0]	spi_bytcnt 	;
  reg	 [79:0]	spi_treg_s 	;
  reg	 [ 7:0]	spi_treg   	;
  reg	 [ 7:0]	spi_rreg   	;
  reg	        spi_wfre   	;
  reg	        spi_rfwe   	;
  reg	        spi_sck    	;
  reg	        spi_hold    	;
  reg	        spi_cs		;
  reg	        spi_sout_en	;

  wire	[ 3:0]	spi_data_bpos   ;//SPI data position

  //-----------------------------------------------------
  `define	FLA_IDLE	4'b0000	// idle
  `define	FLA_CTRL	4'b0001	// write control register
  `define	FLA_WRT1	4'b0010	// write command 1
  `define	FLA_WRT2	4'b0011	// write command 2
  `define	FLA_WRT3	4'b0100	// write command 3
  `define	FLA_RDSR	4'b0101	// read data saved before
  `define	FLA_READ	4'b0110	// read data /w send command
  `define	FLA_PSPI	4'b0111	// processing SPI
  `define	FLA_PERR	4'b1000	// parameter error

  //-----------------------------------------------------	
  assign fla_cs_idle	= fla_cstate == `FLA_IDLE	;
  assign fla_cs_ctrl	= fla_cstate == `FLA_CTRL	;
  assign fla_cs_wrt1	= fla_cstate == `FLA_WRT1	;
  assign fla_cs_wrt2	= fla_cstate == `FLA_WRT2	;
  assign fla_cs_wrt3	= fla_cstate == `FLA_WRT3	;
  assign fla_cs_rdsr	= fla_cstate == `FLA_RDSR	;
  assign fla_cs_read	= fla_cstate == `FLA_READ	;
  assign fla_cs_pspi	= fla_cstate == `FLA_PSPI	;
  assign fla_cs_perr	= fla_cstate == `FLA_PERR	;

  assign fla_ns_idle	= fla_nstate == `FLA_IDLE	;
  assign fla_ns_ctrl	= fla_nstate == `FLA_CTRL	;
  assign fla_ns_wrt1	= fla_nstate == `FLA_WRT1	;
  assign fla_ns_wrt2	= fla_nstate == `FLA_WRT2	;
  assign fla_ns_wrt3	= fla_nstate == `FLA_WRT3	;
  assign fla_ns_rdsr	= fla_nstate == `FLA_RDSR	;
  assign fla_ns_read	= fla_nstate == `FLA_READ	;
  assign fla_ns_pspi	= fla_nstate == `FLA_PSPI	;
  assign fla_ns_perr	= fla_nstate == `FLA_PERR	;

  assign apb_valid      = psel & (!penable);
  assign cpu_rd	        = apb_valid & ~pwrite;
  assign cpu_wr	        = apb_valid &  pwrite;
  assign cpu_rd_redge   = cpu_rd & ~cpu_rd_d1;
  assign cpu_wr_redge   = cpu_wr & ~cpu_wr_d1;

  assign fla_lv_idle    = fla_cs_idle & 
                         (fla_ns_ctrl|fla_ns_wrt1|
			  fla_ns_wrt2|fla_ns_wrt3|
			  fla_ns_rdsr|fla_ns_read|fla_ns_perr);

  assign fla_ent_idle   = fla_ns_idle && (fla_cstate != `FLA_IDLE);

  assign fla_para_err   = (paddr[1:0] == 2'b01) & 
			 ((pwdata[6:4] > 3'h4) |
			  (pwdata[3:0] == 4'h0) |
			 ({1'b0,pwdata[6:4]} > pwdata[3:0]));
	
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      cpu_rd_d1	        <= #D 1'b0;
      cpu_wr_d1	        <= #D 1'b0;
      cpu_rd_lat	<= #D 1'b0;
      cpu_wr_lat	<= #D 1'b0;
      cpu_addr_lat	<= #D 22'b0;
      cpu_wdata_lat	<= #D 32'b0;
      fla_para_err_lat  <= #D 1'b0;
    end
    else begin
      cpu_rd_d1	        <= #D apb_valid & ~pwrite;
      cpu_wr_d1	        <= #D apb_valid &  pwrite;
      cpu_rd_lat	<= #D cpu_rd_redge ? 1'b1 : fla_lv_idle ? 1'b0 : cpu_rd_lat;
      cpu_wr_lat	<= #D cpu_wr_redge ? 1'b1 : fla_lv_idle ? 1'b0 : cpu_wr_lat;
      cpu_addr_lat	<= #D (cpu_rd_redge|cpu_wr_redge) ? paddr : cpu_addr_lat;
      cpu_wdata_lat	<= #D cpu_wr_redge ? pwdata : cpu_wdata_lat;
      fla_para_err_lat  <= #D cpu_wr_redge ? fla_para_err : fla_para_err_lat;
    end
  end

  always @(fla_cstate or cpu_wr_lat or fla_para_err_lat or cpu_rd_lat or cpu_addr_lat[1:0] or fla_rdsr_flag or fla_cmd_done_f_d1) begin
     case (fla_cstate)
	`FLA_IDLE : fla_nstate	<= #D cpu_wr_lat ? (fla_para_err_lat            ? `FLA_PERR :
				                   (cpu_addr_lat[1:0] == 2'b00) ? `FLA_CTRL :
				                   (cpu_addr_lat[1:0] == 2'b01) ? `FLA_WRT1 :
				                   (cpu_addr_lat[1:0] == 2'b10) ? `FLA_WRT2 : `FLA_WRT3) :
       				      cpu_rd_lat ? (fla_rdsr_flag ? `FLA_RDSR : `FLA_READ) : `FLA_IDLE;
	`FLA_CTRL : fla_nstate	<= #D `FLA_IDLE;
	`FLA_WRT1 : fla_nstate	<= #D `FLA_PSPI;
	`FLA_WRT2 : fla_nstate	<= #D `FLA_IDLE;
	`FLA_WRT3 : fla_nstate	<= #D `FLA_IDLE;
	`FLA_RDSR : fla_nstate	<= #D `FLA_IDLE;
	`FLA_READ : fla_nstate	<= #D `FLA_PSPI;
	`FLA_PSPI : fla_nstate	<= #D  fla_cmd_done_f_d1 ? `FLA_IDLE : `FLA_PSPI;
	`FLA_PERR : fla_nstate	<= #D `FLA_IDLE;
	default	  : fla_nstate	<= #D `FLA_IDLE;
     endcase
  end
	
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      fla_cstate	<= #D `FLA_IDLE;
    else 
      fla_cstate	<= #D fla_nstate;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      fla_en		<= #D 1'b1;
      fla_cpol	        <= #D 1'b0;
      fla_lop		<= #D 1'b1;
      fla_dual_md	<= #D 1'b0;
      fla_hold_md	<= #D 1'b0;
      fla_cpha	        <= #D 1'b0;
      fla_rdsr_flag	<= #D 1'b0;
      fla_cmd_st	<= #D 1'b0;
      fla_data_tlen	<= #D 4'b0;
      fla_data_dlen	<= #D 3'b0;
      fla_data_rw	<= #D 1'b0;
      fla_cmd0	        <= #D 8'b0;
      fla_cmd1	        <= #D 8'b0;
      fla_cmd2	        <= #D 8'b0;
      fla_cmd3	        <= #D 8'b0;
      fla_cmd4	        <= #D 8'b0;
      fla_cmd5	        <= #D 8'b0;
      fla_cmd6	        <= #D 8'b0;
      fla_cmd7	        <= #D 8'b0;
      fla_cmd8	        <= #D 8'b0;
      fla_cmd9	        <= #D 8'b0;
      fla_cmd10	        <= #D 8'b0;
    end
    else begin
     {fla_dual_md,fla_hold_md,fla_lop,fla_en,fla_cpol,fla_cpha}	<= #1 fla_cs_ctrl ? cpu_wdata_lat[5:0] : {fla_dual_md,fla_hold_md,fla_lop,fla_en,fla_cpol,fla_cpha};
      fla_rdsr_flag	<= #D fla_cs_wrt1 & cpu_wdata_lat[7] ? 1'b1 : fla_cs_rdsr ? 1'b0 : fla_rdsr_flag;
      fla_cmd_st	<= #D fla_cs_read | fla_cs_wrt1 ? 1'b1 : cmd_st_ak_sync1 ? 1'b0 : fla_cmd_st;
      fla_data_tlen	<= #D fla_cs_read ? 4'h8 : fla_cs_wrt1 ? cpu_wdata_lat[3:0] : fla_data_tlen;
      fla_data_dlen	<= #D fla_cs_read ? 3'h4 : fla_cs_wrt1 ? cpu_wdata_lat[6:4] : fla_data_dlen;
      fla_data_rw	<= #D fla_cs_read ? 1'h1 : fla_cs_wrt1 ? cpu_wdata_lat[7] : fla_data_rw;
      fla_cmd0	        <= #D fla_cs_read ? 8'h03 : fla_cs_wrt1 ? cpu_wdata_lat[15:8] : fla_cmd0;
      fla_cmd1	        <= #D fla_cs_read ? cpu_addr_lat[21:14] : fla_cs_wrt1 ? cpu_wdata_lat[23:16] : fla_cmd1;
      fla_cmd2	        <= #D fla_cs_read ? cpu_addr_lat[13:6] : fla_cs_wrt1 ? cpu_wdata_lat[31:24] : fla_cmd2;
      fla_cmd3	        <= #D fla_cs_read ? {cpu_addr_lat[5:0],2'b00} : fla_cs_wrt2 ? cpu_wdata_lat[7:0] : fla_cmd3;
      fla_cmd4	        <= #D fla_cs_wrt2 ? cpu_wdata_lat[15:8] : fla_cmd4;
      fla_cmd5	        <= #D fla_cs_wrt2 ? cpu_wdata_lat[23:16] : fla_cmd5;
      fla_cmd6	        <= #D fla_cs_wrt2 ? cpu_wdata_lat[31:24] : fla_cmd6;
      fla_cmd7	        <= #D fla_cs_wrt3 ? cpu_wdata_lat[7:0] : fla_cmd7;
      fla_cmd8	        <= #D fla_cs_wrt3 ? cpu_wdata_lat[15:8] : fla_cmd8;
      fla_cmd9	        <= #D fla_cs_wrt3 ? cpu_wdata_lat[23:16] : fla_cmd9;
      fla_cmd10	        <= #D fla_cs_wrt3 ? cpu_wdata_lat[31:24] : fla_cmd10;
    end
  end
	
  assign fla_cmd_done_f  = ~spi_cmd_done_sync2 & spi_cmd_done_sync3;

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      cmd_st_ak_sync0	<= #D 1'b0;
      cmd_st_ak_sync1	<= #D 1'b0;
      spi_cmd_done_sync0<= #D 1'b0;
      spi_cmd_done_sync1<= #D 1'b0;
      spi_cmd_done_sync2<= #D 1'b0;
      spi_cmd_done_sync3<= #D 1'b0;
      fla_cmd_done_f_d1	<= #D 1'b0;
    end
    else begin
      cmd_st_ak_sync0   <= #D cmd_st_ak;
      cmd_st_ak_sync1   <= #D cmd_st_ak_sync0;
      spi_cmd_done_sync0<= #D spi_cmd_done;
      spi_cmd_done_sync1<= #D spi_cmd_done_sync0;
      spi_cmd_done_sync2<= #D spi_cmd_done_sync1;
      spi_cmd_done_sync3<= #D spi_cmd_done_sync2;
      fla_cmd_done_f_d1	<= #D fla_cmd_done_f;
    end
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      fla_cmd_done_ak	<= #D 1'b0;
    end
    else begin
//    fla_cmd_done_ak	<= #D spi_cmd_done_sync2 & ~spi_cmd_done_sync3 ? 1'b1 : ~fla_cmd_done_sync2 ? 1'b0 : fla_cmd_done_ak;
      fla_cmd_done_ak	<= #D spi_cmd_done_sync2 & ~spi_cmd_done_sync3 ? 1'b1 : ~spi_cmd_done_sync2 ? 1'b0 : fla_cmd_done_ak;
    end
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      pready		<= #D 1'b1;
      prdata		<= #D 32'b0;
    end
    else begin
//    pready		<= #D cpu_rd_redge|cpu_wr_redge ? 1'b0 : (fla_data_rw & fla_cmd_done_f_d1) | fla_cs_rdsr ? 1'b1 : pready;
      pready		<= #D cpu_rd_redge|cpu_wr_redge ? 1'b0 : fla_ent_idle ? 1'b1 : pready;
//    to_cpu_rdy	<= #D cpu_rd_redge|cpu_wr_redge ? 1'b0 : fla_lv_idle ? 1'b1 : to_cpu_rdy;
//    to_cpu_en	        <= #D (fla_data_rw & fla_cmd_done_f_d1) | fla_cs_rdsr;
      prdata		<= #D fla_data_rw & fla_cmd_done_f ? {spi_rdata3,spi_rdata2,spi_rdata1,spi_rdata0} : prdata;
    end
  end

  assign spi_en	      = fla_en_sync1;
  assign spi_cpol     = fla_cpol_sync1;
  assign spi_cpha     = fla_cpha_sync1;
	
  assign spi_cmd_st_f = ~fla_cmd_st_sync2 & fla_cmd_st_sync3;
	
  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) begin
      fla_cmd_st_sync0	<= #D 1'b0;
      fla_cmd_st_sync1	<= #D 1'b0;
      fla_cmd_st_sync2	<= #D 1'b0;
      fla_cmd_st_sync3	<= #D 1'b0;
      fla_en_sync0	<= #D 1'b1;
      fla_en_sync1	<= #D 1'b1;
      fla_cpol_sync0	<= #D 1'b0;
      fla_cpol_sync1	<= #D 1'b0;
      fla_cpha_sync0	<= #D 1'b0;
      fla_cpha_sync1	<= #D 1'b0;
      fla_cmd_done_sync0<= #D 1'b0;
      fla_cmd_done_sync1<= #D 1'b0;
      fla_cmd_done_sync2<= #D 1'b0;
      spi_cmd_st_f_d1	<= #D 1'b0;
      spi_cmd_st_f_d2	<= #D 1'b0;
    end
    else begin
      fla_cmd_st_sync0	<= #D fla_cmd_st;
      fla_cmd_st_sync1	<= #D fla_cmd_st_sync0;
      fla_cmd_st_sync2	<= #D fla_cmd_st_sync1;
      fla_cmd_st_sync3	<= #D fla_cmd_st_sync2;
      fla_en_sync0	<= #D fla_en;
      fla_en_sync1	<= #D fla_en_sync0;
      fla_cpol_sync0	<= #D fla_cpol;
      fla_cpol_sync1	<= #D fla_cpol_sync0;
      fla_cpha_sync0	<= #D fla_cpha;
      fla_cpha_sync1	<= #D fla_cpha_sync0;
      fla_cmd_done_sync0<= #D fla_cmd_done_ak;
      fla_cmd_done_sync1<= #D fla_cmd_done_sync0;
      fla_cmd_done_sync2<= #D fla_cmd_done_sync1;
      spi_cmd_st_f_d1	<= #D spi_cmd_st_f;
      spi_cmd_st_f_d2	<= #D spi_cmd_st_f_d1;
    end
  end
  
  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) 
      cmd_st_ak	        <= #D 1'b0;
    else 
      cmd_st_ak	        <= #D fla_cmd_st_sync2 & ~fla_cmd_st_sync3 ? 1'b1 : ~fla_cmd_st_sync2 ? 1'b0 : cmd_st_ak;
  end

  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) 
      spi_cmd_done	<= #D 1'b0;
    else 
      spi_cmd_done	<= #D  spi_rfwe & (spi_bytcnt == spi_data_tlen + 1'b1) ? 1'b1 : ~(~fla_cmd_done_sync1 | fla_cmd_done_sync2) ? 1'b0 : spi_cmd_done;
  end

  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) 
      last_spi_state	<= #D 2'b0;
    else 
      last_spi_state	<= #D spi_state;
  end

  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) begin
      spi_data_tlen	<= #D 4'b0;
      spi_data_dlen	<= #D 3'b0;
      spi_data_rw	<= #D 1'b0;
      spi_cmd0	        <= #D 8'b0;
      spi_cmd1	        <= #D 8'b0;
      spi_cmd2	        <= #D 8'b0;
      spi_cmd3	        <= #D 8'b0;
      spi_cmd4	        <= #D 8'b0;
      spi_cmd5	        <= #D 8'b0;
      spi_cmd6	        <= #D 8'b0;
      spi_cmd7	        <= #D 8'b0;
      spi_cmd8	        <= #D 8'b0;
      spi_cmd9	        <= #D 8'b0;
      spi_cmd10	        <= #D 8'b0;
      spi_lop  	        <= #D 1'b1;
      spi_dual_md	<= #D 1'b0;
      spi_hold_md	<= #D 1'b0;
    end
    else begin
      spi_data_tlen	<= #D spi_cmd_st_f ? fla_data_tlen	: spi_data_tlen	;
      spi_data_dlen	<= #D spi_cmd_st_f ? fla_data_dlen	: spi_data_dlen	;
      spi_data_rw	<= #D spi_cmd_st_f ? fla_data_rw	  : spi_data_rw	  ;
      spi_cmd0	        <= #D spi_cmd_st_f ? fla_cmd0	 : spi_cmd0	;
      spi_cmd1	        <= #D spi_cmd_st_f ? fla_cmd1	 : spi_cmd1	;
      spi_cmd2	        <= #D spi_cmd_st_f ? fla_cmd2	 : spi_cmd2	;
      spi_cmd3	        <= #D spi_cmd_st_f ? fla_cmd3	 : spi_cmd3	;
      spi_cmd4	        <= #D spi_cmd_st_f ? fla_cmd4	 : spi_cmd4	;
      spi_cmd5	        <= #D spi_cmd_st_f ? fla_cmd5	 : spi_cmd5	;
      spi_cmd6	        <= #D spi_cmd_st_f ? fla_cmd6	 : spi_cmd6	;
      spi_cmd7	        <= #D spi_cmd_st_f ? fla_cmd7	 : spi_cmd7	;
      spi_cmd8	        <= #D spi_cmd_st_f ? fla_cmd8	 : spi_cmd8	;
      spi_cmd9	        <= #D spi_cmd_st_f ? fla_cmd9	 : spi_cmd9	;
      spi_cmd10	        <= #D spi_cmd_st_f ? fla_cmd10   : spi_cmd10	;
      spi_lop  	        <= #D spi_cmd_st_f ? fla_lop 	 : spi_lop	;
      spi_dual_md	<= #D spi_cmd_st_f ? fla_dual_md : spi_dual_md	;
      spi_hold_md	<= #D spi_cmd_st_f ? fla_hold_md : spi_hold_md	;
    end
  end

  assign spi_data_bpos   = spi_data_tlen - spi_data_dlen;
	
  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) begin
      spi_state         <= #D 2'b00; // idle
      spi_bcnt          <= #D 3'h0;
      spi_bytcnt        <= #D 5'h1;
      spi_treg_s        <= #D 80'h0;
      spi_treg          <= #D 8'h00;
      spi_rreg          <= #D 8'h00;
      spi_wfre          <= #D 1'b0;
      spi_rfwe          <= #D 1'b0;
      spi_sck           <= #D 1'b0;
      spi_cs	        <= #D 1'b1;
      spi_hold          <= #D 1'b1;
      spi_sout_en       <= #D 1'b1;
    end
    else if (~spi_en) begin
      spi_state         <= #D 2'b00; // idle
      spi_bcnt          <= #D 3'h0;
      spi_bytcnt        <= #D 5'h1;
      spi_treg_s        <= #D 80'h0;
      spi_treg          <= #D 8'h00;
      spi_rreg          <= #D 8'h00;
      spi_wfre          <= #D 1'b0;
      spi_rfwe          <= #D 1'b0;
      spi_sck           <= #D 1'b0;
      spi_cs	        <= #D 1'b1;
      spi_hold          <= #D 1'b1;
      spi_sout_en       <= #D 1'b1;
    end
    else begin
      spi_wfre          <= #D 1'b0;
      spi_rfwe          <= #D 1'b0;

      case (spi_state)
	2'b00: begin // idle state
	  spi_sout_en   <= #D 1'b1;
	  spi_bcnt      <= #D 3'h7;   // set transfer counter
	  spi_bytcnt    <= #D 5'b1;
	  spi_treg_s    <= #D {spi_cmd10,spi_cmd9,spi_cmd8,spi_cmd7,spi_cmd6,
	   		       spi_cmd5,spi_cmd4,spi_cmd3,spi_cmd2,spi_cmd1};
	  spi_treg      <= #D spi_cmd0; // load transfer register
	  spi_rreg      <= #D 8'h00;
//	  spi_sck       <= #D spi_cpol;   // set sck
//	  spi_sck       <= #D ~spi_lop & spi_hold_md ? ~spi_sck : spi_cpol;   // set sck
	  spi_sck       <= #D ~spi_hold ? ~spi_sck : spi_cpol;   // set sck
//	  spi_cs	<= #D 1'b1;
	  spi_cs	<= #D (last_spi_state == 2'b11) ? spi_lop : spi_cs;

	  if ((spi_cmd_st_f_d1|spi_cmd_st_f_d2) && ((spi_sck==~spi_cpha)|spi_hold)) begin
	    spi_sout_en <= #D ~((spi_bytcnt > spi_data_bpos) & spi_dual_md);
	    spi_wfre    <= #D 1'b1;
	    spi_state   <= #D 2'b01;
//	    spi_sck	<= #D spi_cpha ? ~spi_sck : spi_sck;
	    spi_sck	<= #D ~spi_hold | spi_cpha ? ~spi_sck : spi_sck;
//	    spi_hold    <= #D ~spi_lop & spi_hold_md ? 1'b0 : 1'b1;
	    spi_hold    <= #D 1'b1;
	    spi_cs	<= #D 1'b0;
          end
        end
        2'b01: begin // clock-phase2, next data
	    spi_sck     <= #D ~spi_sck;
	    spi_state   <= #D 2'b11;
	end
	2'b11: begin // clock phase1
	    spi_bcnt    <= #D spi_bcnt -3'h1;
	    spi_rreg    <= #D spi_dual_md ? {spi_rreg[5:0],fr_spi_sin,fr_spi_sin2} : {spi_rreg[6:0], fr_spi_sin};
	    if ((~|spi_bcnt)|(~|spi_bcnt[1:0] & ~spi_sout_en)) begin
	      spi_sout_en <= #D ~(spi_bytcnt == spi_data_tlen) ? ~((spi_bytcnt >= spi_data_bpos) & spi_dual_md) : spi_sout_en;
	     {spi_treg_s[72:0],spi_treg} <= #1 spi_treg_s[79:0];
	      spi_bytcnt <= #D spi_bytcnt + 1'b1;
	      spi_state  <= #D (spi_bytcnt == spi_data_tlen) ? 2'b00 : 2'b01;
//	      spi_sck    <= #D spi_cpol;
	      spi_sck    <= #D (spi_bytcnt == spi_data_tlen) & ~spi_lop & spi_hold_md ? ~spi_sck : spi_cpol;
	      spi_hold   <= #D (spi_bytcnt == spi_data_tlen) & ~spi_lop & spi_hold_md ? 1'b0 : 1'b1;
	      spi_rfwe   <= #D 1'b1;
	    end 
	    else begin
	      spi_sout_en <= #D spi_sout_en;
	      spi_treg_s  <= #D spi_treg_s;
	      spi_treg    <= #D {spi_treg[6:0], 1'b0};
	      spi_bytcnt  <= #D spi_bytcnt;
	      spi_state   <= #D 2'b01;
	      spi_sck     <= #D ~spi_sck;
	    end
	end
	default: begin
	      spi_state   <= #D 2'b00;
	end
      endcase
    end
  end

  assign to_spi_sout_en  = spi_sout_en;
  assign to_spi_sout     = spi_treg[7];
  assign to_spi_sck      = spi_sck;
  assign to_spi_hold     = spi_hold;
  assign to_spi_cs       = spi_cs;

  always @(posedge spix2_clk or negedge rst_spi_n) begin
    if (!rst_spi_n) begin
      spi_rdata0	<= #D 8'b0;
      spi_rdata1	<= #D 8'b0;
      spi_rdata2	<= #D 8'b0;
      spi_rdata3	<= #D 8'b0;
    end
    else begin
      spi_rdata0	<= #D (spi_rfwe & (spi_bytcnt == (spi_data_bpos + 3'b010))) ? spi_rreg : spi_rdata0;
      spi_rdata1	<= #D (spi_rfwe & (spi_bytcnt == (spi_data_bpos + 3'b011))) ? spi_rreg : spi_rdata1;
      spi_rdata2	<= #D (spi_rfwe & (spi_bytcnt == (spi_data_bpos + 3'b100))) ? spi_rreg : spi_rdata2;
      spi_rdata3	<= #D (spi_rfwe & (spi_bytcnt == (spi_data_bpos + 3'b101))) ? spi_rreg : spi_rdata3;
    end
  end

endmodule
