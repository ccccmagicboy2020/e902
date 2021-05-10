//********************************************************
//*                        SMIC memory                   *
//********************************************************
module smic_spsram_128x50(
  Q,
  CLK,
  CEN,
  WEN,
  A,
  D
);

//**********************************************************
//                  Parameter Definition
//**********************************************************
parameter ADDR_WIDTH = 7;
parameter DATA_WIDTH = 50;
parameter WE_WIDTH   = 5;

output  [DATA_WIDTH-1:0]  Q;
input                     CLK;
input                     CEN;
input   [WE_WIDTH-1:0]    WEN;
input   [ADDR_WIDTH-1:0]  A;
input   [DATA_WIDTH-1:0]  D;

wire    [DATA_WIDTH-1:0]  Q;
wire                      CLK;
wire                      CEN;
wire    [WE_WIDTH-1:0]    WEN;
wire    [ADDR_WIDTH-1:0]  A;
wire    [DATA_WIDTH-1:0]  D;

//############################################
//#             55nm LL technology           #
//############################################
RF1_128_50 x_sprf055ll_128x50(
  .CLK  (CLK),
  .CEN  (CEN),
  .WEN  (&WEN),
  .A    (A),
  .D    (D),
  .Q    (Q)
);

endmodule
