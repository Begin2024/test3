/*********************************************************
#        filename: trigger_manage_top.v
#        author: rongzhuangzhuang
#        e-mail: zhuangzhuang.rong@insnex.com
#        description: ---
#        create:        2023-07-13 13:35:09
#        Last modified: 2023-08-04 11:11:51
*********************************************************/
module trigger_manage_top(


    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire                  io_input_0              ,
    input wire                  io_input_1              ,

    input wire                  encoder_a_in            ,
    input wire                  encoder_b_in            ,

    input wire [31:0]           reg_camera_delay        ,
    input wire [31:0]           reg_camera_cycle        ,
    input wire [31:0]           reg_camera_trig_num     ,

    input wire [31:0]           reg_external_trig_num   ,
    input wire                  reg_external_trig_polar ,
    input wire [31:0]           reg_external_trig_delay ,
    input wire [31:0]           reg_external_trig_width ,
    input wire                  reg_external_trig_enable,

    // Reg_fpga
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

    input wire                  reg_slave_device        ,

    //
    output wire                 trigger_to_slave        ,
    input wire                  trigger_from_master     ,

    input wire  [5:0]           reg_trigger_multi_en    ,
    input wire  [11:0]          reg_led_polar           ,
    input wire  [31:0]          reg_led_cnt_max         ,

    input wire  [31:0]          reg_trig_start_0        ,
    input wire  [31:0]          reg_trig_end_0          ,
    input wire  [31:0]          reg_trig_start_1        ,
    input wire  [31:0]          reg_trig_end_1          ,
    input wire  [31:0]          reg_trig_start_2        ,
    input wire  [31:0]          reg_trig_end_2          ,
    input wire  [31:0]          reg_trig_start_3        ,
    input wire  [31:0]          reg_trig_end_3          ,
    input wire  [31:0]          reg_trig_start_4        ,
    input wire  [31:0]          reg_trig_end_4          ,
    input wire  [31:0]          reg_trig_start_5        ,
    input wire  [31:0]          reg_trig_end_5          ,
    input wire                  reg_trig_out_polar      ,
    input wire  [31:0]          reg_led_pwm_start_0     ,
    input wire  [31:0]          reg_led_pwm_end_0       ,
    input wire  [31:0]          reg_led_pwm_start_1     ,
    input wire  [31:0]          reg_led_pwm_end_1       ,
    input wire  [31:0]          reg_led_pwm_start_2     ,
    input wire  [31:0]          reg_led_pwm_end_2       ,
    input wire  [31:0]          reg_led_pwm_start_3     ,
    input wire  [31:0]          reg_led_pwm_end_3       ,
    input wire  [31:0]          reg_led_pwm_start_4     ,
    input wire  [31:0]          reg_led_pwm_end_4       ,
    input wire  [31:0]          reg_led_pwm_start_5     ,
    input wire  [31:0]          reg_led_pwm_end_5       ,
    input wire  [31:0]          reg_led_pwm_start_6     ,
    input wire  [31:0]          reg_led_pwm_end_6       ,
    input wire  [31:0]          reg_led_pwm_start_7     ,
    input wire  [31:0]          reg_led_pwm_end_7       ,
    input wire  [31:0]          reg_led_pwm_start_8     ,
    input wire  [31:0]          reg_led_pwm_end_8       ,
    input wire  [31:0]          reg_led_pwm_start_9     ,
    input wire  [31:0]          reg_led_pwm_end_9       ,
    input wire  [31:0]          reg_led_pwm_start_10    ,
    input wire  [31:0]          reg_led_pwm_end_10      ,
    input wire  [31:0]          reg_led_pwm_start_11    ,
    input wire  [31:0]          reg_led_pwm_end_11      ,

    output wire [11:0]          led_pwm                 ,

    // input wire                  trigger_req             ,
    output wire                 io_output               ,

    output wire                 trigger_o               ,

    // Level 1
    input wire                  reg_l1_status_cnt_clr   ,
    input wire [31:0]           reg_l1_soft_trigger_cycle,
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

    input wire                  trigger_out_en          ,
    output wire                 trigger_external        ,
    output wire                 trigger_core            ,
    input                       reg_frame_trigger_en    ,
    input [31:0]                reg_line_num
);


/********************************************************
*                        regs  here                     *
********************************************************/



