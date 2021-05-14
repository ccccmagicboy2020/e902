
module top_reg_apb
       (
        pclk                ,                 
        presetn             ,              
        penable             ,              
        psel                ,                 
        pwrite              ,               
        paddr               ,                
        pwdata              ,               
	
	sys_info            ,
        status              ,               
  	outputreg4          ,
  	outputreg5          ,
  	outputreg6          ,
  	outputreg7          ,
  	outputreg8          ,
  	outputreg9          ,
  	outputrega          ,
  	outputregb          ,
  	outputregc          ,
  	outputregd          ,
  	outputrege          ,
  	outputregf          ,
  	outputreg10         ,
//  	outputreg11         ,
//  	outputreg12         ,
//  	outputreg13         ,
//  	outputreg14         ,
//  	outputreg15         ,
//  	outputreg16         ,
//  	outputreg17         ,
//  	outputreg18         ,
//  	outputreg19         ,
//  	outputreg1a         ,
//  	outputreg1b         ,
//  	outputreg1c         ,
//  	outputreg1d         ,
//  	outputreg1e         ,
//  	outputreg1f         ,
	
        gpin                ,               
        gpout               ,               
        gpioen              ,               
        prdata              ,               
        pready              ,                

        sadc_data           ,
        vco_cnt             ,

        iu_pad_gpr_data     ,//out  [31:0]                   
        iu_pad_gpr_index    ,//out  [4 :0]                   
        iu_pad_gpr_we       ,//out                  
        iu_pad_inst_retire  ,//out               
        iu_pad_inst_split   ,//out               
        iu_pad_retire_pc    ,//out  [31:0] 
        cp0_pad_mcause      ,//out  [31:0]                     
        cp0_pad_mintstatus  ,//out  [31:0]                  
        cp0_pad_mstatus     ,//out  [31:0]                                      
        cpu_pad_lockup      ,//out
        had_pad_jdb_pm      ,  
        sysio_pad_lpmd_b    ,

        treg_int_clr	    ,
        treg_int_clr_en	    ,
	treg_int_sta	    ,//Interrupt status
	treg_int_msk	    ,//Interrupt mask
	treg_int_trg	     //Interrupt trigger
       );

  input         pclk        ;         
  input         presetn     ;      
  input         penable     ;      
  input         psel        ;         
  input         pwrite      ;       
  input  [11:2] paddr       ;        
  input  [31:0] pwdata      ;       
  
  input  [31:0] status      ;       
  input	 [63:0] sys_info    ;

  input  [23:0] gpin        ;         
  output [23:0] gpout       ;        
  output [23:0] gpioen      ;       
  output [31:0] outputreg4  ;
  output [31:0] outputreg5  ;
  output [31:0] outputreg6  ;
  output [31:0] outputreg7  ;
  output [31:0] outputreg8  ;
  output [31:0] outputreg9  ;
  output [31:0] outputrega  ;
  output [31:0] outputregb  ;
  output [31:0] outputregc  ;
  output [31:0] outputregd  ;
  output [31:0] outputrege  ;
  output [31:0] outputregf  ;
  output [31:0] outputreg10 ;
