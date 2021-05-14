module iic_master_wrap(
    pclk          ,
    prstn         ,
    paddr         ,
    pwrite        ,
    penable       ,
    psel          ,
    pwdata        ,
    prdata        ,
    pready        ,
    iicm_int      ,

    scl           ,
    scl_in        , 
    sda_oe        , 
    sda_out       , 
    sda_in         
);
input                   pclk        ;
input                   prstn       ;
input  [23:0]           paddr       ;
input                   pwrite      ;
input                   penable     ;
input                   psel        ;
input  [31:0]           pwdata      ;
output [31:0]           prdata      ;
output                  pready      ;
output                  iicm_int    ;

output                  scl         ;
input                   scl_in      ;
output                  sda_oe      ;
output                  sda_out     ;
input                   sda_in      ;

reg    [31: 0]          iicm_2_data0            ;
reg    [31: 0]          iicm_2_data1            ;
wire                    master_timeout          ;
wire                    master_nstop            ;
wire                    master_nack             ;
wire                    master_rw_done          ;
wire   [ 7: 0]          slave_addr              ;
wire   [ 7: 0]          nword                   ;
wire                    cpu_cmd_w               ;
wire   [ 3: 0]          cpu_cmd                 ;
wire   [15: 0]          cpu_time_out            ;
wire                    cpu_clk_str_en          ;
wire                    cpu_last_ack_en         ;
wire   [15: 0]          mast_read_addr          ;
wire   [31: 0]          data_2_iicm0            ;
wire   [31: 0]          data_2_iicm1            ;
wire                    master_rw_int_en        ;
wire                    master_timeout_en       ;
wire                    master_nstop_en         ;
wire                    master_nack_en          ;
wire                    rel_time_out            ;
wire                    rel_mst_stop            ;
wire                    rel_mst_nack            ;
wire                    rel_mst_rw              ;
wire   [15: 0]          clk_div_cnt             ;
wire                    clk_en                  ;

reg                     clk_div     ;
reg   [15: 0]           clk_cnt     ;  
reg   [ 3: 0]           cpu_command ;  
reg   [ 7: 0]           data_2_iicm ;
wire  [ 7: 0]           data_fr_iicm;       
wire                    cpu_info    ;
wire                    mast_iic_rw1;
wire                    mast_iic_rw2;
wire                    mast_no_act ;
wire                    master_stop ;
wire  [ 7: 0]           data_num    ;
reg                     iicm_int    ;
always @ (posedge pclk or negedge prstn)
begin
    if(~prstn)
        clk_cnt <= #1 16'h0;
    else if(clk_en)
        clk_cnt <= #1 clk_cnt == clk_div_cnt ? 16'h0: clk_cnt + 1 ; 
end 
always @ (posedge pclk or negedge prstn)
begin
    if(~prstn)
        clk_div <= #1 0;
    else if(clk_en)
        clk_div <= #1 clk_cnt ==clk_div_cnt ? ~clk_div : clk_div; 
end 
always @ (posedge pclk or negedge prstn)
begin
    if(~prstn)
    begin
        cpu_command    <= #1 4'h0;
    end
    else
    begin
        cpu_command    <= #1 cpu_cmd_w ? cpu_cmd : cpu_info ? 4'h0 : cpu_command;
    end