/********************************************************
*                        wires here                     *
********************************************************/

    wire                        trigger_origin          ;

    wire                        pol_io_input_0          ;
    wire                        pol_io_input_1          ;

    wire                        phase_encoder_a_in      ;
    wire                        phase_encoder_b_in      ;

    wire                        trigger_c               ;

    wire                        trigger_out             ;

    wire                        trigger_l1_origin       ;

/********************************************************
*                        logic here                     *
********************************************************/

    assign trigger_o            = trigger_c             ;

    io_polar io_polar_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_trigger_polar                              (reg_trigger_polar                              ),

        .io_input_0                                     (io_input_0                                     ),
        .io_input_1                                     (io_input_1                                     ),

        .pol_io_input_0                                 (pol_io_input_0                                 ),
        .pol_io_input_1                                 (pol_io_input_1                                 )
    );

    encoder_phase encoder_phase_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_encoder_phase                              (reg_encoder_phase                              ),
        .reg_encoder_location                           (reg_encoder_location                           ),
        .reg_encoder_a_cnt                              (reg_encoder_a_cnt                              ),
        .reg_encoder_b_cnt                              (reg_encoder_b_cnt                              ),
        .reg_encoder_clr                                (reg_encoder_clr                                ),

        .encoder_a_in                                   (encoder_a_in                                   ),
        .encoder_b_in                                   (encoder_b_in                                   ),

        .phase_encoder_a_in                             (phase_encoder_a_in                             ),
        .phase_encoder_b_in                             (phase_encoder_b_in                             )
    );

    encoder_multi encoder_multi_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_encoder_multi_en                           (reg_encoder_multi_en                           ),
        .reg_encoder_multi_coe                          (reg_encoder_multi_coe                          ),

        .encoder_a_in                                   (phase_encoder_a_in                             ),
        .encoder_b_in                                   (phase_encoder_b_in                             ),

        .encoder_multi_a                                (encoder_multi_a                                ),
        .encoder_multi_b                                (encoder_multi_b                                )
    );

    trigger_top trigger_top_level0(

        .clk                                            (clk                                            ),  //input
        .rst                                            (rst                                            ),  //input

        .reg_soft_trigger_cycle                         (reg_soft_trigger_cycle                         ),  //input       [31:0]
        .reg_soft_trigger_num                           (reg_soft_trigger_num                           ),  //input       [31:0]
        .reg_soft_trigger_en                            (reg_soft_trigger_en                            ),  //input

        .reg_trigger_cycle                              (reg_trigger_cycle                              ),  //input       [31:0]
        .reg_trigger_en                                 (reg_trigger_en                                 ),  //input
        .reg_trigger_mode                               (reg_trigger_mode                               ),  //input       [ 3:0]
        .reg_trigger_num                                (reg_trigger_num                                ),  //input       [31:0]
        .reg_trigger_delay                              (reg_trigger_delay                              ),  //input       [31:0]
        .reg_trigger_width                              (reg_trigger_width                              ),  //input       [31:0]
        .reg_trigger_pulse                              (reg_trigger_pulse                              ),  //input       [31:0]
        .io_input_0                                     (pol_io_input_0                                 ),  //input
        .io_input_1                                     (pol_io_input_1                                 ),  //input

        .reg_encoder_en                                 (reg_encoder_en                                 ),  //input
        .reg_encoder_ignore                             (reg_encoder_ignore                             ),  //input       [31:0]
        .reg_encoder_cnt_mode                           (reg_encoder_cnt_mode                           ),  //input       [ 3:0]
        .reg_encoder_dis_mode                           (reg_encoder_dis_mode                           ),  //input       [ 3:0]
        .reg_encoder_div                                (reg_encoder_div                                ),  //input       [31:0]
        .reg_encoder_width                              (reg_encoder_width                              ),  //input       [31:0]
        .encoder_a_in                                   (encoder_multi_a                                ),  //input
        .encoder_b_in                                   (encoder_multi_b                                ),  //input

        .trigger                                        (trigger_origin                                 )   //output
    );

    trigger_top trigger_top_level1(

        .clk                                            (clk                                            ),  //input
        .rst                                            (rst                                            ),  //input

        .reg_soft_trigger_cycle                         (reg_l1_soft_trigger_cycle                      ),  //input       [31:0]
        .reg_soft_trigger_num                           (reg_l1_soft_trigger_num                        ),  //input       [31:0]
        .reg_soft_trigger_en                            (reg_l1_soft_trigger_en                         ),  //input

        .reg_trigger_cycle                              (reg_l1_trigger_cycle                           ),  //input       [31:0]
        .reg_trigger_en                                 (reg_l1_trigger_en                              ),  //input
        .reg_trigger_mode                               (reg_l1_trigger_mode                            ),  //input       [ 3:0]
        .reg_trigger_num                                (reg_l1_trigger_num                             ),  //input       [31:0]
        .reg_trigger_delay                              (reg_l1_trigger_delay                           ),  //input       [31:0]
        .reg_trigger_width                              (reg_l1_trigger_width                           ),  //input       [31:0]
        .reg_trigger_pulse                              (reg_l1_trigger_pulse                           ),  //input       [31:0]
        .io_input_0                                     (pol_io_input_0                                 ),  //input
        .io_input_1                                     (pol_io_input_1                                 ),  //input

        .reg_encoder_en                                 (reg_l1_encoder_en                              ),  //input
        .reg_encoder_ignore                             (reg_l1_encoder_ignore                          ),  //input       [31:0]
        .reg_encoder_cnt_mode                           (reg_l1_encoder_cnt_mode                        ),  //input       [ 3:0]
        .reg_encoder_dis_mode                           (reg_l1_encoder_dis_mode                        ),  //input       [ 3:0]
        .reg_encoder_div                                (reg_l1_encoder_div                             ),  //input       [31:0]
        .reg_encoder_width                              (reg_l1_encoder_width                           ),  //input       [31:0]
        .encoder_a_in                                   (encoder_multi_a                                ),  //input
        .encoder_b_in                                   (encoder_multi_b                                ),  //input

        .trigger                                        (trigger_li_origin                              )   //output
    );

    // trigger_process trigger_process_inst (

    //     .clk                                            (clk                                                    ),
    //     .rst                                            (rst                                                    ),
    //     .reg_camera_delay                               (reg_camera_delay                                       ),
    //     .reg_camera_cycle                               (reg_camera_cycle                                       ),
    //     .reg_pic_num                                    (reg_pic_num                                            ),
    //     .reg_trigger_level                              (reg_trigger_level                                      ),
    //     .trigger_ctrl                                   (trigger_li_origin                                      ),
    //     .trigger_in                                     (trigger_origin                                         ),

    //     .trigger_camera                                 (trigger_camera                                         ),
    //     .trigger_core                                   (trigger_core                                           )
    // );

    frame_trigger frame_trigger_inst (
        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),
        .reg_frame_trigger_en                           (reg_frame_trigger_en                           ),
        .frame_trigger                                  (pol_io_input_0                                     ),
        .line_trigger                                   (trigger_origin                                     ),
        // .reg_frame_trigger_polar                        (reg_trigger_polar                              ),
        .reg_frame_trigger_width                        (reg_trigger_width                        ),
        .reg_line_num                                   (reg_line_num                                   ),
        .trigger_out                                    (frame_trigger_out                              )
    );

    wire trigger_vld;

    trigger_allow u_trigger_allow(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_trigger_level                              (reg_trigger_level                              ),

        .trigger_c                                      (trigger_li_origin                              ),
        .trigger_in                                     (frame_trigger_out                                 ),

        .trigger_out                                    (trigger_vld                                    )
    );

    trigger_cascade trigger_cascade_level0(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_slave_device                               (reg_slave_device                               ),

        .trigger_from_master                            (trigger_from_master                            ),
        .trigger_to_slave                               (trigger_to_slave                               ),

        .trigger_i                                      (trigger_vld                                    ),
        .trigger_c                                      (trigger_c                                      )
    );

    trigger_process trigger_process_inst (

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),
        .reg_camera_delay                               (reg_camera_delay                               ),
        .reg_camera_cycle                               (reg_camera_cycle                               ),
        .reg_camera_trig_num                            (reg_camera_trig_num                            ),

        .reg_external_trig_enable                       (reg_external_trig_enable                       ),
        .reg_external_trig_width                        (reg_external_trig_width                        ),
        .reg_external_trig_delay                        (reg_external_trig_delay                        ),
        .reg_external_trig_polar                        (reg_external_trig_polar                        ),
        .reg_external_trig_num                          (reg_external_trig_num                          ),

        .trigger_out_en                                 (trigger_out_en                                 ),
        .trigger_in                                     (trigger_c                                      ),

        .trigger_external                               (trigger_external                               ),
        .trigger_camera                                 (trigger_camera                                 ),
        .trigger_core                                   (trigger_core                                   )
    );

    trig_led inst_trig_led (

        .clk_i                                          (clk                                            ),
        .rst_i                                          (rst                                            ),

        .reg_led_polar                                  (reg_led_polar                                  ),

        .led_cnt_max_i                                  (reg_led_cnt_max                                ),

        .led_pwm_start_i_0                              (reg_led_pwm_start_0                            ),
        .led_pwm_end_i_0                                (reg_led_pwm_end_0                              ),
        .led_pwm_start_i_1                              (reg_led_pwm_start_1                            ),
        .led_pwm_end_i_1                                (reg_led_pwm_end_1                              ),
        .led_pwm_start_i_2                              (reg_led_pwm_start_2                            ),
        .led_pwm_end_i_2                                (reg_led_pwm_end_2                              ),
        .led_pwm_start_i_3                              (reg_led_pwm_start_3                            ),
        .led_pwm_end_i_3                                (reg_led_pwm_end_3                              ),
        .led_pwm_start_i_4                              (reg_led_pwm_start_4                            ),
        .led_pwm_end_i_4                                (reg_led_pwm_end_4                              ),
        .led_pwm_start_i_5                              (reg_led_pwm_start_5                            ),
        .led_pwm_end_i_5                                (reg_led_pwm_end_5                              ),
        .led_pwm_start_i_6                              (reg_led_pwm_start_6                            ),
        .led_pwm_end_i_6                                (reg_led_pwm_end_6                              ),
        .led_pwm_start_i_7                              (reg_led_pwm_start_7                            ),
        .led_pwm_end_i_7                                (reg_led_pwm_end_7                              ),
        .led_pwm_start_i_8                              (reg_led_pwm_start_8                            ),
        .led_pwm_end_i_8                                (reg_led_pwm_end_8                              ),
        .led_pwm_start_i_9                              (reg_led_pwm_start_9                            ),
        .led_pwm_end_i_9                                (reg_led_pwm_end_9                              ),
        .led_pwm_start_i_10                             (reg_led_pwm_start_10                           ),
        .led_pwm_end_i_10                               (reg_led_pwm_end_10                             ),
        .led_pwm_start_i_11                             (reg_led_pwm_start_11                           ),
        .led_pwm_end_i_11                               (reg_led_pwm_end_11                             ),

        .trig_start_i_0                                 (reg_trig_start_0                               ),
        .trig_end_i_0                                   (reg_trig_end_0                                 ),
        .trig_start_i_1                                 (reg_trig_start_1                               ),
        .trig_end_i_1                                   (reg_trig_end_1                                 ),
        .trig_start_i_2                                 (reg_trig_start_2                               ),
        .trig_end_i_2                                   (reg_trig_end_2                                 ),
        .trig_start_i_3                                 (reg_trig_start_3                               ),
        .trig_end_i_3                                   (reg_trig_end_3                                 ),
        .trig_start_i_4                                 (reg_trig_start_4                               ),
        .trig_end_i_4                                   (reg_trig_end_4                                 ),
        .trig_start_i_5                                 (reg_trig_start_5                               ),
        .trig_end_i_5                                   (reg_trig_end_5                                 ),
        .reg_trig_out_polar                             (reg_trig_out_polar                             ),

        .trigger_multi_en                               (reg_trigger_multi_en                           ),

        .led_pwm_o                                      (led_pwm                                        ),

        .trigger_i                                      (trigger_camera                                 ),
        .trigger_o                                      (io_output                                      )
    );


 /*-----------------------DEBUG------------------------*/