/*
  output [31:0] outputreg11 ;
  output [31:0] outputreg12 ;
  output [31:0] outputreg13 ;
  output [31:0] outputreg14 ;
  output [31:0] outputreg15 ;
  output [31:0] outputreg16 ;
  output [31:0] outputreg17 ;
  output [31:0] outputreg18 ;
  output [31:0] outputreg19 ;
  output [31:0] outputreg1a ;
  output [31:0] outputreg1b ;
  output [31:0] outputreg1c ;
  output [31:0] outputreg1d ;
  output [31:0] outputreg1e ;
  output [31:0] outputreg1f ;
*/  
  output [31:0] prdata      ;        
  output        pready      ;        

  input  [11:0] sadc_data   ;
  input  [23:0] vco_cnt     ;

  input  [31:0] iu_pad_gpr_data;//out  [31:0]                   
  input  [ 4:0] iu_pad_gpr_index;//out  [4 :0]                   
  input         iu_pad_gpr_we;//out                  
  input         iu_pad_inst_retire;//out               
  input         iu_pad_inst_split;//out               
  input  [31:0] iu_pad_retire_pc;//out  [31:0] 
  input  [31:0] cp0_pad_mcause;//out  [31:0]                     
  input  [31:0] cp0_pad_mintstatus;//out  [31:0]                  
  input  [31:0] cp0_pad_mstatus;//out  [31:0]                                  
  input         cpu_pad_lockup;//out 
  input  [ 1:0] had_pad_jdb_pm;  
  input  [ 1:0] sysio_pad_lpmd_b;

  output [ 4:0] treg_int_clr;
  output        treg_int_clr_en;
  input	 [ 4:0]	treg_int_sta;
  output [ 4:0]	treg_int_msk;
  output [14:0]	treg_int_trg;

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
  parameter  D = 0       ;
  parameter
    ADDRREG0 =  6'b000000,    
    ADDRREG1 =  6'b000001,    
    ADDRREG2 =  6'b000010,    
    ADDRREG3 =  6'b000011,    

    ADDRREG4  = 6'b000100,    
    ADDRREG5  = 6'b000101,
    ADDRREG6  = 6'b000110,
    ADDRREG7  = 6'b000111,
    ADDRREG8  = 6'b001000,
    ADDRREG9  = 6'b001001,
    ADDRREGA  = 6'b001010,
    ADDRREGB  = 6'b001011,
    ADDRREGC  = 6'b001100,
    ADDRREGD  = 6'b001101,
    ADDRREGE  = 6'b001110,
    ADDRREGF  = 6'b001111,

    ADDRREG10 = 6'b010000,
    ADDRREG11 = 6'b010001,
    ADDRREG12 = 6'b010010,
    ADDRREG13 = 6'b010011,
    ADDRREG14 = 6'b010100,    
    ADDRREG15 = 6'b010101,
    ADDRREG16 = 6'b010110,
    ADDRREG17 = 6'b010111,
    ADDRREG18 = 6'b011000,
    ADDRREG19 = 6'b011001,
    ADDRREG1A = 6'b011010,
    ADDRREG1B = 6'b011011,
    ADDRREG1C = 6'b011100,
    ADDRREG1D = 6'b011101,
    ADDRREG1E = 6'b011110,
    ADDRREG1F = 6'b011111,

    ADDRREG20 = 6'b100000,
    ADDRREG21 = 6'b100001,
    ADDRREG22 = 6'b100010, 
    ADDRREG23 = 6'b100011, 
    ADDRREG24 = 6'b100100,
    ADDRREG25 = 6'b100101,
    ADDRREG26 = 6'b100110,
    ADDRREG27 = 6'b100111,
    ADDRREG28 = 6'b101000,
    ADDRREG29 = 6'b101001,
    ADDRREG2A = 6'b101010, 
    ADDRREG2B = 6'b101011,
    ADDRREG2C = 6'b101100, 
    ADDRREG2D = 6'b101101,
    ADDRREG2E = 6'b101110, 
    ADDRREG2F = 6'b101111,

    ADDRREG30 = 6'b110000,
    ADDRREG31 = 6'b110001,
    ADDRREG32 = 6'b110010, 
    ADDRREG33 = 6'b110011,
    ADDRREG34 = 6'b110100,
    ADDRREG35 = 6'b110101,
    ADDRREG36 = 6'b110110,
    ADDRREG37 = 6'b110111,
    ADDRREG38 = 6'b111000, 
    ADDRREG39 = 6'b111001,
    ADDRREG3A = 6'b111010,
    ADDRREG3B = 6'b111011,
    ADDRREG3C = 6'b111100,
    ADDRREG3D = 6'b111101;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  reg    [31:0] prdata      ;

