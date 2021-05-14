//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract :  AHB SBUS to APB bridge
//-----------------------------------------------------------------------------
// The bridge requires PCLK synchronised to HCLK
// APB running at a clock divided from HCLK. E.g.
// - If PCLK is same as HCLK, set PCLKEN to 1
// - If PCLK is half the HCLK speed, toggle PCLKEN every HCLK cycle
// With 4 apb slave port  , aibiter by address hight bits


module ahb_sbus_itf #(
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
  input  wire [ADDRWIDTH-1:0] HADDR,     // Address
  input  wire           [1:0] HTRANS,    // Transfer control
  input  wire           [2:0] HSIZE,     // Transfer size
  input  wire           [3:0] HPROT,     // Protection control
  input  wire                 HWRITE,    // Write control
  input  wire          [31:0] HWDATA,    // Write data

  output wire                 HREADYOUT, // Device ready
  output wire          [31:0] HRDATA,    // Read data output
  output wire                 HRESP,     // Device response


// APB Output

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
  input  wire                 PSLVERR_1,  // Error state for each APB slave

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
  input  wire                 PSLVERR_3 , // Error state for each APB slave


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

  

// --------------------------------------------------------------------------
// Internal wires
// --------------------------------------------------------------------------


// --------------------------------------------------------------------------
// main logic 
// --------------------------------------------------------------------------


