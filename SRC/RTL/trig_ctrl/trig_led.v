/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-10-31 12:17:53
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-09-12 13:27:24
#FilePath     : trig_led.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/

module trig_led(
    input   wire                        clk_i                           ,
    input   wire                        rst_i                           ,

    input               [11:0]          reg_led_polar                   ,

    input   wire                        trigger_i                       ,
    input   wire        [31:0]          led_cnt_max_i                   ,
    input   wire        [31:0]          led_pwm_start_i_0               ,
    input   wire        [31:0]          led_pwm_end_i_0                 ,
    input   wire        [31:0]          led_pwm_start_i_1               ,
    input   wire        [31:0]          led_pwm_end_i_1                 ,
    input   wire        [31:0]          led_pwm_start_i_2               ,
    input   wire        [31:0]          led_pwm_end_i_2                 ,
    input   wire        [31:0]          led_pwm_start_i_3               ,
    input   wire        [31:0]          led_pwm_end_i_3                 ,
    input   wire        [31:0]          led_pwm_start_i_4               ,
    input   wire        [31:0]          led_pwm_end_i_4                 ,
    input   wire        [31:0]          led_pwm_start_i_5               ,
    input   wire        [31:0]          led_pwm_end_i_5                 ,
    input   wire        [31:0]          led_pwm_start_i_6               ,
    input   wire        [31:0]          led_pwm_end_i_6                 ,
    input   wire        [31:0]          led_pwm_start_i_7               ,
    input   wire        [31:0]          led_pwm_end_i_7                 ,
    input   wire        [31:0]          led_pwm_start_i_8               ,
    input   wire        [31:0]          led_pwm_end_i_8                 ,
    input   wire        [31:0]          led_pwm_start_i_9               ,
    input   wire        [31:0]          led_pwm_end_i_9                 ,
    input   wire        [31:0]          led_pwm_start_i_10              ,
    input   wire        [31:0]          led_pwm_end_i_10                ,
    input   wire        [31:0]          led_pwm_start_i_11              ,
    input   wire        [31:0]          led_pwm_end_i_11                ,

    input   wire        [31:0]          trig_start_i_0                  ,
    input   wire        [31:0]          trig_end_i_0                    ,
    input   wire        [31:0]          trig_start_i_1                  ,
    input   wire        [31:0]          trig_end_i_1                    ,
    input   wire        [31:0]          trig_start_i_2                  ,
    input   wire        [31:0]          trig_end_i_2                    ,
    input   wire        [31:0]          trig_start_i_3                  ,
    input   wire        [31:0]          trig_end_i_3                    ,
    input   wire        [31:0]          trig_start_i_4                  ,
    input   wire        [31:0]          trig_end_i_4                    ,
    input   wire        [31:0]          trig_start_i_5                  ,
    input   wire        [31:0]          trig_end_i_5                    ,
    input   wire                        reg_trig_out_polar              ,

    input   wire        [ 5:0]          trigger_multi_en                ,

    output  wire        [11:0]          led_pwm_o                       ,
    output  wire                        trigger_o
);


/////////////////////////////////////////////////////////////////////////////////
//parameter define


//wire define
wire                 pos_trig        ;
wire     [31:0]      led_pwm_start [0:11] ;
wire     [31:0]      led_pwm_end [0:11] ;
wire     [31:0]      trig_start      ;
wire     [31:0]      trig_end        ;

//reg define
reg  [31:0]      led_pwm_cnt     ;
reg              trig_r1         ;
reg  [11:0]      led_pwm         ;
reg              trigger         ;


/////////////////////////////////////////////////////////////////////////////////

assign led_pwm_start[0]  = led_pwm_start_i_0;
assign led_pwm_start[1]  = led_pwm_start_i_1;
assign led_pwm_start[2]  = led_pwm_start_i_2;
assign led_pwm_start[3]  = led_pwm_start_i_3;
assign led_pwm_start[4]  = led_pwm_start_i_4;
assign led_pwm_start[5]  = led_pwm_start_i_5;
assign led_pwm_start[6]  = led_pwm_start_i_6;
assign led_pwm_start[7]  = led_pwm_start_i_7;
assign led_pwm_start[8]  = led_pwm_start_i_8;
assign led_pwm_start[9]  = led_pwm_start_i_9;
assign led_pwm_start[10] = led_pwm_start_i_10;
assign led_pwm_start[11] = led_pwm_start_i_11;

assign led_pwm_end[0]  = led_pwm_end_i_0;
assign led_pwm_end[1]  = led_pwm_end_i_1;
assign led_pwm_end[2]  = led_pwm_end_i_2;
assign led_pwm_end[3]  = led_pwm_end_i_3;
assign led_pwm_end[4]  = led_pwm_end_i_4;
assign led_pwm_end[5]  = led_pwm_end_i_5;
assign led_pwm_end[6]  = led_pwm_end_i_6;
assign led_pwm_end[7]  = led_pwm_end_i_7;
assign led_pwm_end[8]  = led_pwm_end_i_8;
assign led_pwm_end[9]  = led_pwm_end_i_9;
assign led_pwm_end[10] = led_pwm_end_i_10;
assign led_pwm_end[11] = led_pwm_end_i_11;

assign trigger_o = trigger ^ reg_trig_out_polar;


always @(posedge clk_i)
    if (rst_i) begin
        trig_r1 <= 1'b0;
    end
    else begin
        trig_r1 <= trigger_i;
    end

assign pos_trig = ~trig_r1 & trigger_i;

