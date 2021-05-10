// FE Release Version: 2.5.0 
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2021 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Single-Port Register File
//
//      Instance Name:              RF1_128_50
//      Words:                      128
//      Bits:                       50
//      Mux:                        2
//      Drive:                      4
//      Write Mask:                 Off
//      Extra Margin Adjustment:    Off
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  Off
//
//      Creation Date:  Tue Feb  2 18:08:26 2021
//      Version: 	r0p0
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`ifdef ARM_UD_MODEL

`timescale 1 ns/1 ps

`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif

`celldefine
`ifdef POWER_PINS
module RF1_128_50 (Q, CLK, CEN, WEN, A, D, VDD, VSS);
`else
module RF1_128_50 (Q, CLK, CEN, WEN, A, D);
`endif

  parameter BITS = 50;
  parameter WORDS = 128;
  parameter MUX = 2;
  parameter MEM_WIDTH = 100;
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 50 ;
  parameter UPM_WIDTH = 3;

  output [49:0] Q;
  input  CLK;
  input  CEN;
  input  WEN;
  input [6:0] A;
  input [49:0] D;
`ifdef POWER_PINS
  inout VDD;
  inout VSS;
`endif

  integer row_address;
  integer mux_address;
  reg [99:0] mem [0:63];
  reg [99:0] row;
  reg LAST_CLK;
  reg [99:0] data_out;
  reg [99:0] row_mask;
  reg [99:0] new_data;
  reg [49:0] Q_int;
  reg [49:0] writeEnable;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire [49:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire  WEN_;
  reg  WEN_int;
  wire [6:0] A_;
  reg [6:0] A_int;
  wire [49:0] D_;
  reg [49:0] D_int;

  assign Q[0] = Q_[0]; 
  assign Q[1] = Q_[1]; 
  assign Q[2] = Q_[2]; 
  assign Q[3] = Q_[3]; 
  assign Q[4] = Q_[4]; 
  assign Q[5] = Q_[5]; 
  assign Q[6] = Q_[6]; 
  assign Q[7] = Q_[7]; 
  assign Q[8] = Q_[8]; 
  assign Q[9] = Q_[9]; 
  assign Q[10] = Q_[10]; 
  assign Q[11] = Q_[11]; 
  assign Q[12] = Q_[12]; 
  assign Q[13] = Q_[13]; 
  assign Q[14] = Q_[14]; 
  assign Q[15] = Q_[15]; 
  assign Q[16] = Q_[16]; 
  assign Q[17] = Q_[17]; 
  assign Q[18] = Q_[18]; 
  assign Q[19] = Q_[19]; 
  assign Q[20] = Q_[20]; 
  assign Q[21] = Q_[21]; 
  assign Q[22] = Q_[22]; 
  assign Q[23] = Q_[23]; 
  assign Q[24] = Q_[24]; 
  assign Q[25] = Q_[25]; 
  assign Q[26] = Q_[26]; 
  assign Q[27] = Q_[27]; 
  assign Q[28] = Q_[28]; 
  assign Q[29] = Q_[29]; 
  assign Q[30] = Q_[30]; 
  assign Q[31] = Q_[31]; 
  assign Q[32] = Q_[32]; 
  assign Q[33] = Q_[33]; 
  assign Q[34] = Q_[34]; 
  assign Q[35] = Q_[35]; 
  assign Q[36] = Q_[36]; 
  assign Q[37] = Q_[37]; 
  assign Q[38] = Q_[38]; 
  assign Q[39] = Q_[39]; 
  assign Q[40] = Q_[40]; 
  assign Q[41] = Q_[41]; 
  assign Q[42] = Q_[42]; 
  assign Q[43] = Q_[43]; 
  assign Q[44] = Q_[44]; 
  assign Q[45] = Q_[45]; 
  assign Q[46] = Q_[46]; 
  assign Q[47] = Q_[47]; 
  assign Q[48] = Q_[48]; 
  assign Q[49] = Q_[49]; 
  assign CLK_ = CLK;
  assign CEN_ = CEN;
  assign WEN_ = WEN;
  assign A_[0] = A[0];
  assign A_[1] = A[1];
  assign A_[2] = A[2];
  assign A_[3] = A[3];
  assign A_[4] = A[4];
  assign A_[5] = A[5];
  assign A_[6] = A[6];
  assign D_[0] = D[0];
  assign D_[1] = D[1];
  assign D_[2] = D[2];
  assign D_[3] = D[3];
  assign D_[4] = D[4];
  assign D_[5] = D[5];
  assign D_[6] = D[6];
  assign D_[7] = D[7];
  assign D_[8] = D[8];
  assign D_[9] = D[9];
  assign D_[10] = D[10];
  assign D_[11] = D[11];
  assign D_[12] = D[12];
  assign D_[13] = D[13];
  assign D_[14] = D[14];
  assign D_[15] = D[15];
  assign D_[16] = D[16];
  assign D_[17] = D[17];
  assign D_[18] = D[18];
  assign D_[19] = D[19];
  assign D_[20] = D[20];
  assign D_[21] = D[21];
  assign D_[22] = D[22];
  assign D_[23] = D[23];
  assign D_[24] = D[24];
  assign D_[25] = D[25];
  assign D_[26] = D[26];
  assign D_[27] = D[27];
  assign D_[28] = D[28];
  assign D_[29] = D[29];
  assign D_[30] = D[30];
  assign D_[31] = D[31];
  assign D_[32] = D[32];
  assign D_[33] = D[33];
  assign D_[34] = D[34];
  assign D_[35] = D[35];
  assign D_[36] = D[36];
  assign D_[37] = D[37];
  assign D_[38] = D[38];
  assign D_[39] = D[39];
  assign D_[40] = D[40];
  assign D_[41] = D[41];
  assign D_[42] = D[42];
  assign D_[43] = D[43];
  assign D_[44] = D[44];
  assign D_[45] = D[45];
  assign D_[46] = D[46];
  assign D_[47] = D[47];
  assign D_[48] = D[48];
  assign D_[49] = D[49];

  assign `ARM_UD_SEQ Q_ = Q_int;

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (^{CEN_int} === 1'bx) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~{50{WEN_int}};
      Q_int = ((writeEnable & D_int) | (~writeEnable & {50{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 1'b1);
      row_address = (A_int >> 1);
      if (row_address >= 64)
        row = {100{1'bx}};
      else
        row = mem[row_address];
      writeEnable = ~{50{WEN_int}};
      row_mask =  ( {1'b0, writeEnable[49], 1'b0, writeEnable[48], 1'b0, writeEnable[47],
          1'b0, writeEnable[46], 1'b0, writeEnable[45], 1'b0, writeEnable[44], 1'b0, writeEnable[43],
          1'b0, writeEnable[42], 1'b0, writeEnable[41], 1'b0, writeEnable[40], 1'b0, writeEnable[39],
          1'b0, writeEnable[38], 1'b0, writeEnable[37], 1'b0, writeEnable[36], 1'b0, writeEnable[35],
          1'b0, writeEnable[34], 1'b0, writeEnable[33], 1'b0, writeEnable[32], 1'b0, writeEnable[31],
          1'b0, writeEnable[30], 1'b0, writeEnable[29], 1'b0, writeEnable[28], 1'b0, writeEnable[27],
          1'b0, writeEnable[26], 1'b0, writeEnable[25], 1'b0, writeEnable[24], 1'b0, writeEnable[23],
          1'b0, writeEnable[22], 1'b0, writeEnable[21], 1'b0, writeEnable[20], 1'b0, writeEnable[19],
          1'b0, writeEnable[18], 1'b0, writeEnable[17], 1'b0, writeEnable[16], 1'b0, writeEnable[15],
          1'b0, writeEnable[14], 1'b0, writeEnable[13], 1'b0, writeEnable[12], 1'b0, writeEnable[11],
          1'b0, writeEnable[10], 1'b0, writeEnable[9], 1'b0, writeEnable[8], 1'b0, writeEnable[7],
          1'b0, writeEnable[6], 1'b0, writeEnable[5], 1'b0, writeEnable[4], 1'b0, writeEnable[3],
          1'b0, writeEnable[2], 1'b0, writeEnable[1], 1'b0, writeEnable[0]} << mux_address);
      new_data =  ( {1'b0, D_int[49], 1'b0, D_int[48], 1'b0, D_int[47], 1'b0, D_int[46],
          1'b0, D_int[45], 1'b0, D_int[44], 1'b0, D_int[43], 1'b0, D_int[42], 1'b0, D_int[41],
          1'b0, D_int[40], 1'b0, D_int[39], 1'b0, D_int[38], 1'b0, D_int[37], 1'b0, D_int[36],
          1'b0, D_int[35], 1'b0, D_int[34], 1'b0, D_int[33], 1'b0, D_int[32], 1'b0, D_int[31],
          1'b0, D_int[30], 1'b0, D_int[29], 1'b0, D_int[28], 1'b0, D_int[27], 1'b0, D_int[26],
          1'b0, D_int[25], 1'b0, D_int[24], 1'b0, D_int[23], 1'b0, D_int[22], 1'b0, D_int[21],
          1'b0, D_int[20], 1'b0, D_int[19], 1'b0, D_int[18], 1'b0, D_int[17], 1'b0, D_int[16],
          1'b0, D_int[15], 1'b0, D_int[14], 1'b0, D_int[13], 1'b0, D_int[12], 1'b0, D_int[11],
          1'b0, D_int[10], 1'b0, D_int[9], 1'b0, D_int[8], 1'b0, D_int[7], 1'b0, D_int[6],
          1'b0, D_int[5], 1'b0, D_int[4], 1'b0, D_int[3], 1'b0, D_int[2], 1'b0, D_int[1],
          1'b0, D_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      Q_int = {data_out[98], data_out[96], data_out[94], data_out[92], data_out[90],
        data_out[88], data_out[86], data_out[84], data_out[82], data_out[80], data_out[78],
        data_out[76], data_out[74], data_out[72], data_out[70], data_out[68], data_out[66],
        data_out[64], data_out[62], data_out[60], data_out[58], data_out[56], data_out[54],
        data_out[52], data_out[50], data_out[48], data_out[46], data_out[44], data_out[42],
        data_out[40], data_out[38], data_out[36], data_out[34], data_out[32], data_out[30],
        data_out[28], data_out[26], data_out[24], data_out[22], data_out[20], data_out[18],
        data_out[16], data_out[14], data_out[12], data_out[10], data_out[8], data_out[6],
        data_out[4], data_out[2], data_out[0]};
    end
  end
  endtask

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
`endif
    if (CLK_ === 1'bx && (CEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      WEN_int = WEN_;
      A_int = A_;
      D_int = D_;
      clk0_int = 1'b0;
      readWrite;
    end
    LAST_CLK = CLK_;
  end


endmodule
`endcelldefine
`else
`timescale 1 ns/1 ps
`celldefine
`ifdef POWER_PINS
module RF1_128_50 (Q, CLK, CEN, WEN, A, D, VDD, VSS);
`else
module RF1_128_50 (Q, CLK, CEN, WEN, A, D);
`endif

  parameter BITS = 50;
  parameter WORDS = 128;
  parameter MUX = 2;
  parameter MEM_WIDTH = 100;
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 50 ;
  parameter UPM_WIDTH = 3;

  output [49:0] Q;
  input  CLK;
  input  CEN;
  input  WEN;
  input [6:0] A;
  input [49:0] D;
`ifdef POWER_PINS
  inout VDD;
  inout VSS;
`endif

  integer row_address;
  integer mux_address;
  reg [99:0] mem [0:63];
  reg [99:0] row;
  reg LAST_CLK;
  reg [99:0] data_out;
  reg [99:0] row_mask;
  reg [99:0] new_data;
  reg [49:0] Q_int;
  reg [49:0] writeEnable;

  reg NOT_A0, NOT_A1, NOT_A2, NOT_A3, NOT_A4, NOT_A5, NOT_A6, NOT_CEN, NOT_CLK_MINH;
  reg NOT_CLK_MINL, NOT_CLK_PER, NOT_D0, NOT_D1, NOT_D10, NOT_D11, NOT_D12, NOT_D13;
  reg NOT_D14, NOT_D15, NOT_D16, NOT_D17, NOT_D18, NOT_D19, NOT_D2, NOT_D20, NOT_D21;
  reg NOT_D22, NOT_D23, NOT_D24, NOT_D25, NOT_D26, NOT_D27, NOT_D28, NOT_D29, NOT_D3;
  reg NOT_D30, NOT_D31, NOT_D32, NOT_D33, NOT_D34, NOT_D35, NOT_D36, NOT_D37, NOT_D38;
  reg NOT_D39, NOT_D4, NOT_D40, NOT_D41, NOT_D42, NOT_D43, NOT_D44, NOT_D45, NOT_D46;
  reg NOT_D47, NOT_D48, NOT_D49, NOT_D5, NOT_D6, NOT_D7, NOT_D8, NOT_D9, NOT_WEN;
  reg clk0_int;
  reg CREN_legal;
  initial CREN_legal = 1'b1;

  wire [49:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  wire  WEN_;
  reg  WEN_int;
  wire [6:0] A_;
  reg [6:0] A_int;
  wire [49:0] D_;
  reg [49:0] D_int;

  buf B0(Q[0], Q_[0]);
  buf B1(Q[1], Q_[1]);
  buf B2(Q[2], Q_[2]);
  buf B3(Q[3], Q_[3]);
  buf B4(Q[4], Q_[4]);
  buf B5(Q[5], Q_[5]);
  buf B6(Q[6], Q_[6]);
  buf B7(Q[7], Q_[7]);
  buf B8(Q[8], Q_[8]);
  buf B9(Q[9], Q_[9]);
  buf B10(Q[10], Q_[10]);
  buf B11(Q[11], Q_[11]);
  buf B12(Q[12], Q_[12]);
  buf B13(Q[13], Q_[13]);
  buf B14(Q[14], Q_[14]);
  buf B15(Q[15], Q_[15]);
  buf B16(Q[16], Q_[16]);
  buf B17(Q[17], Q_[17]);
  buf B18(Q[18], Q_[18]);
  buf B19(Q[19], Q_[19]);
  buf B20(Q[20], Q_[20]);
  buf B21(Q[21], Q_[21]);
  buf B22(Q[22], Q_[22]);
  buf B23(Q[23], Q_[23]);
  buf B24(Q[24], Q_[24]);
  buf B25(Q[25], Q_[25]);
  buf B26(Q[26], Q_[26]);
  buf B27(Q[27], Q_[27]);
  buf B28(Q[28], Q_[28]);
  buf B29(Q[29], Q_[29]);
  buf B30(Q[30], Q_[30]);
  buf B31(Q[31], Q_[31]);
  buf B32(Q[32], Q_[32]);
  buf B33(Q[33], Q_[33]);
  buf B34(Q[34], Q_[34]);
  buf B35(Q[35], Q_[35]);
  buf B36(Q[36], Q_[36]);
  buf B37(Q[37], Q_[37]);
  buf B38(Q[38], Q_[38]);
  buf B39(Q[39], Q_[39]);
  buf B40(Q[40], Q_[40]);
  buf B41(Q[41], Q_[41]);
  buf B42(Q[42], Q_[42]);
  buf B43(Q[43], Q_[43]);
  buf B44(Q[44], Q_[44]);
  buf B45(Q[45], Q_[45]);
  buf B46(Q[46], Q_[46]);
  buf B47(Q[47], Q_[47]);
  buf B48(Q[48], Q_[48]);
  buf B49(Q[49], Q_[49]);
  buf B50(CLK_, CLK);
  buf B51(CEN_, CEN);
  buf B52(WEN_, WEN);
  buf B53(A_[0], A[0]);
  buf B54(A_[1], A[1]);
  buf B55(A_[2], A[2]);
  buf B56(A_[3], A[3]);
  buf B57(A_[4], A[4]);
  buf B58(A_[5], A[5]);
  buf B59(A_[6], A[6]);
  buf B60(D_[0], D[0]);
  buf B61(D_[1], D[1]);
  buf B62(D_[2], D[2]);
  buf B63(D_[3], D[3]);
  buf B64(D_[4], D[4]);
  buf B65(D_[5], D[5]);
  buf B66(D_[6], D[6]);
  buf B67(D_[7], D[7]);
  buf B68(D_[8], D[8]);
  buf B69(D_[9], D[9]);
  buf B70(D_[10], D[10]);
  buf B71(D_[11], D[11]);
  buf B72(D_[12], D[12]);
  buf B73(D_[13], D[13]);
  buf B74(D_[14], D[14]);
  buf B75(D_[15], D[15]);
  buf B76(D_[16], D[16]);
  buf B77(D_[17], D[17]);
  buf B78(D_[18], D[18]);
  buf B79(D_[19], D[19]);
  buf B80(D_[20], D[20]);
  buf B81(D_[21], D[21]);
  buf B82(D_[22], D[22]);
  buf B83(D_[23], D[23]);
  buf B84(D_[24], D[24]);
  buf B85(D_[25], D[25]);
  buf B86(D_[26], D[26]);
  buf B87(D_[27], D[27]);
  buf B88(D_[28], D[28]);
  buf B89(D_[29], D[29]);
  buf B90(D_[30], D[30]);
  buf B91(D_[31], D[31]);
  buf B92(D_[32], D[32]);
  buf B93(D_[33], D[33]);
  buf B94(D_[34], D[34]);
  buf B95(D_[35], D[35]);
  buf B96(D_[36], D[36]);
  buf B97(D_[37], D[37]);
  buf B98(D_[38], D[38]);
  buf B99(D_[39], D[39]);
  buf B100(D_[40], D[40]);
  buf B101(D_[41], D[41]);
  buf B102(D_[42], D[42]);
  buf B103(D_[43], D[43]);
  buf B104(D_[44], D[44]);
  buf B105(D_[45], D[45]);
  buf B106(D_[46], D[46]);
  buf B107(D_[47], D[47]);
  buf B108(D_[48], D[48]);
  buf B109(D_[49], D[49]);

  assign Q_ = Q_int;

`ifdef INITIALIZE_MEMORY
  integer i;
  initial
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
`endif

  task failedWrite;
  input port;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitIn;
    begin
      isBitX = ( bitIn===1'bx || bitIn===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


  task readWrite;
  begin
    if (^{CEN_int} === 1'bx) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      writeEnable = ~{50{WEN_int}};
      Q_int = ((writeEnable & D_int) | (~writeEnable & {50{1'bx}}));
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 1'b1);
      row_address = (A_int >> 1);
      if (row_address >= 64)
        row = {100{1'bx}};
      else
        row = mem[row_address];
      writeEnable = ~{50{WEN_int}};
      row_mask =  ( {1'b0, writeEnable[49], 1'b0, writeEnable[48], 1'b0, writeEnable[47],
          1'b0, writeEnable[46], 1'b0, writeEnable[45], 1'b0, writeEnable[44], 1'b0, writeEnable[43],
          1'b0, writeEnable[42], 1'b0, writeEnable[41], 1'b0, writeEnable[40], 1'b0, writeEnable[39],
          1'b0, writeEnable[38], 1'b0, writeEnable[37], 1'b0, writeEnable[36], 1'b0, writeEnable[35],
          1'b0, writeEnable[34], 1'b0, writeEnable[33], 1'b0, writeEnable[32], 1'b0, writeEnable[31],
          1'b0, writeEnable[30], 1'b0, writeEnable[29], 1'b0, writeEnable[28], 1'b0, writeEnable[27],
          1'b0, writeEnable[26], 1'b0, writeEnable[25], 1'b0, writeEnable[24], 1'b0, writeEnable[23],
          1'b0, writeEnable[22], 1'b0, writeEnable[21], 1'b0, writeEnable[20], 1'b0, writeEnable[19],
          1'b0, writeEnable[18], 1'b0, writeEnable[17], 1'b0, writeEnable[16], 1'b0, writeEnable[15],
          1'b0, writeEnable[14], 1'b0, writeEnable[13], 1'b0, writeEnable[12], 1'b0, writeEnable[11],
          1'b0, writeEnable[10], 1'b0, writeEnable[9], 1'b0, writeEnable[8], 1'b0, writeEnable[7],
          1'b0, writeEnable[6], 1'b0, writeEnable[5], 1'b0, writeEnable[4], 1'b0, writeEnable[3],
          1'b0, writeEnable[2], 1'b0, writeEnable[1], 1'b0, writeEnable[0]} << mux_address);
      new_data =  ( {1'b0, D_int[49], 1'b0, D_int[48], 1'b0, D_int[47], 1'b0, D_int[46],
          1'b0, D_int[45], 1'b0, D_int[44], 1'b0, D_int[43], 1'b0, D_int[42], 1'b0, D_int[41],
          1'b0, D_int[40], 1'b0, D_int[39], 1'b0, D_int[38], 1'b0, D_int[37], 1'b0, D_int[36],
          1'b0, D_int[35], 1'b0, D_int[34], 1'b0, D_int[33], 1'b0, D_int[32], 1'b0, D_int[31],
          1'b0, D_int[30], 1'b0, D_int[29], 1'b0, D_int[28], 1'b0, D_int[27], 1'b0, D_int[26],
          1'b0, D_int[25], 1'b0, D_int[24], 1'b0, D_int[23], 1'b0, D_int[22], 1'b0, D_int[21],
          1'b0, D_int[20], 1'b0, D_int[19], 1'b0, D_int[18], 1'b0, D_int[17], 1'b0, D_int[16],
          1'b0, D_int[15], 1'b0, D_int[14], 1'b0, D_int[13], 1'b0, D_int[12], 1'b0, D_int[11],
          1'b0, D_int[10], 1'b0, D_int[9], 1'b0, D_int[8], 1'b0, D_int[7], 1'b0, D_int[6],
          1'b0, D_int[5], 1'b0, D_int[4], 1'b0, D_int[3], 1'b0, D_int[2], 1'b0, D_int[1],
          1'b0, D_int[0]} << mux_address);
      row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
      mem[row_address] = row;
      data_out = (row >> mux_address);
      Q_int = {data_out[98], data_out[96], data_out[94], data_out[92], data_out[90],
        data_out[88], data_out[86], data_out[84], data_out[82], data_out[80], data_out[78],
        data_out[76], data_out[74], data_out[72], data_out[70], data_out[68], data_out[66],
        data_out[64], data_out[62], data_out[60], data_out[58], data_out[56], data_out[54],
        data_out[52], data_out[50], data_out[48], data_out[46], data_out[44], data_out[42],
        data_out[40], data_out[38], data_out[36], data_out[34], data_out[32], data_out[30],
        data_out[28], data_out[26], data_out[24], data_out[22], data_out[20], data_out[18],
        data_out[16], data_out[14], data_out[12], data_out[10], data_out[8], data_out[6],
        data_out[4], data_out[2], data_out[0]};
    end
  end
  endtask

  always @ CLK_ begin
`ifdef POWER_PINS
    if (VDD === 1'bx || VDD === 1'bz)
      $display("ERROR: Illegal value for VDD %b", VDD);
    if (VSS === 1'bx || VSS === 1'bz)
      $display("ERROR: Illegal value for VSS %b", VSS);
`endif
    if (CLK_ === 1'bx && (CEN_ !== 1'b1)) begin
      failedWrite(0);
      Q_int = {50{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      WEN_int = WEN_;
      A_int = A_;
      D_int = D_;
      clk0_int = 1'b0;
      readWrite;
    end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || clk0_int === 1'bx) begin
      Q_int = {50{1'bx}};
      failedWrite(0);
    end else begin
      readWrite;
   end
    globalNotifier0 = 1'b0;
  end

  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D32 begin
    D_int[32] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D33 begin
    D_int[33] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D34 begin
    D_int[34] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D35 begin
    D_int[35] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D36 begin
    D_int[36] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D37 begin
    D_int[37] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D38 begin
    D_int[38] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D39 begin
    D_int[39] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D40 begin
    D_int[40] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D41 begin
    D_int[41] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D42 begin
    D_int[42] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D43 begin
    D_int[43] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D44 begin
    D_int[44] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D45 begin
    D_int[45] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D46 begin
    D_int[46] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D47 begin
    D_int[47] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D48 begin
    D_int[48] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D49 begin
    D_int[49] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN begin
    WEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  wire CEN_flag;
  wire flag;
  wire D_flag;
  wire cyc_flag;
  assign CEN_flag = 1'b1;
  assign flag = !CEN_;
  assign D_flag = !(CEN_ || WEN_);
  assign cyc_flag = !CEN_;

  specify
      $setuphold(posedge CLK &&& CEN_flag, posedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& CEN_flag, negedge CEN, 1.000, 0.500, NOT_CEN);
      $setuphold(posedge CLK &&& flag, posedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& flag, negedge WEN, 1.000, 0.500, NOT_WEN);
      $setuphold(posedge CLK &&& flag, posedge A[6], 1.000, 0.500, NOT_A6);
      $setuphold(posedge CLK &&& flag, negedge A[6], 1.000, 0.500, NOT_A6);
      $setuphold(posedge CLK &&& flag, posedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, negedge A[5], 1.000, 0.500, NOT_A5);
      $setuphold(posedge CLK &&& flag, posedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, negedge A[4], 1.000, 0.500, NOT_A4);
      $setuphold(posedge CLK &&& flag, posedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, negedge A[3], 1.000, 0.500, NOT_A3);
      $setuphold(posedge CLK &&& flag, posedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, negedge A[2], 1.000, 0.500, NOT_A2);
      $setuphold(posedge CLK &&& flag, posedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, negedge A[1], 1.000, 0.500, NOT_A1);
      $setuphold(posedge CLK &&& flag, posedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& flag, negedge A[0], 1.000, 0.500, NOT_A0);
      $setuphold(posedge CLK &&& D_flag, posedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& D_flag, negedge D[49], 1.000, 0.500, NOT_D49);
      $setuphold(posedge CLK &&& D_flag, posedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& D_flag, negedge D[48], 1.000, 0.500, NOT_D48);
      $setuphold(posedge CLK &&& D_flag, posedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& D_flag, negedge D[47], 1.000, 0.500, NOT_D47);
      $setuphold(posedge CLK &&& D_flag, posedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& D_flag, negedge D[46], 1.000, 0.500, NOT_D46);
      $setuphold(posedge CLK &&& D_flag, posedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& D_flag, negedge D[45], 1.000, 0.500, NOT_D45);
      $setuphold(posedge CLK &&& D_flag, posedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& D_flag, negedge D[44], 1.000, 0.500, NOT_D44);
      $setuphold(posedge CLK &&& D_flag, posedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& D_flag, negedge D[43], 1.000, 0.500, NOT_D43);
      $setuphold(posedge CLK &&& D_flag, posedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& D_flag, negedge D[42], 1.000, 0.500, NOT_D42);
      $setuphold(posedge CLK &&& D_flag, posedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& D_flag, negedge D[41], 1.000, 0.500, NOT_D41);
      $setuphold(posedge CLK &&& D_flag, posedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& D_flag, negedge D[40], 1.000, 0.500, NOT_D40);
      $setuphold(posedge CLK &&& D_flag, posedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& D_flag, negedge D[39], 1.000, 0.500, NOT_D39);
      $setuphold(posedge CLK &&& D_flag, posedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& D_flag, negedge D[38], 1.000, 0.500, NOT_D38);
      $setuphold(posedge CLK &&& D_flag, posedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& D_flag, negedge D[37], 1.000, 0.500, NOT_D37);
      $setuphold(posedge CLK &&& D_flag, posedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& D_flag, negedge D[36], 1.000, 0.500, NOT_D36);
      $setuphold(posedge CLK &&& D_flag, posedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& D_flag, negedge D[35], 1.000, 0.500, NOT_D35);
      $setuphold(posedge CLK &&& D_flag, posedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& D_flag, negedge D[34], 1.000, 0.500, NOT_D34);
      $setuphold(posedge CLK &&& D_flag, posedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& D_flag, negedge D[33], 1.000, 0.500, NOT_D33);
      $setuphold(posedge CLK &&& D_flag, posedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& D_flag, negedge D[32], 1.000, 0.500, NOT_D32);
      $setuphold(posedge CLK &&& D_flag, posedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag, negedge D[31], 1.000, 0.500, NOT_D31);
      $setuphold(posedge CLK &&& D_flag, posedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag, negedge D[30], 1.000, 0.500, NOT_D30);
      $setuphold(posedge CLK &&& D_flag, posedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag, negedge D[29], 1.000, 0.500, NOT_D29);
      $setuphold(posedge CLK &&& D_flag, posedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag, negedge D[28], 1.000, 0.500, NOT_D28);
      $setuphold(posedge CLK &&& D_flag, posedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag, negedge D[27], 1.000, 0.500, NOT_D27);
      $setuphold(posedge CLK &&& D_flag, posedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag, negedge D[26], 1.000, 0.500, NOT_D26);
      $setuphold(posedge CLK &&& D_flag, posedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag, negedge D[25], 1.000, 0.500, NOT_D25);
      $setuphold(posedge CLK &&& D_flag, posedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag, negedge D[24], 1.000, 0.500, NOT_D24);
      $setuphold(posedge CLK &&& D_flag, posedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag, negedge D[23], 1.000, 0.500, NOT_D23);
      $setuphold(posedge CLK &&& D_flag, posedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag, negedge D[22], 1.000, 0.500, NOT_D22);
      $setuphold(posedge CLK &&& D_flag, posedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag, negedge D[21], 1.000, 0.500, NOT_D21);
      $setuphold(posedge CLK &&& D_flag, posedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag, negedge D[20], 1.000, 0.500, NOT_D20);
      $setuphold(posedge CLK &&& D_flag, posedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag, negedge D[19], 1.000, 0.500, NOT_D19);
      $setuphold(posedge CLK &&& D_flag, posedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag, negedge D[18], 1.000, 0.500, NOT_D18);
      $setuphold(posedge CLK &&& D_flag, posedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag, negedge D[17], 1.000, 0.500, NOT_D17);
      $setuphold(posedge CLK &&& D_flag, posedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag, negedge D[16], 1.000, 0.500, NOT_D16);
      $setuphold(posedge CLK &&& D_flag, posedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag, negedge D[15], 1.000, 0.500, NOT_D15);
      $setuphold(posedge CLK &&& D_flag, posedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag, negedge D[14], 1.000, 0.500, NOT_D14);
      $setuphold(posedge CLK &&& D_flag, posedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag, negedge D[13], 1.000, 0.500, NOT_D13);
      $setuphold(posedge CLK &&& D_flag, posedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag, negedge D[12], 1.000, 0.500, NOT_D12);
      $setuphold(posedge CLK &&& D_flag, posedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag, negedge D[11], 1.000, 0.500, NOT_D11);
      $setuphold(posedge CLK &&& D_flag, posedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag, negedge D[10], 1.000, 0.500, NOT_D10);
      $setuphold(posedge CLK &&& D_flag, posedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag, negedge D[9], 1.000, 0.500, NOT_D9);
      $setuphold(posedge CLK &&& D_flag, posedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag, negedge D[8], 1.000, 0.500, NOT_D8);
      $setuphold(posedge CLK &&& D_flag, posedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag, negedge D[7], 1.000, 0.500, NOT_D7);
      $setuphold(posedge CLK &&& D_flag, posedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag, negedge D[6], 1.000, 0.500, NOT_D6);
      $setuphold(posedge CLK &&& D_flag, posedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag, negedge D[5], 1.000, 0.500, NOT_D5);
      $setuphold(posedge CLK &&& D_flag, posedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag, negedge D[4], 1.000, 0.500, NOT_D4);
      $setuphold(posedge CLK &&& D_flag, posedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag, negedge D[3], 1.000, 0.500, NOT_D3);
      $setuphold(posedge CLK &&& D_flag, posedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag, negedge D[2], 1.000, 0.500, NOT_D2);
      $setuphold(posedge CLK &&& D_flag, posedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag, negedge D[1], 1.000, 0.500, NOT_D1);
      $setuphold(posedge CLK &&& D_flag, posedge D[0], 1.000, 0.500, NOT_D0);
      $setuphold(posedge CLK &&& D_flag, negedge D[0], 1.000, 0.500, NOT_D0);

      $width(posedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINH);
      $width(negedge CLK &&& cyc_flag, 1.000, 0, NOT_CLK_MINL);
      $period(posedge CLK &&& cyc_flag, 3.000, NOT_CLK_PER);

      (posedge CLK => (Q[49]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[48]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[47]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[46]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[45]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[44]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[43]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[42]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[41]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[40]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[39]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[38]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[37]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[36]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[35]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[34]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[33]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[32]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[31]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[30]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[29]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[28]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[27]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[26]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[25]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[24]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[23]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[22]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[21]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[20]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[19]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[18]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[17]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[16]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[15]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[14]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[13]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[12]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[11]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[10]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[9]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[8]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[7]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[6]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[5]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[4]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[3]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[2]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[1]:1'b0))=(1.000, 1.000);
      (posedge CLK => (Q[0]:1'b0))=(1.000, 1.000);

  endspecify

endmodule
`endcelldefine
`endif