// (* mark_debug = "true" *)

(* dont_touch = "true" *)reg                            debug_trigger_origin               ;
(* dont_touch = "true" *)reg                            debug_pol_io_input_0               ;
(* dont_touch = "true" *)reg                            debug_pol_io_input_1               ;

always @ (posedge clk) begin
    debug_trigger_origin <= trigger_origin;
end
always @ (posedge clk) begin
    debug_pol_io_input_0 <= pol_io_input_0;
end
always @ (posedge clk) begin
    debug_pol_io_input_1 <= pol_io_input_1;
end

(* dont_touch = "true" *)reg                            debug_trigger_c               ;
(* dont_touch = "true" *)reg [11:0]                     debug_led_pwm               ;
(* dont_touch = "true" *)reg                            debug_trigger_o               ;

always @ (posedge clk) begin
    debug_trigger_origin <= trigger_origin;
end
always @ (posedge clk) begin
    debug_trigger_c <= trigger_c;
end
//always @ (posedge clk) begin
//    debug_led_pwm <= led_pwm;
//end
always @ (posedge clk) begin
    debug_trigger_o <= trigger_o;
end



(* dont_touch = "true" *)reg                  debug_io_input_0              ;
(* dont_touch = "true" *)reg                  debug_io_input_1              ;

(* dont_touch = "true" *)reg                  debug_encoder_a_in            ;
(* dont_touch = "true" *)reg                  debug_encoder_b_in            ;

    // Reg_fpga
