//
// File name    : pic.v
//
// Description  : interrupt generator
//
//
// History      : 
//   2020/12/07 : First created 
//

module pic (
  gresetn	      ,
  gclk		      ,
  presetn	      ,
  pclk		      ,
  pclk_phase	      ,

  // source of interrput
  src_int00	      ,// source of interrupt 6 per channel

  // int clear
  int_clr_en          ,
  clr_ints	      ,

  // registers
  int_sub00_msk       ,
  int_sub00_trg       ,
  int_sub00_sta       ,

  // Output interrupt
  out_int	
  );

  parameter PIC_INT_NUM	= 16	                ;
  parameter D           = 1                     ;

  input		                gresetn		;
  input		                gclk		;
  input		                presetn		;
  input		                pclk		;
  input		                pclk_phase	;

  input	[PIC_INT_NUM-1:0]	src_int00	;

  input		                int_clr_en	;
  input	[PIC_INT_NUM-1:0]	clr_ints	;

  input	[PIC_INT_NUM-1:0]	int_sub00_msk	;
  input	[3*PIC_INT_NUM-1:0]	int_sub00_trg	;
  output[PIC_INT_NUM-1:0]	int_sub00_sta	;

  output	                out_int		;
 
  /********************************************************************************/
  /* Generate the actual triggers *************************************************/
  /********************************************************************************/
  reg	[PIC_INT_NUM-1:0]	src_int00_psync	;
  reg	[PIC_INT_NUM-1:0]	src_int00_glat	;
  reg	[PIC_INT_NUM-1:0]	src_int00_sync1	;
  reg	[PIC_INT_NUM-1:0]	src_int00_sync2	;

  integer m                                 ;

  always @(posedge gclk or negedge gresetn) begin
    if (!gresetn) begin
      src_int00_glat	    <=#D 'h0;
      src_int00_psync	    <=#D 'h0;
    end
    else begin
      for(m=0; m<=PIC_INT_NUM-1; m=m+1) begin
      	src_int00_glat[m]   <=#D src_int00[m] ? 1'b1 : pclk_phase ? 1'b0 : src_int00_glat[m];
     	src_int00_psync[m]  <=#D pclk_phase   ? src_int00_glat[m] : src_int00_psync[m];
     end
    end
  end

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      src_int00_sync1	    <=#D 'h0;
      src_int00_sync2	    <=#D 'h0;
    end
    else begin
      src_int00_sync1	    <=#D src_int00_psync;
      src_int00_sync2	    <=#D src_int00_sync1;
    end
  end
    	
  // trigger (replace the function trigger)
  function trigger;
    input int_trg2,int_trg1,int_trg0,int_sync1,int_sync2;
    reg   edge_irq, level_irq;
  begin
      edge_irq  = ({int_trg1,int_trg0} == 2'b00) ? (int_sync1 & ~int_sync2) : 
      		      ({int_trg1,int_trg0} == 2'b01) ? (int_sync2 & ~int_sync1) :
      		      (int_sync1 & ~int_sync2) | (int_sync2 & ~int_sync1) ;

      level_irq = int_trg0 ? ~int_sync2 : int_sync2;

      trigger   = int_trg2 ? edge_irq   : level_irq;
  end
  endfunction

  reg  [PIC_INT_NUM-1:0] int00_event;
  integer n;
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      int00_event           <=#D 'h0;
    end
    else begin
      for(n=0; n<=PIC_INT_NUM-1; n=n+1) begin
      	int00_event[n]      <=#D trigger(int_sub00_trg[3*n+2], int_sub00_trg[3*n+1], int_sub00_trg[3*n], src_int00_sync1[n], src_int00_sync2[n]);
     end
    end
  end

  /********************************************************************************/
  /* Generate the sub interrupt table *********************************************/
  /********************************************************************************/
  reg	[PIC_INT_NUM-1:0]	int_sub00_sta	;

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      int_sub00_sta	        <=#D 'h0;
    end
    else begin
      int_sub00_sta	        <=#D int_clr_en ? (int_sub00_sta & ~clr_ints) | int00_event : int_sub00_sta | int00_event;
    end
  end

  /********************************************************************************/
  /* Generate the interrupt table *************************************************/
  /********************************************************************************/
  reg		out_int		;

  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
	  out_int	            <=#D 'h0;
    end
    else begin
	  out_int	            <=#D |(int_sub00_sta & ~int_sub00_msk);
	end
  end

endmodule
