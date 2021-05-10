//
// File name   : pmu_bus.v
//
// Description : PMU APB interface
//
// Author      : Liangzujun
//
// History     :
//   2021/3/5  : first created
//

module pmu_bus (
        pclk                  ,                 
        presetn               ,
              
        penable               ,              
        psel                  ,                 
        pwrite                ,               
        paddr                 ,                
        pwdata                ,               
        prdata                ,               
        pready                ,
        
        pmu_ack               ,              
        pmu_pvalid            ,
        pmu_pwrite            ,
        pmu_paddr             ,
        pmu_pwdata            ,
        pmu_prdata          
       );

  input         pclk          ;          
  input         presetn       ;      
  input         penable       ;       
  input         psel          ;         
  input         pwrite        ;       
  input  [ 7:2] paddr         ;        
  input  [31:0] pwdata        ;       
  output [31:0] prdata        ;        
  output        pready        ;  

  input         pmu_ack       ;              
  output        pmu_pvalid    ;
  output        pmu_pwrite    ;
  output [ 7:2] pmu_paddr     ;
  output [31:0] pmu_pwdata    ;
  input  [31:0] pmu_prdata    ;          

  //------------------------------------------------------------------------------
  // Constant declarations
  //------------------------------------------------------------------------------
  parameter D = 0             ;
        
  //------------------------------------------------------------------------------
  // Signal declarations
  //------------------------------------------------------------------------------
  wire          valid         ;   
  reg    [31:0] prdata        ;
  reg           pready        ;
  reg		pvalid_ack_sync0;
  reg		pvalid_ack_sync1;
  reg		pvalid_ack_sync2;
  reg		pmu_pvalid    ;
//reg	 [39:0]	w_mem_q       ;
      

  //------------------------------------------------------------------------------
  // Beginning of main code
  //------------------------------------------------------------------------------
  assign valid     =  psel & (!penable);  

  always @(posedge pclk or negedge presetn)
    if (!presetn)
      prdata       <= #D 32'b0;
    else if (~pwrite & pvalid_ack_sync1 & ~pvalid_ack_sync2)
      prdata       <= #D pmu_prdata; 

  always @ (posedge pclk or negedge presetn)
    if (!presetn)
      pready       <= #D 1'b1;
    else
      pready       <= #D valid ? 1'b0 : pvalid_ack_sync1 & ~pvalid_ack_sync2 ? 1'b1 : pready;

  always @ (posedge pclk or negedge presetn)
    if (!presetn) begin
      pvalid_ack_sync0 <= #D 1'b0;
      pvalid_ack_sync1 <= #D 1'b0;
      pvalid_ack_sync2 <= #D 1'b0;
      pmu_pvalid       <= #D 1'b0;
    end
    else begin
      pvalid_ack_sync0 <= #D pmu_ack;//slow clk domain
      pvalid_ack_sync1 <= #D pvalid_ack_sync0;
      pvalid_ack_sync2 <= #D pvalid_ack_sync1;
      pmu_pvalid       <= #D pvalid_ack_sync1 ? 1'b0 : valid ? 1'b1 : pmu_pvalid;
    end

/*
  always @(posedge pclk or negedge presetn)
    if (!presetn) 
      w_mem_d		<= #D 39'h0;
    else if (valid)
      w_mem_d	        <= #D {pwrite,paddr[7:2],pwdata};

  assign pmu_pwrite  = w_mem_d[38];
  assign pmu_paddr   = w_mem_d[37:32];
  assign pmu_pwdata  = w_mem_d[31:0];
*/
  assign pmu_pwrite  = pwrite;
  assign pmu_paddr   = paddr;
  assign pmu_pwdata  = pwdata;
 
endmodule
