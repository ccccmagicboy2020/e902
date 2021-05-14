//********************************************************
//*                        SMIC memory                   *
//********************************************************
module smic_spsram_512x32(
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
parameter ADDR_WIDTH = 9;
parameter DATA_WIDTH = 32;
//parameter WE_WIDTH   = 1;

output  [DATA_WIDTH-1:0]  Q;
input                     CLK;
input                     CEN;
input                     WEN;
input   [ADDR_WIDTH-1:0]  A;
input   [DATA_WIDTH-1:0]  D;

wire    [DATA_WIDTH-1:0]  Q;
wire                      CLK;
wire                      CEN;
wire                      WEN;
wire    [ADDR_WIDTH-1:0]  A;
wire    [DATA_WIDTH-1:0]  D;

//############################################
//#             55nm LL technology           #
//############################################
RF1_512_32 x_sprf055ll_512x32(
  .CLK  (CLK),
  .CEN  (CEN),
  .WEN  (WEN),
  .A    (A),
  .D    (D),
  .Q    (Q)
);

endmodule
