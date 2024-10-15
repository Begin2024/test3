/********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2024-10-14 13:09:05
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-10-15 11:42:16
#FilePath     : frame_trigger_tb.v
#Description  : ---
#Copyright (c) 2024 by Insnex.com, All Rights Reserved.
********************************************************************/

module frame_trigger_tb(
);



/******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/


    localparam clk_period = 20;



/******************************************************************************
*                                    WIRE                                     *
******************************************************************************/

    wire frame_trigger_out;
    wire trigger_camera_out;
    reg io_output;


/******************************************************************************
*                                     REG                                     *
******************************************************************************/

    reg clk;
    reg rst;

    reg reg_frame_trigger_en;
    reg io_input_0          ;
    reg reg_trigger_polar   ;
    reg [31:0]reg_trigger_width   ;
    reg trigger_core_in     ;
    reg [31:0]reg_line_num        ;


    reg  trigger_camera_in;

    reg trigger_camera_in_dly;

    wire trigger_camera_in_r;

    reg [31:0] cnt;

    reg [31:0] reg_frame_trigger_cnt;

    reg frame_trigger_out_dly;

/******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/

always@(posedge clk or posedge rst)begin
    if(rst)begin
        frame_trigger_out_dly <= 1'b0;
    end
    else begin
        frame_trigger_out_dly <= frame_trigger_out;
    end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        reg_frame_trigger_cnt <= 32'd0;
    end
    else if(frame_trigger_out & ~frame_trigger_out_dly)begin
        reg_frame_trigger_cnt <= reg_frame_trigger_cnt + 1'b1;
    end
    else
        ;
end

    always #(clk_period/2) clk = ~clk;

    always #(clk_period*10) trigger_camera_in = ~trigger_camera_in;

    // assign trigger_camera_in_r = trigger_camera_in & (~trigger_camera_in_dly);

    // always@(posedge clk or posedge rst)begin
    //     if(rst)begin
    //         trigger_camera_in_dly <= 1'b0;
    //     end
    //     else begin
    //         trigger_camera_in_dly <= trigger_camera_in;
    //     end
    // end

    // always@(posedge clk or posedge rst)begin
    //     if(rst)begin
    //         cnt <= 32'd0;
    //     end
    //     else if(trigger_camera_in_r && cnt < 7)begin
    //         cnt <= cnt + 1'b1;
    //     end
    //     else if(trigger_camera_in_r && cnt == 7)begin
    //         cnt <= 32'd0;
    //     end
    //     else
    //         ;
    // end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trigger_core_in <= 1'b0;
        end
        else if(cnt == 5)begin
            trigger_core_in <= 1'b1;
        end
        else begin
            trigger_core_in <= 1'b0;
        end
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        io_input_0 = 1'b0;
        reg_frame_trigger_en = 1'b0;
        reg_trigger_polar = 1'b0;
        reg_trigger_width = 32'd10;
        reg_line_num = 32'd5000;
        trigger_camera_in = 0;

        #(clk_period*10)rst = 1'b1;
        #(clk_period*10)rst = 1'b0;
        #(clk_period*10)reg_frame_trigger_en = 1'b1;
        #(clk_period*10)io_input_0 = 1'b1;
        #(clk_period*200)io_input_0 = 1'b0;

        #(clk_period*100000)io_input_0 = 1'b1;
        #(clk_period*200)io_input_0 = 1'b0;

        #(clk_period*200000) $stop;

    end




/******************************************************************************
*                                   INSTANCE                                  *
******************************************************************************/

frame_trigger frame_trigger_inst (
    .clk                                            (clk                                            ),
    .rst                                            (rst                                            ),
    .reg_frame_trigger_en                           (reg_frame_trigger_en                           ),
    .frame_trigger                                  (io_input_0                                     ),
    .line_trigger                                   (trigger_camera_in                                     ),
    .reg_frame_trigger_polar                        (reg_trigger_polar                              ),
    .reg_frame_trigger_width                        (reg_trigger_width                        ),
    .reg_line_num                                   (reg_line_num                                   ),
    .trigger_out                                    (frame_trigger_out                              )
);






/******************************************************************************
*                                     IP                                      *
******************************************************************************/






endmodule