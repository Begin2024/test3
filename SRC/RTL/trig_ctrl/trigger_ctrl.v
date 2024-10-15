/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-15  17:09:07
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-10-15 11:39:13
#FilePath     : trigger_ctrl.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module trigger_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // input wire                  trigger_req             ,
    output wire                 io_output               ,
    input wire                  reg_trig_out_polar      ,

    // Trigger io
    input wire                  ext_trigger_0           ,
    input wire                  ext_trigger_1           ,

    // Encoder in
    input wire                  encoder_in_a            ,
    input wire                  encoder_in_b            ,

    // Reg_fpga port

    input wire [31:0]           reg_camera_delay        ,
    input wire [31:0]           reg_camera_cycle        ,
    input wire [31:0]           reg_camera_trig_num     ,

    input wire [31:0]           reg_external_trig_num   ,
    input wire                  reg_external_trig_polar ,
    input wire [31:0]           reg_external_trig_delay ,
    input wire [31:0]           reg_external_trig_width ,
    input wire                  reg_external_trig_enable,

    input wire                  reg_status_cnt_clr      ,

    input wire [31:0]           reg_soft_trigger_cycle  ,
    input wire [31:0]           reg_soft_trigger_num    ,
    input wire                  reg_soft_trigger_en     ,

    input wire [31:0]           reg_trigger_cycle       ,
    input wire [31:0]           reg_trigger_num         ,
    input wire [3:0]            reg_trigger_mode        ,
    input wire [31:0]           reg_trigger_delay       ,
    input wire [31:0]           reg_trigger_width       ,
    input wire [31:0]           reg_trigger_pulse       ,
    input wire [1:0]            reg_trigger_polar       ,
    input wire                  reg_trigger_en          ,

    input wire                  reg_encoder_phase       ,
    input wire [3:0]            reg_encoder_cnt_mode    ,
    input wire [3:0]            reg_encoder_dis_mode    ,
    input wire [31:0]           reg_encoder_ignore      ,
    input wire [31:0]           reg_encoder_div         ,
    input wire [31:0]           reg_encoder_width       ,
    output wire [31:0]          reg_encoder_location    ,
    input wire [4:0]            reg_encoder_multi_coe   ,
    input wire                  reg_encoder_multi_en    ,
    output wire [31:0]          reg_encoder_a_cnt       ,
    output wire [31:0]          reg_encoder_b_cnt       ,
    input wire                  reg_encoder_clr         ,
    input wire                  reg_encoder_en          ,

    input wire                  reg_l1_status_cnt_clr   ,
    input wire [31:0]           reg_l1_soft_trigger_cycle  ,
    input wire [31:0]           reg_l1_soft_trigger_num ,
    input wire                  reg_l1_soft_trigger_en  ,

    input wire [31:0]           reg_l1_trigger_cycle    ,
    input wire [31:0]           reg_l1_trigger_num      ,
    input wire [3:0]            reg_l1_trigger_mode     ,
    input wire [31:0]           reg_l1_trigger_delay    ,
    input wire [31:0]           reg_l1_trigger_width    ,
    input wire [31:0]           reg_l1_trigger_pulse    ,
    input wire [1:0]            reg_l1_trigger_polar    ,
    input wire                  reg_l1_trigger_en       ,

    input wire                  reg_l1_encoder_phase    ,
    input wire [3:0]            reg_l1_encoder_cnt_mode ,
    input wire [3:0]            reg_l1_encoder_dis_mode ,
    input wire [31:0]           reg_l1_encoder_ignore   ,
    input wire [31:0]           reg_l1_encoder_div      ,
    input wire [31:0]           reg_l1_encoder_width    ,
    output wire [31:0]          reg_l1_encoder_location ,
    input wire [4:0]            reg_l1_encoder_multi_coe,
    input wire                  reg_l1_encoder_multi_en ,
    output wire [31:0]          reg_l1_encoder_a_cnt    ,
    output wire [31:0]          reg_l1_encoder_b_cnt    ,
    input wire                  reg_l1_encoder_clr      ,
    input wire                  reg_l1_encoder_en       ,

    input wire [7:0]            reg_trigger_level       ,

    input wire                  reg_slave_device        ,
    output wire                 trigger_to_slave        ,
    input wire                  trigger_from_master     ,
    // output wire                 trigger_l1_to_slave     ,
    // input wire                  trigger_l1_from_master  ,

    input wire [5:0]            reg_trigger_multi_en    ,
    input wire [11:0]           reg_led_polar           ,
    input wire [31:0]           reg_led_cnt_max         ,

    input wire [31:0]           reg_trig_start_0        ,
    input wire [31:0]           reg_trig_end_0          ,
    input wire [31:0]           reg_trig_start_1        ,
    input wire [31:0]           reg_trig_end_1          ,
    input wire [31:0]           reg_trig_start_2        ,
    input wire [31:0]           reg_trig_end_2          ,
    input wire [31:0]           reg_trig_start_3        ,
    input wire [31:0]           reg_trig_end_3          ,
    input wire [31:0]           reg_trig_start_4        ,
    input wire [31:0]           reg_trig_end_4          ,
    input wire [31:0]           reg_trig_start_5        ,
    input wire [31:0]           reg_trig_end_5          ,
    input wire [31:0]           reg_led_pwm_start_0     ,
    input wire [31:0]           reg_led_pwm_end_0       ,
    input wire [31:0]           reg_led_pwm_start_1     ,
    input wire [31:0]           reg_led_pwm_end_1       ,
    input wire [31:0]           reg_led_pwm_start_2     ,
    input wire [31:0]           reg_led_pwm_end_2       ,
    input wire [31:0]           reg_led_pwm_start_3     ,
    input wire [31:0]           reg_led_pwm_end_3       ,
    input wire [31:0]           reg_led_pwm_start_4     ,
    input wire [31:0]           reg_led_pwm_end_4       ,
    input wire [31:0]           reg_led_pwm_start_5     ,
    input wire [31:0]           reg_led_pwm_end_5       ,
    input wire [31:0]           reg_led_pwm_start_6     ,
    input wire [31:0]           reg_led_pwm_end_6       ,
    input wire [31:0]           reg_led_pwm_start_7     ,
    input wire [31:0]           reg_led_pwm_end_7       ,
    input wire [31:0]           reg_led_pwm_start_8     ,
    input wire [31:0]           reg_led_pwm_end_8       ,
    input wire [31:0]           reg_led_pwm_start_9     ,
    input wire [31:0]           reg_led_pwm_end_9       ,
    input wire [31:0]           reg_led_pwm_start_10    ,
    input wire [31:0]           reg_led_pwm_end_10      ,
    input wire [31:0]           reg_led_pwm_start_11    ,
    input wire [31:0]           reg_led_pwm_end_11      ,

    output wire [11:0]          led_pwm                 ,

    // input wire [1:0]            reg_exp_chan            ,
    // input wire [31:0]           reg_exposure_time       ,
    // Sensor exposure
    // output wire                 gmax_texp0              ,
    // output wire                 gmax_texp1

    input wire                  trigger_out_en          ,
    output wire                 trigger_external        ,
    output wire                 trigger_core            ,
    input                       reg_frame_trigger_en    ,
    input [31:0]                reg_line_num            ,
    output wire                 filtered_trigger        ,
    output wire [31:0]           reg_rtc_us_h              ,
    output wire [31:0]           reg_rtc_us_l
);

    parameter TIME_1US          = 125;

