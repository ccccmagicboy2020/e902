`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/24 09:59:32
// Design Name: 
// Module Name: spram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spram #(
parameter   DWIDTH =32,
parameter   AWIDTH =16
)
(
input                                  clk,
input           [AWIDTH-1:0]           addr,
input                                  cen,
input                                  wen,
input           [DWIDTH-1:0]           din,
output   reg    [DWIDTH-1:0]           dout
);
(*ram_style="block"*) reg   [DWIDTH-1:0]    mem_buf [2**AWIDTH-1:0] ;

integer i;
initial begin
       for (i=0;i<2**AWIDTH;i=i+1)
            mem_buf[i] = 32'h1234_7f7f;
end

always@(posedge clk) begin
    if(!cen & !wen)
        mem_buf[addr]<=din;
end

always@(posedge clk ) begin
    if(!cen & wen)
       dout<=mem_buf[addr];
end
      
        
endmodule
