/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-05-15 16:58:44
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-05-15 19:32:07
#FilePath     : trigger_cascade.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module trigger_cascade(
    input                           clk                             ,
    input                           rst                             ,

    input                           reg_slave_device                ,

    input                           trigger_from_master             ,
    output                          trigger_to_slave                ,

    input                           trigger_i                       ,
    output  reg                     trigger_c

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

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        trigger_c <= 1'h0;
    end else if (reg_slave_device == 1'b1) begin
        trigger_c <= trigger_from_master;
    end else begin
        trigger_c <= trigger_i;
    end
end

// assign trigger_o = reg_slave_device == 1'b1 ? trigger_from_master : trigger_i;

assign trigger_to_slave = trigger_c;


endmodule