// internal signals
  wire          valid       ;
  wire          r0en        ;  
  wire          r4en        ;
  wire          r5en        ;
  wire          r6en        ;
  wire          r7en        ;
  wire          r8en        ;
  wire          r9en        ;
  wire          raen        ;
  wire          rben        ;
  wire          rcen        ;
  wire          rden        ;
  wire          reen        ;
  wire          rfen        ;
  wire          r10en       ;
/*
  wire          r11en       ;
  wire          r12en       ;
  wire          r13en       ;
  wire          r14en       ;
  wire          r15en       ;
  wire          r16en       ;
  wire          r17en       ;
  wire          r18en       ;
  wire          r19en       ;
  wire          r1aen       ;
  wire          r1ben       ;
  wire          r1cen       ;
  wire          r1den       ;
  wire          r1een       ;
  wire          r1fen       ;
  wire          r20en       ;
  wire          r21en       ;
  wire          r22en       ;
  wire          r23en       ;
  wire          r24en       ;
  wire          r25en       ;
  wire          r26en       ;
  wire          r27en       ;
  wire          r28en       ;
  wire          r29en       ;
  wire          r2aen       ;
  wire          r2ben       ;
  wire          r2cen       ;
  wire          r2den       ;
  wire          r2een       ;
  wire          r2fen       ;
*/
  wire          r30en       ;
  wire          r31en       ;
  wire          r32en       ;
  wire          r33en       ;
  wire          r34en       ;

  reg    [31:0] outputreg4  ;
  reg    [31:0] outputreg5  ;
  reg    [31:0] outputreg6  ;
  reg    [31:0] outputreg7  ;
  reg    [31:0] outputreg8  ;
  reg    [31:0] outputreg9  ;
  reg    [31:0] outputrega  ;
  reg    [31:0] outputregb  ;
  reg    [31:0] outputregc  ;
  reg    [31:0] outputregd  ;
  reg    [31:0] outputrege  ;
  reg    [31:0] outputregf  ;
  reg    [31:0] outputreg10 ;
/*
  reg    [31:0] outputreg11 ;
  reg    [31:0] outputreg12 ;
  reg    [31:0] outputreg13 ;
  reg    [31:0] outputreg14 ;
  reg    [31:0] outputreg15 ;
  reg    [31:0] outputreg16 ;
  reg    [31:0] outputreg17 ;
  reg    [31:0] outputreg18 ;
  reg    [31:0] outputreg19 ;
  reg    [31:0] outputreg1a ;
  reg    [31:0] outputreg1b ;
  reg    [31:0] outputreg1c ;
  reg    [31:0] outputreg1d ;
  reg    [31:0] outputreg1e ;
  reg    [31:0] outputreg1f ;
  reg    [31:0] outputreg20 ;
  reg    [31:0] outputreg21 ;
  reg    [31:0] outputreg22 ;
  reg    [31:0] outputreg23 ;
  reg    [31:0] outputreg24 ;
  reg    [31:0] outputreg25 ;
  reg    [31:0] outputreg26 ;
  reg    [31:0] outputreg27 ;
  reg    [31:0] outputreg28 ;
  reg    [31:0] outputreg29 ;
  reg    [31:0] outputreg2a ;
  reg    [31:0] outputreg2b ;
  reg    [31:0] outputreg2c ;
  reg    [31:0] outputreg2d ;
  reg    [31:0] outputreg2e ;
  reg    [31:0] outputreg2f ;
*/
  reg    [31:0] statusreg   ;
  reg    [31:0] readregs    ;
  wire          readregen   ;

  reg	 [23:0] gpout       ;
  reg	 [23:0] gpioen      ;

  reg    [ 4:0] treg_int_clr;
  reg           treg_int_clr_en;
  reg	 [ 4:0]	treg_int_msk;
  reg	 [14:0]	treg_int_trg;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
