/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-14  15:54:49
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-01-25 16:03:40
#FilePath     : mos_ctrl.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module mos_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // DAC mos port
    output wire [3:0]           dac_mos_x               ,
    output wire [3:0]           dac_mos_y               ,

    // Core_controller port
    output wire                 mos_ack                 ,
    input wire                  mos_val                 ,
    input wire                  mos_req                 ,

    // Reg_fpga port
    input wire [7:0]            reg_mos_en              ,
    input wire [15:0]           reg_mos_time
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [15:0]                  cnt_mos_time            ;
    reg [3:0]                   mos_req_dly             ;

    reg                         mos_val_lock            ;
    reg                         mos_req_r               ;

/********************************************************
*                        wires Here                     *
********************************************************/

    // wire                        mos_req_r               ;

/********************************************************
*                        logic Here                     *
********************************************************/

    // Get mos_req rise edge
    // assign mos_req_r            = mos_req_dly == 4'b0001;

    // Mos_req delay
    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            mos_req_dly<=0;
        end
        else begin
            mos_req_dly <= {mos_req_dly[2:0], mos_req};
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            mos_req_r<=0;
        end
        else if(mos_req_dly[0]&&(~mos_req_dly[1]))begin
            mos_req_r<=1;
        end
        else begin
            mos_req_r<=0;
        end
    end

    // Lock mos_val value
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mos_val_lock        <= 1'b0;
        end else if (mos_req_r == 1'b1) begin
            mos_val_lock        <= mos_val;
        end else begin
            mos_val_lock        <= mos_val_lock;
        end
    end

    // ACK counter
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_mos_time        <= 'd0;
        end else if (mos_req_r == 1'b1) begin
            cnt_mos_time        <= 1'b1;
        end else if ((cnt_mos_time +1'b1) >= reg_mos_time ) begin
            cnt_mos_time        <= 'd0;
        end else if (cnt_mos_time >= 'd1) begin
            cnt_mos_time        <= cnt_mos_time + 1'b1;
        end else begin
            cnt_mos_time        <= cnt_mos_time;
        end
    end

    // OUTPUT
    assign dac_mos_x            = {4{mos_val_lock}} & reg_mos_en[3:0];
    assign dac_mos_y            = {4{mos_val_lock}} & reg_mos_en[7:4];
    assign mos_ack              = ((cnt_mos_time + 1'b1) >= reg_mos_time) ;


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_mos_time                  ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_mos_req_dly                   ;
(* mark_debug = "true" *)    reg                                debug_mos_val_lock                  ;
(* mark_debug = "true" *)    reg                                debug_mos_req_r                     ;

always @ (posedge clk) begin
    debug_cnt_mos_time                   <= cnt_mos_time                  ;
    debug_mos_req_dly                    <= mos_req_dly                   ;
    debug_mos_val_lock                   <= mos_val_lock                  ;
    debug_mos_req_r                      <= mos_req_r                     ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [3:0]                       debug_dac_mos_x                     ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_dac_mos_y                     ;

always @ (posedge clk) begin
    debug_dac_mos_x                      <= dac_mos_x                     ;
    debug_dac_mos_y                      <= dac_mos_y                     ;
end

endmodule

