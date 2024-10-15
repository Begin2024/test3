/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-02-22 11:31:58
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-02-22 11:42:13
#FilePath     : io_polar.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module io_polar(
    input                           clk                             ,
    input                           rst                             ,

    input       [1:0]               reg_trigger_polar               ,

    input                           io_input_0                      ,
    input                           io_input_1                      ,

    output                          pol_io_input_0                  ,
    output                          pol_io_input_1

);


/********************************************************************
*                         Regs Here                                 *
********************************************************************/


/********************************************************************
*                         Wires Here                                *
********************************************************************/


/********************************************************************
*                         Logic Here                                *
********************************************************************/

assign pol_io_input_0 = io_input_0 ^ reg_trigger_polar[0];
assign pol_io_input_1 = io_input_1 ^ reg_trigger_polar[1];

endmodule