// Only respond to valid APB transfers
  assign valid = psel & (!penable);

//------------------------------------------------------------------------------
// Internal register address decoding
//------------------------------------------------------------------------------
// The enable signal is set when the register is addressed and PWRITE is set.
  assign r0en  = (paddr[7:2] == ADDRREG0) & valid & pwrite;
 
  assign r4en  = (paddr[7:2] == ADDRREG4) & valid & pwrite;
  assign r5en  = (paddr[7:2] == ADDRREG5) & valid & pwrite;
  assign r6en  = (paddr[7:2] == ADDRREG6) & valid & pwrite;
  assign r7en  = (paddr[7:2] == ADDRREG7) & valid & pwrite;
  assign r8en  = (paddr[7:2] == ADDRREG8) & valid & pwrite;
  assign r9en  = (paddr[7:2] == ADDRREG9) & valid & pwrite;
  assign raen  = (paddr[7:2] == ADDRREGA) & valid & pwrite;
  assign rben  = (paddr[7:2] == ADDRREGB) & valid & pwrite;
  assign rcen  = (paddr[7:2] == ADDRREGC) & valid & pwrite;
  assign rden  = (paddr[7:2] == ADDRREGD) & valid & pwrite;
  assign reen  = (paddr[7:2] == ADDRREGE) & valid & pwrite;
  assign rfen  = (paddr[7:2] == ADDRREGF) & valid & pwrite;
  assign r10en = (paddr[7:2] == ADDRREG10)& valid & pwrite;
/*
  assign r11en = (paddr[7:2] == ADDRREG11)& valid & pwrite;
  assign r12en = (paddr[7:2] == ADDRREG12)& valid & pwrite;
  assign r13en = (paddr[7:2] == ADDRREG13)& valid & pwrite;
  assign r14en = (paddr[7:2] == ADDRREG14)& valid & pwrite;
  assign r15en = (paddr[7:2] == ADDRREG15)& valid & pwrite;
  assign r16en = (paddr[7:2] == ADDRREG16)& valid & pwrite;
  assign r17en = (paddr[7:2] == ADDRREG17)& valid & pwrite;
  assign r18en = (paddr[7:2] == ADDRREG18)& valid & pwrite;
  assign r19en = (paddr[7:2] == ADDRREG19)& valid & pwrite;
  assign r1aen = (paddr[7:2] == ADDRREG1A)& valid & pwrite;
  assign r1ben = (paddr[7:2] == ADDRREG1B)& valid & pwrite;
  assign r1cen = (paddr[7:2] == ADDRREG1C)& valid & pwrite;
  assign r1den = (paddr[7:2] == ADDRREG1D)& valid & pwrite;
  assign r1een = (paddr[7:2] == ADDRREG1E)& valid & pwrite;
  assign r1fen = (paddr[7:2] == ADDRREG1F)& valid & pwrite;

  assign r20en = (paddr[7:2] == ADDRREG20)& valid & pwrite;
  assign r21en = (paddr[7:2] == ADDRREG21)& valid & pwrite;
  assign r22en = (paddr[7:2] == ADDRREG22)& valid & pwrite;
  assign r23en = (paddr[7:2] == ADDRREG23)& valid & pwrite;
  assign r24en = (paddr[7:2] == ADDRREG24)& valid & pwrite;
  assign r25en = (paddr[7:2] == ADDRREG25)& valid & pwrite;
  assign r26en = (paddr[7:2] == ADDRREG26)& valid & pwrite;
  assign r27en = (paddr[7:2] == ADDRREG27)& valid & pwrite;
  assign r28en = (paddr[7:2] == ADDRREG28)& valid & pwrite;
  assign r29en = (paddr[7:2] == ADDRREG29)& valid & pwrite;
  assign r2aen = (paddr[7:2] == ADDRREG2A)& valid & pwrite;
  assign r2ben = (paddr[7:2] == ADDRREG2B)& valid & pwrite;
  assign r2cen = (paddr[7:2] == ADDRREG2C)& valid & pwrite;
  assign r2den = (paddr[7:2] == ADDRREG2D)& valid & pwrite;
  assign r2een = (paddr[7:2] == ADDRREG2E)& valid & pwrite;
  assign r2fen = (paddr[7:2] == ADDRREG2F)& valid & pwrite;
*/
  assign r30en = (paddr[7:2] == ADDRREG30)& valid & pwrite; // GPIO and GPIO Interrupt not potect
  assign r31en = (paddr[7:2] == ADDRREG31)& valid & pwrite;
  assign r32en = (paddr[7:2] == ADDRREG32)& valid & pwrite;
  assign r33en = (paddr[7:2] == ADDRREG33)& valid & pwrite;
  assign r34en = (paddr[7:2] == ADDRREG34)& valid & pwrite;
 