ahb2apb_sbus  #(

  // Parameter to define address width
  // 16 = 2^16 = 64KB APB address space
  // APB_ADDR_HIGH_BIT is for addr decode with multi slave ports
           .ADDRWIDTH         (ADDRWIDTH         ),
           .REGISTER_RDATA    (REGISTER_RDATA    ),
           .REGISTER_WDATA    (REGISTER_WDATA    ),
           .APB_ADDR_HIGH_BIT (APB_ADDR_HIGH_BIT ))
 u_ahb2apb_sbus (
         .HCLK      (HCLK      ) ,      // Clock
         .HRESETn   (HRESETn   ) ,   // Reset
         .PCLKEN    (1'h1      ) ,    // APB clock enable signal
         .HSEL      (1'h1      ) ,      // Device select
         .HADDR     (HADDR     ) ,     // Address
         .HTRANS    (HTRANS    ) ,    // Transfer control
         .HSIZE     (HSIZE     ) ,     // Transfer size
         .HPROT     (HPROT     ) ,     // Protection control
         .HWRITE    (HWRITE    ) ,    // Write control
         .HREADY    (1'h1      ) ,    // Transfer phase done
         .HWDATA    (HWDATA    ) ,    // Write data
         .HREADYOUT (HREADYOUT ) , // Device ready
         .HRDATA    (HRDATA    ) ,    // Read data output
         .HRESP     (HRESP     ) ,     // Device response
         .APBACTIVE (          ) , // APB bus is active, for clock gating
 //apb port0                                       
         .PADDR_0   (PADDR_0   ) ,     // APB Address
         .PENABLE_0 (PENABLE_0 ) ,   // APB Enable
         .PWRITE_0  (PWRITE_0  ) ,    // APB Write
         .PSTRB_0   (PSTRB_0   ) ,     // APB Byte Strobe
         .PPROT_0   (PPROT_0   ) ,     // APB Prot
         .PWDATA_0  (PWDATA_0  ) ,    // APB write data
         .PSEL_0    (PSEL_0    ) ,      // APB Select
         .PRDATA_0  (PRDATA_0  ) ,    // Read data for each APB slave
         .PREADY_0  (PREADY_0  ) ,    // Ready for each APB slave
         .PSLVERR_0 (1'b0      ) ,  // Error state for each APB slave

 //apb port1
         .PADDR_1   (PADDR_1  ) ,     // APB Address
         .PENABLE_1 (PENABLE_1) ,   // APB Enable
         .PWRITE_1  (PWRITE_1 ) ,    // APB Write
         .PSTRB_1   (PSTRB_1  ) ,     // APB Byte Strobe
         .PPROT_1   (PPROT_1  ) ,     // APB Prot
         .PWDATA_1  (PWDATA_1 ) ,    // APB write data
         .PSEL_1    (PSEL_1   ) ,      // APB Select
         .PRDATA_1  (PRDATA_1 ) ,    // Read data for each APB slave
         .PREADY_1  (PREADY_1 ) ,    // Ready for each APB slave
         .PSLVERR_1 (1'b0     ) ,  // Error state for each APB slave
                                                   
 //apb port2                                       
         .PADDR_2   (PADDR_2  ) ,     // APB Address
         .PENABLE_2 (PENABLE_2) ,   // APB Enable
         .PWRITE_2  (PWRITE_2 ) ,    // APB Write
         .PSTRB_2   (PSTRB_2  ) ,     // APB Byte Strobe
         .PPROT_2   (PPROT_2  ) ,     // APB Prot
         .PWDATA_2  (PWDATA_2 ) ,    // APB write data
         .PSEL_2    (PSEL_2   ) ,      // APB Select
         .PRDATA_2  (PRDATA_2 ) ,    // Read data for each APB slave
         .PREADY_2  (PREADY_2 ) ,    // Ready for each APB slave
         .PSLVERR_2 (1'b0     ) ,  // Error state for each APB slave
                                                   
//apb port3                                        
         .PADDR_3   (PADDR_3  ) , // APB Address
         .PENABLE_3 (PENABLE_3) ,   // APB Enable
         .PWRITE_3  (PWRITE_3 ) ,    // APB Write
         .PSTRB_3   (PSTRB_3  ) ,     // APB Byte Strobe
         .PPROT_3   (PPROT_3  ) ,     // APB Prot
         .PWDATA_3  (PWDATA_3 ) ,    // APB write data
         .PSEL_3    (PSEL_3   ) ,      // APB Select
         .PRDATA_3  (PRDATA_3 ) ,    // Read data for each APB slave
         .PREADY_3  (PREADY_3 ) ,    // Ready for each APB slave
         .PSLVERR_3 (1'b0     ) ,  // Error state for each APB slav

//apb port4                                        
         .PADDR_4   (PADDR_4  ) , // APB Address
         .PENABLE_4 (PENABLE_4) ,   // APB Enable
         .PWRITE_4  (PWRITE_4 ) ,    // APB Write
         .PSTRB_4   (PSTRB_4  ) ,     // APB Byte Strobe
         .PPROT_4   (PPROT_4  ) ,     // APB Prot
         .PWDATA_4  (PWDATA_4 ) ,    // APB write data
         .PSEL_4    (PSEL_4   ) ,      // APB Select
         .PRDATA_4  (PRDATA_4 ) ,    // Read data for each APB slave
         .PREADY_4  (PREADY_4 ) ,    // Ready for each APB slave
         .PSLVERR_4 (1'b0     ) ,  // Error state for each APB slav

//apb port5                                        
         .PADDR_5   (PADDR_5  ) , // APB Address
         .PENABLE_5 (PENABLE_5) ,   // APB Enable
         .PWRITE_5  (PWRITE_5 ) ,    // APB Write
         .PSTRB_5   (PSTRB_5  ) ,     // APB Byte Strobe
         .PPROT_5   (PPROT_5  ) ,     // APB Prot
         .PWDATA_5  (PWDATA_5 ) ,    // APB write data
         .PSEL_5    (PSEL_5   ) ,      // APB Select
         .PRDATA_5  (PRDATA_5 ) ,    // Read data for each APB slave
         .PREADY_5  (PREADY_5 ) ,    // Ready for each APB slave
         .PSLVERR_5 (1'b0     ) ,  // Error state for each APB slav

//apb port6                                        
         .PADDR_6   (PADDR_6  ) , // APB Address
         .PENABLE_6 (PENABLE_6) ,   // APB Enable
         .PWRITE_6  (PWRITE_6 ) ,    // APB Write
         .PSTRB_6   (PSTRB_6  ) ,     // APB Byte Strobe
         .PPROT_6   (PPROT_6  ) ,     // APB Prot
         .PWDATA_6  (PWDATA_6 ) ,    // APB write data
         .PSEL_6    (PSEL_6   ) ,      // APB Select
         .PRDATA_6  (PRDATA_6 ) ,    // Read data for each APB slave
         .PREADY_6  (PREADY_6 ) ,    // Ready for each APB slave
         .PSLVERR_6 (1'b0     ) ,  // Error state for each APB slav

//apb port7                                        
         .PADDR_7   (PADDR_7  ) , // APB Address
         .PENABLE_7 (PENABLE_7) ,   // APB Enable
         .PWRITE_7  (PWRITE_7 ) ,    // APB Write
         .PSTRB_7   (PSTRB_7  ) ,     // APB Byte Strobe
         .PPROT_7   (PPROT_7  ) ,     // APB Prot
         .PWDATA_7  (PWDATA_7 ) ,    // APB write data
         .PSEL_7    (PSEL_7   ) ,      // APB Select
         .PRDATA_7  (PRDATA_7 ) ,    // Read data for each APB slave
         .PREADY_7  (PREADY_7 ) ,    // Ready for each APB slave
         .PSLVERR_7 (1'b0     ) ,  // Error state for each APB slav


//apb port8                                        
         .PADDR_8   (PADDR_8  ) , // APB Address
         .PENABLE_8 (PENABLE_8) ,   // APB Enable
         .PWRITE_8  (PWRITE_8 ) ,    // APB Write
         .PSTRB_8   (PSTRB_8  ) ,     // APB Byte Strobe
         .PPROT_8   (PPROT_8  ) ,     // APB Prot
         .PWDATA_8  (PWDATA_8 ) ,    // APB write data
         .PSEL_8    (PSEL_8   ) ,      // APB Select
         .PRDATA_8  (PRDATA_8 ) ,    // Read data for each APB slave
         .PREADY_8  (PREADY_8 ) ,    // Ready for each APB slave
         .PSLVERR_8 (1'b0     ) ,  // Error state for each APB slav

//apb port9                                        
         .PADDR_9   (PADDR_9  ) , // APB Address
         .PENABLE_9 (PENABLE_9) ,   // APB Enable
         .PWRITE_9  (PWRITE_9 ) ,    // APB Write
         .PSTRB_9   (PSTRB_9  ) ,     // APB Byte Strobe
         .PPROT_9   (PPROT_9  ) ,     // APB Prot
         .PWDATA_9  (PWDATA_9 ) ,    // APB write data
         .PSEL_9    (PSEL_9   ) ,      // APB Select
         .PRDATA_9  (PRDATA_9 ) ,    // Read data for each APB slave
         .PREADY_9  (PREADY_9 ) ,    // Ready for each APB slave
         .PSLVERR_9 (1'b0     ) ,  // Error state for each APB slav

//apb port10                                        
         .PADDR_10   (PADDR_10  ) , // APB Address
         .PENABLE_10 (PENABLE_10) ,   // APB Enable
         .PWRITE_10  (PWRITE_10 ) ,    // APB Write
         .PSTRB_10   (PSTRB_10  ) ,     // APB Byte Strobe
         .PPROT_10   (PPROT_10  ) ,     // APB Prot
         .PWDATA_10  (PWDATA_10 ) ,    // APB write data
         .PSEL_10    (PSEL_10   ) ,      // APB Select
         .PRDATA_10  (PRDATA_10 ) ,    // Read data for each APB slave
         .PREADY_10  (PREADY_10 ) ,    // Ready for each APB slave
         .PSLVERR_10 (1'b0     ) ,  // Error state for each APB slav

//apb port11                                        
         .PADDR_11   (PADDR_11  ) , // APB Address
         .PENABLE_11 (PENABLE_11) ,   // APB Enable
         .PWRITE_11  (PWRITE_11 ) ,    // APB Write
         .PSTRB_11   (PSTRB_11  ) ,     // APB Byte Strobe
         .PPROT_11   (PPROT_11  ) ,     // APB Prot
         .PWDATA_11  (PWDATA_11 ) ,    // APB write data
         .PSEL_11    (PSEL_11   ) ,      // APB Select
         .PRDATA_11  (PRDATA_11 ) ,    // Read data for each APB slave
         .PREADY_11  (PREADY_11 ) ,    // Ready for each APB slave
         .PSLVERR_11 (1'b0     ) ,  // Error state for each APB slav

//apb port12                                        
         .PADDR_12   (PADDR_12  ) , // APB Address
         .PENABLE_12 (PENABLE_12) ,   // APB Enable
         .PWRITE_12  (PWRITE_12 ) ,    // APB Write
         .PSTRB_12   (PSTRB_12  ) ,     // APB Byte Strobe
         .PPROT_12   (PPROT_12  ) ,     // APB Prot
         .PWDATA_12  (PWDATA_12 ) ,    // APB write data
         .PSEL_12    (PSEL_12   ) ,      // APB Select
         .PRDATA_12  (PRDATA_12 ) ,    // Read data for each APB slave
         .PREADY_12  (PREADY_12 ) ,    // Ready for each APB slave
         .PSLVERR_12 (1'b0     ) ,  // Error state for each APB slav

//apb port13                                        
         .PADDR_13   (PADDR_13  ) , // APB Address
         .PENABLE_13 (PENABLE_13) ,   // APB Enable
         .PWRITE_13  (PWRITE_13 ) ,    // APB Write
         .PSTRB_13   (PSTRB_13  ) ,     // APB Byte Strobe
         .PPROT_13   (PPROT_13  ) ,     // APB Prot
         .PWDATA_13  (PWDATA_13 ) ,    // APB write data
         .PSEL_13    (PSEL_13   ) ,      // APB Select
         .PRDATA_13  (PRDATA_13 ) ,    // Read data for each APB slave
         .PREADY_13  (PREADY_13 ) ,    // Ready for each APB slave
         .PSLVERR_13 (1'b0     ) ,  // Error state for each APB slav

//apb port14                                        
         .PADDR_14   (PADDR_14  ) , // APB Address
         .PENABLE_14 (PENABLE_14) ,   // APB Enable
         .PWRITE_14  (PWRITE_14 ) ,    // APB Write
         .PSTRB_14   (PSTRB_14  ) ,     // APB Byte Strobe
         .PPROT_14   (PPROT_14  ) ,     // APB Prot
         .PWDATA_14  (PWDATA_14 ) ,    // APB write data
         .PSEL_14    (PSEL_14   ) ,      // APB Select
         .PRDATA_14  (PRDATA_14 ) ,    // Read data for each APB slave
         .PREADY_14  (PREADY_14 ) ,    // Ready for each APB slave
         .PSLVERR_14 (1'b0     ) ,  // Error state for each APB slav


//apb port15                                        
         .PADDR_15   (PADDR_15  ) , // APB Address
         .PENABLE_15 (PENABLE_15) ,   // APB Enable
         .PWRITE_15  (PWRITE_15 ) ,    // APB Write
         .PSTRB_15   (PSTRB_15  ) ,     // APB Byte Strobe
         .PPROT_15   (PPROT_15  ) ,     // APB Prot
         .PWDATA_15  (PWDATA_15 ) ,    // APB write data
         .PSEL_15    (PSEL_15   ) ,      // APB Select
         .PRDATA_15  (PRDATA_15 ) ,    // Read data for each APB slave
         .PREADY_15  (PREADY_15 ) ,    // Ready for each APB slave
         .PSLVERR_15 (1'b0     )   // Error state for each APB slav


);


endmodule








