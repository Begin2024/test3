/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-29 17:28:03
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2022-09-08 20:00:07
#FilePath     : soft_trigger.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved. 
********************************************************************/
module soft_trigger(
    input                           clk                             ,
    input                           rst                             ,

    input           [31:0]          reg_soft_trigger_cycle          ,
    input           [31:0]          reg_soft_trigger_num            ,
    input                           reg_soft_trigger_en             ,

    output  reg                     soft_trigger

);

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/
reg                 [31:0]          trigger_cnt                     ;
reg                                 reg_soft_trigger_vld            ;

reg                 [31:0]          soft_trigger_rise_cnt           ;
reg                                 soft_trigger_d                  ;

reg                 [3:0]           reg_soft_trigger_en_d           ;


/********************************************************************
*                        Wires Here                                 *
********************************************************************/

wire                                reg_soft_trigger_en_r           ;


/********************************************************************
*                        Logic Here                                 *
********************************************************************/

always @ (posedge clk) begin
    reg_soft_trigger_en_d <= {reg_soft_trigger_en_d[2:0],reg_soft_trigger_en};
end

assign reg_soft_trigger_en_r = reg_soft_trigger_en_d[3] == 1'b0 && reg_soft_trigger_en_d[2] == 1'b1;

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        reg_soft_trigger_vld <= 1'b0;
    end else if (soft_trigger_rise_cnt == reg_soft_trigger_num && reg_soft_trigger_num != 32'h0) begin
        reg_soft_trigger_vld <= 1'b0;
    end else if (reg_soft_trigger_en == 1'b0) begin
        reg_soft_trigger_vld <= 1'b0;
    end else if (reg_soft_trigger_en_r == 1'b1) begin
        reg_soft_trigger_vld <= 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_cnt <= 32'b0;
    end else if (trigger_cnt == reg_soft_trigger_cycle - 1'b1) begin
        trigger_cnt <= 32'b0;
    end else if (reg_soft_trigger_vld == 1'b1) begin
        trigger_cnt <= trigger_cnt + 1'b1;
    end else begin
        trigger_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        soft_trigger <= 1'b0;
    end else if (reg_soft_trigger_vld == 1'b0) begin
        soft_trigger <= 1'b0;
    end else if ((trigger_cnt == 32'h0) && (reg_soft_trigger_vld == 1'b1)) begin
        soft_trigger <= 1'b1;
    end else if (trigger_cnt == 32'h10) begin
        soft_trigger <= 1'b0;
    end else
        ;
end

always @ (posedge clk) begin
    soft_trigger_d <= soft_trigger;
end

always @ (posedge clk,posedge rst) begin
    if (rst == 1'b1) begin
        soft_trigger_rise_cnt <= 32'h0;
    end else if (reg_soft_trigger_vld == 1'b0) begin
        soft_trigger_rise_cnt <= 32'h0;
    end else if (soft_trigger_d == 1'b1 && soft_trigger == 1'b0) begin
        soft_trigger_rise_cnt <= soft_trigger_rise_cnt + 1'b1;
    end else
        ;
end


(* dont_touch = "true" *)reg                            debug_soft_trigger               ;
(* dont_touch = "true" *)reg [31:0]                     debug_trigger_cnt               ;
(* dont_touch = "true" *)reg [31:0]                     debug_soft_trigger_rise_cnt               ;
(* dont_touch = "true" *)reg                            debug_soft_trigger_d               ;
(* dont_touch = "true" *)reg [3:0]                      debug_reg_soft_trigger_en_d               ;

always @ (posedge clk) begin
    debug_soft_trigger <= soft_trigger;
end
always @ (posedge clk) begin
    debug_trigger_cnt <= trigger_cnt;
end
always @ (posedge clk) begin
    debug_soft_trigger_rise_cnt <= soft_trigger_rise_cnt;
end
always @ (posedge clk) begin
    debug_soft_trigger_d <= soft_trigger_d;
end
always @ (posedge clk) begin
    debug_reg_soft_trigger_en_d <= reg_soft_trigger_en_d;
end











endmodule

