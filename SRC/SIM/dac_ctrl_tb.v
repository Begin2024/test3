    /********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2023-08-19 13:46:29
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-08-19 14:19:03
#FilePath     : dac_ctrl_tb.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/19 13:46:32
// Design Name:
// Module Name: dac_ctrl_tb
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


module dac_ctrl_tb(

    );
localparam clk_period='d10;
// dac_ctrl Inputs
    reg   clk;
    reg   rst;
    reg   [111:0]  dac_val;
    reg   [7:0]  dac_req;
    reg   [31:0]  reg_dac_time;
    reg [7:0]dac_req_dly;
    // dac_ctrl Outputs
    wire  dac_clk;
    wire  dac_wrt;
    wire  [13:0]  dac1_data_x;
    wire  [13:0]  dac2_data_x;
    wire  [13:0]  dac3_data_x;
    wire  [13:0]  dac4_data_x;
    wire  [13:0]  dac1_data_y;
    wire  [13:0]  dac2_data_y;
    wire  [13:0]  dac3_data_y;
    wire  [13:0]  dac4_data_y;
    wire  dac_ack;

    always #(clk_period/2) clk=~clk;



    // always@(posedge clk or posedge rst)begin
    //     if(rst)begin
    //         dac_req<=0;
    //     end
    //     else if(dac_ack==0)begin
    //         dac_req<=8'hff;
    //     end
    //     else begin
    //         dac_req<=0;
    //     end
    // end


    always@(posedge clk or posedge rst)begin
        if(rst)begin
            dac_req_dly<=0;
        end
        else begin
            dac_req_dly<=dac_req;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            dac_val<=112'b1;
        end
        else if((~dac_req_dly[0])&&(dac_req[0]))begin
            dac_val<={dac_val[110:0],1'b0};
        end
    end


integer i;

    initial begin
        clk=0;
        rst=1;
        reg_dac_time=10;
        dac_req=0;
        #(clk_period*4)rst=0;
        for(i=0;i<10;i=i+1)begin
        #(clk_period*100)
        @(posedge clk)dac_req<=8'h0f;
        #(clk_period)
        @(posedge clk)dac_req<=0;
        #(clk_period*100)
        @(posedge clk)dac_req<=8'hf0;
        #(clk_period)
        @(posedge clk)dac_req<=0;
        end
        #(clk_period*10000) $stop;
    end


    dac_ctrl  u_dac_ctrl (
        .clk                     ( clk           ),
        .rst                     ( rst           ),
        .dac_val                 ( dac_val       ),
        .dac_req                 ( dac_req       ),

        .dac_clk                 ( dac_clk       ),
        .dac_wrt                 ( dac_wrt       ),
        .dac1_data             ( dac1_data_x   ),
        .dac2_data             ( dac2_data_x   ),
        .dac3_data             ( dac3_data_x   ),
        .dac4_data             ( dac4_data_x   ),
//        .dac1_data_y             ( dac1_data_y   ),
//        .dac2_data_y             ( dac2_data_y   ),
//        .dac3_data_y             ( dac3_data_y   ),
//        .dac4_data_y             ( dac4_data_y   ),
        .dac_ack                 ( dac_ack       ),
        .reg_dac_time(reg_dac_time)
    );



endmodule