(* dont_touch = "true" *)reg                  debug_reg_status_cnt_clr      ;

(* dont_touch = "true" *)reg [31:0]           debug_reg_soft_trigger_cycle  ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_soft_trigger_num    ;
(* dont_touch = "true" *)reg                  debug_reg_soft_trigger_en     ;

(* dont_touch = "true" *)reg [31:0]           debug_reg_trigger_cycle       ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_trigger_num         ;
(* dont_touch = "true" *)reg [3:0]            debug_reg_trigger_mode        ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_trigger_delay       ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_trigger_width       ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_trigger_pulse       ;
(* dont_touch = "true" *)reg [1:0]            debug_reg_trigger_polar       ;
(* dont_touch = "true" *)reg                  debug_reg_trigger_en          ;

(* dont_touch = "true" *)reg                  debug_reg_encoder_phase       ;
(* dont_touch = "true" *)reg [3:0]            debug_reg_encoder_cnt_mode    ;
(* dont_touch = "true" *)reg [3:0]            debug_reg_encoder_dis_mode    ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_ignore      ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_div         ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_width       ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_location    ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_multi_coe   ;
(* dont_touch = "true" *)reg                  debug_reg_encoder_multi_en    ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_a_cnt       ;
(* dont_touch = "true" *)reg [31:0]           debug_reg_encoder_b_cnt       ;
(* dont_touch = "true" *)reg                  debug_reg_encoder_clr         ;
(* dont_touch = "true" *)reg                  debug_reg_encoder_en          ;

