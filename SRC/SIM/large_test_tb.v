/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-10-28  14:04:42
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-10-28  14:04:42
 # FilePath     : large_test_tb.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`timescale 1ns/1ps

module large_test_tb(

);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg                         clk                     ;
    reg                         rst                     ;

    reg [31:0]                  reg_mos_ack_time        ;
    reg [31:0]                  reg_dac_ack_time        ;
    reg [9:0]                   reg_dds_inc             ;
    reg [31:0]                  reg_dds_ack_time        ;
    reg [13:0]                  reg_current_offset      ;
    reg [31:0]                  reg_sw_ack_time         ;

    wire [13:0]                 reg_ram_rdata           ;
    wire                        reg_ram_done            ;
    reg                         reg_ram_whrl            ;
    reg [9:0]                   reg_ram_addr            ;
    reg [13:0]                  reg_ram_wdata           ;
    reg                         reg_ram_req             ;
    reg                         reg_ram_cfg_en          ;

    wire [31:0]                 reg_trigger_in_num      ;
    reg [31:0]                  reg_dds_phase           ;
    reg [31:0]                  reg_exp_cycle           ;
    reg [31:0]                  reg_trigger_gap         ;
    reg [31:0]                  reg_pic_num             ;
    reg [11:0]                  reg_sw_status           ;
    reg [7:0]                   reg_sw_shift            ;
    reg [31:0]                  reg_sw_loop_gap         ;
    reg [31:0]                  reg_sw_loop_num         ;
    reg [9:0]                   reg_dds_phase_offset    ;
    reg [13:0]                  reg_dac_value_forward   ;
    reg [13:0]                  reg_dac_value_backward  ;
    reg [31:0]                  reg_sw_wait             ;

    reg [3:0]                   reg_core_mode           ;
    reg                         reg_core_en             ;
    wire [9:0]                  reg_core_status         ;
    reg [9:0]                   reg_wave_start_addr     ;
    reg [9:0]                   reg_wave_end_addr       ;

    reg                         trigger_out             ;
    wire                        sensor_trigger_req      ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        dac_mos_x               ;
    wire                        dac_mos_y               ;

    wire                        mos_ack                 ;
    wire                        mos_val                 ;
    wire                        mos_req                 ;

    wire [13:0]                 dac_data_x0             ;
    wire [13:0]                 dac_data_x1             ;
    wire [13:0]                 dac_data_x2             ;
    wire [13:0]                 dac_data_x3             ;
    wire [13:0]                 dac_data_y0             ;
    wire [13:0]                 dac_data_y1             ;
    wire [13:0]                 dac_data_y2             ;
    wire [13:0]                 dac_data_y3             ;

    wire [111:0]                dac_val                 ;
    wire [7:0]                  dac_req                 ;
    wire                        dac_ack                 ;

    wire [9:0]                  dds_addr                ;
    wire                        dds_refresh            ;
    wire                        dds_ack                 ;
    wire                        dds_req                 ;
    wire [167:0]                dds_time_forward        ;
    wire [167:0]                dds_time_backward       ;

    wire [11:0]                 dac_sw_x_0              ;
    wire [11:0]                 dac_sw_x_1              ;
    wire [11:0]                 dac_sw_x_2              ;
    wire [11:0]                 dac_sw_x_3              ;
    wire [11:0]                 dac_sw_y_0              ;
    wire [11:0]                 dac_sw_y_1              ;
    wire [11:0]                 dac_sw_y_2              ;
    wire [11:0]                 dac_sw_y_3              ;

    wire                        sw_ack                  ;
    // wire [167:0]                dds_time_forward        ;
    // wire [167:0]                dds_time_forward        ;
    wire [1:0]                  sw_req                  ;



