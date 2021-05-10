// *****************************************************************************
// *                                                                           *
// * C-Sky Microsystems Confidential                                           *
// * -------------------------------                                           *
// * This file and all its contents are prsrpaies of C-Sky Microsystems. The  *
// * information contained herein is confidential and proprietary and is not   *
// * to be disclosed outside of C-Sky Microsystems except under a              *
// * Non-Disclosure Agreement (NDA).                                           *
// *                                                                           *
// *****************************************************************************
// FILE NAME       : pa_mmu_sysmap.vp
// AUTHOR          : Ziyi Hao
// ORIGINAL TIME   :
// FUNCTION        : I-uTLB:
//                 : 1. 16-entry utlb 
//                 : 2. translate Va to PA
//                 : 3. visit jTLB when uTLB miss
//                 : 4. refill uTLB with PLRU algorithm
// RESET           : 
// DFT             :
// DFP             :
// VERIFICATION    :
// RELEASE HISTORY :
// $Id: sysmap.h,v 1.1 2019/10/24 08:52:17 haozy Exp $
// *****************************************************************************

// ADDR is 28-bit, 4K address
// Flag includes: Strong Order, Cacheable, Bufferable, Shareable, Security
`ifdef FPGA
`define SYSMAP_BASE_ADDR0  20'h02000
`define SYSMAP_FLG0        5'b01100

`define SYSMAP_BASE_ADDR1  20'hfffff
`define SYSMAP_FLG1        5'b00000

`define SYSMAP_BASE_ADDR2  20'hfffff
`define SYSMAP_FLG2        5'b00000

`define SYSMAP_BASE_ADDR3  20'hfffff
`define SYSMAP_FLG3        5'b00000

`define SYSMAP_BASE_ADDR4  20'hfffff
`define SYSMAP_FLG4        5'b00000

`define SYSMAP_BASE_ADDR5  20'hfffff
`define SYSMAP_FLG5        5'b00000

`define SYSMAP_BASE_ADDR6  20'hfffff
`define SYSMAP_FLG6        5'b00000

`define SYSMAP_BASE_ADDR7  20'hfffff 
`define SYSMAP_FLG7        5'b00000
`else
`define SYSMAP_BASE_ADDR0  20'h02000
`define SYSMAP_FLG0        5'b01100

`define SYSMAP_BASE_ADDR1  20'hfffff
`define SYSMAP_FLG1        5'b00000

`define SYSMAP_BASE_ADDR2  20'hfffff
`define SYSMAP_FLG2        5'b00000

`define SYSMAP_BASE_ADDR3  20'hfffff
`define SYSMAP_FLG3        5'b00000

`define SYSMAP_BASE_ADDR4  20'hfffff
`define SYSMAP_FLG4        5'b00000

`define SYSMAP_BASE_ADDR5  20'hfffff
`define SYSMAP_FLG5        5'b00000

`define SYSMAP_BASE_ADDR6  20'hfffff
`define SYSMAP_FLG6        5'b00000

`define SYSMAP_BASE_ADDR7  20'hfffff 
`define SYSMAP_FLG7        5'b00000
`endif