//------------------------------------------------------------------------------
// Read/write registers 0
//------------------------------------------------------------------------------
  always @(posedge pclk or negedge presetn)
    if (!presetn) begin
      outputreg4        <= #D 32'h0;
      outputreg5        <= #D 32'h55040005;
      outputreg6        <= #D 32'h5400;
      outputreg7        <= #D 32'h0;
      outputreg8        <= #D 32'b0;
      outputreg9        <= #D 32'h0;
      outputrega        <= #D 32'h0;
      outputregb        <= #D 32'h0;
      outputregc        <= #D 32'h0;
      outputregd        <= #D 32'h0;
      outputrege        <= #D 32'h0;
      outputregf        <= #D 32'h0;
      outputreg10       <= #D 32'b0;
/*
      outputreg11       <= #D 32'b0;
      outputreg12       <= #D 32'b0;
      outputreg13       <= #D 32'b0;
      outputreg14       <= #D 32'h0;
      outputreg15       <= #D 32'h0;
      outputreg16       <= #D 32'h0;
      outputreg17       <= #D 32'h0;
      outputreg18       <= #D 32'h0;
      outputreg19       <= #D 32'h0;
      outputreg1a       <= #D 32'h0;
      outputreg1b       <= #D 32'h0;
      outputreg1c       <= #D 32'h0;
      outputreg1d       <= #D 32'h0;
      outputreg1e       <= #D 32'h0;
      outputreg1f       <= #D 32'h0;
      outputreg20       <= #D 32'h0;
      outputreg21       <= #D 32'h0;
      outputreg22       <= #D 32'h0;
      outputreg23       <= #D 32'h0;
      outputreg24       <= #D 32'h0;
      outputreg25       <= #D 32'h0;
      outputreg26       <= #D 32'h0;
      outputreg27       <= #D 32'h0;
      outputreg28       <= #D 32'h0;
      outputreg29       <= #D 32'h0;
      outputreg2a       <= #D 32'h0;
      outputreg2b       <= #D 32'h0;
      outputreg2c       <= #D 32'h0;
      outputreg2d       <= #D 32'h0;
      outputreg2e       <= #D 32'h0;
      outputreg2f       <= #D 32'h0;
*/
      gpout             <= #D 24'b0;
      gpioen            <= #D 24'hffffff;
      treg_int_msk	<= #D 5'h1F;
      treg_int_trg	<= #D 15'b0;
      treg_int_clr	<= #D 5'h0;
      treg_int_clr_en	<= #D 1'b0;
    end
    else begin
      outputreg4        <= #D r4en  ? pwdata : outputreg4 ;
      outputreg5        <= #D r5en  ? pwdata : outputreg5 ;
      outputreg6        <= #D r6en  ? pwdata : outputreg6 ;
      outputreg7        <= #D r7en  ? pwdata : outputreg7 ;
      outputreg8        <= #D r8en  ? pwdata : outputreg8 ;
      outputreg9        <= #D r9en  ? pwdata : outputreg9 ;
      outputrega        <= #D raen  ? pwdata : outputrega ;
      outputregb        <= #D rben  ? pwdata : outputregb ;
      outputregc        <= #D rcen  ? pwdata : outputregc ;
      outputregd        <= #D rden  ? pwdata : outputregd ;
      outputrege        <= #D reen  ? pwdata : outputrege ;
      outputregf        <= #D rfen  ? pwdata : outputregf ;
      outputreg10       <= #D r10en ? pwdata : outputreg10;