/********************************************************
*                        logic Here                     *
********************************************************/

    always #5 clk <= ~clk;

    initial begin
        clk <= 1'b1; rst <= 1'b1;

        #2000
        rst <= 1'b0;

        #10000000
        rst <= 1'b1;
        #2000
        rst <= 1'b0;
    end

    initial begin
        reg_mos_ack_time <= 'd5;
        reg_dac_ack_time <= 'd5;
        reg_dds_inc <= 'd12;
        reg_dds_ack_time <= 'd5;
        reg_current_offset <= 'd200;
        reg_sw_ack_time <= 'd100;
        reg_ram_whrl <= 'd0;
        reg_ram_addr <= 'd0;
        reg_ram_wdata <= 'd0;
        reg_ram_req <= 'd0;
        reg_ram_cfg_en <= 'd0;
        reg_dds_phase <= 'd72;
        reg_exp_cycle <= 'd9000;
        reg_trigger_gap <= 'd100;
        reg_pic_num <= 'd8;
        reg_sw_status <= 'd1;
        reg_sw_shift <= 'd1;
        reg_sw_loop_gap <= 'd9;
        reg_sw_loop_num <= 'd4;
        reg_dds_phase_offset <= 'd0;
        reg_dac_value_forward <= 'd8000;
        reg_dac_value_backward <= 'd8000;
        reg_sw_wait <= 'd10;

        reg_core_mode <= 'd0;
        reg_core_en <= 'd1;

        reg_wave_start_addr <= 'd0;
        reg_wave_end_addr <= 'd287;
    end

    initial begin
        trigger_out <= 'd0;


        #8000
        trigger_out <= 'd1;

        #20
        trigger_out <= 'd0;

        #2000000
        trigger_out <= 'd1;

        #20
        trigger_out <= 'd0;


        #2000000
        $stop;
    end









    mos_ctrl mos_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .dac_mos_x                                      (dac_mos_x                                      ),
        .dac_mos_y                                      (dac_mos_y                                      ),

        .mos_ack                                        (mos_ack                                        ),
        .mos_val                                        (mos_val                                        ),
        .mos_req                                        (mos_req                                        ),

        .reg_mos_time                                   (reg_mos_ack_time                               )
    );

    dac_ctrl dac_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .dac_clk                                        (dac_clk                                        ),
        .dac_wrt                                        (dac_wrt                                        ),
        .dac1_data                                      (dac_data_x0                                    ),
        .dac2_data                                      (dac_data_x1                                    ),
        .dac3_data                                      (dac_data_x2                                    ),
        .dac4_data                                      (dac_data_x3                                    ),
        // .dac1_data_y                                    (                                               ),
        // .dac2_data_y                                    (                                               ),
        // .dac3_data_y                                    (                                               ),
        // .dac4_data_y                                    (                                               ),
        .dac_val                                        (dac_val                                        ),
        .dac_req                                        (dac_req                                        ),
        .dac_ack                                        (dac_ack                                        ),
        .reg_dac_time                                   (reg_dac_ack_time                               )
    );

    dds_ctrl dds_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_dds_inc                                    (reg_dds_inc                                    ),
        .reg_dds_ack_time                               (reg_dds_ack_time                               ),
        .reg_current_offset                             (reg_current_offset                             ),

        // .reg_adjust_en                                  (reg_adjust_en                                  ),
        // .reg_adjust_gain                                (reg_adjust_gain                                ),
        // .reg_adjust_offset                              (reg_adjust_offset                              ),

        .dds_full_time                                  (reg_sw_ack_time[15:0]                          ),
        .dds_addr                                       (dds_addr                                       ),
        .dds_refresh                                    (dds_refresh                                    ),
        .dds_ack                                        (dds_ack                                        ),
        .dds_req                                        (dds_req                                        ),
        .dds_time_forward                               (dds_time_forward                               ),
        .dds_time_backward                              (dds_time_backward                              ),

        .reg_ram_rdata                                  (reg_ram_rdata                                  ),
        .reg_ram_done                                   (reg_ram_done                                   ),
        .reg_ram_whrl                                   (reg_ram_whrl                                   ),
        .reg_ram_addr                                   (reg_ram_addr                                   ),
        .reg_ram_wdata                                  (reg_ram_wdata                                  ),
        .reg_ram_req                                    (reg_ram_req                                    ),
        .reg_ram_cfg_en                                 (reg_ram_cfg_en                                 )
    );

    sw_ctrl sw_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_sw_ack_time                                (reg_sw_ack_time                                ),

        .dac_sw_x1                                      (dac_sw_x_0                                     ),
        .dac_sw_x2                                      (dac_sw_x_1                                     ),
        .dac_sw_x3                                      (dac_sw_x_2                                     ),
        .dac_sw_x4                                      (dac_sw_x_3                                     ),
        .dac_sw_y1                                      (dac_sw_y_0                                     ),
        .dac_sw_y2                                      (dac_sw_y_1                                     ),
        .dac_sw_y3                                      (dac_sw_y_2                                     ),
        .dac_sw_y4                                      (dac_sw_y_3                                     ),

        // X Y 椤哄簭纭
        .sw_ack                                         (sw_ack                                         ),
        .sw_time_forward                                (dds_time_forward                               ),
        .sw_time_backward                               (dds_time_backward                              ),
        .sw_req                                         (sw_req                                         )
    );

    core_controller #(

        .BANK_NUM                                       (8'd8                                           ),
        .SW_NUM                                         (8'd12                                          )
    ) core_controller_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_trigger_in_num                             (reg_trigger_in_num                             ),
        .reg_dds_phase                                  (reg_dds_phase                                  ),
        .reg_dds_inc                                    (reg_dds_inc                                    ),
        .reg_exp_cycle                                  (reg_exp_cycle                                  ),
        .reg_trigger_gap                                (reg_trigger_gap                                ),
        .reg_pic_num                                    (reg_pic_num                                    ),
        .reg_sw_status                                  (reg_sw_status                                  ),
        .reg_sw_shift                                   (reg_sw_shift                                   ),
        .reg_sw_loop_gap                                (reg_sw_loop_gap                                ),
        .reg_sw_loop_num                                (reg_sw_loop_num                                ),
        .reg_dds_phase_offset                           (reg_dds_phase_offset                           ),
        .reg_dac_value_forward                          (reg_dac_value_forward                          ),
        .reg_dac_value_backward                         (reg_dac_value_backward                         ),
        .reg_sw_wait                                    (reg_sw_wait                                    ),

        .reg_dac_value_x0                               ('d0),
        .reg_sw_value_x0                                ('d0),
        .reg_mos_value_x0                               ('d0),
        .reg_trigger_req_x0                             ('d0),
        .reg_dac_value_x1                               ('d0),
        .reg_sw_value_x1                                ('d0),
        .reg_mos_value_x1                               ('d0),
        .reg_trigger_req_x1                             ('d0),
        .reg_dac_value_x2                               ('d0),
        .reg_sw_value_x2                                ('d0),
        .reg_mos_value_x2                               ('d0),
        .reg_trigger_req_x2                             ('d0),
        .reg_dac_value_x3                               ('d0),
        .reg_sw_value_x3                                ('d0),
        .reg_mos_value_x3                               ('d0),
        .reg_trigger_req_x3                             ('d0),
        .reg_dac_value_y0                               ('d0),
        .reg_sw_value_y0                                ('d0),
        .reg_mos_value_y0                               ('d0),
        .reg_trigger_req_y0                             ('d0),
        .reg_dac_value_y1                               ('d0),
        .reg_sw_value_y1                                ('d0),
        .reg_mos_value_y1                               ('d0),
        .reg_trigger_req_y1                             ('d0),
        .reg_dac_value_y2                               ('d0),
        .reg_sw_value_y2                                ('d0),
        .reg_mos_value_y2                               ('d0),
        .reg_trigger_req_y2                             ('d0),
        .reg_dac_value_y3                               ('d0),
        .reg_sw_value_y3                                ('d0),
        .reg_mos_value_y3                               ('d0),
        .reg_trigger_req_y3                             ('d0),

        .reg_core_mode                                  (reg_core_mode                                  ),
        .reg_core_en                                    (reg_core_en                                    ),
        .reg_core_status                                (reg_core_status                                ),

        .reg_wave_start_addr                            (reg_wave_start_addr                            ),
        .reg_wave_end_addr                              (reg_wave_end_addr                              ),

        .trigger_in                                     (trigger_out                                    ),
        .sensor_trigger_req                             (sensor_trigger_req                             ),

        .mos_val                                        (mos_val                                        ),
        .mos_req                                        (mos_req                                        ),
        .mos_ack                                        (mos_ack                                        ),

        .dds_refresh                                    (dds_refresh                                    ),
        .dds_addr                                       (dds_addr                                       ),
        .dds_req                                        (dds_req                                        ),
        .dds_ack                                        (dds_ack                                        ),
        // .dds_data_forward                               (dds_data_forward                               ),
        // .dds_data_backward                              (dds_data_backward                              ),

        .dac_val                                        (dac_val                                        ),
        .dac_req                                        (dac_req                                        ),
        .dac_ack                                        (dac_ack                                        ),

        .sw_val                                         (sw_val                                         ),
        .sw_req                                         (sw_req                                         ),
        .sw_ack                                         (sw_ack                                         )
    );

endmodule