/********************************************************
*                        regs  here                     *
********************************************************/

    reg [31:0]                  cnt_timer_us            ;
    // (* mark_debug = "true" *)
    reg [63:0]                  timestamp_us            ;

/********************************************************
*                        wires here                     *
********************************************************/

    wire                        gen_trigger_en          ;
    wire                        gen_trigger             ;
    wire                        trigger_io_in           ;
    wire                        trigger_io_out          ;
    wire                        trigger_temp            ;

    wire                        trigger_o               ;
    wire                        trigger_l1_c            ;

/********************************************************
*                        logic here                     *
********************************************************/

    assign filtered_trigger = trigger_o;
    assign {reg_rtc_us_h, reg_rtc_us_l} = timestamp_us;


    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_timer_us        <= 32'd0;
        end else if (cnt_timer_us >= TIME_1US - 1'b1) begin
            cnt_timer_us        <= 32'd0;
        end else begin
            cnt_timer_us        <= cnt_timer_us + 1'b1;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            timestamp_us        <= 64'd0;
        end else if (cnt_timer_us >= TIME_1US - 1'b1) begin
            timestamp_us        <= timestamp_us + 1'b1;
        end else begin
            timestamp_us        <= timestamp_us;
        end
    end

    trigger_manage_top trigger_manage_top_inst(

        .clk                                            (clk                                                    ),  // input wire
        .rst                                            (rst                                                    ),  // input wire

        .reg_camera_delay                               (reg_camera_delay                                       ),
        .reg_camera_cycle                               (reg_camera_cycle                                       ),
        .reg_camera_trig_num                            (reg_camera_trig_num                                    ),


        .reg_external_trig_num                          (reg_external_trig_num                                  ),
        .reg_external_trig_polar                        (reg_external_trig_polar                                ),
        .reg_external_trig_delay                        (reg_external_trig_delay                                ),
        .reg_external_trig_width                        (reg_external_trig_width                                ),
        .reg_external_trig_enable                       (reg_external_trig_enable                               ),

        .io_input_0                                     (ext_trigger_0                                          ),  // input wire
        .io_input_1                                     (ext_trigger_1                                          ),  // input wire

        .encoder_a_in                                   (encoder_in_a                                           ),  // input wire
        .encoder_b_in                                   (encoder_in_b                                           ),  // input wire

        .reg_status_cnt_clr                             (reg_status_cnt_clr                                     ),  // input wire

        .reg_soft_trigger_cycle                         (reg_soft_trigger_cycle                                 ),  // input wire [31:0]
        .reg_soft_trigger_num                           (reg_soft_trigger_num                                   ),  // input wire [31:0]
        .reg_soft_trigger_en                            (reg_soft_trigger_en                                    ),  // input wire

        .reg_trigger_cycle                              (reg_trigger_cycle                                      ),  // input wire [31:0]
        .reg_trigger_num                                (reg_trigger_num                                        ),  // input wire [31:0]
        .reg_trigger_mode                               (reg_trigger_mode                                       ),  // input wire [3:0]
        .reg_trigger_delay                              (reg_trigger_delay                                      ),  // input wire [31:0]
        .reg_trigger_width                              (reg_trigger_width                                      ),  // input wire [31:0]
        .reg_trigger_pulse                              (reg_trigger_pulse                                      ),  // input wire [31:0]
        .reg_trigger_polar                              (reg_trigger_polar                                      ),  // input wire [1:0]
        .reg_trigger_en                                 (reg_trigger_en                                         ),  // input wire

        .reg_encoder_phase                              (reg_encoder_phase                                      ),  // input wire
        .reg_encoder_cnt_mode                           (reg_encoder_cnt_mode                                   ),  // input wire [3:0]
        .reg_encoder_dis_mode                           (reg_encoder_dis_mode                                   ),  // input wire [3:0]
        .reg_encoder_ignore                             (reg_encoder_ignore                                     ),  // input wire [31:0]
        .reg_encoder_div                                (reg_encoder_div                                        ),  // input wire [31:0]
        .reg_encoder_width                              (reg_encoder_width                                      ),  // input wire [31:0]
        .reg_encoder_location                           (reg_encoder_location                                   ),  // input wire [31:0]
        .reg_encoder_multi_coe                          (reg_encoder_multi_coe                                  ),  // input wire [31:0]
        .reg_encoder_multi_en                           (reg_encoder_multi_en                                   ),  // input wire
        .reg_encoder_a_cnt                              (reg_encoder_a_cnt                                      ),  // input wire [31:0]
        .reg_encoder_b_cnt                              (reg_encoder_b_cnt                                      ),  // input wire [31:0]
        .reg_encoder_clr                                (reg_encoder_clr                                        ),  // input wire
        .reg_encoder_en                                 (reg_encoder_en                                         ),

        // Level 1
        .reg_l1_status_cnt_clr                          (reg_l1_status_cnt_clr                                  ),  // input wire
        .reg_l1_soft_trigger_cycle                      (reg_l1_soft_trigger_cycle                              ),  // input wire [31:0]
        .reg_l1_soft_trigger_num                        (reg_l1_soft_trigger_num                                ),  // input wire [31:0]
        .reg_l1_soft_trigger_en                         (reg_l1_soft_trigger_en                                 ),  // input wire

        .reg_l1_trigger_cycle                           (reg_l1_trigger_cycle                                   ),  // input wire [31:0]
        .reg_l1_trigger_num                             (reg_l1_trigger_num                                     ),  // input wire [31:0]
        .reg_l1_trigger_mode                            (reg_l1_trigger_mode                                    ),  // input wire [3:0]
        .reg_l1_trigger_delay                           (reg_l1_trigger_delay                                   ),  // input wire [31:0]
        .reg_l1_trigger_width                           (reg_l1_trigger_width                                   ),  // input wire [31:0]
        .reg_l1_trigger_pulse                           (reg_l1_trigger_pulse                                   ),  // input wire [31:0]
        .reg_l1_trigger_polar                           (reg_l1_trigger_polar                                   ),  // input wire [1:0]
        .reg_l1_trigger_en                              (reg_l1_trigger_en                                      ),  // input wire

        .reg_l1_encoder_phase                           (reg_l1_encoder_phase                                   ),  // input wire
        .reg_l1_encoder_cnt_mode                        (reg_l1_encoder_cnt_mode                                ),  // input wire [3:0]
        .reg_l1_encoder_dis_mode                        (reg_l1_encoder_dis_mode                                ),  // input wire [3:0]
        .reg_l1_encoder_ignore                          (reg_l1_encoder_ignore                                  ),  // input wire [31:0]
        .reg_l1_encoder_div                             (reg_l1_encoder_div                                     ),  // input wire [31:0]
        .reg_l1_encoder_width                           (reg_l1_encoder_width                                   ),  // input wire [31:0]
        .reg_l1_encoder_location                        (reg_l1_encoder_location                                ),  // input wire [31:0]
        .reg_l1_encoder_multi_coe                       (reg_l1_encoder_multi_coe                               ),  // input wire [31:0]
        .reg_l1_encoder_multi_en                        (reg_l1_encoder_multi_en                                ),  // input wire
        .reg_l1_encoder_a_cnt                           (reg_l1_encoder_a_cnt                                   ),  // input wire [31:0]
        .reg_l1_encoder_b_cnt                           (reg_l1_encoder_b_cnt                                   ),  // input wire [31:0]
        .reg_l1_encoder_clr                             (reg_l1_encoder_clr                                     ),  // input wire
        .reg_l1_encoder_en                              (reg_l1_encoder_en                                      ),

        .reg_trigger_level                              (reg_trigger_level                                      ),

        .reg_slave_device                               (reg_slave_device                                       ),  // input wire
        .trigger_to_slave                               (trigger_to_slave                                       ),  // output wire
        .trigger_from_master                            (trigger_from_master                                    ),  // input wire

        .reg_led_polar                                  (reg_led_polar                                          ),
        .reg_led_cnt_max                                (reg_led_cnt_max                                        ),
        .reg_led_pwm_start_0                            (reg_led_pwm_start_0                                    ),
        .reg_led_pwm_end_0                              (reg_led_pwm_end_0                                      ),
        .reg_led_pwm_start_1                            (reg_led_pwm_start_1                                    ),
        .reg_led_pwm_end_1                              (reg_led_pwm_end_1                                      ),
        .reg_led_pwm_start_2                            (reg_led_pwm_start_2                                    ),
        .reg_led_pwm_end_2                              (reg_led_pwm_end_2                                      ),
        .reg_led_pwm_start_3                            (reg_led_pwm_start_3                                    ),
        .reg_led_pwm_end_3                              (reg_led_pwm_end_3                                      ),
        .reg_led_pwm_start_4                            (reg_led_pwm_start_4                                    ),
        .reg_led_pwm_end_4                              (reg_led_pwm_end_4                                      ),
        .reg_led_pwm_start_5                            (reg_led_pwm_start_5                                    ),
        .reg_led_pwm_end_5                              (reg_led_pwm_end_5                                      ),
        .reg_led_pwm_start_6                            (reg_led_pwm_start_6                                    ),
        .reg_led_pwm_end_6                              (reg_led_pwm_end_6                                      ),
        .reg_led_pwm_start_7                            (reg_led_pwm_start_7                                    ),
        .reg_led_pwm_end_7                              (reg_led_pwm_end_7                                      ),
        .reg_led_pwm_start_8                            (reg_led_pwm_start_8                                    ),
        .reg_led_pwm_end_8                              (reg_led_pwm_end_8                                      ),
        .reg_led_pwm_start_9                            (reg_led_pwm_start_9                                    ),
        .reg_led_pwm_end_9                              (reg_led_pwm_end_9                                      ),
        .reg_led_pwm_start_10                           (reg_led_pwm_start_10                                   ),
        .reg_led_pwm_end_10                             (reg_led_pwm_end_10                                     ),
        .reg_led_pwm_start_11                           (reg_led_pwm_start_11                                   ),
        .reg_led_pwm_end_11                             (reg_led_pwm_end_11                                     ),
        .reg_trig_start_0                               (reg_trig_start_0                                       ),
        .reg_trig_end_0                                 (reg_trig_end_0                                         ),
        .reg_trig_start_1                               (reg_trig_start_1                                       ),
        .reg_trig_end_1                                 (reg_trig_end_1                                         ),
        .reg_trig_start_2                               (reg_trig_start_2                                       ),
        .reg_trig_end_2                                 (reg_trig_end_2                                         ),
        .reg_trig_start_3                               (reg_trig_start_3                                       ),
        .reg_trig_end_3                                 (reg_trig_end_3                                         ),
        .reg_trig_start_4                               (reg_trig_start_4                                       ),
        .reg_trig_end_4                                 (reg_trig_end_4                                         ),
        .reg_trig_start_5                               (reg_trig_start_5                                       ),
        .reg_trig_end_5                                 (reg_trig_end_5                                         ),
        .reg_trigger_multi_en                           (reg_trigger_multi_en                                   ),
        .reg_trig_out_polar                             (reg_trig_out_polar                                     ),

        .led_pwm                                        (led_pwm                                                ),

        // .trigger_req                                    (trigger_camera                                         ),
        .io_output                                      (io_output                                              ),

        // .trigger_l1_c                                   (trigger_l1_c                                           ),
        .trigger_out_en                                 (trigger_out_en                                         ),
        .trigger_external                               (trigger_external                                       ),
        .trigger_core                                   (trigger_core                                           ),
        .reg_frame_trigger_en                           (reg_frame_trigger_en                               ),
        .reg_line_num                                   (reg_line_num                                       ),
        .trigger_o                                      (trigger_o                                              )   // output wire
    );






 /*----------------------------DEBUG----------------------------*/

// (* mark_debug = "true" *)

(* dont_touch = "true" *)reg                            debug_ext_trigger_0               ;
(* dont_touch = "true" *)reg                            debug_ext_trigger_1               ;
// (* dont_touch = "true" *)reg                            debug_gmax_texp0               ;
// (* dont_touch = "true" *)reg                            debug_gmax_texp1               ;
(* dont_touch = "true" *)reg                            debug_trigger_o                  ;

always @ (posedge clk) begin
    debug_ext_trigger_0 <= ext_trigger_0;
end
always @ (posedge clk) begin
    debug_ext_trigger_1 <= ext_trigger_1;
end
// always @ (posedge clk) begin
//     debug_gmax_texp0 <= gmax_texp0;
// end
// always @ (posedge clk) begin
//     debug_gmax_texp1 <= gmax_texp1;
// end
always @ (posedge clk) begin
    debug_trigger_o    <= trigger_o   ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_timer_us                  ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_timestamp_us                  ;

always @ (posedge clk) begin
    debug_cnt_timer_us                   <= cnt_timer_us                  ;
    debug_timestamp_us                   <= timestamp_us                  ;
end

endmodule