/*
      outputreg11       <= #D r11en ? pwdata : outputreg11;
      outputreg12       <= #D r12en ? pwdata : outputreg12;
      outputreg13       <= #D r13en ? pwdata : outputreg13;
      outputreg14       <= #D r14en ? pwdata : outputreg14;
      outputreg15       <= #D r15en ? pwdata : outputreg15;
      outputreg16       <= #D r16en ? pwdata : outputreg16;
      outputreg17       <= #D r17en ? pwdata : outputreg17;
      outputreg18       <= #D r18en ? pwdata : outputreg18;
      outputreg19       <= #D r19en ? pwdata : outputreg19;
      outputreg1a       <= #D r1aen ? pwdata : outputreg1a;
      outputreg1b       <= #D r1ben ? pwdata : outputreg1b;
      outputreg1c       <= #D r1cen ? pwdata : outputreg1c;
      outputreg1d       <= #D r1den ? pwdata : outputreg1d;
      outputreg1e       <= #D r1een ? pwdata : outputreg1e;
      outputreg1f       <= #D r1fen ? pwdata : outputreg1f;
      outputreg20       <= #D r20en ? pwdata : outputreg20;
      outputreg21       <= #D r21en ? pwdata : outputreg21;
      outputreg22       <= #D r22en ? pwdata : outputreg22;
      outputreg23       <= #D r23en ? pwdata : outputreg23;
      outputreg24       <= #D r24en ? pwdata : outputreg24;
      outputreg25       <= #D r25en ? pwdata : outputreg25;
      outputreg26       <= #D r26en ? pwdata : outputreg26;
      outputreg27       <= #D r27en ? pwdata : outputreg27;
      outputreg28       <= #D r28en ? pwdata : outputreg28;
      outputreg29       <= #D r29en ? pwdata : outputreg29;
      outputreg2a       <= #D r2aen ? pwdata : outputreg2a;
      outputreg2b       <= #D r2ben ? pwdata : outputreg2b;
      outputreg2c       <= #D r2cen ? pwdata : outputreg2c;
      outputreg2d       <= #D r2den ? pwdata : outputreg2d;
      outputreg2e       <= #D r2een ? pwdata : outputreg2e;
      outputreg2f       <= #D r2fen ? pwdata : outputreg2f;
*/
      gpout             <= #D r30en ? pwdata[23:0] : gpout;
      gpioen            <= #D r31en ? pwdata[23:0] : gpioen;
      treg_int_msk	<= #D r32en ? pwdata[4:0]  : treg_int_msk;
      treg_int_trg	<= #D r33en ? pwdata[14:0] : treg_int_trg;
      treg_int_clr	<= #D r34en ? pwdata[4:0]  : treg_int_clr;
      treg_int_clr_en	<= #D r34en ;
    end



//------------------------------------------------------------------------------
// only read Register update(example status)
//------------------------------------------------------------------------------
  always @ (posedge pclk or negedge presetn)
    if (!presetn)
      statusreg       <= #D 32'b0;
    else
      statusreg       <= #D status;

