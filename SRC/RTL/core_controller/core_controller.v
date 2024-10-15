/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-17  19:22:56
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-01-26 09:49:03
#FilePath     : core_controller.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/


module core_controller #(

    parameter BANK_NUM          = 8'd8,
    parameter SW_NUM            = 8'd12
)(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Reg_fpga
    input wire [9:0]            reg_dds_phase           ,
    input wire [9:0]            reg_dds_inc             ,
    input wire [31:0]           reg_exp_cycle           ,
    input wire [31:0]           reg_trigger_gap         ,
    input wire [31:0]           reg_pic_num             ,
    input wire [11:0]           reg_sw_status           ,
    input wire [7:0]            reg_sw_shift            ,
    input wire [31:0]           reg_sw_loop_gap         ,
    input wire [31:0]           reg_sw_loop_num         ,
    input wire [9:0]            reg_dds_phase_offset    ,
    input wire 			        reg_dds_direction_x 	,
    input wire 			        reg_dds_direction_y 	,
    input wire [13:0]           reg_dac_value_forward   ,
    input wire [13:0]           reg_dac_value_backward  ,
    input wire [31:0]           reg_sw_wait             ,
    input wire                  reg_dac_req             ,

    input wire [9:0]            reg_dds_phase_y         ,

    input wire [13:0]           reg_dac_value_x0        ,
    input wire [11:0]           reg_sw_value_x0         ,
    input wire                  reg_mos_value_x0        ,
    input wire                  reg_trigger_req_x0      ,

    input wire [13:0]           reg_dac_value_x1        ,
    input wire [11:0]           reg_sw_value_x1         ,
    input wire                  reg_mos_value_x1        ,
    input wire                  reg_trigger_req_x1      ,

    input wire [13:0]           reg_dac_value_x2        ,
    input wire [11:0]           reg_sw_value_x2         ,
    input wire                  reg_mos_value_x2        ,
    input wire                  reg_trigger_req_x2      ,

    input wire [13:0]           reg_dac_value_x3        ,
    input wire [11:0]           reg_sw_value_x3         ,
    input wire                  reg_mos_value_x3        ,
    input wire                  reg_trigger_req_x3      ,

    input wire [13:0]           reg_dac_value_y0        ,
    input wire [11:0]           reg_sw_value_y0         ,
    input wire                  reg_mos_value_y0        ,
    input wire                  reg_trigger_req_y0      ,

    input wire [13:0]           reg_dac_value_y1        ,
    input wire [11:0]           reg_sw_value_y1         ,
    input wire                  reg_mos_value_y1        ,
    input wire                  reg_trigger_req_y1      ,

    input wire [13:0]           reg_dac_value_y2        ,
    input wire [11:0]           reg_sw_value_y2         ,
    input wire                  reg_mos_value_y2        ,
    input wire                  reg_trigger_req_y2      ,

    input wire [13:0]           reg_dac_value_y3        ,
    input wire [11:0]           reg_sw_value_y3         ,
    input wire                  reg_mos_value_y3        ,
    input wire                  reg_trigger_req_y3      ,

    input wire [3:0]            reg_core_mode           ,
    input wire                  reg_core_en             ,
    output wire [15:0]          reg_core_status         ,

        // Step
    input wire                  reg_step_en             ,
    input wire [31:0]           reg_step_pic_num        ,
    input wire [31:0]           reg_step_x_seq          ,
    input wire [31:0]           reg_step_y_seq          ,
        // Step cfg
    input wire [9:0]            reg_step_phase_0        ,
    input wire [9:0]            reg_step_phase_1        ,
    input wire [9:0]            reg_step_phase_2        ,
    input wire [9:0]            reg_step_phase_3        ,
    input wire [9:0]            reg_step_phase_4        ,
    input wire [9:0]            reg_step_phase_5        ,
    input wire [9:0]            reg_step_phase_6        ,
    input wire [9:0]            reg_step_phase_7        ,
    input wire [9:0]            reg_step_phase_8        ,
    input wire [9:0]            reg_step_phase_9        ,
    input wire [9:0]            reg_step_phase_10       ,
    input wire [9:0]            reg_step_phase_11       ,
    input wire [9:0]            reg_step_phase_12       ,
    input wire [9:0]            reg_step_phase_13       ,
    input wire [9:0]            reg_step_phase_14       ,
    input wire [9:0]            reg_step_phase_15       ,
    input wire [9:0]            reg_step_phase_16       ,
    input wire [9:0]            reg_step_phase_17       ,
    input wire [9:0]            reg_step_phase_18       ,
    input wire [9:0]            reg_step_phase_19       ,
    input wire [9:0]            reg_step_phase_20       ,
    input wire [9:0]            reg_step_phase_21       ,
    input wire [9:0]            reg_step_phase_22       ,
    input wire [9:0]            reg_step_phase_23       ,
    input wire [9:0]            reg_step_phase_24       ,
    input wire [9:0]            reg_step_phase_25       ,
    input wire [9:0]            reg_step_phase_26       ,
    input wire [9:0]            reg_step_phase_27       ,
    input wire [9:0]            reg_step_phase_28       ,
    input wire [9:0]            reg_step_phase_29       ,
    input wire [9:0]            reg_step_phase_30       ,
    input wire [9:0]            reg_step_phase_31       ,

    input wire [9:0]            reg_step_inc_0          ,
    input wire [9:0]            reg_step_inc_1          ,
    input wire [9:0]            reg_step_inc_2          ,
    input wire [9:0]            reg_step_inc_3          ,
    input wire [9:0]            reg_step_inc_4          ,
    input wire [9:0]            reg_step_inc_5          ,
    input wire [9:0]            reg_step_inc_6          ,
    input wire [9:0]            reg_step_inc_7          ,
    input wire [9:0]            reg_step_inc_8          ,
    input wire [9:0]            reg_step_inc_9          ,
    input wire [9:0]            reg_step_inc_10         ,
    input wire [9:0]            reg_step_inc_11         ,
    input wire [9:0]            reg_step_inc_12         ,
    input wire [9:0]            reg_step_inc_13         ,
    input wire [9:0]            reg_step_inc_14         ,
    input wire [9:0]            reg_step_inc_15         ,
    input wire [9:0]            reg_step_inc_16         ,
    input wire [9:0]            reg_step_inc_17         ,
    input wire [9:0]            reg_step_inc_18         ,
    input wire [9:0]            reg_step_inc_19         ,
    input wire [9:0]            reg_step_inc_20         ,
    input wire [9:0]            reg_step_inc_21         ,
    input wire [9:0]            reg_step_inc_22         ,
    input wire [9:0]            reg_step_inc_23         ,
    input wire [9:0]            reg_step_inc_24         ,
    input wire [9:0]            reg_step_inc_25         ,
    input wire [9:0]            reg_step_inc_26         ,
    input wire [9:0]            reg_step_inc_27         ,
    input wire [9:0]            reg_step_inc_28         ,
    input wire [9:0]            reg_step_inc_29         ,
    input wire [9:0]            reg_step_inc_30         ,
    input wire [9:0]            reg_step_inc_31         ,

    input wire [9:0]            reg_step_base_0         ,
    input wire [9:0]            reg_step_base_1         ,
    input wire [9:0]            reg_step_base_2         ,
    input wire [9:0]            reg_step_base_3         ,
    input wire [9:0]            reg_step_base_4         ,
    input wire [9:0]            reg_step_base_5         ,
    input wire [9:0]            reg_step_base_6         ,
    input wire [9:0]            reg_step_base_7         ,
    input wire [9:0]            reg_step_base_8         ,
    input wire [9:0]            reg_step_base_9         ,
    input wire [9:0]            reg_step_base_10        ,
    input wire [9:0]            reg_step_base_11        ,
    input wire [9:0]            reg_step_base_12        ,
    input wire [9:0]            reg_step_base_13        ,
    input wire [9:0]            reg_step_base_14        ,
    input wire [9:0]            reg_step_base_15        ,
    input wire [9:0]            reg_step_base_16        ,
    input wire [9:0]            reg_step_base_17        ,
    input wire [9:0]            reg_step_base_18        ,
    input wire [9:0]            reg_step_base_19        ,
    input wire [9:0]            reg_step_base_20        ,
    input wire [9:0]            reg_step_base_21        ,
    input wire [9:0]            reg_step_base_22        ,
    input wire [9:0]            reg_step_base_23        ,
    input wire [9:0]            reg_step_base_24        ,
    input wire [9:0]            reg_step_base_25        ,
    input wire [9:0]            reg_step_base_26        ,
    input wire [9:0]            reg_step_base_27        ,
    input wire [9:0]            reg_step_base_28        ,
    input wire [9:0]            reg_step_base_29        ,
    input wire [9:0]            reg_step_base_30        ,
    input wire [9:0]            reg_step_base_31        ,

    // cmd intf
    input wire                  trigger_in              ,
    output wire                 sensor_trigger_req      ,
    output wire                 trigger_in_en           ,
    output reg                  trigger_miss_flag       ,

    output wire                 mos_val                 ,
    output wire                 mos_req                 ,
    input wire                  mos_ack                 ,

    output wire                 dds_refresh             ,
    output wire [9:0]           dds_addr                ,
    output wire                 dds_req                 ,
    input wire                  dds_ack                 ,
    // input wire [167:0]          dds_time_forward        ,
    // input wire [167:0]          dds_time_backward       ,
    input wire [9:0]            reg_wave_start_addr     ,
    input wire [9:0]            reg_wave_end_addr       ,
    output wire [9:0]           step_inc                ,
    output wire [9:0]           dds_addr_base           ,

    output wire [BANK_NUM*14-1 : 0] dac_val             ,
    output wire [BANK_NUM-1 : 0]dac_req                 ,
    input wire                  dac_ack                 ,

    output wire [BANK_NUM*SW_NUM-1 : 0]sw_val           ,
    output wire [1:0]           sw_req                  ,
    input wire                  sw_ack
);




    localparam S_IDLE           = 8'd0;
    localparam S_DAC_SET        = 8'd1;
    localparam S_WAIT           = 8'd2;
    localparam S_MOS_SET        = 8'd3;
    localparam S_TRIG           = 8'd4;
    localparam S_DDS_GET        = 8'd5;
    localparam S_SW_SET         = 8'd6;
    localparam S_SW_LOOP        = 8'd7;
    localparam S_EXP_LOOP       = 8'd8;
    localparam S_PIC_LOOP       = 8'd9;
    localparam S_MOS_RESET      = 8'd10;




    // localparam S_IDLE           = 8'd0;
    // localparam S_MOS_SET        = 8'd1;
    // localparam S_TRIG           = 8'd2;
    // localparam S_DDS_GET        = 8'd3;
    // localparam S_DAC_SET        = 8'd4;
    // localparam S_SW_SET         = 8'd5;
    // localparam S_SW_LOOP        = 8'd6;
    // localparam S_EXP_LOOP       = 8'd7;
    // localparam S_PIC_LOOP       = 8'd8;
    // localparam S_MOS_RESET      = 8'd9;
    // localparam S_SW_WAIT        = 8'd10;

