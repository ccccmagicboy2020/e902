//------------------------------------------------------------------------
// Phosense Electronics, Inc Confidential
// Project Name	: XBR820
// Module	: xbr820_core
// Function	: Core level modules based on AHB/APB bus
// Created	: Liangzujun
//
// Description	: MCU
// 		  BUS 
// 		  Code SRAM
// 		  SPI Flash
//                UART
//                I2C Master
// 		  I2C Slave
// 		  IR
// 		  STC
// 		  TOP_REG
//
// Revision History:
// 2021/1/21	: Created 
//------------------------------------------------------------------------

module xbr820_core 
       (
	// DFT   
        test_en               ,

        // clk
        clk_cpu		      ,
        clk_bus               ,
        clk_spix2             ,

        // Reset
        cpu_pad_soft_rst      ,//out  [1 :0]                               
        pad_cpu_rst_b         ,  
        pad_had_rst_b         ,
        pad_had_jtg_trst_b    ,
        pad_bus_rst_b	      , 
        pad_spi_rst_b	      ,

        // JTAG & Debug             
        pad_had_jtg_tclk      ,                    
        pad_had_jtg_tms_i     ,//in                                   
        had_pad_jtg_tms_o     ,//out                  
        had_pad_jtg_tms_oe    ,//out              
        had_pad_jdb_pm        ,//out  [1 :0]  status to PMU
        pad_sysio_dbgrq_b     ,//in   

        // Low power 
        pad_cpu_wakeup_event  ,//in 
        sysio_pad_lpmd_b      ,//out  [1 :0]	to PMU/Topreg
	
        //PMU 
        cpu_boot_done	      ,//from PMU
        pmu_int_irq           ,
        pmu_penable           ,              
        pmu_psel              ,                 
        pmu_pwrite            ,               
        pmu_paddr             ,                
        pmu_pwdata            ,               
        pmu_prdata            ,               
        pmu_pready            ,

       `ifdef INN_MEM
       `else
	//CPU sram
	cpu_sram_cen   	      ,
	cpu_sram_wen   	      ,
	cpu_sram_addr  	      ,
	cpu_sram_din	      ,
	cpu_sram_dout	      ,
       `endif

        // UART
        uart1_rx              ,  
        uart1_tx              ,  
        uart2_rx              ,  
        uart2_tx              ,
  	
        // Master I2C
        m_scl_oe              ,
        m_scl_out             ,
        m_scl_in              , 
        m_sda_oe              , 
        m_sda_out             , 
        m_sda_in              ,   		

        // Slave I2C
        s_sda_out             ,
        s_sda_oe              ,
        s_scl_in              ,
        s_sda_in              ,

        // IR
        ir_in                 ,
 		
        // Sflash			 
        fr_spi_sin            ,
        fr_spi_sin2           ,
        to_spi_csn            ,
        to_spi_sck            ,
        to_spi_sout           ,
        to_spi_sout_oen       ,

        pwm_out               ,
				 		
        gpio_in               ,
        gpio_out              ,
        gpio_oen              ,
        wdg_out_rst	      ,
  
        sys_info	      ,
        top_status	      ,
        top_ctl1              ,	 
        top_ctl2              ,	 
        top_ctl3              ,              
        top_ctl4              

       `ifdef BIST				 					
                              ,
        bist_clk	      , 
        rst_l		      , 
        scan_en		      ,
        hold_l		      , 
        debugz		      , 
        test_h		      , 
        scan_out	      , 
        fail_h		      , 
        tst_done
       `endif		
       );

  input         test_en                 ;

  input		clk_cpu			;
  input         clk_bus                 ;
  input         clk_spix2               ;

  output [ 1:0] cpu_pad_soft_rst        ;                                  
  input         pad_cpu_rst_b           ;  
  input         pad_had_rst_b           ;
  input         pad_had_jtg_trst_b      ;   
  input         pad_bus_rst_b		; 
  input         pad_spi_rst_b		;
          
  input         pad_had_jtg_tclk        ;                    
  input         pad_had_jtg_tms_i       ;                                   
  output        had_pad_jtg_tms_o       ;                  
  output        had_pad_jtg_tms_oe      ;              
  output [ 1:0] had_pad_jdb_pm          ;
  input         pad_sysio_dbgrq_b       ;  
  
  input         pad_cpu_wakeup_event    ; 
  output [ 1:0] sysio_pad_lpmd_b        ;
	
  input	        cpu_boot_done		;
  input  [ 3:0] pmu_int_irq             ;
  output        pmu_penable             ;              
  output        pmu_psel                ;                 
  output        pmu_pwrite              ;               
  output [ 7:2] pmu_paddr               ;                
  output [31:0] pmu_pwdata              ;               
  input  [31:0] pmu_prdata              ;               
  input         pmu_pready              ;

`ifdef INN_MEM
`else
  output        cpu_sram_cen    	;
  output        cpu_sram_wen    	;
  output [11:2] cpu_sram_addr   	;
  output [31:0] cpu_sram_din    	;
  input  [31:0] cpu_sram_dout		;
`endif

  input         uart1_rx                ;  
  output        uart1_tx                ;  
  input         uart2_rx                ;  
  output        uart2_tx                ;  

  output        m_scl_oe                ;
  output        m_scl_out               ;
  input         m_scl_in                ; 
  output        m_sda_oe                ; 
  output        m_sda_out               ; 
  input         m_sda_in                ;   	

  output        s_sda_out               ;
  output        s_sda_oe                ;
  input         s_scl_in                ;
  input         s_sda_in                ;

  input         ir_in                   ;

  input		fr_spi_sin		;
  input		fr_spi_sin2		;
  output	to_spi_csn		;
  output	to_spi_sck		;
  output	to_spi_sout		;
  output	to_spi_sout_oen		;

  output [ 4:0]	pwm_out		        ;
  
  input	 [23:0]	gpio_in			;
  output [23:0]	gpio_out		;
  output [23:0]	gpio_oen		;
  output	wdg_out_rst		;
  input  [63:0]	sys_info		;
  input  [31:0]	top_status		;
  output [31:0]	top_ctl1		;
  output [31:0]	top_ctl2		;
  output [31:0]	top_ctl3		;
  output [31:0]	top_ctl4		;

 `ifdef BIST    
  input		bist_clk		;
  input		rst_l			; 
  input		scan_en			;
  input		hold_l			; 
  input		debugz			; 
  input		test_h			; 
  output	scan_out		;
  output	fail_h		        ; 
  output	tst_done		;
 `endif
  
//----------------------------------------   
  // Instruction bus signals
  wire   [31:0] pad_iahbl_hrdata        ;                    
  wire          pad_iahbl_hready        ;                    
  wire          pad_iahbl_hresp         ;                     
  wire   [31:0] iahbl_pad_haddr         ;                                
  wire   [ 3:0] iahbl_pad_hprot         ;                  
  wire   [ 2:0] iahbl_pad_hsize         ;                   
  wire   [ 1:0] iahbl_pad_htrans        ;                  
  wire   [31:0] iahbl_pad_hwdata        ;                 
  wire          iahbl_pad_hwrite        ;        
  wire   [11:0] pad_bmu_iahbl_base      ; 
  wire   [11:0] pad_bmu_iahbl_mask      ;       
  wire   [31:0] pad_cpu_rst_addr        ;

  // System bus signals
  wire   [31:0] pad_biu_hrdata          ;                      
  wire          pad_biu_hready          ;                      
  wire          pad_biu_hresp           ;                       
  wire   [31:0] biu_pad_haddr           ;                                           
  wire   [ 3:0] biu_pad_hprot           ;                      
  wire   [ 2:0] biu_pad_hsize           ;                       
  wire   [ 1:0] biu_pad_htrans          ;                      
  wire   [31:0] biu_pad_hwdata          ;                      
  wire          biu_pad_hwrite          ;  

  // Int signals
  wire   [63:0] pad_cpu_sys_cnt         ;//STC 
  wire   [31:0] pad_clic_int_vld        ;
  wire		top_reg_int_irq		;
  wire          uart1_rx_int_irq        ; 
  wire          uart1_tx_int_irq        ; 
  wire          uart2_rx_int_irq        ; 
  wire          uart2_tx_int_irq        ; 
  wire          iicm_int_irq            ;  
  wire          iics_int_irq            ; 
  wire          ir_int_irq              ;
  wire          wdg_out_int             ;
  wire   [ 3:0] timer_int               ;

  // CPU status
  wire   [31:0] iu_pad_gpr_data         ;                   
  wire   [ 4:0] iu_pad_gpr_index        ;                   
  wire          iu_pad_gpr_we           ;                  
  wire          iu_pad_inst_retire      ;               
  wire          iu_pad_inst_split       ;               
  wire   [31:0] iu_pad_retire_pc        ; 
  wire   [31:0] cp0_pad_mcause          ;                     
  wire   [31:0] cp0_pad_mintstatus      ;                  
  wire   [31:0] cp0_pad_mstatus         ;                                        
  wire          cpu_pad_lockup          ;  

  //APB bus signals                                    
  wire	 [31:0] paddr_sf		; 
  wire          psel_sf			;
  wire          psel_sf_s		;  
  wire	       	penable_sf		;
  wire	       	pwrite_sf		; 
  wire	 [31:0] pwdata_sf		;      
  wire	 [31:0] prdata_sf		;   
  wire          pready_sf		;                                                  
  wire	 [31:0] paddr_0		        ; 
  wire          psel_0			; 
  wire          psel_0_s		; 
  wire	       	penable_0		;
  wire	       	pwrite_0		; 
  wire	 [31:0] pwdata_0		;      
  wire	 [31:0] prdata_0		;   
  wire          pready_0		;
  wire	 [31:0] paddr_1		        ; 
  wire          psel_1			;  
  wire          psel_1_s		;     
  wire	       	penable_1		;
  wire	       	pwrite_1		; 
  wire	 [31:0] pwdata_1		;      
  wire	 [31:0] prdata_1		;   
  wire          pready_1		;
  wire	 [31:0] paddr_2		        ; 
  wire          psel_2			; 
  wire          psel_2_s		; 
  wire	       	penable_2		;
  wire	       	pwrite_2		; 
  wire	 [31:0] pwdata_2		;      
  wire	 [31:0] prdata_2		;   
  wire          pready_2		;
  wire	 [31:0] paddr_3		        ; 
  wire          psel_3			; 
  wire          psel_3_s		; 
  wire	       	penable_3		;
  wire	       	pwrite_3		; 
  wire	 [31:0] pwdata_3		;      
  wire	 [31:0] prdata_3		;   
  wire          pready_3		;
  wire	 [31:0] paddr_4		        ; 
  wire          psel_4			; 
  wire          psel_4_s		; 
  wire	       	penable_4		;
  wire	       	pwrite_4		; 
  wire	 [31:0] pwdata_4		;      
  wire	 [31:0] prdata_4		;   
  wire          pready_4		;
  wire	 [31:0] paddr_5		        ; 
  wire          psel_5			; 
  wire          psel_5_s		; 
  wire	       	penable_5		;
  wire	       	pwrite_5		; 
  wire	 [31:0] pwdata_5		;      
  wire	 [31:0] prdata_5		;   
  wire          pready_5		;
  wire	 [31:0] paddr_6		        ; 
  wire          psel_6			;  
  wire          psel_6_s		;      
  wire	       	penable_6		;
  wire	       	pwrite_6		; 
  wire	 [31:0] pwdata_6		;      
  wire	 [31:0] prdata_6		;   
  wire          pready_6		;
  wire	 [31:0] paddr_7		        ; 
  wire          psel_7			;   
  wire          psel_7_s		;    
  wire	       	penable_7		;
  wire	       	pwrite_7		; 
  wire	 [31:0] pwdata_7		;      
  wire	 [31:0] prdata_7		;   
  wire          pready_7		;

`ifdef INN_MEM 
  wire          cpu_sram_cen    	;
  wire          cpu_sram_wen    	;
  wire   [11:2] cpu_sram_addr   	;
  wire   [31:0] cpu_sram_din    	;
  wire   [31:0] cpu_sram_dout		;
`endif

  wire          spi_sout_en             ;

  //--------------------------------------------------------------------------------
  // MCU Top Start
  //--------------------------------------------------------------------------------
//assign pad_cpu_rst_addr   = cpu_boot_done ? 32'h400000 : 32'h0; 
  assign pad_cpu_rst_addr   = 32'h0;
//assign pad_bmu_iahbl_base = cpu_boot_done ? 12'h4   : 12'h0;
//assign pad_bmu_iahbl_mask = cpu_boot_done ? 12'hfff : 12'hffc;
//assign pad_bmu_iahbl_base = cpu_boot_done ? 12'h10  : 12'h0;
//assign pad_bmu_iahbl_mask = cpu_boot_done ? 12'hfff : 12'hff0;
  assign pad_bmu_iahbl_base = 12'h0;
  assign pad_bmu_iahbl_mask = 12'hfe0;
  assign pad_clic_int_vld   = {15'h0,timer_int,wdg_out_int,ir_int_irq,iics_int_irq,iicm_int_irq,
                               uart2_tx_int_irq,uart2_rx_int_irq,uart1_tx_int_irq,uart1_rx_int_irq,pmu_int_irq,top_reg_int_irq};

  E902_20210130  u_mcu_core
       (
        // DFT                          
        .pad_yy_test_mode       (test_en                ),//in
        .pad_yy_gate_clk_en_b   (test_en                ),//in gate clk enable for low power,low active 

        // System clk                   
        .pll_core_cpuclk        (clk_cpu                ),//in

        // Reset    
        .cpu_pad_soft_rst       (cpu_pad_soft_rst       ),//out  [1 :0]                   
        .pad_cpu_rst_addr       (pad_cpu_rst_addr       ),//in   [31:0]                   
        .pad_cpu_rst_b          (pad_cpu_rst_b          ),//in  
        .pad_had_rst_b          (pad_had_rst_b          ),//in
        .pad_had_jtg_trst_b     (pad_had_jtg_trst_b     ),//in    

        // Instruction BUS
        .pad_iahbl_hrdata       (pad_iahbl_hrdata       ),//in   [31:0]                    
        .pad_iahbl_hready       (pad_iahbl_hready       ),//in                    
        .pad_iahbl_hresp        (pad_iahbl_hresp        ),//in                     
        .pad_bmu_iahbl_base     (pad_bmu_iahbl_base     ),//in   [11:0]  start addr                 
        .pad_bmu_iahbl_mask     (pad_bmu_iahbl_mask     ),//in   [11:0]  1MB addr space
        .iahbl_pad_haddr        (iahbl_pad_haddr        ),//out  [31:0]                  
        .iahbl_pad_hburst       (                       ),//out  [2 :0]  single only                
        .iahbl_pad_hprot        (iahbl_pad_hprot        ),//out  [3 :0]                  
        .iahbl_pad_hsize        (iahbl_pad_hsize        ),//out  [2 :0]                   
        .iahbl_pad_htrans       (iahbl_pad_htrans       ),//out  [1 :0]                  
        .iahbl_pad_hwdata       (iahbl_pad_hwdata       ),//out  [31:0]                 
        .iahbl_pad_hwrite       (iahbl_pad_hwrite       ),//out    

        // System BUS
        .pad_biu_hrdata         (pad_biu_hrdata         ),//in   [31:0]                      
        .pad_biu_hready         (pad_biu_hready         ),//in                      
        .pad_biu_hresp          (pad_biu_hresp          ),//in                       
        .biu_pad_haddr          (biu_pad_haddr          ),//out  [31:0]                      
        .biu_pad_hburst         (                       ),//out  [2 :0] single only                    
        .biu_pad_hprot          (biu_pad_hprot          ),//out  [3 :0]                      
        .biu_pad_hsize          (biu_pad_hsize          ),//out  [2 :0]                       
        .biu_pad_htrans         (biu_pad_htrans         ),//out  [1 :0]                      
        .biu_pad_hwdata         (biu_pad_hwdata         ),//out  [31:0]                      
        .biu_pad_hwrite         (biu_pad_hwrite         ),//out  
          
        // Interrupts & Low power      
        .pad_clic_int_vld       (pad_clic_int_vld       ),//in   [31:0] int 16-47,can wake up CPU                            
        .pad_cpu_ext_int_b      (1'b1                   ),//in   int 11,can wakup CPU                
        .pad_cpu_nmi            (1'b0                   ),//in   non-mask int,can wake up CPU                 
        .pad_cpu_sys_cnt        (pad_cpu_sys_cnt        ),//in   [63:0] int 7: timer int  
        .pad_cpu_wakeup_event   (pad_cpu_wakeup_event   ),//in can wake up CPU,need sync by MCU clk    
        .sysio_pad_lpmd_b       (sysio_pad_lpmd_b       ),//out  [1 :0]	to PMU/Topreg	
                   
        // JTAG & Debug             
        .pad_had_jtg_tclk       (pad_had_jtg_tclk       ),//in                    
        .pad_had_jtg_tms_i      (pad_had_jtg_tms_i      ),//in                                   
        .had_pad_jtg_tms_o      (had_pad_jtg_tms_o      ),//out                  
        .had_pad_jtg_tms_oe     (had_pad_jtg_tms_oe     ),//out              
        .had_pad_jdb_pm         (had_pad_jdb_pm         ),//out  [1 :0]  
        .pad_sysio_dbgrq_b      (pad_sysio_dbgrq_b      ),//in   
                     
        // DFS            
        .pad_cpu_dfs_req        (1'b0                   ),//in    
        .cpu_pad_dfs_ack        (                       ),//out 
                                    
        // CPU status                         
        .iu_pad_gpr_data        (iu_pad_gpr_data        ),//out  [31:0]                   
        .iu_pad_gpr_index       (iu_pad_gpr_index       ),//out  [4 :0]                   
        .iu_pad_gpr_we          (iu_pad_gpr_we          ),//out                  
        .iu_pad_inst_retire     (iu_pad_inst_retire     ),//out               
        .iu_pad_inst_split      (iu_pad_inst_split      ),//out               
        .iu_pad_retire_pc       (iu_pad_retire_pc       ),//out  [31:0] 
        .cp0_pad_mcause         (cp0_pad_mcause         ),//out  [31:0]                     
        .cp0_pad_mintstatus     (cp0_pad_mintstatus     ),//out  [31:0]                  
        .cp0_pad_mstatus        (cp0_pad_mstatus        ),//out  [31:0]                                        
        .cpu_pad_lockup         (cpu_pad_lockup         ) //out     	
       );

//--------------------------------------------------------------------------------
// MCU Top End
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Bus Top Start
//--------------------------------------------------------------------------------

  ahb_ibus_itf #(32,1,0,12,32,24)  u_ahb_ibus_itf
       (
        .HCLK                   (clk_bus                ),      
        .HRESETn                (pad_bus_rst_b          ),  
 
        // AHB interface
        .HADDR                  (iahbl_pad_haddr        ),     
        .HTRANS                 (iahbl_pad_htrans       ),// Transfer control
        .HSIZE                  (iahbl_pad_hsize        ),// Transfer size
        .HPROT                  (iahbl_pad_hprot        ),// Protection control
        .HWRITE                 (iahbl_pad_hwrite       ),// Write control
        .HWDATA                 (iahbl_pad_hwdata       ),// Write data
        .HREADYOUT              (pad_iahbl_hready       ),// Device ready
        .HRDATA                 (pad_iahbl_hrdata       ),// Read data output
        .HRESP                  (pad_iahbl_hresp        ),// Device response

        // APB interface
        .PADDR_0                (paddr_sf               ),// APB Address  [31:0]
        .PENABLE_0              (penable_sf             ),// APB Enable
        .PWRITE_0               (pwrite_sf              ),// APB Write
        .PSTRB_0                (                       ),// APB Byte Strobe [3:0]
        .PPROT_0                (                       ),// APB Prot  [2:0]
        .PWDATA_0               (pwdata_sf              ),// APB write data  [31:0]
        .PSEL_0                 (psel_sf_s              ),// APB Select
        .PRDATA_0               (prdata_sf              ),// Read data for each APB slave  [31:0]
        .PREADY_0               (pready_sf              ),// Ready for each APB slave
        .PSLVERR_0              (1'b0                   ),// Error state for each APB slave

        .addr_switch            (cpu_boot_done          ),

        //SRAM interface       
        .mem_addr               (cpu_sram_addr          ),//[11:2]
        .mem_wen                (cpu_sram_wen           ),
        .mem_cen                (cpu_sram_cen           ),
        .mem_wdata              (cpu_sram_din           ),//[31:0]
        .mem_rdata              (cpu_sram_dout          ) //[31:0]
       );


  ahb_sbus_itf #(32,1,0,19)  u_ahb_sbus_itf
       (
        .HCLK                   (clk_bus                ),
        .HRESETn                (pad_bus_rst_b          ),

        .HADDR                  (biu_pad_haddr          ),// Address
        .HTRANS                 (biu_pad_htrans         ),// Transfer control  [1:0]
        .HSIZE                  (biu_pad_hsize          ),// Transfer size  [2:0]
        .HPROT                  (biu_pad_hprot          ),// Protection control  [3:0]
        .HWRITE                 (biu_pad_hwrite         ),// Write control
        .HWDATA                 (biu_pad_hwdata         ),// Write data  [31:0]

        .HREADYOUT              (pad_biu_hready         ),// Device ready
        .HRDATA                 (pad_biu_hrdata         ),// Read data output  [31:0]
        .HRESP                  (pad_biu_hresp          ),// Device response

        // APB 
        //apb port0
        .PADDR_0                (paddr_0                ),// APB Address  [31:0]
        .PENABLE_0              (penable_0              ),// APB Enable
        .PWRITE_0               (pwrite_0               ),// APB Write
        .PSTRB_0                (                       ),// APB Byte Strobe [3:0]
        .PPROT_0                (                       ),// APB Prot  [2:0]
        .PWDATA_0               (pwdata_0               ),// APB write data  [31:0]
        .PSEL_0                 (psel_0_s               ),// APB Select
        .PRDATA_0               (prdata_0               ),// Read data for each APB slave  [31:0]
        .PREADY_0               (pready_0               ),// Ready for each APB slave
        .PSLVERR_0              (1'b0                   ),// Error state for each APB slave

        //apb port1
        .PADDR_1                (paddr_1                ),// APB Address  [31:0]
        .PENABLE_1              (penable_1              ),// APB Enable
        .PWRITE_1               (pwrite_1               ),// APB Write
        .PSTRB_1                (                       ),// APB Byte Strobe [3:0]
        .PPROT_1                (                       ),// APB Prot  [2:0]
        .PWDATA_1               (pwdata_1               ),// APB write data  [31:0]
        .PSEL_1                 (psel_1_s               ),// APB Select
        .PRDATA_1               (prdata_1               ),// Read data for each APB slave  [31:0]
        .PREADY_1               (pready_1               ),// Ready for each APB slave
        .PSLVERR_1              (1'b0                   ),// Error state for each APB slave

        //apb port2
        .PADDR_2                (paddr_2                ),// APB Address  [31:0]
        .PENABLE_2              (penable_2              ),// APB Enable
        .PWRITE_2               (pwrite_2               ),// APB Write
        .PSTRB_2                (                       ),// APB Byte Strobe [3:0]
        .PPROT_2                (                       ),// APB Prot  [2:0]
        .PWDATA_2               (pwdata_2               ),// APB write data  [31:0]
        .PSEL_2                 (psel_2_s               ),// APB Select
        .PRDATA_2               (prdata_2               ),// Read data for each APB slave  [31:0]
        .PREADY_2               (pready_2               ),// Ready for each APB slave
        .PSLVERR_2              (1'b0                   ),// Error state for each APB slave

        //apb port3
        .PADDR_3                (paddr_3                ),// APB Address  [31:0]
        .PENABLE_3              (penable_3              ),// APB Enable
        .PWRITE_3               (pwrite_3               ),// APB Write
        .PSTRB_3                (                       ),// APB Byte Strobe [3:0]
        .PPROT_3                (                       ),// APB Prot  [2:0]
        .PWDATA_3               (pwdata_3               ),// APB write data  [31:0]
        .PSEL_3                 (psel_3_s               ),// APB Select
        .PRDATA_3               (prdata_3               ),// Read data for each APB slave  [31:0]
        .PREADY_3               (pready_3               ),// Ready for each APB slave
        .PSLVERR_3              (1'b0                   ),// Error state for each APB slave

        //apb port4
        .PADDR_4                (paddr_4                ),// APB Address  [31:0]
        .PENABLE_4              (penable_4              ),// APB Enable
        .PWRITE_4               (pwrite_4               ),// APB Write
        .PSTRB_4                (                       ),// APB Byte Strobe [3:0]
        .PPROT_4                (                       ),// APB Prot  [2:0]
        .PWDATA_4               (pwdata_4               ),// APB write data  [31:0]
        .PSEL_4                 (psel_4_s               ),// APB Select
        .PRDATA_4               (prdata_4               ),// Read data for each APB slave  [31:0]
        .PREADY_4               (pready_4               ),// Ready for each APB slave
        .PSLVERR_4              (1'b0                   ),// Error state for each APB slave

        //apb port5
        .PADDR_5                (paddr_5                ),// APB Address  [31:0]
        .PENABLE_5              (penable_5              ),// APB Enable
        .PWRITE_5               (pwrite_5               ),// APB Write
        .PSTRB_5                (                       ),// APB Byte Strobe [3:0]
        .PPROT_5                (                       ),// APB Prot  [2:0]
        .PWDATA_5               (pwdata_5               ),// APB write data  [31:0]
        .PSEL_5                 (psel_5_s               ),// APB Select
        .PRDATA_5               (prdata_5               ),// Read data for each APB slave  [31:0]
        .PREADY_5               (pready_5               ),// Ready for each APB slave
        .PSLVERR_5              (1'b0                   ),// Error state for each APB slave

        //apb port6
        .PADDR_6                (paddr_6                ),// APB Address  [31:0]
        .PENABLE_6              (penable_6              ),// APB Enable
        .PWRITE_6               (pwrite_6               ),// APB Write
        .PSTRB_6                (                       ),// APB Byte Strobe [3:0]
        .PPROT_6                (                       ),// APB Prot  [2:0]
        .PWDATA_6               (pwdata_6               ),// APB write data  [31:0]
        .PSEL_6                 (psel_6_s               ),// APB Select
        .PRDATA_6               (prdata_6               ),// Read data for each APB slave  [31:0]
        .PREADY_6               (pready_6               ),// Ready for each APB slave
        .PSLVERR_6              (1'b0                   ),// Error state for each APB slave

        //apb port7
        .PADDR_7                (paddr_7                ),// APB Address  [31:0]
        .PENABLE_7              (penable_7              ),// APB Enable
        .PWRITE_7               (pwrite_7               ),// APB Write
        .PSTRB_7                (                       ),// APB Byte Strobe [3:0]
        .PPROT_7                (                       ),// APB Prot  [2:0]
        .PWDATA_7               (pwdata_7               ),// APB write data  [31:0]
        .PSEL_7                 (psel_7_s               ),// APB Select
        .PRDATA_7               (prdata_7               ),// Read data for each APB slave  [31:0]
        .PREADY_7               (pready_7               ),// Ready for each APB slave
        .PSLVERR_7              (1'b0                   ),// Error state for each APB slave

        //apb port8
        .PADDR_8                (                       ),// APB Address  [31:0]
        .PENABLE_8              (                       ),// APB Enable
        .PWRITE_8               (                       ),// APB Write
        .PSTRB_8                (                       ),// APB Byte Strobe [3:0]
        .PPROT_8                (                       ),// APB Prot  [2:0]
        .PWDATA_8               (                       ),// APB write data  [31:0]
        .PSEL_8                 (                       ),// APB Select
        .PRDATA_8               (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_8               (1'b1                   ),// Ready for each APB slave
        .PSLVERR_8              (1'b0                   ),// Error state for each APB slave

        //apb port9
        .PADDR_9                (                       ),// APB Address  [31:0]
        .PENABLE_9              (                       ),// APB Enable
        .PWRITE_9               (                       ),// APB Write
        .PSTRB_9                (                       ),// APB Byte Strobe [3:0]
        .PPROT_9                (                       ),// APB Prot  [2:0]
        .PWDATA_9               (                       ),// APB write data  [31:0]
        .PSEL_9                 (                       ),// APB Select
        .PRDATA_9               (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_9               (1'b1                   ),// Ready for each APB slave
        .PSLVERR_9              (1'b0                   ),// Error state for each APB slave

        //apb port10
        .PADDR_10               (                       ),// APB Address  [31:0]
        .PENABLE_10             (                       ),// APB Enable
        .PWRITE_10              (                       ),// APB Write
        .PSTRB_10               (                       ),// APB Byte Strobe [3:0]
        .PPROT_10               (                       ),// APB Prot  [2:0]
        .PWDATA_10              (                       ),// APB write data  [31:0]
        .PSEL_10                (                       ),// APB Select
        .PRDATA_10              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_10              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_10             (1'b0                   ),// Error state for each APB slave

        //apb port11
        .PADDR_11               (                       ),// APB Address  [31:0]
        .PENABLE_11             (                       ),// APB Enable
        .PWRITE_11              (                       ),// APB Write
        .PSTRB_11               (                       ),// APB Byte Strobe [3:0]
        .PPROT_11               (                       ),// APB Prot  [2:0]
        .PWDATA_11              (                       ),// APB write data  [31:0]
        .PSEL_11                (                       ),// APB Select
        .PRDATA_11              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_11              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_11             (1'b0                   ),// Error state for each APB slave

        //apb port12
        .PADDR_12               (                       ),// APB Address  [31:0]
        .PENABLE_12             (                       ),// APB Enable
        .PWRITE_12              (                       ),// APB Write
        .PSTRB_12               (                       ),// APB Byte Strobe [3:0]
        .PPROT_12               (                       ),// APB Prot  [2:0]
        .PWDATA_12              (                       ),// APB write data  [31:0]
        .PSEL_12                (                       ),// APB Select
        .PRDATA_12              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_12              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_12             (1'b0                   ),// Error state for each APB slave

        //apb port13
        .PADDR_13               (                       ),// APB Address  [31:0]
        .PENABLE_13             (                       ),// APB Enable
        .PWRITE_13              (                       ),// APB Write
        .PSTRB_13               (                       ),// APB Byte Strobe [3:0]
        .PPROT_13               (                       ),// APB Prot  [2:0]
        .PWDATA_13              (                       ),// APB write data  [31:0]
        .PSEL_13                (                       ),// APB Select
        .PRDATA_13              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_13              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_13             (1'b0                   ),// Error state for each APB slave

        //apb port14
        .PADDR_14               (                       ),// APB Address  [31:0]
        .PENABLE_14             (                       ),// APB Enable
        .PWRITE_14              (                       ),// APB Write
        .PSTRB_14               (                       ),// APB Byte Strobe [3:0]
        .PPROT_14               (                       ),// APB Prot  [2:0]
        .PWDATA_14              (                       ),// APB write data  [31:0]
        .PSEL_14                (                       ),// APB Select
        .PRDATA_14              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_14              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_14             (1'b0                   ),// Error state for each APB slave

        //apb port15
        .PADDR_15               (                       ),// APB Address  [31:0]
        .PENABLE_15             (                       ),// APB Enable
        .PWRITE_15              (                       ),// APB Write
        .PSTRB_15               (                       ),// APB Byte Strobe [3:0]
        .PPROT_15               (                       ),// APB Prot  [2:0]
        .PWDATA_15              (                       ),// APB write data  [31:0]
        .PSEL_15                (                       ),// APB Select
        .PRDATA_15              (32'h0                  ),// Read data for each APB slave  [31:0]
        .PREADY_15              (1'b1                   ),// Ready for each APB slave
        .PSLVERR_15             (1'b0                   ) // Error state for each APB slave
       );

  assign psel_sf = paddr_sf[31:22] == 10'h000 & psel_sf_s;

  assign psel_0  = paddr_0[31:20] == 12'h1F0 & psel_0_s;
  assign psel_1  = paddr_1[31:20] == 12'h1F0 & psel_1_s;
  assign psel_2  = paddr_2[31:20] == 12'h1F0 & psel_2_s;
  assign psel_3  = paddr_3[31:20] == 12'h1F0 & psel_3_s;
  assign psel_4  = paddr_4[31:20] == 12'h1F0 & psel_4_s;
  assign psel_5  = paddr_5[31:20] == 12'h1F0 & psel_5_s;
  assign psel_6  = paddr_6[31:20] == 12'h1F0 & psel_6_s;
  assign psel_7  = paddr_7[31:20] == 12'h1F0 & psel_7_s;

  assign pmu_penable = penable_1;              
  assign pmu_psel    = psel_1;                 
  assign pmu_pwrite  = pwrite_1;               
  assign pmu_paddr   = paddr_1[7:2];                
  assign pmu_pwdata  = pwdata_1;               
  assign prdata_1    = pmu_prdata;               
  assign pready_1    = pmu_pready;

//--------------------------------------------------------------------------------
// Bus Top End
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// Code RAM Start
//--------------------------------------------------------------------------------
`ifdef INN_MEM 
  cpu_sram   u_cpu_sram
       (
        .clk                    (clk_bus                ),      
        .rst_n                  (pad_bus_rst_b          ),  
	
	//CPU sram
	.sram_cen		(cpu_sram_cen   	),
	.sram_wen		(cpu_sram_wen   	),
	.sram_addr		(cpu_sram_addr  	),
	.sram_din		(cpu_sram_din		),
	.sram_dout		(cpu_sram_dout		)
	
       `ifdef BIST	
                                                         ,			 
	.tst_done     		(tst_done[1:0]		),
	.fail_h       		(fail_h[1:0]  		),
	.scan_out     		(scan_out[1:0]		),
	.hold_l       		(hold_l  		),
	.debugz       		(debugz  		),
	.test_h       		(test_h  		),
	.bist_clk     		(bist_clk		),
	.scan_en		(scan_en		),
	.rst_l        		(rst_l   		)
       `endif
       );
`endif
//--------------------------------------------------------------------------------
// Code RAM End
//--------------------------------------------------------------------------------

   
//--------------------------------------------------------------------------------
// S-flash Start
//--------------------------------------------------------------------------------

  flash u_flash (
	.rst_spi_n		(pad_spi_rst_b		),
	.presetn		(pad_bus_rst_b		),
	.pclk			(clk_bus		),
	.spix2_clk		(clk_spix2		),

	.penable		(penable_sf		),
	.psel			(psel_sf		),
	.pwrite			(pwrite_sf		),
	.paddr			(paddr_sf[23:2] 	),
	.pwdata			(pwdata_sf      	),
	.prdata			(prdata_sf		),
	.pready			(pready_sf		),

	.fr_spi_sin		(fr_spi_sin		),
	.fr_spi_sin2		(fr_spi_sin2		),
	.to_spi_cs		(to_spi_csn		),
	.to_spi_sck		(to_spi_sck		),
	.to_spi_hold		(		        ),
	.to_spi_sout		(to_spi_sout		),
	.to_spi_sout_en		(spi_sout_en		)
       );

  assign to_spi_sout_oen = ~spi_sout_en;

//--------------------------------------------------------------------------------
// S-flash End 
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// UART Start
//--------------------------------------------------------------------------------

  uart_top  u_uart1_top
       (
        .pclk                   (clk_bus                ),
        .prstn                  (pad_bus_rst_b          ),

        .paddr                  (paddr_5[31:0]          ),
        .pwrite                 (pwrite_5               ),
        .penable                (penable_5              ),
        .psel                   (psel_5                 ),
        .pwdata                 (pwdata_5               ),
        .prdata                 (prdata_5               ),
        .pready                 (pready_5               ),

        .uart_rx                (uart1_rx               ),  
        .uart_tx                (uart1_tx               ), 
        .uart_ri                (uart1_rx_int_irq       ), 
        .uart_ti                (uart1_tx_int_irq       ), 
        .ext_uart_en            (                       )
       );
	
  uart_top  u_uart2_top
       (
        .pclk                   (clk_bus                ),
        .prstn                  (pad_bus_rst_b          ),

        .paddr                  (paddr_6[31:0]          ),
        .pwrite                 (pwrite_6               ),
        .penable                (penable_6              ),
        .psel                   (psel_6                 ),
        .pwdata                 (pwdata_6               ),
        .prdata                 (prdata_6               ),
        .pready                 (pready_6               ),

        .uart_rx                (uart2_rx               ),  
        .uart_tx                (uart2_tx               ), 
        .uart_ri                (uart2_rx_int_irq       ), 
        .uart_ti                (uart2_tx_int_irq       ), 
        .ext_uart_en            (                       )
       );

//--------------------------------------------------------------------------------
// UART End
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// I2C Master
//--------------------------------------------------------------------------------

  iic_master_wrap  u_iic_master
       (
        .pclk                   (clk_bus                ),
        .prstn                  (pad_bus_rst_b          ),

        .paddr                  (paddr_3[23:0]          ),
        .pwrite                 (pwrite_3               ),
        .penable                (penable_3              ),
        .psel                   (psel_3                 ),
        .pwdata                 (pwdata_3               ),
        .prdata                 (prdata_3               ),
        .pready                 (pready_3               ),

        .iicm_int               (iicm_int_irq           ),

        .scl                    (m_scl_out              ),
        .scl_in                 (m_scl_in               ), 
        .sda_oe                 (m_sda_oe               ), 
        .sda_out                (m_sda_out              ), 
        .sda_in                 (m_sda_in               )         
       );
	
  assign  m_scl_oe  = ~m_scl_out                         ;
 
//--------------------------------------------------------------------------------
// I2C Master End
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// I2C Slave
//--------------------------------------------------------------------------------

  iic_slave_wrap  u_iic_slave
       (
        .pclk                   (clk_bus                ),
        .prstn                  (pad_bus_rst_b          ),

        .psel                   (psel_4                 ),
        .penable                (penable_4              ),
        .pwrite                 (pwrite_4               ),
        .paddr                  (paddr_4[23:0]          ),
        .pwdata                 (pwdata_4               ),
        .prdata                 (prdata_4               ),
        .pready                 (pready_4               ),

        .cpu_sda_out            (s_sda_out              ),
        .slave_sda_oe           (s_sda_oe               ),
        .cpu_scl_in             (s_scl_in               ),
        .sda_data_in            (s_sda_in               ),
        .slave_rw_int           (iics_int_irq           )   
       );
	
 
//--------------------------------------------------------------------------------
// I2C Slave End
//--------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
// IR Start 
//--------------------------------------------------------------------------------

  ir u_ir 
       (
	.pclk                  	(clk_bus		),
	.presetn                (pad_bus_rst_b		),

	.penable		(penable_7		),
	.psel		  	(psel_7			),
	.pwrite		  	(pwrite_7		),
	.paddr		  	(paddr_7[23:0]		),
	.pwdata		  	(pwdata_7		),
	.prdata		  	(prdata_7		),
	.pready		  	(pready_7		),

	.ir_int                	(ir_int_irq		),
	.sin 	             	(ir_in  		)    
       );
 
//--------------------------------------------------------------------------------
// IR start 
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// STC start 
//--------------------------------------------------------------------------------

  stc u_stc 
       (
	.pclk			(clk_bus		),
	.presetn		(pad_bus_rst_b		),

	.penable		(penable_2		),
	.psel			(psel_2			),
	.pwrite			(pwrite_2		),
	.paddr			(paddr_2[11:2]		),
	.pwdata			(pwdata_2		),
	.prdata			(prdata_2		),
	.pready			(pready_2		),

        .stc_cnt                (pad_cpu_sys_cnt        ), 
	.pwm_out		(pwm_out		),
	.timer_int              (timer_int              ),
	.wdg_out_int		(wdg_out_int		),
	.wdg_out_rst		(wdg_out_rst		)
       );

//--------------------------------------------------------------------------------
// STC End 
//--------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
// Top Reg Start
//--------------------------------------------------------------------------------
  
  top_reg u_top_reg 
       (
	.pclk			(clk_bus		),
	.presetn		(pad_bus_rst_b		),

	.penable		(penable_0		),
	.psel			(psel_0			),
	.pwrite			(pwrite_0		),
	.paddr			(paddr_0[11:2]		),
	.pwdata			(pwdata_0		),
	.prdata			(prdata_0		),
	.pready			(pready_0		),
		   		   
	.gpin			(gpio_in		),
	.gpout			(gpio_out		),
	.gpioen			(gpio_oen		),
	
        .sys_info		(sys_info	        ),	   
	.status			(top_status		),

	.outputreg4		(top_ctl1	 	),	   
	.outputreg5		(top_ctl2               ),
	.outputreg6		(top_ctl3	 	),
	.outputreg7		(top_ctl4 	        ),
	.outputreg8		(	 	        ),
	.outputreg9		(	 	        ),
	.outputrega		( 	 	        ),
        .outputregb		(   	                ),
        .outputregc		(		        ),
        .outputregd		(		        ),
        .outputrege		(		        ),
        .outputregf		(		        ),

    	// CPU status                         
        .iu_pad_gpr_data        (iu_pad_gpr_data        ),//out  [31:0]                   
        .iu_pad_gpr_index       (iu_pad_gpr_index       ),//out  [4 :0]                   
        .iu_pad_gpr_we          (iu_pad_gpr_we          ),//out                  
        .iu_pad_inst_retire     (iu_pad_inst_retire     ),//out               
        .iu_pad_inst_split      (iu_pad_inst_split      ),//out               
        .iu_pad_retire_pc       (iu_pad_retire_pc       ),//out  [31:0] 
        .cp0_pad_mcause         (cp0_pad_mcause         ),//out  [31:0]                     
        .cp0_pad_mintstatus     (cp0_pad_mintstatus     ),//out  [31:0]                  
        .cp0_pad_mstatus        (cp0_pad_mstatus        ),//out  [31:0]                                        
        .cpu_pad_lockup         (cpu_pad_lockup         ),//out  
	   
	.out_int		(top_reg_int_irq        )
       );

//--------------------------------------------------------------------------------
// Top Reg End 
//--------------------------------------------------------------------------------
    
     
endmodule
