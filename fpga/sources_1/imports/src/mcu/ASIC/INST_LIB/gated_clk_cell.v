// ****************************************************************************
// *                                                                          *
// * C-Sky Microsystems Confidential                                          *
// * -------------------------------                                          *
// * This file and all its contents are properties of C-Sky Microsystems. The *
// * information contained herein is confidential and proprietary and is not  *
// * to be disclosed outside of C-Sky Microsystems except under a             *
// * Non-Disclosure Agreement (NDA).                                          *
// *                                                                          *
// ****************************************************************************
//FILE NAME       : gated_clk_cell
//AUTHOR          : Jiebing Wang
//FUNCTION        : This module models the gated clock macro cell.
//RESET           : 
//DFT             :
//DFP             :  
//VERIFICATION    : 
//RELEASE HISTORY :
//$Id: gated_clk_cell.vp,v 1.4 2019/11/01 03:21:55 weidy Exp $
// ****************************************************************************

module gated_clk_cell(
  clk_in,
  global_en,
  module_en,
  local_en,
  external_en,
  pad_yy_gate_clk_en_b,
  clk_out
);

input  clk_in;
input  global_en;
input  module_en;
input  local_en;
input  external_en;
input  pad_yy_gate_clk_en_b;
output clk_out;
/*
wire   clk_en_bf_latch;
wire   SE;

assign clk_en_bf_latch = (global_en && (module_en || local_en)) || external_en ;

// SE driven from primary input, held constant
assign SE	       = pad_yy_gate_clk_en_b;
 
//   &Instance("gated_cell","x_gated_clk_cell");
// //   &Connect(    .clk_in           (clk_in), @50
// //                .SE               (SE), @51
// //                .external_en      (clk_en_bf_latch), @52
// //                .clk_out          (clk_out) @53
// //                ) ; @54
GCKHBQX8AH6 x_gated_clk_cell(
.CK(clk_in),
.TE(SE),
.E(clk_en_bf_latch),
.Q(clk_out));
*/
assign clk_out = clk_in;

endmodule   
