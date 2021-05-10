module levelsync_dffin(
    i_oclk ,
    i_orstn,
    i_data ,
    o_data   
);
parameter W      = 1;
parameter DEFVAL = 0;
input           i_oclk ;
input           i_orstn;
input  [W-1:0]  i_data ;
output [W-1:0]  o_data ;
reg    [W-1:0]  data_sync0;
reg    [W-1:0]  data_sync1;
always @ (posedge i_oclk or negedge i_orstn)
begin
    if(~i_orstn)
    begin
        data_sync0 <= #1 DEFVAL;
        data_sync1 <= #1 DEFVAL;
    end
    else
    begin
        data_sync0 <= #1 i_data;
        data_sync1 <= #1 data_sync0;
    end
end
assign o_data = data_sync1;
endmodule