always @(posedge clk_i)
    if (rst_i)
        led_pwm_cnt <= 'd0;
    // else if (pos_trig == 1'b1)
    //     led_pwm_cnt <= 'd1;
    else if ((pos_trig == 1'b1) && (led_pwm_cnt == 'd0))
        led_pwm_cnt <= 'd1;
    else if (led_pwm_cnt >= led_cnt_max_i)
        led_pwm_cnt <= 'd0;
    else if (led_pwm_cnt != 'd0)
        led_pwm_cnt <= led_pwm_cnt + 1'b1;
    else
        led_pwm_cnt <= 'd0;

always @(posedge clk_i)
    if (rst_i)
        trigger <= 1'b0;
    else if ((led_pwm_cnt >= trig_start_i_0) && (led_pwm_cnt <= trig_end_i_0) && (trigger_multi_en[0] == 1'b1))
        trigger <= 1'b1;
    else if ((led_pwm_cnt >= trig_start_i_1) && (led_pwm_cnt <= trig_end_i_1) && (trigger_multi_en[1] == 1'b1))
        trigger <= 1'b1;
    else if ((led_pwm_cnt >= trig_start_i_2) && (led_pwm_cnt <= trig_end_i_2) && (trigger_multi_en[2] == 1'b1))
        trigger <= 1'b1;
    else if ((led_pwm_cnt >= trig_start_i_3) && (led_pwm_cnt <= trig_end_i_3) && (trigger_multi_en[3] == 1'b1))
        trigger <= 1'b1;
    else if ((led_pwm_cnt >= trig_start_i_4) && (led_pwm_cnt <= trig_end_i_4) && (trigger_multi_en[4] == 1'b1))
        trigger <= 1'b1;
    else if ((led_pwm_cnt >= trig_start_i_5) && (led_pwm_cnt <= trig_end_i_5) && (trigger_multi_en[5] == 1'b1))
        trigger <= 1'b1;
    else
        trigger <= 1'b0;


generate
    genvar i;

    for (i = 0; i < 12 ; i = i + 1 )
    begin : led_gen

        always @(posedge clk_i)
            if (rst_i)
                led_pwm[i] <= 1'b0;
            else if ((led_pwm_cnt >= led_pwm_start[i]) && (led_pwm_cnt < led_pwm_end[i]))
                led_pwm[i] <= 1'b1;
            else
                led_pwm[i] <= 1'b0;

        assign led_pwm_o[i] = led_pwm[i] ^ reg_led_polar[i];

    end

endgenerate




endmodule


// // -----------------------------------------------------------------------------
// // Copyright (c) 2022-2022 All rights reserved
// // -----------------------------------------------------------------------------
// // Author : tingxuan hu (Sean)
// // File   : trig_led.v
// // Create : 2022-10-24 13:20:33
// // Revise : 2022-10-24 13:20:33
// // Editor : sublime text3, tab size (4)
// // Tool    : VIVADO 2022.1
// // Target : Xilinx K7
// // Version: V1.0
// // Description:
// // -----------------------------------------------------------------------------
// `timescale 1ns / 1ns
// module trig_led(
//  input   wire                        clk_i                           ,
//  input   wire                        rst_i                           ,
//  input   wire                        trigger_i                       ,

//  input   wire        [31:0]          led_pwm_delay_i                 ,
//  input   wire        [31:0]          led_pwm_high_width_i            ,

//  output  wire                        led_pwm_o
//     );


// /////////////////////////////////////////////////////////////////////////////////
// //parameter define


// //wire define
// wire                 pos_trig        ;

// //reg define
// reg  [31:0]      led_delay_cnt   ;
// reg  [31:0]      led_high_cnt    ;
// reg              trig_r1,trig_r2 ;
// reg              led_pwm         ;
// reg              trig_flag       ;


// /////////////////////////////////////////////////////////////////////////////////

// always @(posedge clk_i)
//  if (rst_i) begin
//      trig_r1 <= 1'b0;
//      trig_r2 <= 1'b0;
//  end
//  else begin
//      trig_r1 <= trigger_i;
//      trig_r2 <= trig_r1;
//  end

// assign pos_trig = ~trig_r2 & trig_r1;

// always @(posedge clk_i)
//  if (rst_i)
//      trig_flag <= 1'b0;
//  else if (trig_flag == 1'b1 && led_high_cnt == led_pwm_high_width_i)
//      trig_flag <= 1'b0;
//  else if (pos_trig == 1'b1)
//      trig_flag <= 1'b1;

// always @(posedge clk_i)
//  if (rst_i)
//      led_delay_cnt <= 'd0;
//  else if (trig_flag == 1'b0)
//      led_delay_cnt <= 'd0;
//  else if (led_delay_cnt == led_pwm_delay_i)
//      led_delay_cnt <= led_delay_cnt;
//  else if (trig_flag == 1'b1)
//      led_delay_cnt <= led_delay_cnt + 1'b1;

// always @(posedge clk_i)
//  if (rst_i)
//      led_high_cnt <= 'd0;
//  else if (trig_flag == 1'b0)
//      led_high_cnt <= 'd0;
//  else if (led_high_cnt == led_pwm_high_width_i)
//      led_high_cnt <= led_high_cnt;
//  else if (trig_flag == 1'b1 && led_delay_cnt == led_pwm_delay_i)
//      led_high_cnt <= led_high_cnt + 1'b1;

// // always @(posedge clk_i)
// //   if (rst_i)
// //       led_pwm <= 1'b0;
// //   else if (trig_flag == 1'b0)
// //       led_pwm <= 1'b0;
// //   else if (led_delay_cnt == led_pwm_delay_i && led_high_cnt <= led_pwm_high_width_i)
// //       led_pwm <= 1'b1;

// // assign led_pwm_o = led_pwm;

// assign led_pwm_o = (trig_flag == 1'b1 && led_delay_cnt == led_pwm_delay_i && led_high_cnt <= led_pwm_high_width_i) ? 1'b1 : 1'b0;

// endmodule
