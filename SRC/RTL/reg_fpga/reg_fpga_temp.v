/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-12-26 09:57:54 
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-12-26 09:57:54 
 # FilePath     : reg_fpga.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`include "define.h"
`include "revision.h"

module reg_fpga_temp(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Reg_fpga cmd
    input wire                  reg_req                 ,
    input wire                  reg_whrl                ,
    input wire [31:0]           reg_addr                ,
    input wire [31:0]           reg_wdata               ,
    output reg                  reg_ack                 ,
    output reg [31:0]           reg_rdata               ,

	output reg [0:0]            reg_soft_reset          ,
	input wire [11:0]           reg_device_temp         ,
    output reg [31:0]           reg_mos_ack_time        ,
    output reg [31:0]           reg_dds_ack_time        ,
    output reg [31:0]           reg_dac_ack_time        ,
    output reg [31:0]           reg_sw_ack_time         ,
    output reg [7:0]            reg_mos_en              ,
	input wire [11:0]           reg_mainboard_temp      ,
    output reg [1:0]            reg_laser_status        ,
    output reg [31:0]           reg_soft_trigger_cycle  ,
    output reg [31:0]           reg_soft_trigger_num    ,
    output reg [0:0]            reg_soft_trigger_en     ,
    output reg [31:0]           reg_trigger_cycle       ,
    output reg [31:0]           reg_trigger_num         ,
    output reg [3:0]            reg_trigger_mode        ,
    output reg [31:0]           reg_trigger_width       ,
    output reg [31:0]           reg_trigger_delay       ,
    output reg [31:0]           reg_trigger_pulse       ,
    output reg [1:0]            reg_trigger_polar       ,
    output reg [0:0]            reg_trigger_en          ,
    output reg [0:0]            reg_encoder_phase       ,
    output reg [3:0]            reg_encoder_cnt_mode    ,
    output reg [3:0]            reg_encoder_dis_mode    ,
    output reg [31:0]           reg_encoder_ignore      ,
    output reg [31:0]           reg_encoder_div         ,
    output reg [31:0]           reg_encoder_width       ,
	input wire [31:0]           reg_encoder_location    ,
    output reg [0:0]            reg_encoder_multi_en    ,
    output reg [5:0]            reg_encoder_multi_coe   ,
	input wire [31:0]           reg_encoder_a_cnt       ,
	input wire [31:0]           reg_encoder_b_cnt       ,
	output reg [0:0]            reg_encoder_clr         ,
    output reg [0:0]            reg_encoder_en          ,
    output reg [0:0]            reg_slave_device        ,
	output reg [0:0]            reg_status_cnt_clr      ,
    output reg [31:0]           reg_l1_soft_trigger_cycle,
    output reg [31:0]           reg_l1_soft_trigger_num ,
    output reg [0:0]            reg_l1_soft_trigger_en  ,
    output reg [31:0]           reg_l1_trigger_cycle    ,
    output reg [31:0]           reg_l1_trigger_num      ,
    output reg [3:0]            reg_l1_trigger_mode     ,
    output reg [31:0]           reg_l1_trigger_width    ,
    output reg [31:0]           reg_l1_trigger_delay    ,
    output reg [31:0]           reg_l1_trigger_pulse    ,
    output reg [1:0]            reg_l1_trigger_polar    ,
    output reg [0:0]            reg_l1_trigger_en       ,
    output reg [0:0]            reg_l1_encoder_phase    ,
    output reg [3:0]            reg_l1_encoder_cnt_mode ,
    output reg [3:0]            reg_l1_encoder_dis_mode ,
    output reg [31:0]           reg_l1_encoder_ignore   ,
    output reg [31:0]           reg_l1_encoder_div      ,
    output reg [31:0]           reg_l1_encoder_width    ,
	input wire [31:0]           reg_l1_encoder_location ,
    output reg [0:0]            reg_l1_encoder_multi_en ,
    output reg [5:0]            reg_l1_encoder_multi_coe,
	input wire [31:0]           reg_l1_encoder_a_cnt    ,
	input wire [31:0]           reg_l1_encoder_b_cnt    ,
	output reg [0:0]            reg_l1_encoder_clr      ,
    output reg [0:0]            reg_l1_encoder_en       ,
	output reg [0:0]            reg_l1_status_cnt_clr   ,
    output reg [7:0]            reg_trigger_level       ,
    output reg [1:0]            reg_exp_chan            ,
    output reg [31:0]           reg_exposure_time       ,
    output reg [31:0]           reg_led_cnt_max         ,
    output reg [5:0]            reg_trigger_multi_en    ,
    output reg [11:0]           reg_led_polar           ,
    output reg [31:0]           reg_led_pwm_start_0     ,
    output reg [31:0]           reg_led_pwm_end_0       ,
    output reg [31:0]           reg_led_pwm_start_1     ,
    output reg [31:0]           reg_led_pwm_end_1       ,
    output reg [31:0]           reg_led_pwm_start_2     ,
    output reg [31:0]           reg_led_pwm_end_2       ,
    output reg [31:0]           reg_led_pwm_start_3     ,
    output reg [31:0]           reg_led_pwm_end_3       ,
    output reg [31:0]           reg_led_pwm_start_4     ,
    output reg [31:0]           reg_led_pwm_end_4       ,
    output reg [31:0]           reg_led_pwm_start_5     ,
    output reg [31:0]           reg_led_pwm_end_5       ,
    output reg [31:0]           reg_led_pwm_start_6     ,
    output reg [31:0]           reg_led_pwm_end_6       ,
    output reg [31:0]           reg_led_pwm_start_7     ,
    output reg [31:0]           reg_led_pwm_end_7       ,
    output reg [31:0]           reg_led_pwm_start_8     ,
    output reg [31:0]           reg_led_pwm_end_8       ,
    output reg [31:0]           reg_led_pwm_start_9     ,
    output reg [31:0]           reg_led_pwm_end_9       ,
    output reg [31:0]           reg_led_pwm_start_10    ,
    output reg [31:0]           reg_led_pwm_end_10      ,
    output reg [31:0]           reg_led_pwm_start_11    ,
    output reg [31:0]           reg_led_pwm_end_11      ,
    output reg [31:0]           reg_trig_start_0        ,
    output reg [31:0]           reg_trig_end_0          ,
    output reg [31:0]           reg_trig_start_1        ,
    output reg [31:0]           reg_trig_end_1          ,
    output reg [31:0]           reg_trig_start_2        ,
    output reg [31:0]           reg_trig_end_2          ,
    output reg [31:0]           reg_trig_start_3        ,
    output reg [31:0]           reg_trig_end_3          ,
    output reg [31:0]           reg_trig_start_4        ,
    output reg [31:0]           reg_trig_end_4          ,
    output reg [31:0]           reg_trig_start_5        ,
    output reg [31:0]           reg_trig_end_5          ,
    output reg [0:0]            reg_trig_out_polar      ,
    output reg [31:0]           reg_external_trig_num   ,
    output reg [0:0]            reg_external_trig_polar ,
    output reg [31:0]           reg_external_trig_delay ,
    output reg [31:0]           reg_external_trig_width ,
    output reg [0:0]            reg_external_trig_enable,
    output reg [31:0]           reg_camera_trig_num     ,
    output reg [9:0]            reg_dds_phase           ,
    output reg [9:0]            reg_dds_inc             ,
    output reg [31:0]           reg_exp_cycle           ,
    output reg [31:0]           reg_trigger_gap         ,
    output reg [31:0]           reg_pic_num             ,
    output reg [11:0]           reg_sw_status           ,
    output reg [7:0]            reg_sw_shift            ,
    output reg [31:0]           reg_sw_loop_gap         ,
    output reg [31:0]           reg_sw_loop_num         ,
    output reg [9:0]            reg_dds_phase_offset    ,
    output reg [0:0]            reg_dds_direction_x     ,
    output reg [0:0]            reg_dds_direction_y     ,
    output reg [13:0]           reg_current_offset      ,
    output reg [13:0]           reg_dac_value_forward   ,
    output reg [13:0]           reg_dac_value_backward  ,
    output reg [31:0]           reg_sw_wait             ,
    output reg [31:0]           reg_camera_delay        ,
    output reg [31:0]           reg_camera_cycle        ,
	output reg [0:0]            reg_dac_req             ,
    output reg [9:0]            reg_dds_phase_y         ,
    output reg [13:0]           reg_dac_value_x0        ,
    output reg [11:0]           reg_sw_value_x0         ,
    output reg [0:0]            reg_mos_value_x0        ,
	output reg [0:0]            reg_trigger_req_x0      ,
    output reg [13:0]           reg_dac_value_x1        ,
    output reg [11:0]           reg_sw_value_x1         ,
    output reg [0:0]            reg_mos_value_x1        ,
	output reg [0:0]            reg_trigger_req_x1      ,
    output reg [13:0]           reg_dac_value_x2        ,
    output reg [11:0]           reg_sw_value_x2         ,
    output reg [0:0]            reg_mos_value_x2        ,
	output reg [0:0]            reg_trigger_req_x2      ,
    output reg [13:0]           reg_dac_value_x3        ,
    output reg [11:0]           reg_sw_value_x3         ,
    output reg [0:0]            reg_mos_value_x3        ,
	output reg [0:0]            reg_trigger_req_x3      ,
    output reg [13:0]           reg_dac_value_y0        ,
    output reg [11:0]           reg_sw_value_y0         ,
    output reg [0:0]            reg_mos_value_y0        ,
	output reg [0:0]            reg_trigger_req_y0      ,
    output reg [13:0]           reg_dac_value_y1        ,
    output reg [11:0]           reg_sw_value_y1         ,
    output reg [0:0]            reg_mos_value_y1        ,
	output reg [0:0]            reg_trigger_req_y1      ,
    output reg [13:0]           reg_dac_value_y2        ,
    output reg [11:0]           reg_sw_value_y2         ,
    output reg [0:0]            reg_mos_value_y2        ,
	output reg [0:0]            reg_trigger_req_y2      ,
    output reg [13:0]           reg_dac_value_y3        ,
    output reg [11:0]           reg_sw_value_y3         ,
    output reg [0:0]            reg_mos_value_y3        ,
	output reg [0:0]            reg_trigger_req_y3      ,
    output reg [0:0]            reg_core_en             ,
    output reg [3:0]            reg_core_mode           ,
    output reg [0:0]            reg_step_en             ,
    output reg [31:0]           reg_step_pic_num        ,
    output reg [31:0]           reg_step_x_seq          ,
    output reg [31:0]           reg_step_y_seq          ,
    output reg [9:0]            reg_step_phase_0        ,
    output reg [9:0]            reg_step_phase_1        ,
    output reg [9:0]            reg_step_phase_2        ,
    output reg [9:0]            reg_step_phase_3        ,
    output reg [9:0]            reg_step_phase_4        ,
    output reg [9:0]            reg_step_phase_5        ,
    output reg [9:0]            reg_step_phase_6        ,
    output reg [9:0]            reg_step_phase_7        ,
    output reg [9:0]            reg_step_phase_8        ,
    output reg [9:0]            reg_step_phase_9        ,
    output reg [9:0]            reg_step_phase_10       ,
    output reg [9:0]            reg_step_phase_11       ,
    output reg [9:0]            reg_step_phase_12       ,
    output reg [9:0]            reg_step_phase_13       ,
    output reg [9:0]            reg_step_phase_14       ,
    output reg [9:0]            reg_step_phase_15       ,
    output reg [9:0]            reg_step_phase_16       ,
    output reg [9:0]            reg_step_phase_17       ,
    output reg [9:0]            reg_step_phase_18       ,
    output reg [9:0]            reg_step_phase_19       ,
    output reg [9:0]            reg_step_phase_20       ,
    output reg [9:0]            reg_step_phase_21       ,
    output reg [9:0]            reg_step_phase_22       ,
    output reg [9:0]            reg_step_phase_23       ,
    output reg [9:0]            reg_step_phase_24       ,
    output reg [9:0]            reg_step_phase_25       ,
    output reg [9:0]            reg_step_phase_26       ,
    output reg [9:0]            reg_step_phase_27       ,
    output reg [9:0]            reg_step_phase_28       ,
    output reg [9:0]            reg_step_phase_29       ,
    output reg [9:0]            reg_step_phase_30       ,
    output reg [9:0]            reg_step_phase_31       ,
    output reg [9:0]            reg_step_inc_0          ,
    output reg [9:0]            reg_step_inc_1          ,
    output reg [9:0]            reg_step_inc_2          ,
    output reg [9:0]            reg_step_inc_3          ,
    output reg [9:0]            reg_step_inc_4          ,
    output reg [9:0]            reg_step_inc_5          ,
    output reg [9:0]            reg_step_inc_6          ,
    output reg [9:0]            reg_step_inc_7          ,
    output reg [9:0]            reg_step_inc_8          ,
    output reg [9:0]            reg_step_inc_9          ,
    output reg [9:0]            reg_step_inc_10         ,
    output reg [9:0]            reg_step_inc_11         ,
    output reg [9:0]            reg_step_inc_12         ,
    output reg [9:0]            reg_step_inc_13         ,
    output reg [9:0]            reg_step_inc_14         ,
    output reg [9:0]            reg_step_inc_15         ,
    output reg [9:0]            reg_step_inc_16         ,
    output reg [9:0]            reg_step_inc_17         ,
    output reg [9:0]            reg_step_inc_18         ,
    output reg [9:0]            reg_step_inc_19         ,
    output reg [9:0]            reg_step_inc_20         ,
    output reg [9:0]            reg_step_inc_21         ,
    output reg [9:0]            reg_step_inc_22         ,
    output reg [9:0]            reg_step_inc_23         ,
    output reg [9:0]            reg_step_inc_24         ,
    output reg [9:0]            reg_step_inc_25         ,
    output reg [9:0]            reg_step_inc_26         ,
    output reg [9:0]            reg_step_inc_27         ,
    output reg [9:0]            reg_step_inc_28         ,
    output reg [9:0]            reg_step_inc_29         ,
    output reg [9:0]            reg_step_inc_30         ,
    output reg [9:0]            reg_step_inc_31         ,
    output reg [9:0]            reg_step_base_0         ,
    output reg [9:0]            reg_step_base_1         ,
    output reg [9:0]            reg_step_base_2         ,
    output reg [9:0]            reg_step_base_3         ,
    output reg [9:0]            reg_step_base_4         ,
    output reg [9:0]            reg_step_base_5         ,
    output reg [9:0]            reg_step_base_6         ,
    output reg [9:0]            reg_step_base_7         ,
    output reg [9:0]            reg_step_base_8         ,
    output reg [9:0]            reg_step_base_9         ,
    output reg [9:0]            reg_step_base_10        ,
    output reg [9:0]            reg_step_base_11        ,
    output reg [9:0]            reg_step_base_12        ,
    output reg [9:0]            reg_step_base_13        ,
    output reg [9:0]            reg_step_base_14        ,
    output reg [9:0]            reg_step_base_15        ,
    output reg [9:0]            reg_step_base_16        ,
    output reg [9:0]            reg_step_base_17        ,
    output reg [9:0]            reg_step_base_18        ,
    output reg [9:0]            reg_step_base_19        ,
    output reg [9:0]            reg_step_base_20        ,
    output reg [9:0]            reg_step_base_21        ,
    output reg [9:0]            reg_step_base_22        ,
    output reg [9:0]            reg_step_base_23        ,
    output reg [9:0]            reg_step_base_24        ,
    output reg [9:0]            reg_step_base_25        ,
    output reg [9:0]            reg_step_base_26        ,
    output reg [9:0]            reg_step_base_27        ,
    output reg [9:0]            reg_step_base_28        ,
    output reg [9:0]            reg_step_base_29        ,
    output reg [9:0]            reg_step_base_30        ,
    output reg [9:0]            reg_step_base_31        ,
    output reg [0:0]            reg_ram_cfg_en          ,
    output reg [0:0]            reg_ram_whrl            ,
    output reg [9:0]            reg_ram_addr            ,
    output reg [13:0]           reg_ram_wdata           ,
	input wire [13:0]           reg_ram_rdata           ,
	output reg [0:0]            reg_ram_req             ,
	input wire [0:0]            reg_ram_done            ,
    output reg [9:0]            reg_wave_start_addr     ,
    output reg [9:0]            reg_wave_end_addr       ,
    output reg [0:0]            reg_adjust_en           ,
    output reg [31:0]           reg_adjust_gain         ,
    output reg [31:0]           reg_adjust_offset       ,
	output reg [0:0]            reg_num_check_clr       ,
	input wire [31:0]           reg_io_in_0_num         ,
	input wire [31:0]           reg_io_in_1_num         ,
	input wire [31:0]           reg_encoder_a_num       ,
	input wire [31:0]           reg_encoder_b_num       ,
	input wire [31:0]           reg_io_out_num          ,
	input wire [31:0]           reg_mos_req_num         ,
	input wire [31:0]           reg_mos_ack_num         ,
	input wire [31:0]           reg_dds_req_num         ,
	input wire [31:0]           reg_dds_ack_num         ,
	input wire [31:0]           reg_dac_req_num         ,
	input wire [31:0]           reg_dac_ack_num         ,
	input wire [31:0]           reg_sw_req_num          ,
	input wire [31:0]           reg_sw_ack_num          ,
	input wire [31:0]           reg_reg_req_num         ,
	input wire [31:0]           reg_reg_ack_num         ,
	input wire [31:0]           reg_sum_err_num         ,
	input wire [31:0]           reg_trigger_in_num      ,
	input wire [31:0]           reg_lps                 ,
	input wire [15:0]           reg_core_status
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [2:0] 					reg_req_dly 			;
    reg [1:0] 					reg_whrl_dly 			;
    reg [63:0] 					reg_addr_dly 			;
    reg [63:0] 					reg_wdata_dly 			;
    reg [7:0] 					reg_ack_high_cnt 		;
    reg [7:0] 					reg_soft_reset_cnt 		;
    reg [31:0] 					reg_rdata_pre 			;
    reg [31:0] 					reg_test 				;
    reg [9:0] 					wc_clr_flag 			;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire 						reg_req_r 				;
    wire 						reg_whrl_sync 			;
    wire [31:0] 				reg_addr_sync			;
    wire [31:0] 				reg_wdata_sync			;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign reg_req_r 			= reg_req_dly[2:1] == 2'b01;
    assign reg_whrl_sync 		= reg_whrl_dly[1];
    assign reg_addr_sync 		= reg_addr_dly[63:32];
    assign reg_wdata_sync 		= reg_wdata_dly[63:32];

    always @ (posedge clk) begin
        reg_req_dly <= {reg_req_dly[1:0], reg_req};
    end

    always @ (posedge clk) begin
        reg_whrl_dly <= {reg_whrl_dly[0], reg_whrl};
    end

    always @ (posedge clk) begin
        reg_addr_dly <= {reg_addr_dly[31:0], reg_addr};
    end

    always @ (posedge clk) begin
        reg_wdata_dly <= {reg_wdata_dly[31:0], reg_wdata};
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            reg_ack_high_cnt <= 8'h0;
        end else if (reg_req_r == 1'b1) begin
            reg_ack_high_cnt <= 8'h1;
        end else if (reg_ack_high_cnt != 8'h0) begin
            reg_ack_high_cnt <= reg_ack_high_cnt + 1'b1;
        end else begin
            reg_ack_high_cnt <= reg_ack_high_cnt;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            reg_ack <= 1'h0;
        end else if (reg_ack_high_cnt == 8'h2) begin
            reg_ack <= 1'b1;
        end else begin
            reg_ack <= 1'b0;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            reg_rdata <= 32'd0;
        end else begin
            reg_rdata <= reg_rdata_pre;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            wc_clr_flag <= 10'b00_0000_000;
        end else if (reg_req_r == 1'b1) begin
            wc_clr_flag <= 10'b10_0000_0000;
        end else begin
            wc_clr_flag <= wc_clr_flag >> 1'b1;
        end
    end

// Register write logic start--------------------------------------

    //register `COMPANY is Read only type

    //register `DEVICE is Read only type

    //register `DEVICE_SUB is Read only type

    //register `PROPERTY is Read only type

    //register `YEAR_MOUTH_DATE is Read only type

    //register `HOUR_MINUTE is Read only type

    //register `REV is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_soft_reset <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_001C) begin
            reg_soft_reset <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_soft_reset <= 'd0;
        end else begin 
            reg_soft_reset <= reg_soft_reset;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_test <= 32'haaaa_5555;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_0020) begin
            reg_test <= reg_wdata_sync[31:0];
        end else begin 
            reg_test <= reg_test;
        end
    end

    //register reg_device_temp is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_ack_time <= 32'd2;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1100) begin
            reg_mos_ack_time <= reg_wdata_sync[31:0];
        end else begin 
            reg_mos_ack_time <= reg_mos_ack_time;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_ack_time <= 32'd2;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1104) begin
            reg_dds_ack_time <= reg_wdata_sync[31:0];
        end else begin 
            reg_dds_ack_time <= reg_dds_ack_time;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_ack_time <= 32'd2;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1108) begin
            reg_dac_ack_time <= reg_wdata_sync[31:0];
        end else begin 
            reg_dac_ack_time <= reg_dac_ack_time;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_ack_time <= 32'h1DC;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_110C) begin
            reg_sw_ack_time <= reg_wdata_sync[31:0];
        end else begin 
            reg_sw_ack_time <= reg_sw_ack_time;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_en <= 8'hFF;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1110) begin
            reg_mos_en <= reg_wdata_sync[7:0];
        end else begin 
            reg_mos_en <= reg_mos_en;
        end
    end

    //register reg_mainboard_temp is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_laser_status <= 2'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1400) begin
            reg_laser_status <= reg_wdata_sync[1:0];
        end else begin 
            reg_laser_status <= reg_laser_status;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_soft_trigger_cycle <= 32'd33334;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1600) begin
            reg_soft_trigger_cycle <= reg_wdata_sync[31:0];
        end else begin 
            reg_soft_trigger_cycle <= reg_soft_trigger_cycle;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_soft_trigger_num <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1604) begin
            reg_soft_trigger_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_soft_trigger_num <= reg_soft_trigger_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_soft_trigger_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1608) begin
            reg_soft_trigger_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_soft_trigger_en <= reg_soft_trigger_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_cycle  <= 32'd125_0000;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_160C) begin
            reg_trigger_cycle  <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_cycle  <= reg_trigger_cycle ;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_num <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1610) begin
            reg_trigger_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_num <= reg_trigger_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1614) begin
            reg_trigger_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_trigger_mode <= reg_trigger_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_width <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1618) begin
            reg_trigger_width <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_width <= reg_trigger_width;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_delay <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_161C) begin
            reg_trigger_delay <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_delay <= reg_trigger_delay;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_pulse <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1620) begin
            reg_trigger_pulse <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_pulse <= reg_trigger_pulse;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_polar <= 2'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1624) begin
            reg_trigger_polar <= reg_wdata_sync[1:0];
        end else begin 
            reg_trigger_polar <= reg_trigger_polar;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1628) begin
            reg_trigger_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_trigger_en <= reg_trigger_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_phase <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_162C) begin
            reg_encoder_phase <= reg_wdata_sync[0:0];
        end else begin 
            reg_encoder_phase <= reg_encoder_phase;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_cnt_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1630) begin
            reg_encoder_cnt_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_encoder_cnt_mode <= reg_encoder_cnt_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_dis_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1634) begin
            reg_encoder_dis_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_encoder_dis_mode <= reg_encoder_dis_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_ignore <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1638) begin
            reg_encoder_ignore <= reg_wdata_sync[31:0];
        end else begin 
            reg_encoder_ignore <= reg_encoder_ignore;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_div <= 32'h1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_163C) begin
            reg_encoder_div <= reg_wdata_sync[31:0];
        end else begin 
            reg_encoder_div <= reg_encoder_div;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_width <= 32'h100;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1640) begin
            reg_encoder_width <= reg_wdata_sync[31:0];
        end else begin 
            reg_encoder_width <= reg_encoder_width;
        end
    end

    //register reg_encoder_location is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_multi_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1648) begin
            reg_encoder_multi_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_encoder_multi_en <= reg_encoder_multi_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_multi_coe <= 6'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_164C) begin
            reg_encoder_multi_coe <= reg_wdata_sync[5:0];
        end else begin 
            reg_encoder_multi_coe <= reg_encoder_multi_coe;
        end
    end

    //register reg_encoder_a_cnt is Read only type

    //register reg_encoder_b_cnt is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_clr <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1658) begin
            reg_encoder_clr <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_encoder_clr <= 'd0;
        end else begin 
            reg_encoder_clr <= reg_encoder_clr;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_encoder_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_165C) begin
            reg_encoder_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_encoder_en <= reg_encoder_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_slave_device <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1660) begin
            reg_slave_device <= reg_wdata_sync[0:0];
        end else begin 
            reg_slave_device <= reg_slave_device;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_status_cnt_clr <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1664) begin
            reg_status_cnt_clr <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_status_cnt_clr <= 'd0;
        end else begin 
            reg_status_cnt_clr <= reg_status_cnt_clr;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_soft_trigger_cycle <= 32'd33334;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1680) begin
            reg_l1_soft_trigger_cycle <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_soft_trigger_cycle <= reg_l1_soft_trigger_cycle;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_soft_trigger_num <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1684) begin
            reg_l1_soft_trigger_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_soft_trigger_num <= reg_l1_soft_trigger_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_soft_trigger_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1688) begin
            reg_l1_soft_trigger_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_l1_soft_trigger_en <= reg_l1_soft_trigger_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_cycle  <= 32'd125_0000;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_168C) begin
            reg_l1_trigger_cycle  <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_trigger_cycle  <= reg_l1_trigger_cycle ;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_num <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1690) begin
            reg_l1_trigger_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_trigger_num <= reg_l1_trigger_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1694) begin
            reg_l1_trigger_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_l1_trigger_mode <= reg_l1_trigger_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_width <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1698) begin
            reg_l1_trigger_width <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_trigger_width <= reg_l1_trigger_width;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_delay <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_169C) begin
            reg_l1_trigger_delay <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_trigger_delay <= reg_l1_trigger_delay;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_pulse <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16A0) begin
            reg_l1_trigger_pulse <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_trigger_pulse <= reg_l1_trigger_pulse;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_polar <= 2'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16A4) begin
            reg_l1_trigger_polar <= reg_wdata_sync[1:0];
        end else begin 
            reg_l1_trigger_polar <= reg_l1_trigger_polar;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_trigger_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16A8) begin
            reg_l1_trigger_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_l1_trigger_en <= reg_l1_trigger_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_phase <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16AC) begin
            reg_l1_encoder_phase <= reg_wdata_sync[0:0];
        end else begin 
            reg_l1_encoder_phase <= reg_l1_encoder_phase;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_cnt_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16B0) begin
            reg_l1_encoder_cnt_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_l1_encoder_cnt_mode <= reg_l1_encoder_cnt_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_dis_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16B4) begin
            reg_l1_encoder_dis_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_l1_encoder_dis_mode <= reg_l1_encoder_dis_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_ignore <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16B8) begin
            reg_l1_encoder_ignore <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_encoder_ignore <= reg_l1_encoder_ignore;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_div <= 32'h1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16BC) begin
            reg_l1_encoder_div <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_encoder_div <= reg_l1_encoder_div;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_width <= 32'h100;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16C0) begin
            reg_l1_encoder_width <= reg_wdata_sync[31:0];
        end else begin 
            reg_l1_encoder_width <= reg_l1_encoder_width;
        end
    end

    //register reg_l1_encoder_location is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_multi_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16C8) begin
            reg_l1_encoder_multi_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_l1_encoder_multi_en <= reg_l1_encoder_multi_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_multi_coe <= 6'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16CC) begin
            reg_l1_encoder_multi_coe <= reg_wdata_sync[5:0];
        end else begin 
            reg_l1_encoder_multi_coe <= reg_l1_encoder_multi_coe;
        end
    end

    //register reg_l1_encoder_a_cnt is Read only type

    //register reg_l1_encoder_b_cnt is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_clr <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16D8) begin
            reg_l1_encoder_clr <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_l1_encoder_clr <= 'd0;
        end else begin 
            reg_l1_encoder_clr <= reg_l1_encoder_clr;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_encoder_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16DC) begin
            reg_l1_encoder_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_l1_encoder_en <= reg_l1_encoder_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_l1_status_cnt_clr <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16E0) begin
            reg_l1_status_cnt_clr <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_l1_status_cnt_clr <= 'd0;
        end else begin 
            reg_l1_status_cnt_clr <= reg_l1_status_cnt_clr;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_level <= 8'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_16FC) begin
            reg_trigger_level <= reg_wdata_sync[7:0];
        end else begin 
            reg_trigger_level <= reg_trigger_level;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_exp_chan <= 2'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1700) begin
            reg_exp_chan <= reg_wdata_sync[1:0];
        end else begin 
            reg_exp_chan <= reg_exp_chan;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_exposure_time <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1704) begin
            reg_exposure_time <= reg_wdata_sync[31:0];
        end else begin 
            reg_exposure_time <= reg_exposure_time;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_cnt_max <= 32'd400;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1708) begin
            reg_led_cnt_max <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_cnt_max <= reg_led_cnt_max;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_multi_en <= 6'h1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_170C) begin
            reg_trigger_multi_en <= reg_wdata_sync[5:0];
        end else begin 
            reg_trigger_multi_en <= reg_trigger_multi_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_polar <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1710) begin
            reg_led_polar <= reg_wdata_sync[11:0];
        end else begin 
            reg_led_polar <= reg_led_polar;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_0 <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1714) begin
            reg_led_pwm_start_0 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_0 <= reg_led_pwm_start_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_0 <= 32'd300;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1718) begin
            reg_led_pwm_end_0 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_0 <= reg_led_pwm_end_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_1 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_171C) begin
            reg_led_pwm_start_1 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_1 <= reg_led_pwm_start_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_1 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1720) begin
            reg_led_pwm_end_1 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_1 <= reg_led_pwm_end_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_2 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1724) begin
            reg_led_pwm_start_2 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_2 <= reg_led_pwm_start_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_2 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1728) begin
            reg_led_pwm_end_2 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_2 <= reg_led_pwm_end_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_3 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_172C) begin
            reg_led_pwm_start_3 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_3 <= reg_led_pwm_start_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_3 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1730) begin
            reg_led_pwm_end_3 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_3 <= reg_led_pwm_end_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_4 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1734) begin
            reg_led_pwm_start_4 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_4 <= reg_led_pwm_start_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_4 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1738) begin
            reg_led_pwm_end_4 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_4 <= reg_led_pwm_end_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_5 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_173C) begin
            reg_led_pwm_start_5 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_5 <= reg_led_pwm_start_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_5 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1740) begin
            reg_led_pwm_end_5 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_5 <= reg_led_pwm_end_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_6 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1744) begin
            reg_led_pwm_start_6 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_6 <= reg_led_pwm_start_6;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_6 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1748) begin
            reg_led_pwm_end_6 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_6 <= reg_led_pwm_end_6;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_7 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_174C) begin
            reg_led_pwm_start_7 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_7 <= reg_led_pwm_start_7;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_7 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1750) begin
            reg_led_pwm_end_7 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_7 <= reg_led_pwm_end_7;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_8 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1754) begin
            reg_led_pwm_start_8 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_8 <= reg_led_pwm_start_8;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_8 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1758) begin
            reg_led_pwm_end_8 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_8 <= reg_led_pwm_end_8;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_9 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_175C) begin
            reg_led_pwm_start_9 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_9 <= reg_led_pwm_start_9;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_9 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1760) begin
            reg_led_pwm_end_9 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_9 <= reg_led_pwm_end_9;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_10 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1764) begin
            reg_led_pwm_start_10 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_10 <= reg_led_pwm_start_10;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_10 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1768) begin
            reg_led_pwm_end_10 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_10 <= reg_led_pwm_end_10;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_start_11 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_176C) begin
            reg_led_pwm_start_11 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_start_11 <= reg_led_pwm_start_11;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_led_pwm_end_11 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1770) begin
            reg_led_pwm_end_11 <= reg_wdata_sync[31:0];
        end else begin 
            reg_led_pwm_end_11 <= reg_led_pwm_end_11;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_0 <= 32'd10;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1774) begin
            reg_trig_start_0 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_0 <= reg_trig_start_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_0 <= 32'd300;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1778) begin
            reg_trig_end_0 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_0 <= reg_trig_end_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_1 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_177C) begin
            reg_trig_start_1 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_1 <= reg_trig_start_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_1 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1780) begin
            reg_trig_end_1 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_1 <= reg_trig_end_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_2 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1784) begin
            reg_trig_start_2 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_2 <= reg_trig_start_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_2 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1788) begin
            reg_trig_end_2 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_2 <= reg_trig_end_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_3 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_178C) begin
            reg_trig_start_3 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_3 <= reg_trig_start_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_3 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1790) begin
            reg_trig_end_3 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_3 <= reg_trig_end_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_4 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1794) begin
            reg_trig_start_4 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_4 <= reg_trig_start_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_4 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1798) begin
            reg_trig_end_4 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_4 <= reg_trig_end_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_start_5 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_179C) begin
            reg_trig_start_5 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_start_5 <= reg_trig_start_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_end_5 <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_17A0) begin
            reg_trig_end_5 <= reg_wdata_sync[31:0];
        end else begin 
            reg_trig_end_5 <= reg_trig_end_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trig_out_polar <= 1'h1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_17A4) begin
            reg_trig_out_polar <= reg_wdata_sync[0:0];
        end else begin 
            reg_trig_out_polar <= reg_trig_out_polar;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_external_trig_num <= 32'd1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1800) begin
            reg_external_trig_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_external_trig_num <= reg_external_trig_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_external_trig_polar <= 1'b0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1804) begin
            reg_external_trig_polar <= reg_wdata_sync[0:0];
        end else begin 
            reg_external_trig_polar <= reg_external_trig_polar;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_external_trig_delay <= 32'h64;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1808) begin
            reg_external_trig_delay <= reg_wdata_sync[31:0];
        end else begin 
            reg_external_trig_delay <= reg_external_trig_delay;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_external_trig_width <= 32'hEA6;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_180C) begin
            reg_external_trig_width <= reg_wdata_sync[31:0];
        end else begin 
            reg_external_trig_width <= reg_external_trig_width;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_external_trig_enable <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1810) begin
            reg_external_trig_enable <= reg_wdata_sync[0:0];
        end else begin 
            reg_external_trig_enable <= reg_external_trig_enable;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_camera_trig_num <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_1814) begin
            reg_camera_trig_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_camera_trig_num <= reg_camera_trig_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_phase <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2000) begin
            reg_dds_phase <= reg_wdata_sync[9:0];
        end else begin 
            reg_dds_phase <= reg_dds_phase;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_inc <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2004) begin
            reg_dds_inc <= reg_wdata_sync[9:0];
        end else begin 
            reg_dds_inc <= reg_dds_inc;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_exp_cycle <= 32'd3500;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2008) begin
            reg_exp_cycle <= reg_wdata_sync[31:0];
        end else begin 
            reg_exp_cycle <= reg_exp_cycle;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_gap <= 32'd250;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_200C) begin
            reg_trigger_gap <= reg_wdata_sync[31:0];
        end else begin 
            reg_trigger_gap <= reg_trigger_gap;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_pic_num <= 32'h8;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2010) begin
            reg_pic_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_pic_num <= reg_pic_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_status <= 12'h001;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2014) begin
            reg_sw_status <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_status <= reg_sw_status;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_shift <= 12'h001;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2018) begin
            reg_sw_shift <= reg_wdata_sync[7:0];
        end else begin 
            reg_sw_shift <= reg_sw_shift;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_loop_gap <= 32'd9;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_201C) begin
            reg_sw_loop_gap <= reg_wdata_sync[31:0];
        end else begin 
            reg_sw_loop_gap <= reg_sw_loop_gap;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_loop_num <= 32'd1;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2020) begin
            reg_sw_loop_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_sw_loop_num <= reg_sw_loop_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_phase_offset <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2024) begin
            reg_dds_phase_offset <= reg_wdata_sync[9:0];
        end else begin 
            reg_dds_phase_offset <= reg_dds_phase_offset;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_direction_x <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2028) begin
            reg_dds_direction_x <= reg_wdata_sync[0:0];
        end else begin 
            reg_dds_direction_x <= reg_dds_direction_x;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_direction_y <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_202C) begin
            reg_dds_direction_y <= reg_wdata_sync[0:0];
        end else begin 
            reg_dds_direction_y <= reg_dds_direction_y;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_current_offset <= 14'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2030) begin
            reg_current_offset <= reg_wdata_sync[13:0];
        end else begin 
            reg_current_offset <= reg_current_offset;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_forward <= 14'hAFF;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2034) begin
            reg_dac_value_forward <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_forward <= reg_dac_value_forward;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_backward <= 14'hAFF;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2038) begin
            reg_dac_value_backward <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_backward <= reg_dac_value_backward;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_wait <= 32'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_203C) begin
            reg_sw_wait <= reg_wdata_sync[31:0];
        end else begin 
            reg_sw_wait <= reg_sw_wait;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_camera_delay <= 32'h64;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2040) begin
            reg_camera_delay <= reg_wdata_sync[31:0];
        end else begin 
            reg_camera_delay <= reg_camera_delay;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_camera_cycle <= 32'd4166;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2044) begin
            reg_camera_cycle <= reg_wdata_sync[31:0];
        end else begin 
            reg_camera_cycle <= reg_camera_cycle;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_req <= 1'b0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2048) begin
            reg_dac_req <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_dac_req <= 'd0;
        end else begin 
            reg_dac_req <= reg_dac_req;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dds_phase_y <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2070) begin
            reg_dds_phase_y <= reg_wdata_sync[9:0];
        end else begin 
            reg_dds_phase_y <= reg_dds_phase_y;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_x0 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2100) begin
            reg_dac_value_x0 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_x0 <= reg_dac_value_x0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_x0 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2104) begin
            reg_sw_value_x0 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_x0 <= reg_sw_value_x0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_x0 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2108) begin
            reg_mos_value_x0 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_x0 <= reg_mos_value_x0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_x0 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_210C) begin
            reg_trigger_req_x0 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_x0 <= 'd0;
        end else begin 
            reg_trigger_req_x0 <= reg_trigger_req_x0;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_x1 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2110) begin
            reg_dac_value_x1 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_x1 <= reg_dac_value_x1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_x1 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2114) begin
            reg_sw_value_x1 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_x1 <= reg_sw_value_x1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_x1 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2118) begin
            reg_mos_value_x1 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_x1 <= reg_mos_value_x1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_x1 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_211C) begin
            reg_trigger_req_x1 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_x1 <= 'd0;
        end else begin 
            reg_trigger_req_x1 <= reg_trigger_req_x1;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_x2 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2120) begin
            reg_dac_value_x2 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_x2 <= reg_dac_value_x2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_x2 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2124) begin
            reg_sw_value_x2 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_x2 <= reg_sw_value_x2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_x2 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2128) begin
            reg_mos_value_x2 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_x2 <= reg_mos_value_x2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_x2 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_212C) begin
            reg_trigger_req_x2 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_x2 <= 'd0;
        end else begin 
            reg_trigger_req_x2 <= reg_trigger_req_x2;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_x3 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2130) begin
            reg_dac_value_x3 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_x3 <= reg_dac_value_x3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_x3 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2134) begin
            reg_sw_value_x3 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_x3 <= reg_sw_value_x3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_x3 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2138) begin
            reg_mos_value_x3 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_x3 <= reg_mos_value_x3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_x3 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_213C) begin
            reg_trigger_req_x3 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_x3 <= 'd0;
        end else begin 
            reg_trigger_req_x3 <= reg_trigger_req_x3;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_y0 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2140) begin
            reg_dac_value_y0 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_y0 <= reg_dac_value_y0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_y0 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2144) begin
            reg_sw_value_y0 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_y0 <= reg_sw_value_y0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_y0 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2148) begin
            reg_mos_value_y0 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_y0 <= reg_mos_value_y0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_y0 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_214C) begin
            reg_trigger_req_y0 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_y0 <= 'd0;
        end else begin 
            reg_trigger_req_y0 <= reg_trigger_req_y0;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_y1 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2150) begin
            reg_dac_value_y1 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_y1 <= reg_dac_value_y1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_y1 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2154) begin
            reg_sw_value_y1 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_y1 <= reg_sw_value_y1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_y1 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2158) begin
            reg_mos_value_y1 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_y1 <= reg_mos_value_y1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_y1 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_215C) begin
            reg_trigger_req_y1 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_y1 <= 'd0;
        end else begin 
            reg_trigger_req_y1 <= reg_trigger_req_y1;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_y2 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2160) begin
            reg_dac_value_y2 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_y2 <= reg_dac_value_y2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_y2 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2164) begin
            reg_sw_value_y2 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_y2 <= reg_sw_value_y2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_y2 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2168) begin
            reg_mos_value_y2 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_y2 <= reg_mos_value_y2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_y2 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_216C) begin
            reg_trigger_req_y2 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_y2 <= 'd0;
        end else begin 
            reg_trigger_req_y2 <= reg_trigger_req_y2;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_dac_value_y3 <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2170) begin
            reg_dac_value_y3 <= reg_wdata_sync[13:0];
        end else begin 
            reg_dac_value_y3 <= reg_dac_value_y3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_sw_value_y3 <= 12'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2174) begin
            reg_sw_value_y3 <= reg_wdata_sync[11:0];
        end else begin 
            reg_sw_value_y3 <= reg_sw_value_y3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_mos_value_y3 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2178) begin
            reg_mos_value_y3 <= reg_wdata_sync[0:0];
        end else begin 
            reg_mos_value_y3 <= reg_mos_value_y3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_trigger_req_y3 <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_217C) begin
            reg_trigger_req_y3 <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_trigger_req_y3 <= 'd0;
        end else begin 
            reg_trigger_req_y3 <= reg_trigger_req_y3;
        end 
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_core_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2200) begin
            reg_core_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_core_en <= reg_core_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_core_mode <= 4'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2204) begin
            reg_core_mode <= reg_wdata_sync[3:0];
        end else begin 
            reg_core_mode <= reg_core_mode;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2300) begin
            reg_step_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_step_en <= reg_step_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_pic_num <= 32'd32;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2304) begin
            reg_step_pic_num <= reg_wdata_sync[31:0];
        end else begin 
            reg_step_pic_num <= reg_step_pic_num;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_x_seq <= 32'h0F0F0F0F;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2308) begin
            reg_step_x_seq <= reg_wdata_sync[31:0];
        end else begin 
            reg_step_x_seq <= reg_step_x_seq;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_y_seq <= 32'hF0F0F0F0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_230C) begin
            reg_step_y_seq <= reg_wdata_sync[31:0];
        end else begin 
            reg_step_y_seq <= reg_step_y_seq;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_0 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2400) begin
            reg_step_phase_0 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_0 <= reg_step_phase_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_1 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2404) begin
            reg_step_phase_1 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_1 <= reg_step_phase_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_2 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2408) begin
            reg_step_phase_2 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_2 <= reg_step_phase_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_3 <= 10'd216;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_240C) begin
            reg_step_phase_3 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_3 <= reg_step_phase_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_4 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2410) begin
            reg_step_phase_4 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_4 <= reg_step_phase_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_5 <= 10'd216;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2414) begin
            reg_step_phase_5 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_5 <= reg_step_phase_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_6 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2418) begin
            reg_step_phase_6 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_6 <= reg_step_phase_6;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_7 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_241C) begin
            reg_step_phase_7 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_7 <= reg_step_phase_7;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_8 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2420) begin
            reg_step_phase_8 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_8 <= reg_step_phase_8;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_9 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2424) begin
            reg_step_phase_9 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_9 <= reg_step_phase_9;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_10 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2428) begin
            reg_step_phase_10 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_10 <= reg_step_phase_10;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_11 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_242C) begin
            reg_step_phase_11 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_11 <= reg_step_phase_11;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_12 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2430) begin
            reg_step_phase_12 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_12 <= reg_step_phase_12;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_13 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2434) begin
            reg_step_phase_13 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_13 <= reg_step_phase_13;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_14 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2438) begin
            reg_step_phase_14 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_14 <= reg_step_phase_14;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_15 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_243C) begin
            reg_step_phase_15 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_15 <= reg_step_phase_15;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_16 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2440) begin
            reg_step_phase_16 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_16 <= reg_step_phase_16;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_17 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2444) begin
            reg_step_phase_17 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_17 <= reg_step_phase_17;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_18 <= 10'd216;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2448) begin
            reg_step_phase_18 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_18 <= reg_step_phase_18;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_19 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_244C) begin
            reg_step_phase_19 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_19 <= reg_step_phase_19;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_20 <= 10'd216;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2450) begin
            reg_step_phase_20 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_20 <= reg_step_phase_20;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_21 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2454) begin
            reg_step_phase_21 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_21 <= reg_step_phase_21;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_22 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2458) begin
            reg_step_phase_22 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_22 <= reg_step_phase_22;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_23 <= 10'd144;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_245C) begin
            reg_step_phase_23 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_23 <= reg_step_phase_23;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_24 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2460) begin
            reg_step_phase_24 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_24 <= reg_step_phase_24;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_25 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2464) begin
            reg_step_phase_25 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_25 <= reg_step_phase_25;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_26 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2468) begin
            reg_step_phase_26 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_26 <= reg_step_phase_26;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_27 <= 10'd0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_246C) begin
            reg_step_phase_27 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_27 <= reg_step_phase_27;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_28 <= 10'd72;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2470) begin
            reg_step_phase_28 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_28 <= reg_step_phase_28;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_29 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2474) begin
            reg_step_phase_29 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_29 <= reg_step_phase_29;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_30 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2478) begin
            reg_step_phase_30 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_30 <= reg_step_phase_30;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_phase_31 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_247C) begin
            reg_step_phase_31 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_phase_31 <= reg_step_phase_31;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_0 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2480) begin
            reg_step_inc_0 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_0 <= reg_step_inc_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_1 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2484) begin
            reg_step_inc_1 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_1 <= reg_step_inc_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_2 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2488) begin
            reg_step_inc_2 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_2 <= reg_step_inc_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_3 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_248C) begin
            reg_step_inc_3 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_3 <= reg_step_inc_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_4 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2490) begin
            reg_step_inc_4 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_4 <= reg_step_inc_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_5 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2494) begin
            reg_step_inc_5 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_5 <= reg_step_inc_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_6 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2498) begin
            reg_step_inc_6 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_6 <= reg_step_inc_6;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_7 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_249C) begin
            reg_step_inc_7 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_7 <= reg_step_inc_7;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_8 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24A0) begin
            reg_step_inc_8 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_8 <= reg_step_inc_8;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_9 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24A4) begin
            reg_step_inc_9 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_9 <= reg_step_inc_9;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_10 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24A8) begin
            reg_step_inc_10 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_10 <= reg_step_inc_10;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_11 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24AC) begin
            reg_step_inc_11 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_11 <= reg_step_inc_11;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_12 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24B0) begin
            reg_step_inc_12 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_12 <= reg_step_inc_12;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_13 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24B4) begin
            reg_step_inc_13 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_13 <= reg_step_inc_13;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_14 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24B8) begin
            reg_step_inc_14 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_14 <= reg_step_inc_14;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_15 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24BC) begin
            reg_step_inc_15 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_15 <= reg_step_inc_15;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_16 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24C0) begin
            reg_step_inc_16 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_16 <= reg_step_inc_16;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_17 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24C4) begin
            reg_step_inc_17 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_17 <= reg_step_inc_17;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_18 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24C8) begin
            reg_step_inc_18 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_18 <= reg_step_inc_18;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_19 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24CC) begin
            reg_step_inc_19 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_19 <= reg_step_inc_19;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_20 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24D0) begin
            reg_step_inc_20 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_20 <= reg_step_inc_20;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_21 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24D4) begin
            reg_step_inc_21 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_21 <= reg_step_inc_21;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_22 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24D8) begin
            reg_step_inc_22 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_22 <= reg_step_inc_22;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_23 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24DC) begin
            reg_step_inc_23 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_23 <= reg_step_inc_23;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_24 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24E0) begin
            reg_step_inc_24 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_24 <= reg_step_inc_24;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_25 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24E4) begin
            reg_step_inc_25 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_25 <= reg_step_inc_25;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_26 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24E8) begin
            reg_step_inc_26 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_26 <= reg_step_inc_26;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_27 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24EC) begin
            reg_step_inc_27 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_27 <= reg_step_inc_27;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_28 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24F0) begin
            reg_step_inc_28 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_28 <= reg_step_inc_28;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_29 <= 10'd12;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24F4) begin
            reg_step_inc_29 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_29 <= reg_step_inc_29;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_30 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24F8) begin
            reg_step_inc_30 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_30 <= reg_step_inc_30;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_inc_31 <= 10'd3;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_24FC) begin
            reg_step_inc_31 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_inc_31 <= reg_step_inc_31;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_0 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2500) begin
            reg_step_base_0 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_0 <= reg_step_base_0;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_1 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2504) begin
            reg_step_base_1 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_1 <= reg_step_base_1;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_2 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2508) begin
            reg_step_base_2 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_2 <= reg_step_base_2;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_3 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_250C) begin
            reg_step_base_3 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_3 <= reg_step_base_3;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_4 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2510) begin
            reg_step_base_4 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_4 <= reg_step_base_4;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_5 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2514) begin
            reg_step_base_5 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_5 <= reg_step_base_5;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_6 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2518) begin
            reg_step_base_6 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_6 <= reg_step_base_6;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_7 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_251C) begin
            reg_step_base_7 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_7 <= reg_step_base_7;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_8 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2520) begin
            reg_step_base_8 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_8 <= reg_step_base_8;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_9 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2524) begin
            reg_step_base_9 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_9 <= reg_step_base_9;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_10 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2528) begin
            reg_step_base_10 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_10 <= reg_step_base_10;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_11 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_252C) begin
            reg_step_base_11 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_11 <= reg_step_base_11;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_12 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2530) begin
            reg_step_base_12 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_12 <= reg_step_base_12;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_13 <= 10'd512;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2534) begin
            reg_step_base_13 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_13 <= reg_step_base_13;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_14 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2538) begin
            reg_step_base_14 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_14 <= reg_step_base_14;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_15 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_253C) begin
            reg_step_base_15 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_15 <= reg_step_base_15;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_16 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2540) begin
            reg_step_base_16 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_16 <= reg_step_base_16;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_17 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2544) begin
            reg_step_base_17 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_17 <= reg_step_base_17;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_18 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2548) begin
            reg_step_base_18 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_18 <= reg_step_base_18;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_19 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_254C) begin
            reg_step_base_19 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_19 <= reg_step_base_19;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_20 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2550) begin
            reg_step_base_20 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_20 <= reg_step_base_20;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_21 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2554) begin
            reg_step_base_21 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_21 <= reg_step_base_21;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_22 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2558) begin
            reg_step_base_22 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_22 <= reg_step_base_22;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_23 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_255C) begin
            reg_step_base_23 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_23 <= reg_step_base_23;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_24 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2560) begin
            reg_step_base_24 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_24 <= reg_step_base_24;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_25 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2564) begin
            reg_step_base_25 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_25 <= reg_step_base_25;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_26 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2568) begin
            reg_step_base_26 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_26 <= reg_step_base_26;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_27 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_256C) begin
            reg_step_base_27 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_27 <= reg_step_base_27;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_28 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2570) begin
            reg_step_base_28 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_28 <= reg_step_base_28;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_29 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2574) begin
            reg_step_base_29 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_29 <= reg_step_base_29;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_30 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_2578) begin
            reg_step_base_30 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_30 <= reg_step_base_30;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_step_base_31 <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_257C) begin
            reg_step_base_31 <= reg_wdata_sync[9:0];
        end else begin 
            reg_step_base_31 <= reg_step_base_31;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_ram_cfg_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3000) begin
            reg_ram_cfg_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_ram_cfg_en <= reg_ram_cfg_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_ram_whrl <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3004) begin
            reg_ram_whrl <= reg_wdata_sync[0:0];
        end else begin 
            reg_ram_whrl <= reg_ram_whrl;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_ram_addr <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3008) begin
            reg_ram_addr <= reg_wdata_sync[9:0];
        end else begin 
            reg_ram_addr <= reg_ram_addr;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_ram_wdata <= 14'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_300C) begin
            reg_ram_wdata <= reg_wdata_sync[13:0];
        end else begin 
            reg_ram_wdata <= reg_ram_wdata;
        end
    end

    //register reg_ram_rdata is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_ram_req <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3014) begin
            reg_ram_req <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_ram_req <= 'd0;
        end else begin 
            reg_ram_req <= reg_ram_req;
        end 
    end

    //register reg_ram_done is Read only type

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_wave_start_addr <= 10'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_301C) begin
            reg_wave_start_addr <= reg_wdata_sync[9:0];
        end else begin 
            reg_wave_start_addr <= reg_wave_start_addr;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_wave_end_addr <= 10'd287;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3020) begin
            reg_wave_end_addr <= reg_wdata_sync[9:0];
        end else begin 
            reg_wave_end_addr <= reg_wave_end_addr;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_adjust_en <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3100) begin
            reg_adjust_en <= reg_wdata_sync[0:0];
        end else begin 
            reg_adjust_en <= reg_adjust_en;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_adjust_gain <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3104) begin
            reg_adjust_gain <= reg_wdata_sync[31:0];
        end else begin 
            reg_adjust_gain <= reg_adjust_gain;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_adjust_offset <= 32'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_3108) begin
            reg_adjust_offset <= reg_wdata_sync[31:0];
        end else begin 
            reg_adjust_offset <= reg_adjust_offset;
        end
    end

    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_num_check_clr <= 1'h0;
        end else if (reg_req_r == 1'b1 && reg_whrl_sync == 1'b1 && reg_addr_sync == 32'h0000_7000) begin
            reg_num_check_clr <= reg_wdata_sync[0:0];
        end else if (wc_clr_flag[0] == 1'b1) begin 
            reg_num_check_clr <= 'd0;
        end else begin 
            reg_num_check_clr <= reg_num_check_clr;
        end 
    end

    //register reg_io_in_0_num is Read only type

    //register reg_io_in_1_num is Read only type

    //register reg_encoder_a_num is Read only type

    //register reg_encoder_b_num is Read only type

    //register reg_io_out_num is Read only type

    //register reg_mos_req_num is Read only type

    //register reg_mos_ack_num is Read only type

    //register reg_dds_req_num is Read only type

    //register reg_dds_ack_num is Read only type

    //register reg_dac_req_num is Read only type

    //register reg_dac_ack_num is Read only type

    //register reg_sw_req_num is Read only type

    //register reg_sw_ack_num is Read only type

    //register reg_reg_req_num is Read only type

    //register reg_reg_ack_num is Read only type

    //register reg_sum_err_num is Read only type

    //register reg_trigger_in_num is Read only type

    //register reg_lps is Read only type

    //register reg_core_status is Read only type

// Register write logic end----------------------------------------

// Register read logic start---------------------------------------


    always @ (posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            reg_rdata_pre <= 32'd0;
        end else if (reg_req_r == 1'b1) begin
            case (reg_addr_sync)
                32'h0000_0000	 : reg_rdata_pre	 <= `COMPANY;
                32'h0000_0004	 : reg_rdata_pre	 <= `DEVICE;
                32'h0000_0008	 : reg_rdata_pre	 <= `DEVICE_SUB;
                32'h0000_000C	 : reg_rdata_pre	 <= `PROPERTY;
                32'h0000_0010	 : reg_rdata_pre	 <= `YEAR_MOUTH_DATE;
                32'h0000_0014	 : reg_rdata_pre	 <= `HOUR_MINUTE;
                32'h0000_0018	 : reg_rdata_pre	 <= `REV;
                32'h0000_001C	 : reg_rdata_pre	 <= reg_soft_reset;
                32'h0000_0020	 : reg_rdata_pre	 <= reg_test;
                32'h0000_0024	 : reg_rdata_pre	 <= reg_device_temp;
                32'h0000_1100	 : reg_rdata_pre	 <= reg_mos_ack_time;
                32'h0000_1104	 : reg_rdata_pre	 <= reg_dds_ack_time;
                32'h0000_1108	 : reg_rdata_pre	 <= reg_dac_ack_time;
                32'h0000_110C	 : reg_rdata_pre	 <= reg_sw_ack_time;
                32'h0000_1110	 : reg_rdata_pre	 <= reg_mos_en;
                32'h0000_1200	 : reg_rdata_pre	 <= reg_mainboard_temp;
                32'h0000_1400	 : reg_rdata_pre	 <= reg_laser_status;
                32'h0000_1600	 : reg_rdata_pre	 <= reg_soft_trigger_cycle;
                32'h0000_1604	 : reg_rdata_pre	 <= reg_soft_trigger_num;
                32'h0000_1608	 : reg_rdata_pre	 <= reg_soft_trigger_en;
                32'h0000_160C	 : reg_rdata_pre	 <= reg_trigger_cycle ;
                32'h0000_1610	 : reg_rdata_pre	 <= reg_trigger_num;
                32'h0000_1614	 : reg_rdata_pre	 <= reg_trigger_mode;
                32'h0000_1618	 : reg_rdata_pre	 <= reg_trigger_width;
                32'h0000_161C	 : reg_rdata_pre	 <= reg_trigger_delay;
                32'h0000_1620	 : reg_rdata_pre	 <= reg_trigger_pulse;
                32'h0000_1624	 : reg_rdata_pre	 <= reg_trigger_polar;
                32'h0000_1628	 : reg_rdata_pre	 <= reg_trigger_en;
                32'h0000_162C	 : reg_rdata_pre	 <= reg_encoder_phase;
                32'h0000_1630	 : reg_rdata_pre	 <= reg_encoder_cnt_mode;
                32'h0000_1634	 : reg_rdata_pre	 <= reg_encoder_dis_mode;
                32'h0000_1638	 : reg_rdata_pre	 <= reg_encoder_ignore;
                32'h0000_163C	 : reg_rdata_pre	 <= reg_encoder_div;
                32'h0000_1640	 : reg_rdata_pre	 <= reg_encoder_width;
                32'h0000_1644	 : reg_rdata_pre	 <= reg_encoder_location;
                32'h0000_1648	 : reg_rdata_pre	 <= reg_encoder_multi_en;
                32'h0000_164C	 : reg_rdata_pre	 <= reg_encoder_multi_coe;
                32'h0000_1650	 : reg_rdata_pre	 <= reg_encoder_a_cnt;
                32'h0000_1654	 : reg_rdata_pre	 <= reg_encoder_b_cnt;
                32'h0000_1658	 : reg_rdata_pre	 <= reg_encoder_clr;
                32'h0000_165C	 : reg_rdata_pre	 <= reg_encoder_en;
                32'h0000_1660	 : reg_rdata_pre	 <= reg_slave_device;
                32'h0000_1664	 : reg_rdata_pre	 <= reg_status_cnt_clr;
                32'h0000_1680	 : reg_rdata_pre	 <= reg_l1_soft_trigger_cycle;
                32'h0000_1684	 : reg_rdata_pre	 <= reg_l1_soft_trigger_num;
                32'h0000_1688	 : reg_rdata_pre	 <= reg_l1_soft_trigger_en;
                32'h0000_168C	 : reg_rdata_pre	 <= reg_l1_trigger_cycle ;
                32'h0000_1690	 : reg_rdata_pre	 <= reg_l1_trigger_num;
                32'h0000_1694	 : reg_rdata_pre	 <= reg_l1_trigger_mode;
                32'h0000_1698	 : reg_rdata_pre	 <= reg_l1_trigger_width;
                32'h0000_169C	 : reg_rdata_pre	 <= reg_l1_trigger_delay;
                32'h0000_16A0	 : reg_rdata_pre	 <= reg_l1_trigger_pulse;
                32'h0000_16A4	 : reg_rdata_pre	 <= reg_l1_trigger_polar;
                32'h0000_16A8	 : reg_rdata_pre	 <= reg_l1_trigger_en;
                32'h0000_16AC	 : reg_rdata_pre	 <= reg_l1_encoder_phase;
                32'h0000_16B0	 : reg_rdata_pre	 <= reg_l1_encoder_cnt_mode;
                32'h0000_16B4	 : reg_rdata_pre	 <= reg_l1_encoder_dis_mode;
                32'h0000_16B8	 : reg_rdata_pre	 <= reg_l1_encoder_ignore;
                32'h0000_16BC	 : reg_rdata_pre	 <= reg_l1_encoder_div;
                32'h0000_16C0	 : reg_rdata_pre	 <= reg_l1_encoder_width;
                32'h0000_16C4	 : reg_rdata_pre	 <= reg_l1_encoder_location;
                32'h0000_16C8	 : reg_rdata_pre	 <= reg_l1_encoder_multi_en;
                32'h0000_16CC	 : reg_rdata_pre	 <= reg_l1_encoder_multi_coe;
                32'h0000_16D0	 : reg_rdata_pre	 <= reg_l1_encoder_a_cnt;
                32'h0000_16D4	 : reg_rdata_pre	 <= reg_l1_encoder_b_cnt;
                32'h0000_16D8	 : reg_rdata_pre	 <= reg_l1_encoder_clr;
                32'h0000_16DC	 : reg_rdata_pre	 <= reg_l1_encoder_en;
                32'h0000_16E0	 : reg_rdata_pre	 <= reg_l1_status_cnt_clr;
                32'h0000_16FC	 : reg_rdata_pre	 <= reg_trigger_level;
                32'h0000_1700	 : reg_rdata_pre	 <= reg_exp_chan;
                32'h0000_1704	 : reg_rdata_pre	 <= reg_exposure_time;
                32'h0000_1708	 : reg_rdata_pre	 <= reg_led_cnt_max;
                32'h0000_170C	 : reg_rdata_pre	 <= reg_trigger_multi_en;
                32'h0000_1710	 : reg_rdata_pre	 <= reg_led_polar;
                32'h0000_1714	 : reg_rdata_pre	 <= reg_led_pwm_start_0;
                32'h0000_1718	 : reg_rdata_pre	 <= reg_led_pwm_end_0;
                32'h0000_171C	 : reg_rdata_pre	 <= reg_led_pwm_start_1;
                32'h0000_1720	 : reg_rdata_pre	 <= reg_led_pwm_end_1;
                32'h0000_1724	 : reg_rdata_pre	 <= reg_led_pwm_start_2;
                32'h0000_1728	 : reg_rdata_pre	 <= reg_led_pwm_end_2;
                32'h0000_172C	 : reg_rdata_pre	 <= reg_led_pwm_start_3;
                32'h0000_1730	 : reg_rdata_pre	 <= reg_led_pwm_end_3;
                32'h0000_1734	 : reg_rdata_pre	 <= reg_led_pwm_start_4;
                32'h0000_1738	 : reg_rdata_pre	 <= reg_led_pwm_end_4;
                32'h0000_173C	 : reg_rdata_pre	 <= reg_led_pwm_start_5;
                32'h0000_1740	 : reg_rdata_pre	 <= reg_led_pwm_end_5;
                32'h0000_1744	 : reg_rdata_pre	 <= reg_led_pwm_start_6;
                32'h0000_1748	 : reg_rdata_pre	 <= reg_led_pwm_end_6;
                32'h0000_174C	 : reg_rdata_pre	 <= reg_led_pwm_start_7;
                32'h0000_1750	 : reg_rdata_pre	 <= reg_led_pwm_end_7;
                32'h0000_1754	 : reg_rdata_pre	 <= reg_led_pwm_start_8;
                32'h0000_1758	 : reg_rdata_pre	 <= reg_led_pwm_end_8;
                32'h0000_175C	 : reg_rdata_pre	 <= reg_led_pwm_start_9;
                32'h0000_1760	 : reg_rdata_pre	 <= reg_led_pwm_end_9;
                32'h0000_1764	 : reg_rdata_pre	 <= reg_led_pwm_start_10;
                32'h0000_1768	 : reg_rdata_pre	 <= reg_led_pwm_end_10;
                32'h0000_176C	 : reg_rdata_pre	 <= reg_led_pwm_start_11;
                32'h0000_1770	 : reg_rdata_pre	 <= reg_led_pwm_end_11;
                32'h0000_1774	 : reg_rdata_pre	 <= reg_trig_start_0;
                32'h0000_1778	 : reg_rdata_pre	 <= reg_trig_end_0;
                32'h0000_177C	 : reg_rdata_pre	 <= reg_trig_start_1;
                32'h0000_1780	 : reg_rdata_pre	 <= reg_trig_end_1;
                32'h0000_1784	 : reg_rdata_pre	 <= reg_trig_start_2;
                32'h0000_1788	 : reg_rdata_pre	 <= reg_trig_end_2;
                32'h0000_178C	 : reg_rdata_pre	 <= reg_trig_start_3;
                32'h0000_1790	 : reg_rdata_pre	 <= reg_trig_end_3;
                32'h0000_1794	 : reg_rdata_pre	 <= reg_trig_start_4;
                32'h0000_1798	 : reg_rdata_pre	 <= reg_trig_end_4;
                32'h0000_179C	 : reg_rdata_pre	 <= reg_trig_start_5;
                32'h0000_17A0	 : reg_rdata_pre	 <= reg_trig_end_5;
                32'h0000_17A4	 : reg_rdata_pre	 <= reg_trig_out_polar;
                32'h0000_1800	 : reg_rdata_pre	 <= reg_external_trig_num;
                32'h0000_1804	 : reg_rdata_pre	 <= reg_external_trig_polar;
                32'h0000_1808	 : reg_rdata_pre	 <= reg_external_trig_delay;
                32'h0000_180C	 : reg_rdata_pre	 <= reg_external_trig_width;
                32'h0000_1810	 : reg_rdata_pre	 <= reg_external_trig_enable;
                32'h0000_1814	 : reg_rdata_pre	 <= reg_camera_trig_num;
                32'h0000_2000	 : reg_rdata_pre	 <= reg_dds_phase;
                32'h0000_2004	 : reg_rdata_pre	 <= reg_dds_inc;
                32'h0000_2008	 : reg_rdata_pre	 <= reg_exp_cycle;
                32'h0000_200C	 : reg_rdata_pre	 <= reg_trigger_gap;
                32'h0000_2010	 : reg_rdata_pre	 <= reg_pic_num;
                32'h0000_2014	 : reg_rdata_pre	 <= reg_sw_status;
                32'h0000_2018	 : reg_rdata_pre	 <= reg_sw_shift;
                32'h0000_201C	 : reg_rdata_pre	 <= reg_sw_loop_gap;
                32'h0000_2020	 : reg_rdata_pre	 <= reg_sw_loop_num;
                32'h0000_2024	 : reg_rdata_pre	 <= reg_dds_phase_offset;
                32'h0000_2028	 : reg_rdata_pre	 <= reg_dds_direction_x;
                32'h0000_202C	 : reg_rdata_pre	 <= reg_dds_direction_y;
                32'h0000_2030	 : reg_rdata_pre	 <= reg_current_offset;
                32'h0000_2034	 : reg_rdata_pre	 <= reg_dac_value_forward;
                32'h0000_2038	 : reg_rdata_pre	 <= reg_dac_value_backward;
                32'h0000_203C	 : reg_rdata_pre	 <= reg_sw_wait;
                32'h0000_2040	 : reg_rdata_pre	 <= reg_camera_delay;
                32'h0000_2044	 : reg_rdata_pre	 <= reg_camera_cycle;
                32'h0000_2048	 : reg_rdata_pre	 <= reg_dac_req;
                32'h0000_2070	 : reg_rdata_pre	 <= reg_dds_phase_y;
                32'h0000_2100	 : reg_rdata_pre	 <= reg_dac_value_x0;
                32'h0000_2104	 : reg_rdata_pre	 <= reg_sw_value_x0;
                32'h0000_2108	 : reg_rdata_pre	 <= reg_mos_value_x0;
                32'h0000_210C	 : reg_rdata_pre	 <= reg_trigger_req_x0;
                32'h0000_2110	 : reg_rdata_pre	 <= reg_dac_value_x1;
                32'h0000_2114	 : reg_rdata_pre	 <= reg_sw_value_x1;
                32'h0000_2118	 : reg_rdata_pre	 <= reg_mos_value_x1;
                32'h0000_211C	 : reg_rdata_pre	 <= reg_trigger_req_x1;
                32'h0000_2120	 : reg_rdata_pre	 <= reg_dac_value_x2;
                32'h0000_2124	 : reg_rdata_pre	 <= reg_sw_value_x2;
                32'h0000_2128	 : reg_rdata_pre	 <= reg_mos_value_x2;
                32'h0000_212C	 : reg_rdata_pre	 <= reg_trigger_req_x2;
                32'h0000_2130	 : reg_rdata_pre	 <= reg_dac_value_x3;
                32'h0000_2134	 : reg_rdata_pre	 <= reg_sw_value_x3;
                32'h0000_2138	 : reg_rdata_pre	 <= reg_mos_value_x3;
                32'h0000_213C	 : reg_rdata_pre	 <= reg_trigger_req_x3;
                32'h0000_2140	 : reg_rdata_pre	 <= reg_dac_value_y0;
                32'h0000_2144	 : reg_rdata_pre	 <= reg_sw_value_y0;
                32'h0000_2148	 : reg_rdata_pre	 <= reg_mos_value_y0;
                32'h0000_214C	 : reg_rdata_pre	 <= reg_trigger_req_y0;
                32'h0000_2150	 : reg_rdata_pre	 <= reg_dac_value_y1;
                32'h0000_2154	 : reg_rdata_pre	 <= reg_sw_value_y1;
                32'h0000_2158	 : reg_rdata_pre	 <= reg_mos_value_y1;
                32'h0000_215C	 : reg_rdata_pre	 <= reg_trigger_req_y1;
                32'h0000_2160	 : reg_rdata_pre	 <= reg_dac_value_y2;
                32'h0000_2164	 : reg_rdata_pre	 <= reg_sw_value_y2;
                32'h0000_2168	 : reg_rdata_pre	 <= reg_mos_value_y2;
                32'h0000_216C	 : reg_rdata_pre	 <= reg_trigger_req_y2;
                32'h0000_2170	 : reg_rdata_pre	 <= reg_dac_value_y3;
                32'h0000_2174	 : reg_rdata_pre	 <= reg_sw_value_y3;
                32'h0000_2178	 : reg_rdata_pre	 <= reg_mos_value_y3;
                32'h0000_217C	 : reg_rdata_pre	 <= reg_trigger_req_y3;
                32'h0000_2200	 : reg_rdata_pre	 <= reg_core_en;
                32'h0000_2204	 : reg_rdata_pre	 <= reg_core_mode;
                32'h0000_2300	 : reg_rdata_pre	 <= reg_step_en;
                32'h0000_2304	 : reg_rdata_pre	 <= reg_step_pic_num;
                32'h0000_2308	 : reg_rdata_pre	 <= reg_step_x_seq;
                32'h0000_230C	 : reg_rdata_pre	 <= reg_step_y_seq;
                32'h0000_2400	 : reg_rdata_pre	 <= reg_step_phase_0;
                32'h0000_2404	 : reg_rdata_pre	 <= reg_step_phase_1;
                32'h0000_2408	 : reg_rdata_pre	 <= reg_step_phase_2;
                32'h0000_240C	 : reg_rdata_pre	 <= reg_step_phase_3;
                32'h0000_2410	 : reg_rdata_pre	 <= reg_step_phase_4;
                32'h0000_2414	 : reg_rdata_pre	 <= reg_step_phase_5;
                32'h0000_2418	 : reg_rdata_pre	 <= reg_step_phase_6;
                32'h0000_241C	 : reg_rdata_pre	 <= reg_step_phase_7;
                32'h0000_2420	 : reg_rdata_pre	 <= reg_step_phase_8;
                32'h0000_2424	 : reg_rdata_pre	 <= reg_step_phase_9;
                32'h0000_2428	 : reg_rdata_pre	 <= reg_step_phase_10;
                32'h0000_242C	 : reg_rdata_pre	 <= reg_step_phase_11;
                32'h0000_2430	 : reg_rdata_pre	 <= reg_step_phase_12;
                32'h0000_2434	 : reg_rdata_pre	 <= reg_step_phase_13;
                32'h0000_2438	 : reg_rdata_pre	 <= reg_step_phase_14;
                32'h0000_243C	 : reg_rdata_pre	 <= reg_step_phase_15;
                32'h0000_2440	 : reg_rdata_pre	 <= reg_step_phase_16;
                32'h0000_2444	 : reg_rdata_pre	 <= reg_step_phase_17;
                32'h0000_2448	 : reg_rdata_pre	 <= reg_step_phase_18;
                32'h0000_244C	 : reg_rdata_pre	 <= reg_step_phase_19;
                32'h0000_2450	 : reg_rdata_pre	 <= reg_step_phase_20;
                32'h0000_2454	 : reg_rdata_pre	 <= reg_step_phase_21;
                32'h0000_2458	 : reg_rdata_pre	 <= reg_step_phase_22;
                32'h0000_245C	 : reg_rdata_pre	 <= reg_step_phase_23;
                32'h0000_2460	 : reg_rdata_pre	 <= reg_step_phase_24;
                32'h0000_2464	 : reg_rdata_pre	 <= reg_step_phase_25;
                32'h0000_2468	 : reg_rdata_pre	 <= reg_step_phase_26;
                32'h0000_246C	 : reg_rdata_pre	 <= reg_step_phase_27;
                32'h0000_2470	 : reg_rdata_pre	 <= reg_step_phase_28;
                32'h0000_2474	 : reg_rdata_pre	 <= reg_step_phase_29;
                32'h0000_2478	 : reg_rdata_pre	 <= reg_step_phase_30;
                32'h0000_247C	 : reg_rdata_pre	 <= reg_step_phase_31;
                32'h0000_2480	 : reg_rdata_pre	 <= reg_step_inc_0;
                32'h0000_2484	 : reg_rdata_pre	 <= reg_step_inc_1;
                32'h0000_2488	 : reg_rdata_pre	 <= reg_step_inc_2;
                32'h0000_248C	 : reg_rdata_pre	 <= reg_step_inc_3;
                32'h0000_2490	 : reg_rdata_pre	 <= reg_step_inc_4;
                32'h0000_2494	 : reg_rdata_pre	 <= reg_step_inc_5;
                32'h0000_2498	 : reg_rdata_pre	 <= reg_step_inc_6;
                32'h0000_249C	 : reg_rdata_pre	 <= reg_step_inc_7;
                32'h0000_24A0	 : reg_rdata_pre	 <= reg_step_inc_8;
                32'h0000_24A4	 : reg_rdata_pre	 <= reg_step_inc_9;
                32'h0000_24A8	 : reg_rdata_pre	 <= reg_step_inc_10;
                32'h0000_24AC	 : reg_rdata_pre	 <= reg_step_inc_11;
                32'h0000_24B0	 : reg_rdata_pre	 <= reg_step_inc_12;
                32'h0000_24B4	 : reg_rdata_pre	 <= reg_step_inc_13;
                32'h0000_24B8	 : reg_rdata_pre	 <= reg_step_inc_14;
                32'h0000_24BC	 : reg_rdata_pre	 <= reg_step_inc_15;
                32'h0000_24C0	 : reg_rdata_pre	 <= reg_step_inc_16;
                32'h0000_24C4	 : reg_rdata_pre	 <= reg_step_inc_17;
                32'h0000_24C8	 : reg_rdata_pre	 <= reg_step_inc_18;
                32'h0000_24CC	 : reg_rdata_pre	 <= reg_step_inc_19;
                32'h0000_24D0	 : reg_rdata_pre	 <= reg_step_inc_20;
                32'h0000_24D4	 : reg_rdata_pre	 <= reg_step_inc_21;
                32'h0000_24D8	 : reg_rdata_pre	 <= reg_step_inc_22;
                32'h0000_24DC	 : reg_rdata_pre	 <= reg_step_inc_23;
                32'h0000_24E0	 : reg_rdata_pre	 <= reg_step_inc_24;
                32'h0000_24E4	 : reg_rdata_pre	 <= reg_step_inc_25;
                32'h0000_24E8	 : reg_rdata_pre	 <= reg_step_inc_26;
                32'h0000_24EC	 : reg_rdata_pre	 <= reg_step_inc_27;
                32'h0000_24F0	 : reg_rdata_pre	 <= reg_step_inc_28;
                32'h0000_24F4	 : reg_rdata_pre	 <= reg_step_inc_29;
                32'h0000_24F8	 : reg_rdata_pre	 <= reg_step_inc_30;
                32'h0000_24FC	 : reg_rdata_pre	 <= reg_step_inc_31;
                32'h0000_2500	 : reg_rdata_pre	 <= reg_step_base_0;
                32'h0000_2504	 : reg_rdata_pre	 <= reg_step_base_1;
                32'h0000_2508	 : reg_rdata_pre	 <= reg_step_base_2;
                32'h0000_250C	 : reg_rdata_pre	 <= reg_step_base_3;
                32'h0000_2510	 : reg_rdata_pre	 <= reg_step_base_4;
                32'h0000_2514	 : reg_rdata_pre	 <= reg_step_base_5;
                32'h0000_2518	 : reg_rdata_pre	 <= reg_step_base_6;
                32'h0000_251C	 : reg_rdata_pre	 <= reg_step_base_7;
                32'h0000_2520	 : reg_rdata_pre	 <= reg_step_base_8;
                32'h0000_2524	 : reg_rdata_pre	 <= reg_step_base_9;
                32'h0000_2528	 : reg_rdata_pre	 <= reg_step_base_10;
                32'h0000_252C	 : reg_rdata_pre	 <= reg_step_base_11;
                32'h0000_2530	 : reg_rdata_pre	 <= reg_step_base_12;
                32'h0000_2534	 : reg_rdata_pre	 <= reg_step_base_13;
                32'h0000_2538	 : reg_rdata_pre	 <= reg_step_base_14;
                32'h0000_253C	 : reg_rdata_pre	 <= reg_step_base_15;
                32'h0000_2540	 : reg_rdata_pre	 <= reg_step_base_16;
                32'h0000_2544	 : reg_rdata_pre	 <= reg_step_base_17;
                32'h0000_2548	 : reg_rdata_pre	 <= reg_step_base_18;
                32'h0000_254C	 : reg_rdata_pre	 <= reg_step_base_19;
                32'h0000_2550	 : reg_rdata_pre	 <= reg_step_base_20;
                32'h0000_2554	 : reg_rdata_pre	 <= reg_step_base_21;
                32'h0000_2558	 : reg_rdata_pre	 <= reg_step_base_22;
                32'h0000_255C	 : reg_rdata_pre	 <= reg_step_base_23;
                32'h0000_2560	 : reg_rdata_pre	 <= reg_step_base_24;
                32'h0000_2564	 : reg_rdata_pre	 <= reg_step_base_25;
                32'h0000_2568	 : reg_rdata_pre	 <= reg_step_base_26;
                32'h0000_256C	 : reg_rdata_pre	 <= reg_step_base_27;
                32'h0000_2570	 : reg_rdata_pre	 <= reg_step_base_28;
                32'h0000_2574	 : reg_rdata_pre	 <= reg_step_base_29;
                32'h0000_2578	 : reg_rdata_pre	 <= reg_step_base_30;
                32'h0000_257C	 : reg_rdata_pre	 <= reg_step_base_31;
                32'h0000_3000	 : reg_rdata_pre	 <= reg_ram_cfg_en;
                32'h0000_3004	 : reg_rdata_pre	 <= reg_ram_whrl;
                32'h0000_3008	 : reg_rdata_pre	 <= reg_ram_addr;
                32'h0000_300C	 : reg_rdata_pre	 <= reg_ram_wdata;
                32'h0000_3010	 : reg_rdata_pre	 <= reg_ram_rdata;
                32'h0000_3014	 : reg_rdata_pre	 <= reg_ram_req;
                32'h0000_3018	 : reg_rdata_pre	 <= reg_ram_done;
                32'h0000_301C	 : reg_rdata_pre	 <= reg_wave_start_addr;
                32'h0000_3020	 : reg_rdata_pre	 <= reg_wave_end_addr;
                32'h0000_3100	 : reg_rdata_pre	 <= reg_adjust_en;
                32'h0000_3104	 : reg_rdata_pre	 <= reg_adjust_gain;
                32'h0000_3108	 : reg_rdata_pre	 <= reg_adjust_offset;
                32'h0000_7000	 : reg_rdata_pre	 <= reg_num_check_clr;
                32'h0000_7004	 : reg_rdata_pre	 <= reg_io_in_0_num;
                32'h0000_7008	 : reg_rdata_pre	 <= reg_io_in_1_num;
                32'h0000_700C	 : reg_rdata_pre	 <= reg_encoder_a_num;
                32'h0000_7010	 : reg_rdata_pre	 <= reg_encoder_b_num;
                32'h0000_7014	 : reg_rdata_pre	 <= reg_io_out_num;
                32'h0000_7018	 : reg_rdata_pre	 <= reg_mos_req_num;
                32'h0000_701C	 : reg_rdata_pre	 <= reg_mos_ack_num;
                32'h0000_7020	 : reg_rdata_pre	 <= reg_dds_req_num;
                32'h0000_7024	 : reg_rdata_pre	 <= reg_dds_ack_num;
                32'h0000_7028	 : reg_rdata_pre	 <= reg_dac_req_num;
                32'h0000_702C	 : reg_rdata_pre	 <= reg_dac_ack_num;
                32'h0000_7030	 : reg_rdata_pre	 <= reg_sw_req_num;
                32'h0000_7034	 : reg_rdata_pre	 <= reg_sw_ack_num;
                32'h0000_7038	 : reg_rdata_pre	 <= reg_reg_req_num;
                32'h0000_703C	 : reg_rdata_pre	 <= reg_reg_ack_num;
                32'h0000_7040	 : reg_rdata_pre	 <= reg_sum_err_num;
                32'h0000_7044	 : reg_rdata_pre	 <= reg_trigger_in_num;
                32'h0000_7048	 : reg_rdata_pre	 <= reg_lps;
                32'h0000_7100	 : reg_rdata_pre	 <= reg_core_status;
                default          : reg_rdata_pre     <= 32'h0;
            endcase
        end else begin
            reg_rdata_pre <= reg_rdata_pre;
        end
    end

// Register read logic end-----------------------------------------


endmodule