/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-05-19 15:27:57
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-05-19 17:49:13
#FilePath     : xadc_top.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module xadc_top(
    input                           clk                             ,
    input                           rst                             ,

    output      [11:0]              reg_device_temp

);


/********************************************************************
*                         Regs Here                                 *
********************************************************************/


/********************************************************************
*                         Wires Here                                *
********************************************************************/
wire        [15:0]                  di                              ;
wire        [6:0]                   daddr                           ;
wire                                den                             ;
wire                                dwe                             ;
wire                                drdy                            ;
wire        [15:0]                  do                              ;

wire                                eoc_out                         ;

/********************************************************************
*                         Logic Here                                *
********************************************************************/

xadc_wiz_0 u_xadc_wiz_0 (
    .di_in                                  (di                                     ),  // input wire [15 : 0] di_in
    .daddr_in                               (daddr                                  ),  // input wire [6 : 0] daddr_in
    .den_in                                 (den                                    ),  // input wire den_in
    .dwe_in                                 (dwe                                    ),  // input wire dwe_in
    .drdy_out                               (drdy                                   ),  // output wire drdy_out
    .do_out                                 (do                                     ),  // output wire [15 : 0] do_out

    .dclk_in                                (clk                                    ),  // input wire dclk_in
    .reset_in                               (rst                                    ),  // input wire reset_in

    .vp_in                                  (1'b1                                   ),  // input wire vp_in
    .vn_in                                  (1'b0                                   ),  // input wire vn_in

    .user_temp_alarm_out                    (                                       ),  // output wire user_temp_alarm_out
    .vccint_alarm_out                       (                                       ),  // output wire vccint_alarm_out
    .vccaux_alarm_out                       (                                       ),  // output wire vccaux_alarm_out
    .ot_out                                 (                                       ),  // output wire ot_out
    .channel_out                            (                                       ),  // output wire [4 : 0] channel_out
    .eoc_out                                (eoc_out                                ),  // output wire eoc_out
    .alarm_out                              (                                       ),  // output wire alarm_out
    .eos_out                                (                                       ),  // output wire eos_out
    .busy_out                               (                                       )   // output wire busy_out
);

xadc_fsm u_xadc_fsm(
    .clk                                    (clk                                    ),
    .rst                                    (rst                                    ),

    .di                                     (di                                     ),
    .daddr                                  (daddr                                  ),
    .den                                    (den                                    ),
    .dwe                                    (dwe                                    ),
    .drdy                                   (drdy                                   ),
    .do                                     (do                                     ),

    .reg_device_temp                        (reg_device_temp                        ),

    .eoc_out                                (eoc_out                                )
);

endmodule