end 
always @ (*)
begin
    data_2_iicm = 8'h0;
    if(cpu_command[0] == 1'b1)
    begin
        if(data_num[2:0] == 3'h0)
            data_2_iicm = data_2_iicm0[ 7: 0];
        else if (data_num[2:0] == 3'h1)
            data_2_iicm = data_2_iicm0[15: 8];
        else if (data_num[2:0] == 3'h2)
            data_2_iicm = data_2_iicm0[23:16];
        else if (data_num[2:0] == 3'h3)
            data_2_iicm = data_2_iicm0[31:24];
        else if (data_num[2:0] == 3'h4)
            data_2_iicm = data_2_iicm1[ 7: 0];
        else if (data_num[2:0] == 3'h5)
            data_2_iicm = data_2_iicm1[15: 8];
        else if (data_num[2:0] == 3'h6)
            data_2_iicm = data_2_iicm1[23:16];
        else if (data_num[2:0] == 3'h7)
            data_2_iicm = data_2_iicm1[31:24];
        else
            data_2_iicm = 8'h0;    
    end
    else
        data_2_iicm = 8'h0;
end
always @ (posedge pclk or negedge prstn)
begin
    if(~prstn)
    begin
        iicm_2_data0 <= #1 32'h0;
        iicm_2_data1 <= #1 32'h0;
    end
    else if(mast_iic_rw2)//& ~ cpu_command[0])
    begin
        iicm_2_data0[ 7: 0] <= #1 (data_num[2:0] == 3'h0) ? data_fr_iicm : iicm_2_data0[ 7: 0];
        iicm_2_data0[15: 8] <= #1 (data_num[2:0] == 3'h1) ? data_fr_iicm : iicm_2_data0[15: 8];
        iicm_2_data0[23:16] <= #1 (data_num[2:0] == 3'h2) ? data_fr_iicm : iicm_2_data0[23:16];
        iicm_2_data0[31:24] <= #1 (data_num[2:0] == 3'h3) ? data_fr_iicm : iicm_2_data0[31:24];
        iicm_2_data1[ 7: 0] <= #1 (data_num[2:0] == 3'h4) ? data_fr_iicm : iicm_2_data1[ 7: 0];
        iicm_2_data1[15: 8] <= #1 (data_num[2:0] == 3'h5) ? data_fr_iicm : iicm_2_data1[15: 8];
        iicm_2_data1[23:16] <= #1 (data_num[2:0] == 3'h6) ? data_fr_iicm : iicm_2_data1[23:16];
        iicm_2_data1[31:24] <= #1 (data_num[2:0] == 3'h7) ? data_fr_iicm : iicm_2_data1[31:24];
    end
end
always @ (posedge pclk or negedge prstn)
begin
    if(~prstn)
        iicm_int <= #1 0;
    else 
        iicm_int <= #1 (master_timeout & master_timeout_en  )    
                      |(master_nstop   & master_nstop_en )   
                      |(master_nack    & master_nack_en  ) 
                      |(master_rw_done & master_rw_int_en)
                      ; 
end 
iic_master u_iic_master(
    .reset_n            (prstn              ),
    .clk                (pclk               ), 
    .clk_ref            (clk_div            ), 
    //cpu register
    .slave_addr         (slave_addr         ),
    .nword              (nword              ), 
    .cpu_command        (cpu_command        ), 
    .cpu_time_out       (cpu_time_out       ),//added by yupingji, 20081120;
    .cpu_clk_str_en     (cpu_clk_str_en     ),//added by yupingji, 20081120;
    .cpu_last_ack_en    (cpu_last_ack_en    ),
    .mast_read_addr     (mast_read_addr     ),
    .data_8032_2_iicm   (data_2_iicm        ), 
    .data_iicm_2_8032   (data_fr_iicm       ),
    .cpu_info           (cpu_info           ), 
    .mast_iic_rw1       (mast_iic_rw1       ), 
    .mast_iic_rw2       (mast_iic_rw2       ), 
    .mast_no_act        (mast_no_act        ),
    .master_stop        (master_nstop       ), 
    .master_nack        (master_nack        ),
    .master_rw_done     (master_rw_done     ),
    .stretch_time_out   (master_timeout     ),
    .rel_mst_rw         (rel_mst_rw         ), 
    .rel_mst_stop       (rel_mst_stop       ), 
    .rel_mst_nack       (rel_mst_nack       ), 
    .rel_time_out       (rel_time_out       ), 
    .data_num           (data_num           ),
    //iic bus
    .scl                (scl                ),
    .scl_in             (scl_in             ), 
    .sda_oe             (sda_oe             ), 
    .sda_out            (sda_out            ), 
    .sda_in             (sda_in             )      
    );
apbreg_iic_master u_apbreg_iic_master(
    .pclk               (pclk               ),
    .prstn              (prstn              ),
    .psel               (psel               ),
    .penable            (penable            ),
    .pwrite             (pwrite             ),
    .paddr              (paddr              ),
    .pwdata             (pwdata             ),
    .prdata             (prdata             ),
    .pready             (pready             ),
    //input ports        
    .iicm_2_data0       (iicm_2_data0       ),
    .iicm_2_data1       (iicm_2_data1       ),
    .master_timeout     (master_timeout     ),
    .master_nstop       (master_nstop       ),
    .master_nack        (master_nack        ),
    .master_rw_done     (master_rw_done     ),
    .data_num           (data_num           ),

    //output ports      
    .slave_addr         (slave_addr         ),
    .nword              (nword              ),
    .cpu_cmd_w          (cpu_cmd_w          ),
    .cpu_cmd            (cpu_cmd            ),
    .cpu_time_out       (cpu_time_out       ),
    .cpu_clk_str_en     (cpu_clk_str_en     ),
    .cpu_last_ack_en    (cpu_last_ack_en    ),
    .mast_read_addr     (mast_read_addr     ),
    .data_2_iicm0       (data_2_iicm0       ),
    .data_2_iicm1       (data_2_iicm1       ),
    .mast_no_act        (mast_no_act        ),
    .master_rw_int_en   (master_rw_int_en   ),
    .master_timeout_en  (master_timeout_en  ),
    .master_nstop_en    (master_nstop_en    ),
    .master_nack_en     (master_nack_en     ),
    .rel_mst_rw         (rel_mst_rw         ), 
    .rel_time_out       (rel_time_out       ),
    .rel_mst_stop       (rel_mst_stop       ),
    .rel_mst_nack       (rel_mst_nack       ),
    .clk_div_cnt        (clk_div_cnt        ),
    .clk_en             (clk_en             ) 
);

endmodule
