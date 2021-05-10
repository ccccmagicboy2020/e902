//
// File name   : stc.v
//
// Description : 
//
// Author      : Liangzujun
//
// History     :
//   2020/12/08: first created
//

module stc (
        pclk                  ,                 
        presetn               ,
              
        penable               ,              
        psel                  ,                 
        pwrite                ,               
        paddr                 ,                
        pwdata                ,               
        prdata                ,               
        pready                ,   
	
        stc_cnt               ,	             
	pwm_out               ,
        timer_int             ,
	wdg_out_int           ,
	wdg_out_rst	
       );

  input         pclk          ;          
  input         presetn       ;      
  input         penable       ;       
  input         psel          ;         
  input         pwrite        ;       
  input  [11:2] paddr         ;        
  input  [31:0] pwdata        ;       
  output [31:0] prdata        ;        
  output        pready        ;  
  
  output [63:0] stc_cnt       ;         
  (*mark_debug="true"*)output [ 4:0]	pwm_out       ;
  output [ 3:0] timer_int     ;
  output	wdg_out_int   ;
  output	wdg_out_rst   ;

  //------------------------------------------------------------------------------
  // Constant declarations
  //------------------------------------------------------------------------------
  parameter D = 0             ;
    
  //------------------------------------------------------------------------------
  // Signal declarations
  //------------------------------------------------------------------------------
  wire          wr0           ;
  wire          wr1           ;
  wire          wr2           ;
  wire          wr3           ;
  wire          wr4           ;
  wire          wr5           ;
  wire          wr6           ;
  wire          wr7           ;
  wire          wr8           ;
  wire          wr9           ;
  wire          wr10          ;
  wire          wr11          ;
  wire          wr12          ;
  wire          wr13          ;
  wire          wr14          ;
  wire          wr15          ;
  reg   [31:0]  prdata        ;

  reg           stc_cnt_en    ;
  reg           wdg_en        ;
  reg           wdg_rst_en    ;
  reg   [ 3:0]  timer_en      ;
  reg   [ 4:0]  pwm_en        ;
  reg   [31:0]  wdg_cnt_reg   ;
  reg   [31:0]  timer1_reg    ;
  reg   [31:0]  timer2_reg    ;
  reg   [31:0]  timer3_reg    ;
  reg   [31:0]  timer4_reg    ;
  reg   [23:0]  pwm_freq_ctrl1;
  reg   [23:0]  pwm_freq_ctrl2;
  reg   [23:0]  pwm_freq_ctrl3;
  reg   [23:0]  pwm_freq_ctrl4;
  reg   [23:0]  pwm_freq_ctrl5;
  reg   [23:0]  pwm_duty_ctrl1;
  reg   [23:0]  pwm_duty_ctrl2;
  reg   [23:0]  pwm_duty_ctrl3;
  reg   [23:0]  pwm_duty_ctrl4;
  reg   [23:0]  pwm_duty_ctrl5;

  wire  [ 3:0]  timer_rel     ;

  reg   [63:0]  stc_cnt       ;
  reg   [31:0]  timer1_cnt    ;
  reg           timer1_int    ;
  reg   [31:0]  timer2_cnt    ;
  reg           timer2_int    ;
  reg   [31:0]  timer3_cnt    ;
  reg           timer3_int    ;
  reg   [31:0]  timer4_cnt    ;
  reg           timer4_int    ;
  reg   [31:0]  wdg_cnt       ;
  reg		wdg_rst       ;
  reg		wdg_rst_d0    ;
  reg		wdg_rst_d1    ;
  reg		wdg_rst_d2    ;
  reg		wdg_rst_d3    ;
  reg		wdg_rst_d4    ;
  reg		wdg_rst_d5    ;
  reg		wdg_rst_d6    ;
  reg		wdg_rst_d7    ;
  reg		wdg_rst_d8    ;
  reg		wdg_rst_d9    ;
  reg		wdg_out_rst   ;
  reg		wdg_out_int   ;

  wire   [ 4:0] count_clr     ;
  wire   [ 4:0] pwm_tmp       ;
  reg    [23:0] pwm1_cnt      ;
  reg    [23:0] pwm2_cnt      ;
  reg    [23:0] pwm3_cnt      ;
  reg    [23:0] pwm4_cnt      ;
  reg    [23:0] pwm5_cnt      ;
  reg    [ 4:0] pwm_out       ;
     
  //------------------------------------------------------------------------------
  // Beginning of main code
  //------------------------------------------------------------------------------
  assign wr0  = psel & pwrite & ~penable & paddr == 8'h00;
  assign wr1  = psel & pwrite & ~penable & paddr == 8'h01;
  assign wr2  = psel & pwrite & ~penable & paddr == 8'h02;
  assign wr3  = psel & pwrite & ~penable & paddr == 8'h03;
  assign wr4  = psel & pwrite & ~penable & paddr == 8'h04;
  assign wr5  = psel & pwrite & ~penable & paddr == 8'h05;
  assign wr6  = psel & pwrite & ~penable & paddr == 8'h06;
  assign wr7  = psel & pwrite & ~penable & paddr == 8'h07;
  assign wr8  = psel & pwrite & ~penable & paddr == 8'h08;
  assign wr9  = psel & pwrite & ~penable & paddr == 8'h09;
  assign wr10 = psel & pwrite & ~penable & paddr == 8'h0A;
  assign wr11 = psel & pwrite & ~penable & paddr == 8'h0B;
  assign wr12 = psel & pwrite & ~penable & paddr == 8'h0C;
  assign wr13 = psel & pwrite & ~penable & paddr == 8'h0D;
  assign wr14 = psel & pwrite & ~penable & paddr == 8'h0E;
  assign wr15 = psel & pwrite & ~penable & paddr == 8'h0F;

  assign pready = 1'b1;

  always @ (posedge pclk or negedge presetn)                                                         
    if (!presetn) begin                                          
      stc_cnt_en         <= #D 1'b0;
      wdg_en             <= #D 1'b0;
      wdg_rst_en         <= #D 1'b0;
      timer_en           <= #D 4'h0;
      pwm_en             <= #D 5'h0;
      wdg_cnt_reg        <= #D 32'h0;
      timer1_reg         <= #D 32'hFFF00000;
      timer2_reg         <= #D 32'hFFF00000;
      timer3_reg         <= #D 32'hFFF00000;
      timer4_reg         <= #D 32'hFFF00000;
      pwm_freq_ctrl1     <= #D 24'h0;
      pwm_freq_ctrl2     <= #D 24'h0;
      pwm_freq_ctrl3     <= #D 24'h0;
      pwm_freq_ctrl4     <= #D 24'h0;
      pwm_freq_ctrl5     <= #D 24'h0;
      pwm_duty_ctrl1     <= #D 24'h0;
      pwm_duty_ctrl2     <= #D 24'h0;
      pwm_duty_ctrl3     <= #D 24'h0;
      pwm_duty_ctrl4     <= #D 24'h0;
      pwm_duty_ctrl5     <= #D 24'h0;
    end                                            
    else begin
      stc_cnt_en         <= #D wr0  ? pwdata[0]     : stc_cnt_en;
      wdg_en             <= #D wr0  ? pwdata[1]     : wdg_en;
      wdg_rst_en         <= #D wr0  ? pwdata[2]     : wdg_rst_en;
      timer_en           <= #D wr0  ? pwdata[7:4]   : timer_en;
      pwm_en             <= #D wr0  ? pwdata[16:12] : pwm_en;
      wdg_cnt_reg        <= #D wr1  ? pwdata        : wdg_cnt_reg;
      timer1_reg         <= #D wr2  ? pwdata        : timer1_reg;
      timer2_reg         <= #D wr3  ? pwdata        : timer2_reg;
      timer3_reg         <= #D wr4  ? pwdata        : timer3_reg;
      timer4_reg         <= #D wr5  ? pwdata        : timer4_reg;
      pwm_freq_ctrl1     <= #D wr6  ? pwdata[23:0]  : pwm_freq_ctrl1;
      pwm_freq_ctrl2     <= #D wr7  ? pwdata[23:0]  : pwm_freq_ctrl2;
      pwm_freq_ctrl3     <= #D wr8  ? pwdata[23:0]  : pwm_freq_ctrl3;
      pwm_freq_ctrl4     <= #D wr9  ? pwdata[23:0]  : pwm_freq_ctrl4;
      pwm_freq_ctrl5     <= #D wr10 ? pwdata[23:0]  : pwm_freq_ctrl5;
      pwm_duty_ctrl1     <= #D wr11 ? pwdata[23:0]  : pwm_duty_ctrl1;
      pwm_duty_ctrl2     <= #D wr12 ? pwdata[23:0]  : pwm_duty_ctrl2;
      pwm_duty_ctrl3     <= #D wr13 ? pwdata[23:0]  : pwm_duty_ctrl3;
      pwm_duty_ctrl4     <= #D wr14 ? pwdata[23:0]  : pwm_duty_ctrl4;
      pwm_duty_ctrl5     <= #D wr15 ? pwdata[23:0]  : pwm_duty_ctrl5;
    end
             
  assign timer_rel[0] = wr0 & pwdata[8];
  assign timer_rel[1] = wr0 & pwdata[9];
  assign timer_rel[2] = wr0 & pwdata[10];
  assign timer_rel[3] = wr0 & pwdata[11];

  always @ (posedge pclk or negedge presetn)
    if ((!presetn))
      prdata      <=#D 32'b0;
    else if (psel & ~pwrite & ~penable) begin
      case (paddr)
        10'h00: prdata    <=#D {15'h0,pwm_en,4'h0,timer_en,1'b0,wdg_rst_en,wdg_en,stc_cnt_en};
        10'h01: prdata    <=#D wdg_cnt_reg;
        10'h02: prdata    <=#D timer1_reg;
        10'h03: prdata    <=#D timer2_reg;
        10'h04: prdata    <=#D timer3_reg;
        10'h05: prdata    <=#D timer4_reg;
        10'h06: prdata    <=#D {8'h0,pwm_freq_ctrl1};
        10'h07: prdata    <=#D {8'h0,pwm_freq_ctrl2};
        10'h08: prdata    <=#D {8'h0,pwm_freq_ctrl3};
        10'h09: prdata    <=#D {8'h0,pwm_freq_ctrl4};
        10'h0A: prdata    <=#D {8'h0,pwm_freq_ctrl5};
        10'h0B: prdata    <=#D {8'h0,pwm_duty_ctrl1};
        10'h0C: prdata    <=#D {8'h0,pwm_duty_ctrl2};
        10'h0D: prdata    <=#D {8'h0,pwm_duty_ctrl3};
        10'h0E: prdata    <=#D {8'h0,pwm_duty_ctrl4};
        10'h0F: prdata    <=#D {8'h0,pwm_duty_ctrl5};
        10'h10: prdata    <=#D timer1_cnt;
        10'h11: prdata    <=#D timer2_cnt;
        10'h12: prdata    <=#D timer3_cnt;
        10'h13: prdata    <=#D timer4_cnt; 
      default:
                prdata    <=#D 32'h0; 
      endcase
    end	   
 
  //------------------------------------------------------------------------------
  // Timers
  //------------------------------------------------------------------------------

  always @(posedge pclk or negedge presetn) 
    if (!presetn) 
      stc_cnt      <= #D 64'h0;
    else if (~stc_cnt_en) 
      stc_cnt      <= #D 64'h0;
    else 
      stc_cnt      <= #D stc_cnt + 1'b1;

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer1_cnt   <= #D 32'h0;
    else if (~timer_en[0]) 
      timer1_cnt   <= #D timer1_reg;
    else if (~(|timer1_cnt))
      timer1_cnt   <= #D timer1_reg;
    else
      timer1_cnt   <= #D timer1_cnt - 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer1_int   <= #D 1'b0;
    else if (~timer_en[0] | timer_rel[0]) 
      timer1_int   <= #D 1'b0;
    else if (~(|timer1_cnt))
      timer1_int   <= #D 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer2_cnt   <= #D 32'h0;
    else if (~timer_en[1]) 
      timer2_cnt   <= #D timer2_reg;
    else if (~(|timer2_cnt))
      timer2_cnt   <= #D timer2_reg;
    else
      timer2_cnt   <= #D timer2_cnt - 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer2_int   <= #D 1'b0;
    else if (~timer_en[1] | timer_rel[1]) 
      timer2_int   <= #D 1'b0;
    else if (~(|timer2_cnt))
      timer2_int   <= #D 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer3_cnt   <= #D 32'h0;
    else if (~timer_en[2]) 
      timer3_cnt   <= #D timer3_reg;
    else if (~(|timer3_cnt))
      timer3_cnt   <= #D timer3_reg;
    else
      timer3_cnt   <= #D timer3_cnt - 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer3_int   <= #D 1'b0;
    else if (~timer_en[2] | timer_rel[2]) 
      timer3_int   <= #D 1'b0;
    else if (~(|timer3_cnt))
      timer3_int   <= #D 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer4_cnt   <= #D 32'h0;
    else if (~timer_en[3]) 
      timer4_cnt   <= #D timer4_reg;
    else if (~(|timer4_cnt))
      timer4_cnt   <= #D timer4_reg;
    else
      timer4_cnt   <= #D timer4_cnt - 1'b1;
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      timer4_int   <= #D 1'b0;
    else if (~timer_en[3] | timer_rel[3]) 
      timer4_int   <= #D 1'b0;
    else if (~(|timer4_cnt))
      timer4_int   <= #D 1'b1;
  end

  assign timer_int = {timer4_int,timer3_int,timer2_int,timer1_int};

  //------------------------------------------------------------------------------
  // Watchdogs
  //------------------------------------------------------------------------------

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      wdg_cnt      <= #D 32'hFF000000;
      wdg_rst      <= #D 1'h0;
    end
    else if (~wdg_en) begin
      wdg_cnt      <= #D wdg_cnt_reg;
      wdg_rst      <= #D 1'h0;
    end
    else begin
      wdg_cnt      <= #D &wdg_cnt ? wdg_cnt : wdg_cnt + 1'b1;
      wdg_rst      <= #D &wdg_cnt ;
    end
  end

  always @(posedge pclk) begin
      wdg_rst_d0   <= #D wdg_rst;
      wdg_rst_d1   <= #D wdg_rst_d0 & wdg_rst_en;
      wdg_rst_d2   <= #D wdg_rst_d1;
      wdg_rst_d3   <= #D wdg_rst_d2;
      wdg_rst_d4   <= #D wdg_rst_d3;
      wdg_rst_d5   <= #D wdg_rst_d4;
      wdg_rst_d6   <= #D wdg_rst_d5;
      wdg_rst_d7   <= #D wdg_rst_d6;
      wdg_rst_d8   <= #D wdg_rst_d7;
      wdg_rst_d9   <= #D wdg_rst_d8;
      wdg_out_rst  <= #D wdg_rst_d2 | wdg_rst_d3 | wdg_rst_d4 | wdg_rst_d5 |
		         wdg_rst_d6 | wdg_rst_d7 | wdg_rst_d8 | wdg_rst_d9 ;
  end
   
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) 
      wdg_out_int <= #D 1'h0;
    else 
      wdg_out_int <= #D wdg_rst | wdg_rst_d0;
  end

  //------------------------------------------------------------------------------
  // PWMs
  //------------------------------------------------------------------------------
  assign count_clr[0]	= (pwm1_cnt == pwm_freq_ctrl1);
  assign count_clr[1]	= (pwm2_cnt == pwm_freq_ctrl2);
  assign count_clr[2]	= (pwm3_cnt == pwm_freq_ctrl3);
  assign count_clr[3]	= (pwm4_cnt == pwm_freq_ctrl4);
  assign count_clr[4]	= (pwm5_cnt == pwm_freq_ctrl5);

  assign pwm_tmp[0]	= (pwm_duty_ctrl1 >= pwm1_cnt);
  assign pwm_tmp[1]	= (pwm_duty_ctrl2 >= pwm2_cnt);
  assign pwm_tmp[2]	= (pwm_duty_ctrl3 >= pwm3_cnt);
  assign pwm_tmp[3]	= (pwm_duty_ctrl4 >= pwm4_cnt);
  assign pwm_tmp[4]	= (pwm_duty_ctrl5 >= pwm5_cnt);
  
  always @(posedge pclk or negedge presetn)
    if (!presetn)
      pwm1_cnt	        <=#D 24'h0;
    else if (!pwm_en[0])
      pwm1_cnt	        <=#D 24'h0;
    else if (count_clr[0])
      pwm1_cnt	        <=#D 24'h0;
    else
      pwm1_cnt	        <=#D pwm1_cnt + 1'b1;

  always @(posedge pclk or negedge presetn)
    if (!presetn)
      pwm2_cnt	        <=#D 24'h0;
    else if (!pwm_en[1])
      pwm2_cnt	        <=#D 24'h0;
    else if (count_clr[1])
      pwm2_cnt	        <=#D 24'h0;
    else
      pwm2_cnt	        <=#D pwm2_cnt + 1'b1;
 
  always @(posedge pclk or negedge presetn)
    if (!presetn)
      pwm3_cnt	        <=#D 24'h0;
    else if (!pwm_en[2])
      pwm3_cnt	        <=#D 24'h0;
    else if (count_clr[2])
      pwm3_cnt	        <=#D 24'h0;
    else
      pwm3_cnt	        <=#D pwm3_cnt + 1'b1;

  always @(posedge pclk or negedge presetn)
    if (!presetn)
      pwm4_cnt	        <=#D 24'h0;
    else if (!pwm_en[3])
      pwm4_cnt	        <=#D 24'h0;
    else if (count_clr[3])
      pwm4_cnt	        <=#D 24'h0;
    else
      pwm4_cnt	        <=#D pwm4_cnt + 1'b1;

  always @(posedge pclk or negedge presetn)
    if (!presetn)
      pwm5_cnt	        <=#D 24'h0;
    else if (!pwm_en[4])
      pwm5_cnt	        <=#D 24'h0;
    else if (count_clr[4])
      pwm5_cnt	        <=#D 24'h0;
    else
      pwm5_cnt	        <=#D pwm5_cnt + 1'b1;

  always @(posedge pclk or negedge presetn)
    if (!presetn) 
      pwm_out	        <=#D 5'b0;
    else 
      pwm_out	        <=#D pwm_tmp;

  
endmodule
