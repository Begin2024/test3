/********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2023-11-01 19:07:43
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-11-03 09:53:06
#FilePath     : tb_trig_delay_ctrl.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/11/01 19:07:46
// Design Name:
// Module Name: tb_trig_delay_ctrl
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module tb_trig_delay_ctrl(

    );

    localparam clk_period = 'd8;
    localparam T='d4152;
    reg clk;
    reg rst;
    reg trigger_in;
    reg [31:0]reg_camera_cycle;
    reg [31:0]reg_camera_delay;
    reg [31:0]reg_pic_num;
    wire trig_to_camera;
    wire trig_to_core;



    reg [31:0] cnt;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt <= 0;
        end
        else if(cnt<T)begin
            cnt<=cnt+1'b1;
        end
        else if(cnt==T)begin
            cnt<=1;
        end
        else
            ;
    end
    always #(clk_period/2) clk=~clk;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trigger_in<=0;
        end
        else if((cnt==1)||(cnt==T/2))begin
            trigger_in<=~trigger_in;
        end
        else
            ;
    end

    initial begin
        clk=0;
        rst=1;
        reg_pic_num=8;
        reg_camera_cycle='d3750;
        reg_camera_delay='d300;
        #(clk_period*6)rst=0;

        #(clk_period*101000) $stop;


    end

 trigger_delay_ctrl U1_test(
    .clk             (clk             ),
    .rst             (rst             ),
    .trigger_in      (trigger_in      ),
    .reg_camera_cycle(reg_camera_cycle),
    .reg_camera_delay(reg_camera_delay),//相机收到触发后一段时间曝光开始
    .reg_pic_num     (reg_pic_num     ),
    .trig_to_camera  (trig_to_camera  ),
    .trig_to_core    (trig_to_core    )
);
endmodule