//------------------------------------------------------------------------------
// PRDATA generation
//------------------------------------------------------------------------------
  always @ (*)
    begin : p_readregsgen
      // determine the next value of readregs
      case (paddr[7:2])
        ADDRREG0  : readregs = sys_info[31:0];
        ADDRREG1  : readregs = sys_info[63:32];
        ADDRREG2  : readregs = statusreg;

        ADDRREG4  : readregs = outputreg4;
        ADDRREG5  : readregs = outputreg5;
        ADDRREG6  : readregs = outputreg6;
        ADDRREG7  : readregs = outputreg7;
        ADDRREG8  : readregs = outputreg8;
        ADDRREG9  : readregs = outputreg9;
        ADDRREGA  : readregs = outputrega;
        ADDRREGB  : readregs = outputregb;
        ADDRREGC  : readregs = outputregc;
        ADDRREGD  : readregs = outputregd;
        ADDRREGE  : readregs = outputrege;
        ADDRREGF  : readregs = outputregf;
        ADDRREG10 : readregs = outputreg10;
        ADDRREG11 : readregs = {8'h0,vco_cnt};
/*
        ADDRREG12 : readregs = outputreg12;
        ADDRREG13 : readregs = outputreg13;
        ADDRREG14 : readregs = outputreg14;
        ADDRREG15 : readregs = outputreg15;
        ADDRREG16 : readregs = outputreg16;
        ADDRREG17 : readregs = outputreg17;
        ADDRREG18 : readregs = outputreg18;
        ADDRREG19 : readregs = outputreg19;
        ADDRREG1A : readregs = outputreg1a;
        ADDRREG1B : readregs = outputreg1b;
        ADDRREG1C : readregs = outputreg1c;
	ADDRREG1D : readregs = outputreg1d;
	ADDRREG1E : readregs = outputreg1e;
        ADDRREG1F : readregs = outputreg1f;
        ADDRREG20 : readregs = outputreg20;
        ADDRREG21 : readregs = outputreg21;
        ADDRREG22 : readregs = outputreg22;
        ADDRREG23 : readregs = outputreg23;
        ADDRREG24 : readregs = outputreg24;
        ADDRREG25 : readregs = outputreg25;
        ADDRREG26 : readregs = outputreg26;
        ADDRREG27 : readregs = outputreg27;
        ADDRREG28 : readregs = outputreg28;
        ADDRREG29 : readregs = outputreg29;
        ADDRREG2A : readregs = outputreg2a;
        ADDRREG2B : readregs = outputreg2b;
        ADDRREG2C : readregs = outputreg2c;
        ADDRREG2D : readregs = outputreg2d;
        ADDRREG2E : readregs = outputreg2e;
        ADDRREG2F : readregs = outputreg2f;
*/
        ADDRREG30 : readregs = {8'h0,gpin};   
        ADDRREG31 : readregs = {8'h0,gpioen}; 
        ADDRREG32 : readregs = {27'h0,treg_int_msk};
        ADDRREG33 : readregs = {17'h0,treg_int_trg};
        ADDRREG34 : readregs = {27'h0,treg_int_clr};
        ADDRREG35 : readregs = {27'h0,treg_int_sta};

        ADDRREG36 : readregs = iu_pad_gpr_data; 
        ADDRREG37 : readregs = {24'h0,iu_pad_inst_split,iu_pad_inst_retire,iu_pad_gpr_we,iu_pad_gpr_index};                  
        ADDRREG38 : readregs = iu_pad_retire_pc; 
        ADDRREG39 : readregs = cp0_pad_mcause;                     
        ADDRREG3A : readregs = cp0_pad_mintstatus;                  
        ADDRREG3B : readregs = cp0_pad_mstatus;                                        
        ADDRREG3C : readregs = {27'h0,had_pad_jdb_pm,sysio_pad_lpmd_b,cpu_pad_lockup};
        ADDRREG3D : readregs = sadc_data;         
        default   : readregs = 32'b0 ;  // read as zero default
      endcase
    end

  assign readregen = valid & (~pwrite);

  always @ (posedge pclk or negedge presetn) begin
      if ((!presetn))
        prdata        <= #D 32'b0;
      else if (readregen)
        prdata        <= #D readregs;
  end

  assign pready = 1'b1;


endmodule


