  /********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-21  19:46:04
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-09-05 13:43:10
#FilePath     : core_controller_tb.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`timescale  1ns / 1ps

module core_controller_tb;

// core_controller Parameters
parameter PERIOD    = 10   ;
parameter BANK_NUM  = 8'd8 ;
parameter SW_NUM    = 8'd12;

// core_controller Inputs
reg   clk                                  = 1 ;
reg   rst                                  = 1 ;
reg   [9:0]  reg_dds_phase                 = 72 ;
reg   [9:0]  reg_dds_inc                   = 12 ;
reg   [31:0]  reg_exp_cycle                = 8750 ;
reg   [31:0]  reg_trigger_gap              = 2500 ;
reg   [31:0]  reg_pic_num                  = 8 ;
reg   [11:0]  reg_sw_status                = 1 ;
reg   [7:0]  reg_sw_shift                  = 1 ;
reg   [31:0]    reg_sw_gap                 = 62;
reg   [31:0]    reg_sw_loop_num            = 5 ;
reg   [13:0]  reg_dac_value_x0             = 1 ;
reg   [11:0]  reg_sw_value_x0              = 1 ;
reg   reg_mos_value_x0                     = 1 ;
reg   reg_trigger_req_x0                   = 0 ;
reg   [13:0]  reg_dac_value_x1             = 0 ;
reg   [11:0]  reg_sw_value_x1              = 0 ;
reg   reg_mos_value_x1                     = 0 ;
reg   reg_trigger_req_x1                   = 0 ;
reg   [13:0]  reg_dac_value_x2             = 0 ;
reg   [11:0]  reg_sw_value_x2              = 0 ;
reg   reg_mos_value_x2                     = 0 ;
reg   reg_trigger_req_x2                   = 0 ;
reg   [13:0]  reg_dac_value_x3             = 0 ;
reg   [11:0]  reg_sw_value_x3              = 0 ;
reg   reg_mos_value_x3                     = 0 ;
reg   reg_trigger_req_x3                   = 0 ;
reg   [13:0]  reg_dac_value_y0             = 0 ;
reg   [11:0]  reg_sw_value_y0              = 0 ;
reg   reg_mos_value_y0                     = 0 ;
reg   reg_trigger_req_y0                   = 0 ;
reg   [13:0]  reg_dac_value_y1             = 0 ;
reg   [11:0]  reg_sw_value_y1              = 0 ;
reg   reg_mos_value_y1                     = 0 ;
reg   reg_trigger_req_y1                   = 0 ;
reg   [13:0]  reg_dac_value_y2             = 0 ;
reg   [11:0]  reg_sw_value_y2              = 0 ;
reg   reg_mos_value_y2                     = 0 ;
reg   reg_trigger_req_y2                   = 0 ;
reg   [13:0]  reg_dac_value_y3             = 0 ;
reg   [11:0]  reg_sw_value_y3              = 0 ;
reg   reg_mos_value_y3                     = 0 ;
reg   reg_trigger_req_y3                   = 0 ;
reg   [3:0]  reg_core_mode                 = 0 ;
reg   reg_core_en                          = 0 ;
reg   trigger_in                           = 0 ;
reg   mos_ack                              = 1 ;
reg   dds_ack                              = 1 ;
reg   [167:0]  dds_data_forward             = 'h05A505A505A505A505A505A505A575A565A555A545A535A525A515A505A5 ;
reg   [167:0]  dds_data_backward            = 'h3FFF ;
reg   [9:0]  reg_wave_start_addr           = 0 ;
reg   [9:0]  reg_wave_end_addr             = 1024 ;
reg   dac_ack                              = 1 ;
reg   sw_ack                               = 75 ;

// core_controller Outputs
wire  [15:0]  reg_core_status              ;
wire  sensor_trigger_req                   ;
wire  mos_val                              ;
wire  mos_req                              ;
wire  [9:0]  dds_addr                      ;
wire  dds_req                              ;
wire  [BANK_NUM*14-1 : 0]  dac_val         ;
wire  [BANK_NUM-1 : 0]  dac_req            ;
wire  [BANK_NUM*SW_NUM-1 : 0]  sw_val      ;
wire  [BANK_NUM-1 : 0]  sw_req             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rst <= 1'b1;
    #2000
    #(PERIOD*2) rst  =  'd0;
end

core_controller #(
    .BANK_NUM ( BANK_NUM ),
    .SW_NUM   ( SW_NUM   ))
 core_controller_DUT (
    .clk                     ( clk                                          ),
    .rst                     ( rst                                          ),
    .reg_dds_phase           ( reg_dds_phase        [9:0]                   ),
    .reg_dds_inc             ( reg_dds_inc          [9:0]                   ),
    .reg_exp_cycle           ( reg_exp_cycle        [31:0]                  ),
    .reg_trigger_gap         ( reg_trigger_gap      [31:0]                  ),
    .reg_pic_num             ( reg_pic_num          [31:0]                  ),
    .reg_sw_status           ( reg_sw_status        [11:0]                  ),
    .reg_sw_shift            ( reg_sw_shift         [7:0]                   ),
    .reg_sw_gap              ( reg_sw_gap           [31:0]                  ),
    .reg_sw_loop_num         ( reg_sw_loop_num      [31:0]                  ),
    .reg_dac_value_x0        ( reg_dac_value_x0     [13:0]                  ),
    .reg_sw_value_x0         ( reg_sw_value_x0      [11:0]                  ),
    .reg_mos_value_x0        ( reg_mos_value_x0                             ),
    .reg_trigger_req_x0      ( reg_trigger_req_x0                           ),
    .reg_dac_value_x1        ( reg_dac_value_x1     [13:0]                  ),
    .reg_sw_value_x1         ( reg_sw_value_x1      [11:0]                  ),
    .reg_mos_value_x1        ( reg_mos_value_x1                             ),
    .reg_trigger_req_x1      ( reg_trigger_req_x1                           ),
    .reg_dac_value_x2        ( reg_dac_value_x2     [13:0]                  ),
    .reg_sw_value_x2         ( reg_sw_value_x2      [11:0]                  ),
    .reg_mos_value_x2        ( reg_mos_value_x2                             ),
    .reg_trigger_req_x2      ( reg_trigger_req_x2                           ),
    .reg_dac_value_x3        ( reg_dac_value_x3     [13:0]                  ),
    .reg_sw_value_x3         ( reg_sw_value_x3      [11:0]                  ),
    .reg_mos_value_x3        ( reg_mos_value_x3                             ),
    .reg_trigger_req_x3      ( reg_trigger_req_x3                           ),
    .reg_dac_value_y0        ( reg_dac_value_y0     [13:0]                  ),
    .reg_sw_value_y0         ( reg_sw_value_y0      [11:0]                  ),
    .reg_mos_value_y0        ( reg_mos_value_y0                             ),
    .reg_trigger_req_y0      ( reg_trigger_req_y0                           ),
    .reg_dac_value_y1        ( reg_dac_value_y1     [13:0]                  ),
    .reg_sw_value_y1         ( reg_sw_value_y1      [11:0]                  ),
    .reg_mos_value_y1        ( reg_mos_value_y1                             ),
    .reg_trigger_req_y1      ( reg_trigger_req_y1                           ),
    .reg_dac_value_y2        ( reg_dac_value_y2     [13:0]                  ),
    .reg_sw_value_y2         ( reg_sw_value_y2      [11:0]                  ),
    .reg_mos_value_y2        ( reg_mos_value_y2                             ),
    .reg_trigger_req_y2      ( reg_trigger_req_y2                           ),
    .reg_dac_value_y3        ( reg_dac_value_y3     [13:0]                  ),
    .reg_sw_value_y3         ( reg_sw_value_y3      [11:0]                  ),
    .reg_mos_value_y3        ( reg_mos_value_y3                             ),
    .reg_trigger_req_y3      ( reg_trigger_req_y3                           ),
    .reg_core_mode           ( reg_core_mode        [3:0]                   ),
    .reg_core_en             ( reg_core_en                                  ),
    .trigger_in              ( trigger_in                                   ),
    .mos_ack                 ( mos_ack                                      ),
    .dds_ack                 ( dds_ack                                      ),
    .dds_data_forward        ( dds_data_forward     [167:0]                  ),
    .dds_data_backward       ( dds_data_backward    [167:0]                  ),
    .reg_wave_start_addr     ( reg_wave_start_addr  [9:0]                   ),
    .reg_wave_end_addr       ( reg_wave_end_addr    [9:0]                   ),
    .dac_ack                 ( dac_ack                                      ),
    .sw_ack                  ( sw_ack                                       ),

    .reg_core_status         ( reg_core_status      [15:0]                  ),
    .sensor_trigger_req      ( sensor_trigger_req                           ),
    .mos_val                 ( mos_val                                      ),
    .mos_req                 ( mos_req                                      ),
    .dds_addr                ( dds_addr             [9:0]                   ),
    .dds_req                 ( dds_req                                      ),
    .dac_val                 ( dac_val              [BANK_NUM*14-1 : 0]     ),
    .dac_req                 ( dac_req              [BANK_NUM-1 : 0]        ),
    .sw_val                  ( sw_val               [BANK_NUM*SW_NUM-1 : 0] ),
    .sw_req                  ( sw_req               [BANK_NUM-1 : 0]        )
);

initial
begin

    #1000_0000
    $finish;
end

    reg [71:0] c_state_tb;

    always @ (*) begin
        case (core_controller_DUT.c_state)
            8'd0 : c_state_tb = "IDLE     ";
            8'd1 : c_state_tb = "MOS_SET  ";
            8'd2 : c_state_tb = "TRIG     ";
            8'd3 : c_state_tb = "DDS_GET  ";
            8'd4 : c_state_tb = "DAC_SET  ";
            8'd5 : c_state_tb = "SW_SET   ";
            8'd6 : c_state_tb = "SW_LOOP  ";
            8'd7 : c_state_tb = "EXP_LOOP ";
            8'd8 : c_state_tb = "PIC_LOOP ";
            8'd9 : c_state_tb = "MOS_RESET";
            default : c_state_tb = "IDLE     ";
        endcase
    end

    always @ (posedge clk) begin
        mos_ack <= mos_req;
        dds_ack <= dds_req;
        dac_ack <= (dac_req > 0);
        sw_ack <= (sw_req > 0);
    end

    initial begin
        #8000
        reg_core_en <= 1'b1;
        #8000
        trigger_in <= 1'b1;
        #20
        trigger_in <= 1'b0;


        #8000000
        reg_core_en <= 1'b0;
        #20
        reg_core_mode <= 'd1;
        #20
        reg_core_en <= 1'b1;
    end

endmodule