//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : Simple AHB to APB bridge
//-----------------------------------------------------------------------------
// The bridge requires PCLK synchronised to HCLK
// APB running at a clock divided from HCLK. E.g.
// - If PCLK is same as HCLK, set PCLKEN to 1
// - If PCLK is half the HCLK speed, toggle PCLKEN every HCLK cycle
// With 4 apb slave port  , aibiter by address hight bits


module ahb2apb_sbus #(
  // Parameter to define address width
  parameter     ADDRWIDTH = 32,
  parameter     REGISTER_RDATA = 1,
  parameter     REGISTER_WDATA = 0,
  parameter     APB_ADDR_HIGH_BIT = 19)
 (
// --------------------------------------------------------------------------
// Port Definitions
// --------------------------------------------------------------------------
  input  wire                 HCLK,      // Clock
  input  wire                 HRESETn,   // Reset
  input  wire                 PCLKEN,    // APB clock enable signal

  input  wire                 HSEL,      // Device select
  input  wire [ADDRWIDTH-1:0] HADDR,     // Address
  input  wire           [1:0] HTRANS,    // Transfer control
  input  wire           [2:0] HSIZE,     // Transfer size
  input  wire           [3:0] HPROT,     // Protection control
  input  wire                 HWRITE,    // Write control
  input  wire                 HREADY,    // Transfer phase done
  input  wire          [31:0] HWDATA,    // Write data

  output reg                  HREADYOUT, // Device ready
  output wire          [31:0] HRDATA,    // Read data output
  output wire                 HRESP,     // Device response


// APB Output

  output wire                 APBACTIVE, // APB bus is active, for clock gating
                                         // of APB bus
 //apb port0
  output wire [ADDRWIDTH-1:0] PADDR_0,     // APB Address
  output wire                 PENABLE_0,   // APB Enable
  output wire                 PWRITE_0,    // APB Write
  output wire           [3:0] PSTRB_0,     // APB Byte Strobe
  output wire           [2:0] PPROT_0,     // APB Prot
  output wire          [31:0] PWDATA_0,    // APB write data
  output wire                 PSEL_0,      // APB Select
  input  wire          [31:0] PRDATA_0,    // Read data for each APB slave
  input  wire                 PREADY_0,    // Ready for each APB slave
  input  wire                 PSLVERR_0,  // Error state for each APB slave

 //apb port1
  output wire [ADDRWIDTH-1:0] PADDR_1,     // APB Address
  output wire                 PENABLE_1,   // APB Enable
  output wire                 PWRITE_1,    // APB Write
  output wire           [3:0] PSTRB_1,     // APB Byte Strobe
  output wire           [2:0] PPROT_1,     // APB Prot
  output wire          [31:0] PWDATA_1,    // APB write data
  output wire                 PSEL_1,      // APB Select
  input  wire          [31:0] PRDATA_1,    // Read data for each APB slave
  input  wire                 PREADY_1,    // Ready for each APB slave
  input  wire                 PSLVERR_1 ,  // Error state for each APB slave

 //apb port2
  output wire [ADDRWIDTH-1:0] PADDR_2,     // APB Address
  output wire                 PENABLE_2,   // APB Enable
  output wire                 PWRITE_2,    // APB Write
  output wire           [3:0] PSTRB_2,     // APB Byte Strobe
  output wire           [2:0] PPROT_2,     // APB Prot
  output wire          [31:0] PWDATA_2,    // APB write data
  output wire                 PSEL_2,      // APB Select
  input  wire          [31:0] PRDATA_2,    // Read data for each APB slave
  input  wire                 PREADY_2,    // Ready for each APB slave
  input  wire                 PSLVERR_2,  // Error state for each APB slave

//apb port3
  output wire [ADDRWIDTH-1:0] PADDR_3,     // APB Address
  output wire                 PENABLE_3,   // APB Enable
  output wire                 PWRITE_3,    // APB Write
  output wire           [3:0] PSTRB_3,     // APB Byte Strobe
  output wire           [2:0] PPROT_3,     // APB Prot
  output wire          [31:0] PWDATA_3,    // APB write data
  output wire                 PSEL_3,      // APB Select
  input  wire          [31:0] PRDATA_3,    // Read data for each APB slave
  input  wire                 PREADY_3,    // Ready for each APB slave
  input  wire                 PSLVERR_3 ,  // Error state for each APB slave


//apb port4
  output wire [ADDRWIDTH-1:0] PADDR_4,     // APB Address
  output wire                 PENABLE_4,   // APB Enable
  output wire                 PWRITE_4,    // APB Write
  output wire           [3:0] PSTRB_4,     // APB Byte Strobe
  output wire           [2:0] PPROT_4,     // APB Prot
  output wire          [31:0] PWDATA_4,    // APB write data
  output wire                 PSEL_4,      // APB Select
  input  wire          [31:0] PRDATA_4,    // Read data for each APB slave
  input  wire                 PREADY_4,    // Ready for each APB slave
  input  wire                 PSLVERR_4 ,  // Error state for each APB slave


//apb port5
  output wire [ADDRWIDTH-1:0] PADDR_5,     // APB Address
  output wire                 PENABLE_5,   // APB Enable
  output wire                 PWRITE_5,    // APB Write
  output wire           [3:0] PSTRB_5,     // APB Byte Strobe
  output wire           [2:0] PPROT_5,     // APB Prot
  output wire          [31:0] PWDATA_5,    // APB write data
  output wire                 PSEL_5,      // APB Select
  input  wire          [31:0] PRDATA_5,    // Read data for each APB slave
  input  wire                 PREADY_5,    // Ready for each APB slave
  input  wire                 PSLVERR_5 ,  // Error state for each APB slave


//apb port6
 output wire [ADDRWIDTH-1:0] PADDR_6,     // APB Address
 output wire                 PENABLE_6,   // APB Enable
 output wire                 PWRITE_6,    // APB Write
 output wire           [3:0] PSTRB_6,     // APB Byte Strobe
 output wire           [2:0] PPROT_6,     // APB Prot
 output wire          [31:0] PWDATA_6,    // APB write data
 output wire                 PSEL_6,      // APB Select
 input  wire          [31:0] PRDATA_6,    // Read data for each APB slave
 input  wire                 PREADY_6,    // Ready for each APB slave
 input  wire                 PSLVERR_6 ,  // Error state for each APB slave

//apb port7
 output wire [ADDRWIDTH-1:0] PADDR_7,     // APB Address
 output wire                 PENABLE_7,   // APB Enable
 output wire                 PWRITE_7,    // APB Write
 output wire           [3:0] PSTRB_7,     // APB Byte Strobe
 output wire           [2:0] PPROT_7,     // APB Prot
 output wire          [31:0] PWDATA_7,    // APB write data
 output wire                 PSEL_7,      // APB Select
 input  wire          [31:0] PRDATA_7,    // Read data for each APB slave
 input  wire                 PREADY_7,    // Ready for each APB slave
 input  wire                 PSLVERR_7 ,  // Error state for each APB slave


//apb port8
  output wire [ADDRWIDTH-1:0] PADDR_8,     // APB Address
  output wire                 PENABLE_8,   // APB Enable
  output wire                 PWRITE_8,    // APB Write
  output wire           [3:0] PSTRB_8,     // APB Byte Strobe
  output wire           [2:0] PPROT_8,     // APB Prot
  output wire          [31:0] PWDATA_8,    // APB write data
  output wire                 PSEL_8,      // APB Select
  input  wire          [31:0] PRDATA_8,    // Read data for each APB slave
  input  wire                 PREADY_8,    // Ready for each APB slave
  input  wire                 PSLVERR_8 ,  // Error state for each APB slave


//apb port9
  output wire [ADDRWIDTH-1:0] PADDR_9,     // APB Address
  output wire                 PENABLE_9,   // APB Enable
  output wire                 PWRITE_9,    // APB Write
  output wire           [3:0] PSTRB_9,     // APB Byte Strobe
  output wire           [2:0] PPROT_9,     // APB Prot
  output wire          [31:0] PWDATA_9,    // APB write data
  output wire                 PSEL_9,      // APB Select
  input  wire          [31:0] PRDATA_9,    // Read data for each APB slave
  input  wire                 PREADY_9,    // Ready for each APB slave
  input  wire                 PSLVERR_9 ,  // Error state for each APB slave


//apb port10
  output wire [ADDRWIDTH-1:0] PADDR_10,     // APB Address
  output wire                 PENABLE_10,   // APB Enable
  output wire                 PWRITE_10,    // APB Write
  output wire           [3:0] PSTRB_10,     // APB Byte Strobe
  output wire           [2:0] PPROT_10,     // APB Prot
  output wire          [31:0] PWDATA_10,    // APB write data
  output wire                 PSEL_10,      // APB Select
  input  wire          [31:0] PRDATA_10,    // Read data for each APB slave
  input  wire                 PREADY_10,    // Ready for each APB slave
  input  wire                 PSLVERR_10 ,  // Error state for each APB slave


//apb port11
  output wire [ADDRWIDTH-1:0] PADDR_11,     // APB Address
  output wire                 PENABLE_11,   // APB Enable
  output wire                 PWRITE_11,    // APB Write
  output wire           [3:0] PSTRB_11,     // APB Byte Strobe
  output wire           [2:0] PPROT_11,     // APB Prot
  output wire          [31:0] PWDATA_11,    // APB write data
  output wire                 PSEL_11,      // APB Select
  input  wire          [31:0] PRDATA_11,    // Read data for each APB slave
  input  wire                 PREADY_11,    // Ready for each APB slave
  input  wire                 PSLVERR_11 ,  // Error state for each APB slave


//apb port12
  output wire [ADDRWIDTH-1:0] PADDR_12,     // APB Address
  output wire                 PENABLE_12,   // APB Enable
  output wire                 PWRITE_12,    // APB Write
  output wire           [3:0] PSTRB_12,     // APB Byte Strobe
  output wire           [2:0] PPROT_12,     // APB Prot
  output wire          [31:0] PWDATA_12,    // APB write data
  output wire                 PSEL_12,      // APB Select
  input  wire          [31:0] PRDATA_12,    // Read data for each APB slave
  input  wire                 PREADY_12,    // Ready for each APB slave
  input  wire                 PSLVERR_12 ,  // Error state for each APB slave


//apb port13
  output wire [ADDRWIDTH-1:0] PADDR_13,     // APB Address
  output wire                 PENABLE_13,   // APB Enable
  output wire                 PWRITE_13,    // APB Write
  output wire           [3:0] PSTRB_13,     // APB Byte Strobe
  output wire           [2:0] PPROT_13,     // APB Prot
  output wire          [31:0] PWDATA_13,    // APB write data
  output wire                 PSEL_13,      // APB Select
  input  wire          [31:0] PRDATA_13,    // Read data for each APB slave
  input  wire                 PREADY_13,    // Ready for each APB slave
  input  wire                 PSLVERR_13 ,  // Error state for each APB slave


//apb port14
  output wire [ADDRWIDTH-1:0] PADDR_14,     // APB Address
  output wire                 PENABLE_14,   // APB Enable
  output wire                 PWRITE_14,    // APB Write
  output wire           [3:0] PSTRB_14,     // APB Byte Strobe
  output wire           [2:0] PPROT_14,     // APB Prot
  output wire          [31:0] PWDATA_14,    // APB write data
  output wire                 PSEL_14,      // APB Select
  input  wire          [31:0] PRDATA_14,    // Read data for each APB slave
  input  wire                 PREADY_14,    // Ready for each APB slave
  input  wire                 PSLVERR_14 ,  // Error state for each APB slave

//apb port15
  output wire [ADDRWIDTH-1:0] PADDR_15,     // APB Address
  output wire                 PENABLE_15,   // APB Enable
  output wire                 PWRITE_15,    // APB Write
  output wire           [3:0] PSTRB_15,     // APB Byte Strobe
  output wire           [2:0] PPROT_15,     // APB Prot
  output wire          [31:0] PWDATA_15,    // APB write data
  output wire                 PSEL_15,      // APB Select
  input  wire          [31:0] PRDATA_15,    // Read data for each APB slave
  input  wire                 PREADY_15,    // Ready for each APB slave
  input  wire                 PSLVERR_15 ) ;  // Error state for each APB slave


