/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-10-27  11:37:28
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-10-27  11:37:28
 # FilePath     : sw_driver_new.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module sw_driver(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [31:0]           reg_sw_ack_time         ,

    output wire [11:0]          dac_sw_1                ,
    output wire [11:0]          dac_sw_2                ,
    output wire [11:0]          dac_sw_3                ,
    output wire [11:0]          dac_sw_4                ,

    input wire [335:0]          sw_time_group           ,
    input wire                  sw_req                  ,
    output wire                 sw_ack
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   sw_req_dly              ;

    reg [31:0]                  cnt_time                ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        sw_req_r                ;

    wire [13:0]                 sw_group         [0:23] ;
    wire [23:0]                 sw_flag                 ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign sw_req_r             = sw_req_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sw_req_dly          <= 'd0;
        end else begin
            sw_req_dly          <= {sw_req_dly[2:0], sw_req};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_time            <= 'h3FFF_FFFF;
        end else if (sw_req_r == 1'b1) begin
            cnt_time            <= 'd0;
        end else if (cnt_time >= reg_sw_ack_time - 1'b1) begin
            cnt_time            <= 'h3FFF_FFFF;
        end else begin
            cnt_time            <= cnt_time + 1'b1;
        end
    end

    genvar i;

    generate for (i = 0; i < 24; i = i + 1) begin

        assign sw_group[i]      = sw_time_group[(((i+1)*14)-1) -: 14];

        assign sw_flag[i]       = cnt_time <= sw_group[i];
    end
    endgenerate

    // Output
    assign sw_ack               = cnt_time == (reg_sw_ack_time - 1'b1);

    assign dac_sw_1             = sw_flag[23:12];
    assign dac_sw_2             = sw_flag[11:0];
    assign dac_sw_3             = sw_flag[11:0];
    assign dac_sw_4             = sw_flag[23:12];


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_sw_ack_time               ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_1                      ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_2                      ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_3                      ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_4                      ;
(* mark_debug = "true" *)    reg    [335:0]                     debug_sw_time_group                 ;
(* mark_debug = "true" *)    reg                                debug_sw_req                        ;
(* mark_debug = "true" *)    reg                                debug_sw_ack                        ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_sw_req_dly                    ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_time                      ;
(* mark_debug = "true" *)    reg                                debug_sw_req_r                      ;
(* mark_debug = "true" *)    reg    [23:0]                      debug_sw_flag                       ;

always @ (posedge clk) begin
    debug_reg_sw_ack_time                <= reg_sw_ack_time               ;
    debug_dac_sw_1                       <= dac_sw_1                      ;
    debug_dac_sw_2                       <= dac_sw_2                      ;
    debug_dac_sw_3                       <= dac_sw_3                      ;
    debug_dac_sw_4                       <= dac_sw_4                      ;
    debug_sw_time_group                  <= sw_time_group                 ;
    debug_sw_req                         <= sw_req                        ;
    debug_sw_ack                         <= sw_ack                        ;
    debug_sw_req_dly                     <= sw_req_dly                    ;
    debug_cnt_time                       <= cnt_time                      ;
    debug_sw_req_r                       <= sw_req_r                      ;
    debug_sw_flag                        <= sw_flag                       ;
end

endmodule
