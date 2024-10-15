`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/11/01 16:06:59
// Design Name:
// Module Name: trigger_delay_ctrl
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

module trigger_delay_ctrl(
    input        clk                            ,
    input        rst                            ,
    input        trigger_in                     ,

    input [31:0] reg_camera_cycle               ,
    input [31:0] reg_camera_delay               ,//相机收到触发后一段时间曝光开始
    input [31:0] reg_camera_trig_num            ,

    // input [31:0] reg_external_start,
    // output wire trig_to_external,
    output reg   trig_to_camera                 ,
    output reg   trig_to_core
);



/******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/






/******************************************************************************
*                                    WIRE                                     *
******************************************************************************/



    wire [31:0] trig_in_cycle;


/******************************************************************************
*                                     REG                                     *
******************************************************************************/
    reg [31:0] cnt_camera_cycle         ;
    reg [31:0] cnt_camera_delay         ;



    reg [31:0] cnt_trig_in_cycle        ;
    reg [31:0] cnt_camera_trig_num      ;

    reg         trig_in_flag            ;

    reg         delay_flag              ;
    reg [31:0]  cnt_pic_num             ;
    reg [1:0]   trigger_in_dly          ;
    reg [1:0]   trig_to_camera_dly      ;




/******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/

    // assign trig_to_external = (cnt_pic_num == reg_external_start)&&(reg_external_start != 32'b0);


    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_trig_in_cycle <= 'd0;
        end
        else if((cnt_trig_in_cycle >= (reg_camera_cycle -'d3)))begin
            cnt_trig_in_cycle <= 'd0;
        end
        else if((trigger_in_dly[0]==1'b1)&&(trigger_in_dly[1]==1'b0)&&(cnt_trig_in_cycle == 'd0))begin
            cnt_trig_in_cycle <= 'd1;
        end
        else if((trig_in_flag == 0)&&(cnt_trig_in_cycle < (reg_camera_cycle -'d3)))begin                 // 3 cycle == trigger_in_r ---> trig_to_camera_r
            cnt_trig_in_cycle <= cnt_trig_in_cycle + 1'b1;
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_camera_trig_num <= 'd0;
        end
        else if((cnt_camera_trig_num >= reg_camera_trig_num - 1'b1)&&((cnt_trig_in_cycle >= (reg_camera_cycle -'d3))))begin
            cnt_camera_trig_num <= 'd0;
        end
        else if(cnt_trig_in_cycle >= (reg_camera_cycle -'d3))begin
            cnt_camera_trig_num <= cnt_camera_trig_num + 1'b1;
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trig_in_flag <= 1'b1;
        end
        else if((cnt_trig_in_cycle >= (reg_camera_cycle -'d3))&&(cnt_camera_trig_num >= reg_camera_trig_num - 1'b1))begin
            trig_in_flag <= 1'b1;
        end
        else if((trigger_in_dly[0]==1'b1)&&(trigger_in_dly[1]==1'b0)&&(cnt_camera_trig_num >= reg_camera_trig_num - 1'b1)&&((cnt_trig_in_cycle >= (reg_camera_cycle -'d3))))begin
            trig_in_flag <= 1'b0;
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trigger_in_dly <= 2'b0;
        end
        else if(trig_in_flag == 1'b1)begin
            trigger_in_dly <= {trigger_in_dly[0], trigger_in};
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trig_to_camera_dly <= 1'b0;
        end
        else begin
            trig_to_camera_dly <= {trig_to_camera_dly[0], trig_to_camera};
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_pic_num <= 'd0;
        end
        else if((cnt_camera_cycle==1'b1)&&(cnt_pic_num < reg_camera_trig_num))begin
            cnt_pic_num <= cnt_pic_num + 1'b1;
        end
        else if((cnt_camera_cycle==0))begin
            cnt_pic_num <= 'd0;
        end
        else
            ;
    end


    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_camera_cycle <= 'd0;
        end
        else if(((trigger_in_dly[0]==1'b1)&&(trigger_in_dly[1]==1'b0)&&(cnt_camera_cycle == 0))||((cnt_camera_cycle >= reg_camera_cycle)&&(cnt_pic_num < reg_camera_trig_num)))begin
            cnt_camera_cycle <= 'd1;
        end
        else if((cnt_pic_num >= reg_camera_trig_num)&&(cnt_camera_cycle >= reg_camera_cycle-1))begin
            cnt_camera_cycle <= 'd0;
        end
        else if((cnt_camera_cycle != 'd0)&&(cnt_camera_cycle < reg_camera_cycle)&&(cnt_pic_num <= reg_camera_trig_num))begin
            cnt_camera_cycle <= cnt_camera_cycle + 1'b1;
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trig_to_camera <= 0;
        end
        else if((cnt_camera_cycle==1'b1)||(cnt_camera_cycle==(reg_camera_cycle>>1)))begin
            trig_to_camera <= ~trig_to_camera;
        end
        else
            ;
    end

    /***************************************trig_to_core*********************************/

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            delay_flag <= 1'b0;
        end
        else if((trig_to_camera_dly[1]==0)&&(trig_to_camera_dly[0]==1'b1)&&(cnt_pic_num=='d1))begin
            delay_flag <= 1'b1;
        end
        else begin
            delay_flag <= 1'b0;
        end
    end



    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_camera_delay <= 'd0;
        end
        else if(delay_flag==1)begin
            cnt_camera_delay <= 'd1;
        end
        else if((cnt_camera_delay<reg_camera_delay)&&(cnt_camera_delay!=0))begin
            cnt_camera_delay <= cnt_camera_delay + 1'b1;
        end
        else if(cnt_camera_delay >= reg_camera_delay)begin
            cnt_camera_delay <= 'd0;
        end
        else
            ;
    end


    always@(posedge clk or posedge rst)begin
        if(rst)begin
            trig_to_core <= 1'b0;
        end
        else if(cnt_camera_delay >= reg_camera_delay)begin
            trig_to_core <= 1'b1;
        end
        else begin
            trig_to_core<=0;
        end
    end

/******************************************************************************
*                                   INSTANCE                                  *
******************************************************************************/






/******************************************************************************
*                                     IP                                      *
******************************************************************************/


/*********************************debug***************************************/

(* mark_debug = "true" *)reg [31:0] debug_cnt_camera_cycle;
(* mark_debug = "true" *)reg [31:0] debug_cnt_camera_delay;
(* mark_debug = "true" *)reg [31:0] debug_cnt_trig_in_cycle;
(* mark_debug = "true" *)reg [31:0] debug_cnt_camera_trig_num;
(* mark_debug = "true" *)reg debug_trig_in_flag;
(* mark_debug = "true" *)reg debug_delay_flag;
(* mark_debug = "true" *)reg [31:0] debug_cnt_pic_num;
(* mark_debug = "true" *)reg [1:0] debug_trigger_in_dly;
(* mark_debug = "true" *)reg [1:0] debug_trig_to_camera_dly;
(* mark_debug = "true" *)reg [31:0] debug_trig_in_cycle;
(* mark_debug = "true" *)reg debug_trig_to_camera;
(* mark_debug = "true" *)reg debug_trig_to_core;
always@(posedge clk)begin
 debug_cnt_camera_cycle <= cnt_camera_cycle;
 debug_cnt_camera_delay <= cnt_camera_delay;
 debug_cnt_trig_in_cycle <= cnt_trig_in_cycle;
 debug_cnt_camera_trig_num <= cnt_camera_trig_num;
 debug_trig_in_flag <= trig_in_flag;
 debug_delay_flag <= delay_flag;
 debug_cnt_pic_num <= cnt_pic_num;
 debug_trigger_in_dly <= trigger_in_dly;
 debug_trig_to_camera_dly <= trig_to_camera_dly;
 debug_trig_in_cycle <= trig_in_cycle;
 debug_trig_to_camera <= trig_to_camera;
 debug_trig_to_core <= trig_to_core;
end


endmodule
