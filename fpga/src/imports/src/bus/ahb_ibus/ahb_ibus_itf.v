//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract :  AHB IBUS Interface with apb if and sram if 
//-----------------------------------------------------------------------------
// The bridge requires PCLK synchronised to HCLK
// APB running at a clock divided from HCLK. E.g.
// - If PCLK is same as HCLK, set PCLKEN to 1
// - If PCLK is half the HCLK speed, toggle PCLKEN every HCLK cycle
// With one sram  port and one slave port , aibiter by address hight bits


module ahb_ibus_itf #(
  // Parameter to define address width
  parameter     ADDRWIDTH = 32,
  parameter     REGISTER_RDATA = 1,
  parameter     REGISTER_WDATA = 0,
  parameter     SRAM_ADDR_WIDTH=13,//sram size 13: 8K, 12:4k
  parameter     SRAM_DATA_WIDTH = 32,
  parameter     APB_ADDR_HIGH_BIT = 22)
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

  input  wire                 addr_switch,
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

//sram inteface
output		         	mem_cen				,
output		        [3:0]   mem_wen				,
output	[SRAM_ADDR_WIDTH-1:2]	mem_addr			,
output	[SRAM_DATA_WIDTH-1:0]	mem_wdata			,
input	[SRAM_DATA_WIDTH-1:0]	mem_rdata			

) ;

// --------------------------------------------------------------------------
// Internal wires
// --------------------------------------------------------------------------



 wire [ADDRWIDTH-1:0] PADDR_1   ;     // APB Address
 wire                 PENABLE_1 ;   // APB Enable
 wire                 PWRITE_1  ;    // APB Write
 wire           [3:0] PSTRB_1   ;     // APB Byte Strobe
 wire           [2:0] PPROT_1   ;     // APB Prot
 wire          [31:0] PWDATA_1  ;    // APB write data
 wire                 PSEL_1    ;      // APB Select
 wire          [31:0] PRDATA_1  ;    // Read data for each APB slave
 wire                 PREADY_1  ;    // Ready for each APB slave






// --------------------------------------------------------------------------
// main logic 
// --------------------------------------------------------------------------


ahb2apb_ibus  #(

  // Parameter to define address width
  // 16 = 2^16 = 64KB APB address space
  // APB_ADDR_HIGH_BIT is for addr decode with multi slave ports
           .ADDRWIDTH         ( ADDRWIDTH         ),
           .REGISTER_RDATA    ( REGISTER_RDATA    ),
           .REGISTER_WDATA    ( REGISTER_WDATA    ),
           .APB_ADDR_HIGH_BIT ( APB_ADDR_HIGH_BIT ))
 u_ahb2apb_ibus (
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

         .addr_switch(addr_switch),

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
         .PSLVERR_1 (1'b0     )   // Error state for each APB slave
);





 apb2sram   #(.AW   (ADDRWIDTH) ,
              .M_AW (SRAM_ADDR_WIDTH) , //8KB 
	      .M_DW (SRAM_DATA_WIDTH) )    
		  
             u_apb2sram(
				.pclk				(HCLK	       ),
				.preset_n			(HRESETn       ),
                                                                                
				.psel				(PSEL_1	       ),
				.paddr				(PADDR_1       ),
				.penable			(PENABLE_1     ),
				.pwrite				(PWRITE_1      ),
                                .pstrb                          (PSTRB_1       ),
				.pwdata				(PWDATA_1      ),
				.prdata				(PRDATA_1      ),
				.pready				(PREADY_1      ),
                                                                              
				.mem_cen		        (mem_cen	),
				.mem_wen		        (mem_wen	),
				.mem_addr		        (mem_addr	),
				.mem_wdata		        (mem_wdata	),
				.mem_rdata			(mem_rdata      )	                                     
				
);







  






endmodule








