module pulsesync(
    iclk ,
    irstn,
    idata,
    oclk ,
    orstn,
    odata  

);
input         iclk ;
input         irstn;
input         idata;
input         oclk ;
input         orstn;
output        odata;
reg           idata_d0;
reg           idata_d1;
reg           pulse_det;
reg           odata_d0;
reg           odata_d1;
reg           odata_d2;
reg           odata   ;

always @ (posedge iclk or negedge irstn)
begin
    if(~irstn)
    begin
        idata_d0 <= #1 0;
        idata_d1 <= #1 0;
        pulse_det<= #1 0;
    end
    else
    begin
        idata_d0 <= #1 idata;
        idata_d1 <= #1 idata_d0;
        pulse_det<= #1 (idata_d0 & ~idata_d1)?~pulse_det : pulse_det;
    end
end
always @ (posedge oclk or negedge orstn)
begin
    if(~orstn)
    begin
        odata_d0 <= #1 0;
        odata_d1 <= #1 0;
        odata_d2 <= #1 0;
        odata    <= #1 0;
    end
    else
    begin
        odata_d0 <= #1 pulse_det;
        odata_d1 <= #1 odata_d0;
        odata_d2 <= #1 odata_d1;
        odata    <= #1 odata_d1 ^ odata_d2;
    end
end
endmodule
