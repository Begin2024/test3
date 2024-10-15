/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-11-02  09:35:22
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-05-22 14:51:57
#FilePath     : trigger_allow.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module trigger_allow(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [7:0]            reg_trigger_level       ,

    input wire                  trigger_c               ,
    input wire                  trigger_in              ,

    output wire                 trigger_out
);

    parameter TIME_1S           = 125_000_000;

/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   trigger_c_dly           ;

    reg                         trigger_allow           ;

    reg [31:0]                  cnt_time                ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        trigger_c_r             ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign trigger_c_r          = trigger_c_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            trigger_c_dly       <= 'd0;
        end else begin
            trigger_c_dly       <= {trigger_c_dly[2:0], trigger_c};
        end
    end

    // Allow time out
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_time            <= 'd0;
        end else if (trigger_c_r == 1'b1) begin
            cnt_time            <= 'd0;
        end else if(cnt_time < TIME_1S - 1'b1)begin
            cnt_time            <= cnt_time + 1'b1;
        end
        else
        ;
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            trigger_allow       <= 'b0;
        end else if (trigger_c_r == 1'b1) begin
            trigger_allow       <= 'b1;
        end else if (trigger_out == 1'b1) begin
            trigger_allow       <= 'b0;
        end else if (cnt_time >= TIME_1S - 1'b1) begin
            trigger_allow       <= 'b0;
        end else begin
            trigger_allow       <= trigger_allow;
        end
    end


    // Output
    assign trigger_out          = (trigger_allow || (reg_trigger_level[0] == 1'b0)) && trigger_in;


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [3:0]                       debug_trigger_c_dly                 ;
(* mark_debug = "true" *)    reg                                debug_trigger_allow                 ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_time                      ;
(* mark_debug = "true" *)    reg                                debug_trigger_c_r                   ;

always @ (posedge clk) begin
    debug_trigger_c_dly                  <= trigger_c_dly                 ;
    debug_trigger_allow                  <= trigger_allow                 ;
    debug_cnt_time                       <= cnt_time                      ;
    debug_trigger_c_r                    <= trigger_c_r                   ;
end

endmodule