(* dont_touch = "true" *)reg                  debug_reg_slave_device        ;

    //
(* dont_touch = "true" *)reg                  debug_trigger_to_slave        ;
(* dont_touch = "true" *)reg                  debug_trigger_from_master     ;




always @(posedge clk)begin
    debug_io_input_0              <= io_input_0              ;
    debug_io_input_1              <= io_input_1              ;

    debug_encoder_a_in            <= encoder_a_in            ;
    debug_encoder_b_in            <= encoder_b_in            ;

    debug_reg_status_cnt_clr      <= reg_status_cnt_clr      ;

    debug_reg_soft_trigger_cycle  <= reg_soft_trigger_cycle  ;
    debug_reg_soft_trigger_num    <= reg_soft_trigger_num    ;
    debug_reg_soft_trigger_en     <= reg_soft_trigger_en     ;

    debug_reg_trigger_cycle       <= reg_trigger_cycle       ;
    debug_reg_trigger_num         <= reg_trigger_num         ;
    debug_reg_trigger_mode        <= reg_trigger_mode        ;
    debug_reg_trigger_delay       <= reg_trigger_delay       ;
    debug_reg_trigger_width       <= reg_trigger_width       ;
    debug_reg_trigger_pulse       <= reg_trigger_pulse       ;
    debug_reg_trigger_polar       <= reg_trigger_polar       ;
    debug_reg_trigger_en          <= reg_trigger_en          ;

    debug_reg_encoder_phase       <= reg_encoder_phase       ;
    debug_reg_encoder_cnt_mode    <= reg_encoder_cnt_mode    ;
    debug_reg_encoder_dis_mode    <= reg_encoder_dis_mode    ;
    debug_reg_encoder_ignore      <= reg_encoder_ignore      ;
    debug_reg_encoder_div         <= reg_encoder_div         ;
    debug_reg_encoder_width       <= reg_encoder_width       ;
    debug_reg_encoder_location    <= reg_encoder_location    ;
    debug_reg_encoder_multi_coe   <= reg_encoder_multi_coe   ;
    debug_reg_encoder_multi_en    <= reg_encoder_multi_en    ;
    debug_reg_encoder_a_cnt       <= reg_encoder_a_cnt       ;
    debug_reg_encoder_b_cnt       <= reg_encoder_b_cnt       ;
    debug_reg_encoder_clr         <= reg_encoder_clr         ;
    debug_reg_encoder_en          <= reg_encoder_en          ;

    debug_reg_slave_device        <= reg_slave_device        ;

    debug_trigger_to_slave        <= trigger_to_slave        ;
    debug_trigger_from_master     <= trigger_from_master     ;
end










endmodule