/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [7:0]                   c_state                 ;
    reg [7:0]                   n_state                 ;

    reg [3:0]                   trigger_in_dly          ;

    // reg [31:0]                  cnt_trigger_in          ;
    reg [31:0]                  cnt_wait                ;
    reg [31:0]                  cnt_sw                  ;
    reg [31:0]                  cnt_exp                 ;
    reg [31:0]                  cnt_gap                 ;
    reg [31:0]                  cnt_pic                 ;
    reg [31:0]                  cnt_sw_loop_gap         ;
    reg [31:0]                  cnt_sw_loop_num         ;

    reg                         trig_req_temp           ;

    reg                         mos_val_temp            ;
    reg                         mos_req_temp            ;

    reg [9:0]                   dds_addr_temp           ;
    reg [9:0]                   dds_addr_temp2          ;
    reg [9:0]                   dds_addr_temp3          ;
    reg                         dds_req_temp            ;
    reg                         dds_req_temp2           ;
    reg                         dds_req_temp3           ;

    reg [BANK_NUM*14-1 : 0]     dac_val_temp            ;
    reg [BANK_NUM/2-1 : 0]      dac_req_temp_x          ;
    reg [BANK_NUM/2-1 : 0]      dac_req_temp_y          ;

    reg [BANK_NUM*SW_NUM-1 :0]  sw_val_temp             ;
    reg [BANK_NUM/2-1 : 0]      sw_req_temp_x           ;
    reg [BANK_NUM/2-1 : 0]      sw_req_temp_y           ;

    reg [4:0]                   cnt_step_pic            ;

    reg [31:0]                  step_sw_x               ;
    reg [31:0]                  step_sw_y               ;

    reg [31:0]                  step_dac_x              ;
    reg [31:0]                  step_dac_y              ;

    reg [9:0]                   step_temp               ;
    reg [9:0]                   inc_temp                ;
    reg [9:0]                   base_temp               ;

    reg                         state_finish            ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        flag_status_jump        ;

    wire                        trigger_in_r            ;

    wire                        loop_status             ;
    wire                        remote_status           ;


    wire [BANK_NUM-1 : 0]       dac_req_temp            ;
    wire [1:0]                  sw_req_temp             ;

    wire                        trigger_req_reg         ;
    wire                        mos_value_reg           ;

    wire [9:0]                  x0                      ;
    wire [9:0]                  x1                      ;
    wire [9:0]                  x2                      ;
    wire [9:0]                  x3                      ;

    wire [9:0]                  y0                      ;
    wire [9:0]                  y1                      ;
    wire [9:0]                  y2                      ;
    wire [9:0]                  y3                      ;

    wire                        step_sw_temp_x          ;
    wire                        step_sw_temp_y          ;

    wire                        step_dac_temp_x         ;
    wire                        step_dac_temp_y         ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign dds_refresh          = c_state == S_WAIT;

    assign flag_status_jump     = c_state != n_state;

    assign loop_status          = reg_core_en == 1'b1 && reg_core_mode == 'd0;
    assign remote_status        = reg_core_en == 1'b1 && reg_core_mode == 'd1;

    assign trigger_req_reg      = reg_trigger_req_x0;
    assign mos_value_reg        = reg_mos_value_x0;

    assign trigger_in_r         = trigger_in_dly == 4'b0001;

    assign trigger_in_en        = state_finish;

    // assign reg_trigger_in_num = cnt_trigger_in;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trigger_miss_flag <= 1'd0;
        end
        else if((c_state != S_WAIT)&&(trigger_in_r == 1'b1))begin
            trigger_miss_flag <= 1'b1;
        end
        else
            trigger_miss_flag <= 1'b0;
    end

    assign x0                   = reg_dds_direction_x ? 10'd0   : 10'd0;
    assign x1                   = reg_dds_direction_x ? 10'd216 : 10'd72;
    assign x2                   = reg_dds_direction_x ? 10'd144 : 10'd144;
    assign x3                   = reg_dds_direction_x ? 10'd72  : 10'd216;

    assign y0                   = reg_dds_direction_y ? 10'd0   : 10'd0;
    assign y1                   = reg_dds_direction_y ? 10'd216 : 10'd72;
    assign y2                   = reg_dds_direction_y ? 10'd144 : 10'd144;
    assign y3                   = reg_dds_direction_y ? 10'd72  : 10'd216;

    always@(posedge clk or posedge rst)begin
        if(rst == 1'b1)begin
            state_finish        <= 'd1;
        end else if((c_state == S_WAIT) && (trigger_in_r == 1'b1))begin
            state_finish        <= 1'b0;
        end else if((c_state == S_MOS_RESET) && (mos_ack == 1'b1))begin
            state_finish        <= 1'b1;
        end else begin
            state_finish        <= state_finish;
        end
    end


    always @ (posedge clk) begin
        trigger_in_dly          <= {trigger_in_dly[2:0], trigger_in};
    end

    // Loop mode
    always @ (posedge clk or posedge rst) begin : FSM_1
        if (rst == 1'b1) begin
            c_state             <= S_IDLE;
        end else begin
            c_state             <= n_state;
        end
    end

    always @ (*) begin : FSM_2
        case (c_state)

            S_IDLE  :           n_state = S_DAC_SET;


            S_DAC_SET :         if (dac_ack == 1'b1) begin
                                    n_state = S_WAIT;
                                end else begin
                                    n_state = S_DAC_SET;
                                end

            S_WAIT :            if (trigger_in_r == 1'b1) begin
                                    n_state = S_MOS_SET;
                                end else begin
                                    n_state = S_WAIT;
                                end

            S_MOS_SET :         if (mos_ack == 1'b1) begin
                                    n_state = S_TRIG;
                                end else begin
                                    n_state = S_MOS_SET;
                                end

            S_TRIG :            n_state = S_DDS_GET;


            S_DDS_GET :         if (dds_ack == 1'b1) begin
                                    n_state = S_SW_SET;
                                end else begin
                                    n_state = S_DDS_GET;
                                end

            S_SW_SET :          if (sw_ack == 1'b1) begin
                                    n_state = S_SW_LOOP;
                                end else begin
                                    n_state = S_SW_SET;
                                end

            // S_SW_WAIT :         if (cnt_wait >= reg_sw_wait - 1'b1) begin
            //                         n_state = S_SW_LOOP;
            //                     end else begin
            //                         n_state = S_SW_WAIT;
            //                     end

            // S_SW_LOOP :         if (cnt_sw >= SW_NUM - 1'b1) begin
            //                         n_state = S_EXP_LOOP;
            //                     end else begin
            //                         n_state = S_SW_SET;
            //                     end
            S_SW_LOOP :         n_state = S_EXP_LOOP;

            S_EXP_LOOP :        if (cnt_exp >= reg_exp_cycle - 1'b1 && cnt_sw_loop_gap >= reg_sw_loop_gap - 1'b1) begin
                                    n_state = S_PIC_LOOP;
                                end else if ((cnt_sw_loop_gap >= reg_sw_loop_gap - 1'b1)&&(cnt_sw_loop_num<reg_sw_loop_num)) begin
                                    n_state = S_SW_SET;
                                end else begin
                                    n_state = S_EXP_LOOP;
                                end

            S_PIC_LOOP :        if (cnt_gap >= reg_trigger_gap - 1'b1 && cnt_pic >= reg_pic_num - 1'b1) begin
                                    n_state = S_MOS_RESET;
                                end else if (cnt_gap >= reg_trigger_gap - 1'b1) begin
                                    n_state = S_TRIG;
                                end else begin
                                    n_state = S_PIC_LOOP;
                                end

            S_MOS_RESET :       if (mos_ack == 1'b1) begin
                                    n_state = S_WAIT;
                                end else begin
                                    n_state = S_MOS_RESET;
                                end

            default :           n_state = S_WAIT;
        endcase
    end


        // Counter

    // always@(posedge clk or posedge rst)begin
    //     if(rst)begin
    //         cnt_trigger_in <= 'd0;
    //     end
    //     else if(trigger_in_r==1'b1)begin
    //         cnt_trigger_in <= cnt_trigger_in + 1'b1;
    //     end
    //     else
    //         ;
    // end

    // always @ (posedge clk or posedge rst) begin
    //     if (rst == 1'b1) begin
    //         cnt_wait        <= 'd0;
    //     end else if (c_state == S_SW_WAIT) begin
    //         cnt_wait        <= cnt_wait + 1'b1;
    //     end else begin
    //         cnt_wait        <= 'd0;
    //     end
    // end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_sw              <= 'd0;
        // end else if (c_state == S_SW_LOOP && cnt_sw >= SW_NUM - 1'b1) begin
        //     cnt_sw              <= 'd0;
        // end else if (c_state == S_SW_LOOP) begin
        //     cnt_sw              <= cnt_sw + 1'b1;
        end else begin
            cnt_sw              <= cnt_sw;
        end
    end



    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_sw_loop_gap          <= 'd0;
        end else if (c_state == S_EXP_LOOP && cnt_sw_loop_gap >= reg_sw_loop_gap - 1'b1) begin
            cnt_sw_loop_gap          <= cnt_sw_loop_gap;
        end else if (c_state == S_EXP_LOOP) begin
            cnt_sw_loop_gap          <= cnt_sw_loop_gap + 1'b1;
        end else begin
            cnt_sw_loop_gap          <= 'd0;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_exp             <= 'd0;
        end else if (c_state == S_EXP_LOOP && cnt_exp >= reg_exp_cycle - 1'b1 &&  cnt_sw_loop_gap >= reg_sw_loop_gap - 1'b1) begin
            cnt_exp             <= 'd0;
        end else if (c_state == S_TRIG) begin
            cnt_exp             <= 'd0;
            // Writing code this way increases system power consumption
        end else begin
            cnt_exp             <= cnt_exp + 1'b1;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_gap             <= 'd0;
        end else if (c_state == S_PIC_LOOP && cnt_gap >= reg_trigger_gap - 1'b1) begin
            cnt_gap             <= 'd0;
        end else if (c_state == S_PIC_LOOP) begin
            cnt_gap             <= cnt_gap + 1'b1;
        end else begin
            cnt_gap             <= cnt_gap;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_pic             <= 'd0;
        end else if (c_state == S_PIC_LOOP && cnt_gap >= reg_trigger_gap - 1'b1 && cnt_pic >= reg_pic_num - 1'b1) begin
            cnt_pic             <= 'd0;
        end else if (c_state == S_PIC_LOOP && cnt_gap >= reg_trigger_gap - 1'b1) begin
            cnt_pic             <= cnt_pic + 1'b1;
        end else begin
            cnt_pic             <= cnt_pic;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_sw_loop_num<='d0;
        end
        else if((c_state==S_EXP_LOOP)&&(cnt_exp >= reg_exp_cycle - 1'b1 && cnt_sw_loop_gap >= reg_sw_loop_gap - 1'b1))begin
            cnt_sw_loop_num<='d0;
        end
        else if(c_state==S_SW_LOOP)begin
            cnt_sw_loop_num<=cnt_sw_loop_num+1'b1;
        end
        else begin
            cnt_sw_loop_num<=cnt_sw_loop_num;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            trig_req_temp       <= 'd0;
        end else if (c_state == S_TRIG) begin
            trig_req_temp       <= 1'b1;
        end else begin
            trig_req_temp       <= 1'b0;
        end
    end

        // loop cmd
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mos_val_temp        <= 'd0;
        end else if (c_state == S_MOS_SET) begin
            mos_val_temp        <= 'd1;
        end else if (c_state == S_MOS_RESET) begin
            mos_val_temp        <= 'd0;
        end else begin
            mos_val_temp        <= mos_val_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mos_req_temp        <= 'b0;
        end else if ((c_state == S_MOS_SET || c_state == S_MOS_RESET) && mos_ack == 'b0) begin
            mos_req_temp        <= 'b1;
        end else begin
            mos_req_temp        <= 'b0;
        end
    end



    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_addr_temp       <= 'd0;
        end else if (c_state == S_WAIT) begin
            dds_addr_temp       <= reg_wave_start_addr + reg_dds_phase_offset + reg_dds_phase + x0;
        end else if (c_state == S_DDS_GET && dds_ack == 'd0) begin
            case (cnt_pic)
                 ('d1 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_offset + reg_dds_phase + x1;
                 ('d2 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_offset + reg_dds_phase + x2;
                 ('d3 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_offset + reg_dds_phase + x3;

                //  ('d4 - 1'b1) :         dds_addr_temp <= reg_wave_start_addr + reg_dds_phase + 72*2;
                //  ('d5 - 1'b1) :         dds_addr_temp <= reg_wave_start_addr + reg_dds_phase + 72*1;
                //  ('d6 - 1'b1) :         dds_addr_temp <= reg_wave_start_addr + reg_dds_phase + 72*0;
                //  ('d7 - 1'b1) :         dds_addr_temp <= reg_wave_start_addr + reg_dds_phase + 72*3;

                 ('d4 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_y + y0;
                 ('d5 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_y + y1;
                 ('d6 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_y + y2;
                 ('d7 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_y + y3;

                 ('d8 - 1'b1) : dds_addr_temp <= reg_wave_start_addr + reg_dds_phase_offset + reg_dds_phase + x0;
                 default :      dds_addr_temp <= 'd0;
            endcase
        end else begin
            dds_addr_temp       <= dds_addr_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_addr_temp2      <= 'd0;
        end else if (dds_addr_temp >= 10'd864) begin
            dds_addr_temp2      <= dds_addr_temp - 10'd864;
        end else if (dds_addr_temp >= 10'd576) begin
            dds_addr_temp2      <= dds_addr_temp - 10'd576;
        end else if (dds_addr_temp >= 10'd288) begin
            dds_addr_temp2      <= dds_addr_temp - 10'd288;
        end else begin
            dds_addr_temp2      <= dds_addr_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_req_temp        <= 'd0;
        end else if (c_state == S_DDS_GET && dds_ack == 'd0) begin
            dds_req_temp        <= 'b1;
        end else begin
            dds_req_temp        <= 'b0;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_req_temp2       <= 'd0;
        end else begin
            dds_req_temp2       <= dds_req_temp;
        end
    end

    // always @ (posedge clk or posedge rst) begin
    //     if (rst == 1'b1) begin
    //         dac_val_temp        <= 'd0;
    //     end else begin
    //         case(cnt_sw)
    //         32'd0:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[13:0], dds_data_backward[13:0]}};
    //         32'd1:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[27:14], dds_data_backward[27:14]}};
    //         32'd2:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[41:28], dds_data_backward[41:28]}};
    //         32'd3:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[55:42], dds_data_backward[55:42]}};
    //         32'd4:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[69:56], dds_data_backward[69:56]}};
    //         32'd5:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[83:70], dds_data_backward[83:70]}};
    //         32'd6:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[97:84], dds_data_backward[97:84]}};
    //         32'd7:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[111:98], dds_data_backward[111:98]}};
    //         32'd8:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[125:112], dds_data_backward[125:112]}};
    //         32'd9:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[139:126], dds_data_backward[139:126]}};
    //         32'd10:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[153:140], dds_data_backward[153:140]}};
    //         32'd11:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[167:154], dds_data_backward[167:154]}};
    //         default:dac_val_temp        <= {(BANK_NUM>>1'b1){dds_data_forward[167:154], dds_data_backward[167:154]}};
    //         endcase
    //     end
    // end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dac_val_temp        <= 'd0;
        end else begin
            dac_val_temp        <= {(BANK_NUM>>1'b1){reg_dac_value_forward[13:0], reg_dac_value_backward[13:0]}};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dac_req_temp_x      <= 'd0;
        end else if (c_state == S_DAC_SET && (cnt_pic <= (reg_pic_num >> 1'b1) - 1'b1) && dac_ack == 'b0) begin
            dac_req_temp_x      <= {(BANK_NUM/2){1'b1}};
        end else begin
            dac_req_temp_x      <= 'd0;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dac_req_temp_y      <= 'd0;
        end else if (c_state == S_DAC_SET && (cnt_pic > (reg_pic_num >> 1'b1) - 1'b1) && dac_ack == 'b0) begin
            dac_req_temp_y      <= {(BANK_NUM/2){1'b1}};
        end else begin
            dac_req_temp_y      <= 'd0;
        end
    end

    // assign dac_req_temp         = {dac_req_temp_y, dac_req_temp_x};
    assign dac_req_temp         = reg_step_en ? ({{(BANK_NUM/2){step_dac_temp_y}}, {(BANK_NUM/2){step_dac_temp_x}}}) : {dac_req_temp_y, dac_req_temp_x};


    // X: 001 left shift loop 1  Y: 800 right shift loop 1
        wire [11:0] sw_status_init_y;

    genvar i;

    generate for (i = 0; i < 12; i = i + 1) begin

        assign sw_status_init_y[i] = reg_sw_status[11-i];
    end
    endgenerate

    // Step mode or loop mode
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sw_val_temp         <= 'd0;
        end else if (c_state == S_TRIG) begin
            if (reg_step_en == 1'b0) begin
                if (cnt_pic <= 'd3) begin
                    sw_val_temp         <= {BANK_NUM{reg_sw_status}};
                end else begin
                    sw_val_temp         <= {BANK_NUM{sw_status_init_y}};
                end
            end else begin
                if (step_sw_x[0] == 1'b1) begin
                    sw_val_temp         <= {BANK_NUM{reg_sw_status}};
                end else begin
                    sw_val_temp         <= {BANK_NUM{sw_status_init_y}};
                end
            end
        end else if (reg_step_en == 1'b0) begin
            if (c_state == S_SW_SET && sw_ack == 1'b1 && cnt_pic <= 'd3) begin
                // sw_val_temp         <= {BANK_NUM{sw_val_temp[SW_NUM-2:0], sw_val_temp[SW_NUM-1]}};
                case (reg_sw_shift)
                    8'd0 :          sw_val_temp <= sw_val_temp;
                    8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-2:0] , sw_val_temp[SW_NUM-1:SW_NUM-1]}};
                    8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-3:0] , sw_val_temp[SW_NUM-1:SW_NUM-2]}};
                    8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-4:0] , sw_val_temp[SW_NUM-1:SW_NUM-3]}};
                    8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-5:0] , sw_val_temp[SW_NUM-1:SW_NUM-4]}};
                    8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-6:0] , sw_val_temp[SW_NUM-1:SW_NUM-5]}};
                    8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-7:0] , sw_val_temp[SW_NUM-1:SW_NUM-6]}};
                    8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-8:0] , sw_val_temp[SW_NUM-1:SW_NUM-7]}};
                    8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-9:0] , sw_val_temp[SW_NUM-1:SW_NUM-8]}};
                    8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-10:0], sw_val_temp[SW_NUM-1:SW_NUM-9]}};
                    8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-11:0], sw_val_temp[SW_NUM-1:SW_NUM-10]}};
                    8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-12:0], sw_val_temp[SW_NUM-1:SW_NUM-11]}};
                    default :       sw_val_temp <= sw_val_temp;
                endcase
            end else if (c_state == S_SW_SET && sw_ack == 1'b1 && cnt_pic > 'd3) begin
                case (reg_sw_shift)
                    8'd0 :          sw_val_temp <= sw_val_temp;
                    8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[0:0] , sw_val_temp[SW_NUM-1:1]}};
                    8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[1:0] , sw_val_temp[SW_NUM-1:2]}};
                    8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[2:0] , sw_val_temp[SW_NUM-1:3]}};
                    8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[3:0] , sw_val_temp[SW_NUM-1:4]}};
                    8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[4:0] , sw_val_temp[SW_NUM-1:5]}};
                    8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[5:0] , sw_val_temp[SW_NUM-1:6]}};
                    8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[6:0] , sw_val_temp[SW_NUM-1:7]}};
                    8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[7:0] , sw_val_temp[SW_NUM-1:8]}};
                    8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[8:0], sw_val_temp[SW_NUM-1:9]}};
                    8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[9:0], sw_val_temp[SW_NUM-1:10]}};
                    8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[10:0], sw_val_temp[SW_NUM-1:11]}};
                    default :       sw_val_temp <= sw_val_temp;
                endcase
            end else begin
                sw_val_temp         <= sw_val_temp;
            end
        end else begin
            if (c_state == S_SW_SET && sw_ack == 1'b1 && step_sw_x[0] == 1'b1) begin
                case (reg_sw_shift)
                    8'd0 :          sw_val_temp <= sw_val_temp;
                    8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-2:0] , sw_val_temp[SW_NUM-1:SW_NUM-1]}};
                    8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-3:0] , sw_val_temp[SW_NUM-1:SW_NUM-2]}};
                    8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-4:0] , sw_val_temp[SW_NUM-1:SW_NUM-3]}};
                    8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-5:0] , sw_val_temp[SW_NUM-1:SW_NUM-4]}};
                    8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-6:0] , sw_val_temp[SW_NUM-1:SW_NUM-5]}};
                    8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-7:0] , sw_val_temp[SW_NUM-1:SW_NUM-6]}};
                    8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-8:0] , sw_val_temp[SW_NUM-1:SW_NUM-7]}};
                    8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-9:0] , sw_val_temp[SW_NUM-1:SW_NUM-8]}};
                    8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-10:0], sw_val_temp[SW_NUM-1:SW_NUM-9]}};
                    8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-11:0], sw_val_temp[SW_NUM-1:SW_NUM-10]}};
                    8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-12:0], sw_val_temp[SW_NUM-1:SW_NUM-11]}};
                    default :       sw_val_temp <= sw_val_temp;
                endcase
            end else if (c_state == S_SW_SET && sw_ack == 1'b1 && step_sw_y[0] == 1'b1) begin
                case (reg_sw_shift)
                    8'd0 :          sw_val_temp <= sw_val_temp;
                    8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[0:0] , sw_val_temp[SW_NUM-1:1]}};
                    8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[1:0] , sw_val_temp[SW_NUM-1:2]}};
                    8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[2:0] , sw_val_temp[SW_NUM-1:3]}};
                    8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[3:0] , sw_val_temp[SW_NUM-1:4]}};
                    8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[4:0] , sw_val_temp[SW_NUM-1:5]}};
                    8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[5:0] , sw_val_temp[SW_NUM-1:6]}};
                    8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[6:0] , sw_val_temp[SW_NUM-1:7]}};
                    8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[7:0] , sw_val_temp[SW_NUM-1:8]}};
                    8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[8:0], sw_val_temp[SW_NUM-1:9]}};
                    8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[9:0], sw_val_temp[SW_NUM-1:10]}};
                    8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[10:0], sw_val_temp[SW_NUM-1:11]}};
                    default :       sw_val_temp <= sw_val_temp;
                endcase
            end else begin
                sw_val_temp         <= sw_val_temp;
            end
        end
    end

    // always @ (posedge clk or posedge rst) begin
    //     if (rst == 1'b1) begin
    //         sw_val_temp         <= 'd0;
    //     end else if (c_state == S_TRIG) begin
    //         if (cnt_pic <= 'd3) begin
    //             sw_val_temp         <= {BANK_NUM{reg_sw_status}};
    //         end else begin
    //             sw_val_temp         <= {BANK_NUM{sw_status_init_y}};
    //         end
    //     end else if (c_state == S_SW_SET && sw_ack == 1'b1 && cnt_pic <= 'd3) begin
    //         // sw_val_temp         <= {BANK_NUM{sw_val_temp[SW_NUM-2:0], sw_val_temp[SW_NUM-1]}};
    //         case (reg_sw_shift)
    //             8'd0 :          sw_val_temp <= {BANK_NUM{sw_val_temp}};
    //             8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-2:0] , sw_val_temp[SW_NUM-1:SW_NUM-1]}};
    //             8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-3:0] , sw_val_temp[SW_NUM-1:SW_NUM-2]}};
    //             8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-4:0] , sw_val_temp[SW_NUM-1:SW_NUM-3]}};
    //             8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-5:0] , sw_val_temp[SW_NUM-1:SW_NUM-4]}};
    //             8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-6:0] , sw_val_temp[SW_NUM-1:SW_NUM-5]}};
    //             8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-7:0] , sw_val_temp[SW_NUM-1:SW_NUM-6]}};
    //             8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-8:0] , sw_val_temp[SW_NUM-1:SW_NUM-7]}};
    //             8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-9:0] , sw_val_temp[SW_NUM-1:SW_NUM-8]}};
    //             8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-10:0], sw_val_temp[SW_NUM-1:SW_NUM-9]}};
    //             8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-11:0], sw_val_temp[SW_NUM-1:SW_NUM-10]}};
    //             8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-12:0], sw_val_temp[SW_NUM-1:SW_NUM-11]}};
    //             default :       sw_val_temp <= sw_val_temp;
    //         endcase
    //     end else if (c_state == S_SW_SET && sw_ack == 1'b1 && cnt_pic > 'd3) begin
    //         case (reg_sw_shift)
    //             8'd0 :          sw_val_temp <= {BANK_NUM{sw_val_temp}};
    //             8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[0:0] , sw_val_temp[SW_NUM-1:1]}};
    //             8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[1:0] , sw_val_temp[SW_NUM-1:2]}};
    //             8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[2:0] , sw_val_temp[SW_NUM-1:3]}};
    //             8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[3:0] , sw_val_temp[SW_NUM-1:4]}};
    //             8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[4:0] , sw_val_temp[SW_NUM-1:5]}};
    //             8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[5:0] , sw_val_temp[SW_NUM-1:6]}};
    //             8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[6:0] , sw_val_temp[SW_NUM-1:7]}};
    //             8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[7:0] , sw_val_temp[SW_NUM-1:8]}};
    //             8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[8:0], sw_val_temp[SW_NUM-1:9]}};
    //             8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[9:0], sw_val_temp[SW_NUM-1:10]}};
    //             8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[10:0], sw_val_temp[SW_NUM-1:11]}};
    //             default :       sw_val_temp <= sw_val_temp;
    //         endcase
    //     end else begin
    //         sw_val_temp         <= sw_val_temp;
    //     end
    // end



    //原来的y方向

    // always @ (posedge clk or posedge rst) begin
    //     if (rst == 1'b1) begin
    //         sw_val_temp         <= 'd0;
    //     end else if (c_state == S_IDLE) begin
    //         sw_val_temp         <= {BANK_NUM{reg_sw_status}};
    //     end else if (c_state == S_SW_SET && sw_ack == 1'b1) begin
    //         // sw_val_temp         <= {BANK_NUM{sw_val_temp[SW_NUM-2:0], sw_val_temp[SW_NUM-1]}};
    //         case (reg_sw_shift)
    //             8'd0 :          sw_val_temp <= {BANK_NUM{sw_val_temp}};
    //             8'd1 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-2:0] , sw_val_temp[SW_NUM-1:SW_NUM-1]}};
    //             8'd2 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-3:0] , sw_val_temp[SW_NUM-1:SW_NUM-2]}};
    //             8'd3 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-4:0] , sw_val_temp[SW_NUM-1:SW_NUM-3]}};
    //             8'd4 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-5:0] , sw_val_temp[SW_NUM-1:SW_NUM-4]}};
    //             8'd5 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-6:0] , sw_val_temp[SW_NUM-1:SW_NUM-5]}};
    //             8'd6 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-7:0] , sw_val_temp[SW_NUM-1:SW_NUM-6]}};
    //             8'd7 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-8:0] , sw_val_temp[SW_NUM-1:SW_NUM-7]}};
    //             8'd8 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-9:0] , sw_val_temp[SW_NUM-1:SW_NUM-8]}};
    //             8'd9 :          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-10:0], sw_val_temp[SW_NUM-1:SW_NUM-9]}};
    //             8'd10:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-11:0], sw_val_temp[SW_NUM-1:SW_NUM-10]}};
    //             8'd11:          sw_val_temp <= {BANK_NUM{sw_val_temp[SW_NUM-12:0], sw_val_temp[SW_NUM-1:SW_NUM-11]}};
    //             default :       sw_val_temp <= sw_val_temp;
    //         endcase
    //     end else begin
    //         sw_val_temp         <= sw_val_temp;
    //     end
    // end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sw_req_temp_x       <= 'd0;
        end else if (c_state == S_SW_SET && (cnt_pic <= ((reg_pic_num >> 1'b1) - 1'b1)) && sw_ack == 'b0) begin
            sw_req_temp_x       <= {(BANK_NUM/2){1'b1}};
        end else begin
            sw_req_temp_x       <= 'd0;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sw_req_temp_y       <= 'd0;
        end else if (c_state == S_SW_SET && (cnt_pic > ((reg_pic_num >> 1'b1) - 1'b1)) && sw_ack == 'b0) begin
            sw_req_temp_y       <= {(BANK_NUM/2){1'b1}};
        end else begin
            sw_req_temp_y       <= 'd0;
        end
    end

    // assign sw_req_temp         = {sw_req_temp_y[0], sw_req_temp_x[0]};
    assign sw_req_temp         = reg_step_en ? ({step_sw_temp_y, step_sw_temp_x}) : ({sw_req_temp_y[0], sw_req_temp_x[0]});

    // Step

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_step_pic        <= 'd0;
        end else if (reg_step_en == 1'b0) begin
            cnt_step_pic        <= 'd0;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1 && (cnt_step_pic >= reg_step_pic_num[5:0] - 1'b1)) begin
            cnt_step_pic        <= 'd0;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1) begin
            cnt_step_pic        <= cnt_step_pic + 1'b1;
        end else begin
            cnt_step_pic        <= cnt_step_pic;
        end
    end

    // Step DAC req
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            step_dac_x          <= 'd0;
        end else if (reg_step_en == 1'b0) begin
            step_dac_x          <= reg_step_x_seq;
        end else if (cnt_step_pic == 'd0 && c_state == S_WAIT) begin
            step_dac_x          <= reg_step_x_seq;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1) begin
            step_dac_x          <= {step_dac_x[0], step_dac_x[31:1]};
        end else begin
            step_dac_x          <= step_dac_x;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            step_dac_y          <= 'd0;
        end else if (reg_step_en == 1'b0) begin
            step_dac_y          <= reg_step_y_seq;
        end else if (cnt_step_pic == 'd0 && c_state == S_WAIT) begin
            step_dac_y          <= reg_step_y_seq;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1) begin
            step_dac_y          <= {step_dac_y[0], step_dac_y[31:1]};
        end else begin
            step_dac_y          <= step_dac_y;
        end
    end

    assign step_dac_temp_x       = (c_state == S_DAC_SET) && step_dac_x[0];
    assign step_dac_temp_y       = (c_state == S_DAC_SET) && step_dac_y[0];

    // Step SW req
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            step_sw_x           <= 'd0;
        end else if (reg_step_en == 1'b0) begin
            step_sw_x           <= reg_step_x_seq;
        end else if (cnt_step_pic == 'd0 && c_state == S_WAIT) begin
            step_sw_x           <= reg_step_x_seq;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1) begin
            step_sw_x           <= {step_sw_x[0], step_sw_x[31:1]};
        end else begin
            step_sw_x           <= step_sw_x;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            step_sw_y           <= 'd0;
        end else if (reg_step_en == 1'b0) begin
            step_sw_y           <= reg_step_y_seq;
        end else if (cnt_step_pic == 'd0 && c_state == S_WAIT) begin
            step_sw_y           <= reg_step_y_seq;
        end else if (c_state == S_MOS_RESET && mos_ack == 1'b1) begin
            step_sw_y           <= {step_sw_y[0], step_sw_y[31:1]};
        end else begin
            step_sw_y           <= step_sw_y;
        end
    end

    assign step_sw_temp_x       = (c_state == S_SW_SET) && step_sw_x[0];
    assign step_sw_temp_y       = (c_state == S_SW_SET) && step_sw_y[0];

    always @ (posedge clk) begin
        case (cnt_step_pic)
            32'd0 :             step_temp <= reg_step_phase_0;
            32'd1 :             step_temp <= reg_step_phase_1;
            32'd2 :             step_temp <= reg_step_phase_2;
            32'd3 :             step_temp <= reg_step_phase_3;
            32'd4 :             step_temp <= reg_step_phase_4;
            32'd5 :             step_temp <= reg_step_phase_5;
            32'd6 :             step_temp <= reg_step_phase_6;
            32'd7 :             step_temp <= reg_step_phase_7;
            32'd8 :             step_temp <= reg_step_phase_8;
            32'd9 :             step_temp <= reg_step_phase_9;
            32'd10 :            step_temp <= reg_step_phase_10;
            32'd11 :            step_temp <= reg_step_phase_11;
            32'd12 :            step_temp <= reg_step_phase_12;
            32'd13 :            step_temp <= reg_step_phase_13;
            32'd14 :            step_temp <= reg_step_phase_14;
            32'd15 :            step_temp <= reg_step_phase_15;
            32'd16 :            step_temp <= reg_step_phase_16;
            32'd17 :            step_temp <= reg_step_phase_17;
            32'd18 :            step_temp <= reg_step_phase_18;
            32'd19 :            step_temp <= reg_step_phase_19;
            32'd20 :            step_temp <= reg_step_phase_20;
            32'd21 :            step_temp <= reg_step_phase_21;
            32'd22 :            step_temp <= reg_step_phase_22;
            32'd23 :            step_temp <= reg_step_phase_23;
            32'd24 :            step_temp <= reg_step_phase_24;
            32'd25 :            step_temp <= reg_step_phase_25;
            32'd26 :            step_temp <= reg_step_phase_26;
            32'd27 :            step_temp <= reg_step_phase_27;
            32'd28 :            step_temp <= reg_step_phase_28;
            32'd29 :            step_temp <= reg_step_phase_29;
            32'd30 :            step_temp <= reg_step_phase_30;
            32'd31 :            step_temp <= reg_step_phase_31;
            default :           step_temp <= 'd0;
        endcase
    end

    always @ (posedge clk) begin
        case (cnt_step_pic)
            32'd0 :             inc_temp <= reg_step_inc_0;
            32'd1 :             inc_temp <= reg_step_inc_1;
            32'd2 :             inc_temp <= reg_step_inc_2;
            32'd3 :             inc_temp <= reg_step_inc_3;
            32'd4 :             inc_temp <= reg_step_inc_4;
            32'd5 :             inc_temp <= reg_step_inc_5;
            32'd6 :             inc_temp <= reg_step_inc_6;
            32'd7 :             inc_temp <= reg_step_inc_7;
            32'd8 :             inc_temp <= reg_step_inc_8;
            32'd9 :             inc_temp <= reg_step_inc_9;
            32'd10 :            inc_temp <= reg_step_inc_10;
            32'd11 :            inc_temp <= reg_step_inc_11;
            32'd12 :            inc_temp <= reg_step_inc_12;
            32'd13 :            inc_temp <= reg_step_inc_13;
            32'd14 :            inc_temp <= reg_step_inc_14;
            32'd15 :            inc_temp <= reg_step_inc_15;
            32'd16 :            inc_temp <= reg_step_inc_16;
            32'd17 :            inc_temp <= reg_step_inc_17;
            32'd18 :            inc_temp <= reg_step_inc_18;
            32'd19 :            inc_temp <= reg_step_inc_19;
            32'd20 :            inc_temp <= reg_step_inc_20;
            32'd21 :            inc_temp <= reg_step_inc_21;
            32'd22 :            inc_temp <= reg_step_inc_22;
            32'd23 :            inc_temp <= reg_step_inc_23;
            32'd24 :            inc_temp <= reg_step_inc_24;
            32'd25 :            inc_temp <= reg_step_inc_25;
            32'd26 :            inc_temp <= reg_step_inc_26;
            32'd27 :            inc_temp <= reg_step_inc_27;
            32'd28 :            inc_temp <= reg_step_inc_28;
            32'd29 :            inc_temp <= reg_step_inc_29;
            32'd30 :            inc_temp <= reg_step_inc_30;
            32'd31 :            inc_temp <= reg_step_inc_31;
            default :           inc_temp <= 'd0;
        endcase
    end

    always @ (posedge clk) begin
        case (cnt_step_pic)
            32'd0 :             base_temp <= reg_step_base_0;
            32'd1 :             base_temp <= reg_step_base_1;
            32'd2 :             base_temp <= reg_step_base_2;
            32'd3 :             base_temp <= reg_step_base_3;
            32'd4 :             base_temp <= reg_step_base_4;
            32'd5 :             base_temp <= reg_step_base_5;
            32'd6 :             base_temp <= reg_step_base_6;
            32'd7 :             base_temp <= reg_step_base_7;
            32'd8 :             base_temp <= reg_step_base_8;
            32'd9 :             base_temp <= reg_step_base_9;
            32'd10 :            base_temp <= reg_step_base_10;
            32'd11 :            base_temp <= reg_step_base_11;
            32'd12 :            base_temp <= reg_step_base_12;
            32'd13 :            base_temp <= reg_step_base_13;
            32'd14 :            base_temp <= reg_step_base_14;
            32'd15 :            base_temp <= reg_step_base_15;
            32'd16 :            base_temp <= reg_step_base_16;
            32'd17 :            base_temp <= reg_step_base_17;
            32'd18 :            base_temp <= reg_step_base_18;
            32'd19 :            base_temp <= reg_step_base_19;
            32'd20 :            base_temp <= reg_step_base_20;
            32'd21 :            base_temp <= reg_step_base_21;
            32'd22 :            base_temp <= reg_step_base_22;
            32'd23 :            base_temp <= reg_step_base_23;
            32'd24 :            base_temp <= reg_step_base_24;
            32'd25 :            base_temp <= reg_step_base_25;
            32'd26 :            base_temp <= reg_step_base_26;
            32'd27 :            base_temp <= reg_step_base_27;
            32'd28 :            base_temp <= reg_step_base_28;
            32'd29 :            base_temp <= reg_step_base_29;
            32'd30 :            base_temp <= reg_step_base_30;
            32'd31 :            base_temp <= reg_step_base_31;
            default :           base_temp <= 'd0;
        endcase
    end

    // Output

    assign step_inc             = inc_temp;

    assign reg_core_status      = {8'd0, c_state};

    assign sensor_trigger_req   = (loop_status ? trig_req_temp : 1'b0);

    assign mos_val              = (loop_status ? mos_val_temp  : 1'b0);
    assign mos_req              = (loop_status ? mos_req_temp  : 1'b0);

    assign dds_addr_base        = base_temp;
    assign dds_addr             = (loop_status ? (reg_step_en ? step_temp : dds_addr_temp2): 1'b0);
    assign dds_req              = (loop_status ? dds_req_temp2 : 1'b0);

    assign dac_val              = (loop_status ? dac_val_temp  : 1'b0);
    assign dac_req              = (loop_status ? (dac_req_temp | ({BANK_NUM{reg_dac_req}}))  : 1'b0);

    assign sw_val               = (loop_status ? sw_val_temp  : 1'b0);
    assign sw_req               = (loop_status ? sw_req_temp   : 'd0);


 /*-----------------------CHECK------------------------*/

// num check here



 /*-----------------------DEBUG------------------------*/

// (* mark_debug = "true" *)





// -------------------------< debug >-------------------------

// (* mark_debug = "true" *)    reg    [31:0]                      debug_reg_trigger_in_num            ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_dds_phase                 ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_dds_inc                   ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_exp_cycle                 ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_trigger_gap               ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_pic_num                   ;
(* mark_debug = "true" *)    reg    [11:0]                      debug_reg_sw_status                 ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_reg_sw_shift                  ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_sw_loop_gap               ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_sw_loop_num               ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_dds_phase_offset          ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_dac_value_forward         ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_dac_value_backward        ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_sw_wait                   ;

always @ (posedge clk) begin
    // debug_reg_trigger_in_num             <= reg_trigger_in_num            ;
    debug_reg_dds_phase                  <= reg_dds_phase                 ;
    debug_reg_dds_inc                    <= reg_dds_inc                   ;
    debug_reg_exp_cycle                  <= reg_exp_cycle                 ;
    debug_reg_trigger_gap                <= reg_trigger_gap               ;
    debug_reg_pic_num                    <= reg_pic_num                   ;
    debug_reg_sw_status                  <= reg_sw_status                 ;
    debug_reg_sw_shift                   <= reg_sw_shift                  ;
    debug_reg_sw_loop_gap                <= reg_sw_loop_gap               ;
    debug_reg_sw_loop_num                <= reg_sw_loop_num               ;
    debug_reg_dds_phase_offset           <= reg_dds_phase_offset          ;
    debug_reg_dac_value_forward          <= reg_dac_value_forward         ;
    debug_reg_dac_value_backward         <= reg_dac_value_backward        ;
    debug_reg_sw_wait                    <= reg_sw_wait                   ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [3:0]                       debug_reg_core_mode                 ;
(* mark_debug = "true" *)    reg                                debug_reg_core_en                   ;
(* mark_debug = "true" *)    reg    [15:0]                      debug_reg_core_status               ;

always @ (posedge clk) begin
    debug_reg_core_mode                  <= reg_core_mode                 ;
    debug_reg_core_en                    <= reg_core_en                   ;
    debug_reg_core_status                <= reg_core_status               ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg                                debug_trigger_in                    ;
(* mark_debug = "true" *)    reg                                debug_sensor_trigger_req            ;
(* mark_debug = "true" *)    reg                                debug_mos_val                       ;
(* mark_debug = "true" *)    reg                                debug_mos_req                       ;
(* mark_debug = "true" *)    reg                                debug_mos_ack                       ;
(* mark_debug = "true" *)    reg                                debug_dds_refresh                   ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr                      ;
(* mark_debug = "true" *)    reg                                debug_dds_req                       ;
(* mark_debug = "true" *)    reg                                debug_dds_ack                       ;

always @ (posedge clk) begin
    debug_trigger_in                     <= trigger_in                    ;
    debug_sensor_trigger_req             <= sensor_trigger_req            ;
    debug_mos_val                        <= mos_val                       ;
    debug_mos_req                        <= mos_req                       ;
    debug_mos_ack                        <= mos_ack                       ;
    debug_dds_refresh                    <= dds_refresh                   ;
    debug_dds_addr                       <= dds_addr                      ;
    debug_dds_req                        <= dds_req                       ;
    debug_dds_ack                        <= dds_ack                       ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_wave_start_addr           ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_wave_end_addr             ;
(* mark_debug = "true" *)    reg    [BANK_NUM*14-1 : 0]         debug_dac_val                       ;
(* mark_debug = "true" *)    reg    [BANK_NUM-1 : 0]            debug_dac_req                       ;
(* mark_debug = "true" *)    reg                                debug_dac_ack                       ;
(* mark_debug = "true" *)    reg    [BANK_NUM*SW_NUM-1 : 0]     debug_sw_val                        ;
(* mark_debug = "true" *)    reg    [1:0]                       debug_sw_req                        ;
(* mark_debug = "true" *)    reg                                debug_sw_ack                        ;

always @ (posedge clk) begin
    debug_reg_wave_start_addr            <= reg_wave_start_addr           ;
    debug_reg_wave_end_addr              <= reg_wave_end_addr             ;
    debug_dac_val                        <= dac_val                       ;
    debug_dac_req                        <= dac_req                       ;
    debug_dac_ack                        <= dac_ack                       ;
    debug_sw_val                         <= sw_val                        ;
    debug_sw_req                         <= sw_req                        ;
    debug_sw_ack                         <= sw_ack                        ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [7:0]                       debug_c_state                       ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_n_state                       ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_trigger_in_dly                ;
// (* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_trigger_in                ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_wait                      ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_sw                        ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_exp                       ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_gap                       ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_pic                       ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_sw_loop_gap               ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_sw_loop_num               ;
(* mark_debug = "true" *)    reg                                debug_trig_req_temp                 ;
(* mark_debug = "true" *)    reg                                debug_mos_val_temp                  ;
(* mark_debug = "true" *)    reg                                debug_mos_req_temp                  ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr_temp                 ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr_temp2                ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr_temp3                ;
(* mark_debug = "true" *)    reg                                debug_dds_req_temp                  ;
(* mark_debug = "true" *)    reg                                debug_dds_req_temp2                 ;
(* mark_debug = "true" *)    reg                                debug_dds_req_temp3                 ;
(* mark_debug = "true" *)    reg    [BANK_NUM*14-1 : 0]         debug_dac_val_temp                  ;
(* mark_debug = "true" *)    reg    [BANK_NUM/2-1 : 0]          debug_dac_req_temp_x                ;
(* mark_debug = "true" *)    reg    [BANK_NUM/2-1 : 0]          debug_dac_req_temp_y                ;
(* mark_debug = "true" *)    reg    [BANK_NUM*SW_NUM-1 :0]      debug_sw_val_temp                   ;
(* mark_debug = "true" *)    reg    [BANK_NUM/2-1 : 0]          debug_sw_req_temp_x                 ;
(* mark_debug = "true" *)    reg    [BANK_NUM/2-1 : 0]          debug_sw_req_temp_y                 ;
(* mark_debug = "true" *)    reg                                debug_flag_status_jump              ;
(* mark_debug = "true" *)    reg                                debug_trigger_in_r                  ;
(* mark_debug = "true" *)    reg                                debug_loop_status                   ;
(* mark_debug = "true" *)    reg                                debug_remote_status                 ;
(* mark_debug = "true" *)    reg    [BANK_NUM-1 : 0]            debug_dac_req_temp                  ;
(* mark_debug = "true" *)    reg    [1:0]                       debug_sw_req_temp                   ;
(* mark_debug = "true" *)    reg                                debug_trigger_req_reg               ;
(* mark_debug = "true" *)    reg                                debug_mos_value_reg                 ;

always @ (posedge clk) begin
    debug_c_state                        <= c_state                       ;
    debug_n_state                        <= n_state                       ;
    debug_trigger_in_dly                 <= trigger_in_dly                ;
    // debug_cnt_trigger_in                 <= cnt_trigger_in                ;
    debug_cnt_wait                       <= cnt_wait                      ;
    debug_cnt_sw                         <= cnt_sw                        ;
    debug_cnt_exp                        <= cnt_exp                       ;
    debug_cnt_gap                        <= cnt_gap                       ;
    debug_cnt_pic                        <= cnt_pic                       ;
    debug_cnt_sw_loop_gap                <= cnt_sw_loop_gap               ;
    debug_cnt_sw_loop_num                <= cnt_sw_loop_num               ;
    debug_trig_req_temp                  <= trig_req_temp                 ;
    debug_mos_val_temp                   <= mos_val_temp                  ;
    debug_mos_req_temp                   <= mos_req_temp                  ;
    debug_dds_addr_temp                  <= dds_addr_temp                 ;
    debug_dds_addr_temp2                 <= dds_addr_temp2                ;
    debug_dds_addr_temp3                 <= dds_addr_temp3                ;
    debug_dds_req_temp                   <= dds_req_temp                  ;
    debug_dds_req_temp2                  <= dds_req_temp2                 ;
    debug_dds_req_temp3                  <= dds_req_temp3                 ;
    debug_dac_val_temp                   <= dac_val_temp                  ;
    debug_dac_req_temp_x                 <= dac_req_temp_x                ;
    debug_dac_req_temp_y                 <= dac_req_temp_y                ;
    debug_sw_val_temp                    <= sw_val_temp                   ;
    debug_sw_req_temp_x                  <= sw_req_temp_x                 ;
    debug_sw_req_temp_y                  <= sw_req_temp_y                 ;
    debug_flag_status_jump               <= flag_status_jump              ;
    debug_trigger_in_r                   <= trigger_in_r                  ;
    debug_loop_status                    <= loop_status                   ;
    debug_remote_status                  <= remote_status                 ;
    debug_dac_req_temp                   <= dac_req_temp                  ;
    debug_sw_req_temp                    <= sw_req_temp                   ;
    debug_trigger_req_reg                <= trigger_req_reg               ;
    debug_mos_value_reg                  <= mos_value_reg                 ;
end

// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg                                debug_step_sw_temp_x                ;
(* mark_debug = "true" *)    reg                                debug_step_sw_temp_y                ;

always @ (posedge clk) begin
    debug_step_sw_temp_x                 <= step_sw_temp_x                ;
    debug_step_sw_temp_y                 <= step_sw_temp_y                ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [4:0]                       debug_cnt_step_pic                  ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_step_sw_x                     ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_step_sw_y                     ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_step_temp                     ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_inc_temp                      ;

always @ (posedge clk) begin
    debug_cnt_step_pic                   <= cnt_step_pic                  ;
    debug_step_sw_x                      <= step_sw_x                     ;
    debug_step_sw_y                      <= step_sw_y                     ;
    debug_step_temp                      <= step_temp                     ;
    debug_inc_temp                       <= inc_temp                      ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [9:0]                       debug_base_temp                     ;

always @ (posedge clk) begin
    debug_base_temp                      <= base_temp                     ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg                                debug_step_dac_temp_x               ;
(* mark_debug = "true" *)    reg                                debug_step_dac_temp_y               ;

always @ (posedge clk) begin
    debug_step_dac_temp_x                <= step_dac_temp_x               ;
    debug_step_dac_temp_y                <= step_dac_temp_y               ;
end

endmodule