//parameter for Addr Arbiter 
//   parameter       APB_ADDR_HIGH_BIT   = 10 ;



  // --------------------------------------------------------------------------
  // Internal wires
  // --------------------------------------------------------------------------

  reg  [ADDRWIDTH-3:0]   addr_reg;    // Address sample register
  reg                    wr_reg;      // Write control sample register
  reg            [2:0]   state_reg;   // State for finite state machine

  reg            [3:0]   pstrb_reg;   // Byte lane strobe register
  wire           [3:0]   pstrb_nxt;   // Byte lane strobe next state
  reg            [1:0]   pprot_reg;   // PPROT register
  wire           [1:0]   pprot_nxt;   // PPROT register next state

  wire                   apb_select;   // APB bridge is selected
  wire                   apb_tran_end; // Transfer is completed on APB
  reg            [2:0]   next_state;   // Next state for finite state machine
  reg           [31:0]   rwdata_reg;   // Read/Write data sample register

  wire                   reg_rdata_cfg; // REGISTER_RDATA paramater
  wire                   reg_wdata_cfg; // REGISTER_WDATA paramater

  reg                    sample_wdata_reg; // Control signal to sample HWDATA



  wire [ADDRWIDTH-1:0] PADDR   ;     // Internal APB Address
  wire                 PENABLE ;   // Internal APB Enable
  wire                 PWRITE  ;    // Internal APB Write
  wire           [3:0] PSTRB   ;     // Internal APB Byte Strobe
  wire           [2:0] PPROT   ;     // Internal APB Prot
  wire          [31:0] PWDATA  ;    // Internal APB write data
  wire                 PSEL    ;      // Internal APB Select
  wire          [31:0] PRDATA  ;    // Internal Read data for each APB slave
  wire                 PREADY  ;    // Internal Ready for each APB slave
  wire                 PSLVERR ;   // Internal Error state for each APB slave



   // -------------------------------------------------------------------------
   // State machine
   // -------------------------------------------------------------------------

   localparam ST_BITS = 3;

   localparam [ST_BITS-1:0] ST_IDLE      = 3'b000; // Idle waiting for transaction
   localparam [ST_BITS-1:0] ST_APB_WAIT  = 3'b001; // Wait APB transfer
   localparam [ST_BITS-1:0] ST_APB_TRNF  = 3'b010; // Start APB transfer
   localparam [ST_BITS-1:0] ST_APB_TRNF2 = 3'b011; // Second APB transfer cycle
   localparam [ST_BITS-1:0] ST_APB_ENDOK = 3'b100; // Ending cycle for OKAY
   localparam [ST_BITS-1:0] ST_APB_ERR1  = 3'b101; // First cycle for Error response
   localparam [ST_BITS-1:0] ST_APB_ERR2  = 3'b110; // Second cycle for Error response
   localparam [ST_BITS-1:0] ST_ILLEGAL   = 3'b111; // Illegal state

  // --------------------------------------------------------------------------
  // Start of main code
  // --------------------------------------------------------------------------
  // Configuration signal
  assign reg_rdata_cfg = (REGISTER_RDATA==0) ? 1'b0 : 1'b1;
  assign reg_wdata_cfg = (REGISTER_WDATA==0) ? 1'b0 : 1'b1;

  // Generate APB bridge select
  assign apb_select = HSEL & HTRANS[1] & HREADY;
  // Generate APB transfer ended
  assign apb_tran_end = (state_reg==3'b011) & PREADY;

  assign pprot_nxt[0] =  HPROT[1];  // (0) Normal, (1) Privileged
  assign pprot_nxt[1] = ~HPROT[0];  // (0) Data, (1) Instruction

  // Byte strobe generation
  // - Only enable for write operations
  // - For word write transfers (HSIZE[1]=1), all byte strobes are 1
  // - For hword write transfers (HSIZE[0]=1), check HADDR[1]
  // - For byte write transfers, check HADDR[1:0]
  assign pstrb_nxt[0] = HWRITE & ((HSIZE[1])|((HSIZE[0])&(~HADDR[1]))|(HADDR[1:0]==2'b00));
  assign pstrb_nxt[1] = HWRITE & ((HSIZE[1])|((HSIZE[0])&(~HADDR[1]))|(HADDR[1:0]==2'b01));
  assign pstrb_nxt[2] = HWRITE & ((HSIZE[1])|((HSIZE[0])&( HADDR[1]))|(HADDR[1:0]==2'b10));
  assign pstrb_nxt[3] = HWRITE & ((HSIZE[1])|((HSIZE[0])&( HADDR[1]))|(HADDR[1:0]==2'b11));

  // Sample control signals
  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    begin
    addr_reg  <= {(ADDRWIDTH-2){1'b0}};
    wr_reg    <= 1'b0;
    pprot_reg <= {2{1'b0}};
    pstrb_reg <= {4{1'b0}};
    end
  else if (apb_select) // Capture transfer information at the end of AHB address phase
    begin
    addr_reg  <= HADDR[ADDRWIDTH-1:2];
    wr_reg    <= HWRITE;
    pprot_reg <= pprot_nxt;
    pstrb_reg <= pstrb_nxt;
    end
  end

  // Sample write data control signal
  // Assert after write address phase, deassert after PCLKEN=1
  wire sample_wdata_set = apb_select & HWRITE & reg_wdata_cfg;
  wire sample_wdata_clr = sample_wdata_reg & PCLKEN;

  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    sample_wdata_reg <= 1'b0;
  else if (sample_wdata_set | sample_wdata_clr)
    sample_wdata_reg <= sample_wdata_set;
  end

  // Generate next state for FSM
  // Note : case 3'b111 is not used.  The design has been checked that
  //        this illegal state cannot be entered using formal verification.
  always @(state_reg or PREADY or PSLVERR or apb_select or reg_rdata_cfg or
           PCLKEN or reg_wdata_cfg or HWRITE)
    begin
    case (state_reg)
     // Idle
     ST_IDLE :
     begin
        if (PCLKEN & apb_select & ~(reg_wdata_cfg & HWRITE))
           next_state = ST_APB_TRNF; // Start APB transfer in next cycle
        else if (apb_select)
           next_state = ST_APB_WAIT; // Wait for start of APB transfer at PCLKEN high
        else
           next_state = ST_IDLE; // Remain idle
     end
     // Transfer announced on AHB, but PCLKEN was low, so waiting
     ST_APB_WAIT :
     begin
        if (PCLKEN)
           next_state = ST_APB_TRNF; // Start APB transfer in next cycle
        else
           next_state = ST_APB_WAIT; // Wait for start of APB transfer at PCLKEN high
     end
     // First APB transfer cycle
     ST_APB_TRNF :
     begin
        if (PCLKEN)
           next_state = ST_APB_TRNF2;   // Change to second cycle of APB transfer
        else
           next_state = ST_APB_TRNF;   // Change to state-2
     end
     // Second APB transfer cycle
     ST_APB_TRNF2 :
     begin
        if (PREADY & PSLVERR & PCLKEN) // Error received - Generate two cycle
           // Error response on AHB by
           next_state = ST_APB_ERR1; // Changing to state-5 and 6
        else if (PREADY & (~PSLVERR) & PCLKEN) // Okay received
        begin
           if (reg_rdata_cfg)
              // Registered version
              next_state = ST_APB_ENDOK; // Generate okay response in state 4
           else
              // Non-registered version
              next_state = {2'b00, apb_select}; // Terminate transfer
        end
        else // Slave not ready
           next_state = ST_APB_TRNF2; // Unchange
     end
     // Ending cycle for OKAY (registered response)
     ST_APB_ENDOK :
     begin
         if (PCLKEN & apb_select & ~(reg_wdata_cfg & HWRITE))
            next_state = ST_APB_TRNF; // Start APB transfer in next cycle
         else if (apb_select)
            next_state = ST_APB_WAIT; // Wait for start of APB transfer at PCLKEN high
         else
            next_state = ST_IDLE; // Remain idle
     end
     // First cycle for Error response
     ST_APB_ERR1 : next_state = ST_APB_ERR2; // Goto 2nd cycle of error response
     // Second cycle for Error response
     ST_APB_ERR2 :
     begin
        if (PCLKEN & apb_select & ~(reg_wdata_cfg & HWRITE))
           next_state = ST_APB_TRNF; // Start APB transfer in next cycle
        else if (apb_select)
           next_state = ST_APB_WAIT; // Wait for start of APB transfer at PCLKEN high
        else
           next_state = ST_IDLE; // Remain idle
     end
     default : // Not used
            next_state = 3'bxxx; // X-Propagation
    endcase
    end

  // Registering state machine
  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    state_reg <= 3'b000;
  else
    state_reg <= next_state;
  end

  // Sample PRDATA or HWDATA
  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    rwdata_reg <= {32{1'b0}};
  else
    if (sample_wdata_reg & reg_wdata_cfg & PCLKEN)
      rwdata_reg <= HWDATA;
    else if (apb_tran_end & reg_rdata_cfg & PCLKEN)
      rwdata_reg <= PRDATA;
  end

  // Connect outputs to top level
  assign PADDR   = {addr_reg, 2'b00}; // from sample register
  assign PWRITE  = wr_reg;            // from sample register
  // From sample register or from HWDATA directly
  assign PWDATA  = (reg_wdata_cfg) ? rwdata_reg : HWDATA;
  assign PSEL    = (state_reg==ST_APB_TRNF) | (state_reg==ST_APB_TRNF2);
  assign PENABLE = (state_reg==ST_APB_TRNF2);
  assign PPROT   = {pprot_reg[1], 1'b0, pprot_reg[0]};
  assign PSTRB   = pstrb_reg[3:0];

  // Generate HREADYOUT
  always @(state_reg or reg_rdata_cfg or PREADY or PSLVERR or PCLKEN)
  begin
    case (state_reg)
      ST_IDLE      : HREADYOUT = 1'b1; // Idle
      ST_APB_WAIT  : HREADYOUT = 1'b0; // Transfer announced on AHB, but PCLKEN was low, so waiting
      ST_APB_TRNF  : HREADYOUT = 1'b0; // First APB transfer cycle
         // Second APB transfer cycle:
         // if Non-registered feedback version, and APB transfer completed without error
         // Then response with ready immediately. If registered feedback version,
         // wait until state_reg==ST_APB_ENDOK
      ST_APB_TRNF2 : HREADYOUT = (~reg_rdata_cfg) & PREADY & (~PSLVERR) & PCLKEN;
      ST_APB_ENDOK : HREADYOUT = reg_rdata_cfg; // Ending cycle for OKAY (registered response only)
      ST_APB_ERR1  : HREADYOUT = 1'b0; // First cycle for Error response
      ST_APB_ERR2  : HREADYOUT = 1'b1; // Second cycle for Error response
      default: HREADYOUT = 1'bx; // x propagation (note :3'b111 is illegal state)
    endcase
  end

  // From sample register or from PRDATA directly
  assign HRDATA = (reg_rdata_cfg) ? rwdata_reg : PRDATA;
  assign HRESP  = (state_reg==ST_APB_ERR1) | (state_reg==ST_APB_ERR2);

  assign APBACTIVE = (HSEL & HTRANS[1]) | (|state_reg);

`ifdef ARM_AHB_ASSERT_ON
   // ------------------------------------------------------------
   // Assertions
   // ------------------------------------------------------------
`include "std_ovl_defines.h"
   // Capture last read APB data
  reg [31:0] ovl_last_read_apb_data_reg;
  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    ovl_last_read_apb_data_reg <= {32{1'b0}};
  else if (PREADY & PENABLE & (~PWRITE) & PSEL & PCLKEN)
    ovl_last_read_apb_data_reg <= PRDATA;
  end

  // Capture last APB response, clear at start of APB transfer
  reg        ovl_last_read_apb_resp_reg;
  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    ovl_last_read_apb_resp_reg <= 1'b0;
  else
    begin
    if (PCLKEN)
      begin
      if (PREADY & PSEL)
         ovl_last_read_apb_resp_reg <= PSLVERR & PENABLE;
      else if (PSEL)
         ovl_last_read_apb_resp_reg <= 1'b0;
      end
    end
  end

  // Create signal to indicate data phase
  reg        ovl_ahb_data_phase_reg;
  wire       ovl_ahb_data_phase_nxt = HSEL & HTRANS[1];

  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    ovl_ahb_data_phase_reg <= 1'b0;
  else if (HREADY)
    ovl_ahb_data_phase_reg <= ovl_ahb_data_phase_nxt;
  end

generate
      if(REGISTER_RDATA!=0) begin : gen_ovl_read_data_mistmatch

  // Last read APB data should be the same as HRDATA, unless there is an error response
  // (Only check if using registered read data config. Otherwise HRDATA is directly connected
  // to PRDATA so no need to have OVL check)
   assert_implication
     #(`OVL_ERROR,`OVL_ASSERT,
       "Read data mismatch")
   u_ovl_read_data_mistmatch
     (.clk(HCLK), .reset_n(HRESETn),
      .antecedent_expr(ovl_ahb_data_phase_reg & (~wr_reg) & HREADYOUT & (~HRESP)),
      .consequent_expr(ovl_last_read_apb_data_reg==HRDATA)
      );
      end
endgenerate

  // AHB response should match APB response
   assert_implication
     #(`OVL_ERROR,`OVL_ASSERT,
       "Response mismatch")
   u_ovl_resp_mistmatch
     (.clk(HCLK), .reset_n(HRESETn),
      .antecedent_expr(ovl_ahb_data_phase_reg & HREADYOUT),
      .consequent_expr(ovl_last_read_apb_resp_reg==HRESP)
      );

  // APBACTIVE should be high before and during APB transfers
   assert_implication
     #(`OVL_ERROR,`OVL_ASSERT,
       "APBACTIVE should be active when PSEL is high")
   u_ovl_apbactive_1
     (.clk(HCLK), .reset_n(HRESETn),
      .antecedent_expr(PSEL),
      .consequent_expr(APBACTIVE)
      );

   assert_implication
     #(`OVL_ERROR,`OVL_ASSERT,
       "APBACTIVE should be active when there is an active transfer (data phase)")
   u_ovl_apbactive_2
     (.clk(HCLK), .reset_n(HRESETn),
      .antecedent_expr(~HREADYOUT),
      .consequent_expr(APBACTIVE)
      );

   assert_implication
     #(`OVL_ERROR,`OVL_ASSERT,
       "APBACTIVE should be active when AHB to APB bridge is selected")
   u_ovl_apbactive_3
     (.clk(HCLK), .reset_n(HRESETn),
      .antecedent_expr((HSEL & HTRANS[1])),
      .consequent_expr(APBACTIVE)
      );

  // Create register to check a transfer on AHB side result in a transfer in APB side
  reg        ovl_transfer_started_reg;
  // Set by transfer starting, clear by PSEL
  wire       ovl_transfer_started_nxt = (HREADY & ovl_ahb_data_phase_nxt) |
                                    (ovl_transfer_started_reg & (~PSEL));

  always @(posedge HCLK or negedge HRESETn)
  begin
  if (~HRESETn)
    ovl_transfer_started_reg <= 1'b0;
  else
    ovl_transfer_started_reg <= ovl_transfer_started_nxt;
  end

  // Check a valid transfer must result in an APB transfer
   assert_never
     #(`OVL_ERROR,`OVL_ASSERT,
       "APB transfer missing.")
   u_ovl_apb_transfer_missing
     (.clk(HCLK), .reset_n(HRESETn),
      .test_expr(HREADY & ovl_ahb_data_phase_nxt & ovl_transfer_started_reg)
      );

   // Ensure state_reg must not be 3'b111
   assert_never
     #(`OVL_ERROR,`OVL_ASSERT,
       "state_reg in illegal state")
   u_ovl_rx_state_illegal
     (.clk(HCLK), .reset_n(HRESETn),
      .test_expr(state_reg==ST_ILLEGAL));

`endif


 //APB ARBITER
assign PSEL_0   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h0) ;
assign PSEL_1   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h1) ;
assign PSEL_2   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h2) ;
assign PSEL_3   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h3) ;
assign PSEL_4   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h4) ;
assign PSEL_5   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h5) ;
assign PSEL_6   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h6) ;
assign PSEL_7   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h7) ;
assign PSEL_8   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h8) ;
assign PSEL_9   =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'h9) ;
assign PSEL_10  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'ha) ;
assign PSEL_11  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'hb) ;
assign PSEL_12  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'hc) ;
assign PSEL_13  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'hd) ;
assign PSEL_14  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'he) ;
assign PSEL_15  =  PSEL &&(PADDR[APB_ADDR_HIGH_BIT:APB_ADDR_HIGH_BIT-3] == 4'hf) ;



//APB output
assign  PADDR_0      =  PADDR    ;    // APB Address
assign  PENABLE_0    =  PSEL_0&&PENABLE  ;    // APB Enable
assign  PWRITE_0     =  PSEL_0&&PWRITE   ;    // APB Write
assign  PSTRB_0      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_0      =  PPROT    ;    // APB Prot
assign  PWDATA_0     =  PWDATA   ;    // APB write data

assign  PADDR_1      =  PADDR    ;    // APB Address
assign  PENABLE_1    =  PSEL_1&&PENABLE  ;    // APB Enable
assign  PWRITE_1     =  PSEL_1&&PWRITE   ;    // APB Write
assign  PSTRB_1      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_1      =  PPROT    ;    // APB Prot
assign  PWDATA_1     =  PWDATA   ;    // APB write data

assign  PADDR_2      =  PADDR    ;    // APB Address
assign  PENABLE_2    =  PSEL_2&&PENABLE  ;    // APB Enable
assign  PWRITE_2     =  PSEL_2&&PWRITE   ;    // APB Write
assign  PSTRB_2      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_2      =  PPROT    ;    // APB Prot
assign  PWDATA_2     =  PWDATA   ;    // APB write data

assign  PADDR_3      =  PADDR    ;    // APB Address
assign  PENABLE_3    =  PSEL_3&&PENABLE  ;    // APB Enable
assign  PWRITE_3     =  PSEL_3&&PWRITE   ;    // APB Write
assign  PSTRB_3      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_3      =  PPROT    ;    // APB Prot
assign  PWDATA_3     =  PWDATA   ;    // APB write data

assign  PADDR_4      =  PADDR    ;    // APB Address
assign  PENABLE_4    =  PSEL_4&&PENABLE  ;    // APB Enable
assign  PWRITE_4     =  PSEL_4&&PWRITE   ;    // APB Write
assign  PSTRB_4      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_4      =  PPROT    ;    // APB Prot
assign  PWDATA_4     =  PWDATA   ;    // APB write data

assign  PADDR_5      =  PADDR    ;    // APB Address
assign  PENABLE_5    =  PSEL_5&&PENABLE  ;    // APB Enable
assign  PWRITE_5     =  PSEL_5&&PWRITE   ;    // APB Write
assign  PSTRB_5      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_5      =  PPROT    ;    // APB Prot
assign  PWDATA_5     =  PWDATA   ;    // APB write data

assign  PADDR_6      =  PADDR    ;    // APB Address
assign  PENABLE_6    =  PSEL_6&&PENABLE  ;    // APB Enable
assign  PWRITE_6     =  PSEL_6&&PWRITE   ;    // APB Write
assign  PSTRB_6      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_6      =  PPROT    ;    // APB Prot
assign  PWDATA_6     =  PWDATA   ;    // APB write data

assign  PADDR_7      =  PADDR    ;    // APB Address
assign  PENABLE_7    =  PSEL_7&&PENABLE  ;    // APB Enable
assign  PWRITE_7     =  PSEL_7&&PWRITE   ;    // APB Write
assign  PSTRB_7      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_7      =  PPROT    ;    // APB Prot
assign  PWDATA_7     =  PWDATA   ;    // APB write data

assign  PADDR_8      =  PADDR    ;    // APB Address
assign  PENABLE_8    =  PSEL_8&&PENABLE  ;    // APB Enable
assign  PWRITE_8     =  PSEL_8&&PWRITE   ;    // APB Write
assign  PSTRB_8      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_8      =  PPROT    ;    // APB Prot
assign  PWDATA_8     =  PWDATA   ;    // APB write data


assign  PADDR_9      =  PADDR    ;    // APB Address
assign  PENABLE_9    =  PSEL_9&&PENABLE  ;    // APB Enable
assign  PWRITE_9     =  PSEL_9&&PWRITE   ;    // APB Write
assign  PSTRB_9      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_9      =  PPROT    ;    // APB Prot
assign  PWDATA_9     =  PWDATA   ;    // APB write data

assign  PADDR_10      =  PADDR    ;    // APB Address
assign  PENABLE_10    =  PSEL_10&&PENABLE  ;    // APB Enable
assign  PWRITE_10     =  PSEL_10&&PWRITE   ;    // APB Write
assign  PSTRB_10      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_10      =  PPROT    ;    // APB Prot
assign  PWDATA_10     =  PWDATA   ;    // APB write data

assign  PADDR_11      =  PADDR    ;    // APB Address
assign  PENABLE_11    =  PSEL_11&&PENABLE  ;    // APB Enable
assign  PWRITE_11     =  PSEL_11&&PWRITE   ;    // APB Write
assign  PSTRB_11      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_11      =  PPROT    ;    // APB Prot
assign  PWDATA_11     =  PWDATA   ;    // APB write data

assign  PADDR_12      =  PADDR    ;    // APB Address
assign  PENABLE_12    =  PSEL_12&&PENABLE  ;    // APB Enable
assign  PWRITE_12     =  PSEL_12&&PWRITE   ;    // APB Write
assign  PSTRB_12      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_12      =  PPROT    ;    // APB Prot
assign  PWDATA_12     =  PWDATA   ;    // APB write data

assign  PADDR_13      =  PADDR    ;    // APB Address
assign  PENABLE_13    =  PSEL_13&&PENABLE  ;    // APB Enable
assign  PWRITE_13     =  PSEL_13&&PWRITE   ;    // APB Write
assign  PSTRB_13      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_13      =  PPROT    ;    // APB Prot
assign  PWDATA_13     =  PWDATA   ;    // APB write data


assign  PADDR_14      =  PADDR    ;    // APB Address
assign  PENABLE_14    =  PSEL_14&&PENABLE  ;    // APB Enable
assign  PWRITE_14     =  PSEL_14&&PWRITE   ;    // APB Write
assign  PSTRB_14      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_14      =  PPROT    ;    // APB Prot
assign  PWDATA_14     =  PWDATA   ;    // APB write data

assign  PADDR_15      =  PADDR    ;    // APB Address
assign  PENABLE_15    =  PSEL_15&&PENABLE  ;    // APB Enable
assign  PWRITE_15     =  PSEL_15&&PWRITE   ;    // APB Write
assign  PSTRB_15      =  PSTRB    ;    // APB Byte Strobe
assign  PPROT_15      =  PPROT    ;    // APB Prot
assign  PWDATA_15     =  PWDATA   ;    // APB write data

//APB input                                         
assign  PRDATA       = 
                       PSEL_15? PRDATA_15 :
                       PSEL_14? PRDATA_14 :
                       PSEL_13? PRDATA_13 :
                       PSEL_12? PRDATA_12 :
                       PSEL_11? PRDATA_11 :
                       PSEL_10? PRDATA_10 :
                       PSEL_9? PRDATA_9 :
                       PSEL_8? PRDATA_8 :
                       PSEL_7? PRDATA_7 :
                       PSEL_6? PRDATA_6 :
                       PSEL_5? PRDATA_5 :
                       PSEL_4? PRDATA_4 :
                       PSEL_3? PRDATA_3 :
		       PSEL_2? PRDATA_2 :
		       PSEL_1? PRDATA_1 :PRDATA_0  ;    // Read data for each APB slave

assign  PREADY       = 
		       PSEL_15? PREADY_15 :
		       PSEL_14? PREADY_14 :
		       PSEL_13? PREADY_13 :
		       PSEL_12? PREADY_12 :
		       PSEL_11? PREADY_11 :
		       PSEL_10? PREADY_10 :
		       PSEL_9? PREADY_9 :
		       PSEL_8? PREADY_8 :
		       PSEL_7? PREADY_7 :
		       PSEL_6? PREADY_6 :
		       PSEL_5? PREADY_5 :
		       PSEL_4? PREADY_4 :
		       PSEL_3? PREADY_3 :
                       PSEL_2? PREADY_2 :
		       PSEL_1? PREADY_1 :PREADY_0  ;    // Ready for each APB slave


assign  PSLVERR      = 
	               PSEL_15? PSLVERR_15:
	               PSEL_14? PSLVERR_14:
	               PSEL_13? PSLVERR_13:
	               PSEL_12? PSLVERR_12:
	               PSEL_11? PSLVERR_11:
	               PSEL_10? PSLVERR_10:
	               PSEL_9? PSLVERR_9:
	               PSEL_8? PSLVERR_8:
	               PSEL_7? PSLVERR_7:
	               PSEL_6? PSLVERR_6:
	               PSEL_5? PSLVERR_5:
	               PSEL_4? PSLVERR_4:
	               PSEL_3? PSLVERR_3:
		       PSEL_2? PSLVERR_2:
		       PSEL_1? PSLVERR_1:PSLVERR_0 ;    // Error state for each APB slave




endmodule
