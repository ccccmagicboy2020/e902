
module apb2sram   #(
               parameter  AW = 32,    
               parameter  M_AW = 13,  //8KB
               parameter  M_DW = 32 )
   
                           (
				pclk				,
				preset_n			,

				psel				,
				paddr				,
				penable				,
				pwrite				,
                                pstrb                           ,
				pwdata				,
				prdata				,
				pready				,

				mem_cen				,
				mem_wen				,
				mem_addr			,
				mem_wdata			,
				mem_rdata					
);


//------------------------------------------------------------------------------
// Parameter
//------------------------------------------------------------------------------
parameter  D = 1;

//------------------------------------------------------------------------------
// Port
//------------------------------------------------------------------------------
input			pclk				;
input			preset_n			;

input			psel				;
input	[AW-1:0]	paddr				;
input			penable				;
input			pwrite				;
input   [ 3:0]          pstrb                           ;
input	[31:0]		pwdata				;
output	[31:0]		prdata				;
output			pready				;

output			mem_cen				;
output	[ 3:0]		mem_wen				;
output	[M_AW-1:2]	mem_addr			;
output	[M_DW-1:0]	mem_wdata			;
input	[M_DW-1:0]	mem_rdata			;

wire			pready				;

//------------------------------------------------------------------------------
// Internal Signal
//------------------------------------------------------------------------------
wire	            valid			;
wire [M_DW-1:0]	    mem_wdata			;
wire [31:0]	    prdata			;


//------------------------------------------------------------------------------
// Main
//------------------------------------------------------------------------------
// Only respond to valid APB transfers
assign valid		= (psel & (~penable));
// The enable signal is set when the register is addressed and PWRITE is set.
assign writeregen	= valid &  pwrite;
assign readregen	= valid & ~pwrite;

assign mem_cen		= ~valid;
assign mem_wen[0]       = ~(writeregen & pstrb[0]);
assign mem_wen[1]       = ~(writeregen & pstrb[1]);
assign mem_wen[2]       = ~(writeregen & pstrb[2]);
assign mem_wen[3]       = ~(writeregen & pstrb[3]);
assign mem_addr		= paddr[M_AW-1:2];
assign mem_wdata        = pwdata         ;
assign prdata           = mem_rdata      ;


assign pready   = 1  ;



endmodule
