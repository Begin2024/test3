/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-10-27  11:32:21
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-10-27  11:32:21
 # FilePath     : sw_ctrl_new.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module sw_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    output wire [11:0]          dac_sw_x1               ,
    output wire [11:0]          dac_sw_x2               ,
    output wire [11:0]          dac_sw_x3               ,
    output wire [11:0]          dac_sw_x4               ,

    output wire [11:0]          dac_sw_y1               ,
    output wire [11:0]          dac_sw_y2               ,
    output wire [11:0]          dac_sw_y3               ,
    output wire [11:0]          dac_sw_y4               ,

    output wire                 sw_ack                  ,
    input wire [167:0]          sw_time_forward         ,
    input wire [167:0]          sw_time_backward        ,
    input wire [1:0]            sw_req                  ,
    input wire [31:0]           reg_sw_ack_time
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    // reg [95:0]                  sw_temp                 ;
    // reg [47:0]                  sw_temp_x               ;
    // reg [47:0]                  sw_temp_y               ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire [335:0]                sw_time_group           ;

    wire                        sw_ack_x                ;
    wire                        sw_ack_y                ;

    wire                        sw_req_x                ;
    wire                        sw_req_y                ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign sw_time_group        = {sw_time_forward, sw_time_backward};

    assign sw_req_x             = sw_req[0];
    assign sw_req_y             = sw_req[1];

    sw_driver sw_driver_x(

        .clk                                            (clk                                            ),  //input wire
        .rst                                            (rst                                            ),  //input wire

        .reg_sw_ack_time                                (reg_sw_ack_time                                ),  //input wire [31:0]

        .dac_sw_1                                       (dac_sw_x1                                      ),  //output wire [11:0]
        .dac_sw_2                                       (dac_sw_x2                                      ),  //output wire [11:0]
        .dac_sw_3                                       (dac_sw_x3                                      ),  //output wire [11:0]
        .dac_sw_4                                       (dac_sw_x4                                      ),  //output wire [11:0]

        .sw_time_group                                  (sw_time_group                                  ),  //input wire [335:0]
        .sw_req                                         (sw_req_x                                       ),  //input wire
        .sw_ack                                         (sw_ack_x                                       )   //output wire
    );


    sw_driver sw_driver_y(

        .clk                                            (clk                                            ),  //input wire
        .rst                                            (rst                                            ),  //input wire

        .reg_sw_ack_time                                (reg_sw_ack_time                                ),  //input wire [31:0]

        .dac_sw_1                                       (dac_sw_y3                                      ),  //output wire [11:0]
        .dac_sw_2                                       (dac_sw_y2                                      ),  //output wire [11:0]
        .dac_sw_3                                       (dac_sw_y1                                      ),  //output wire [11:0]
        .dac_sw_4                                       (dac_sw_y4                                      ),  //output wire [11:0]

        .sw_time_group                                  (sw_time_group                                  ),  //input wire [335:0]
        .sw_req                                         (sw_req_y                                       ),  //input wire
        .sw_ack                                         (sw_ack_y                                       )   //output wire
    );


    // Output
    assign sw_ack               = sw_ack_x || sw_ack_y;




// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_x1                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_x2                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_x3                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_x4                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_y1                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_y2                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_y3                     ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_dac_sw_y4                     ;
(* mark_debug = "true" *)    reg                                debug_sw_ack                        ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_sw_time_forward               ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_sw_time_backward              ;
(* mark_debug = "true" *)    reg    [1:0]                       debug_sw_req                        ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_sw_ack_time               ;
// (* mark_debug = "true" *)    reg    [95:0]                      debug_sw_temp                       ;
// (* mark_debug = "true" *)    reg    [47:0]                      debug_sw_temp_x                     ;
// (* mark_debug = "true" *)    reg    [47:0]                      debug_sw_temp_y                     ;
(* mark_debug = "true" *)    reg    [335:0]                     debug_sw_time_group                 ;
(* mark_debug = "true" *)    reg                                debug_sw_ack_x                      ;
(* mark_debug = "true" *)    reg                                debug_sw_ack_y                      ;
(* mark_debug = "true" *)    reg                                debug_sw_req_x                      ;
(* mark_debug = "true" *)    reg                                debug_sw_req_y                      ;

always @ (posedge clk) begin
    debug_dac_sw_x1                      <= dac_sw_x1                     ;
    debug_dac_sw_x2                      <= dac_sw_x2                     ;
    debug_dac_sw_x3                      <= dac_sw_x3                     ;
    debug_dac_sw_x4                      <= dac_sw_x4                     ;
    debug_dac_sw_y1                      <= dac_sw_y1                     ;
    debug_dac_sw_y2                      <= dac_sw_y2                     ;
    debug_dac_sw_y3                      <= dac_sw_y3                     ;
    debug_dac_sw_y4                      <= dac_sw_y4                     ;
    debug_sw_ack                         <= sw_ack                        ;
    debug_sw_time_forward                <= sw_time_forward               ;
    debug_sw_time_backward               <= sw_time_backward              ;
    debug_sw_req                         <= sw_req                        ;
    debug_reg_sw_ack_time                <= reg_sw_ack_time               ;
    // debug_sw_temp                        <= sw_temp                       ;
    // debug_sw_temp_x                      <= sw_temp_x                     ;
    // debug_sw_temp_y                      <= sw_temp_y                     ;
    debug_sw_time_group                  <= sw_time_group                 ;
    debug_sw_ack_x                       <= sw_ack_x                      ;
    debug_sw_ack_y                       <= sw_ack_y                      ;
    debug_sw_req_x                       <= sw_req_x                      ;
    debug_sw_req_y                       <= sw_req_y                      ;
end

endmodule





