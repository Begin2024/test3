module frame_trigger(
    input clk,
    input rst,
    input reg_frame_trigger_en,                 //module enable
    input frame_trigger,                    //IO
    // input reg_frame_trigger_polar,
    input [31:0] reg_frame_trigger_width,
    input line_trigger,                     // encoder/soft
    input [31:0] reg_line_num,
    output  trigger_out
);



/******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/






/******************************************************************************
*                                    WIRE                                     *
******************************************************************************/
wire frame_trigger_r;

// wire frame_en;

wire trigger_out_r;


/******************************************************************************
*                                     REG                                     *
******************************************************************************/


reg [31:0] line_trigger_counter;
reg [1:0]  frame_trigger_dly;
reg line_cnt_vld;

reg trigger_out_temp;

reg trigger_out_temp_dly;

reg [31:0] trigger_filter_cnt;
/******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/
// assign frame_en = reg_frame_trigger_polar == 1'b0 ? frame_trigger : ~frame_trigger;
assign frame_trigger_r = (~frame_trigger_dly[1]) & frame_trigger_dly[0];

assign trigger_out_r = trigger_out_temp & (~trigger_out_temp_dly);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        trigger_filter_cnt <= 32'd0;
    end
    else if(reg_frame_trigger_en == 1'b0)begin
        trigger_filter_cnt <= 32'd0;
    end
    else if(frame_trigger_r == 1'b1)begin
        trigger_filter_cnt <= 1'b1;
    end
    else if(frame_trigger_dly[1] == 1'b1 && trigger_filter_cnt == reg_frame_trigger_width)begin
        trigger_filter_cnt <= 32'd0;
    end
    else if(frame_trigger_dly[1] == 1'b1 && trigger_filter_cnt < reg_frame_trigger_width && trigger_filter_cnt != 32'd0)begin
        trigger_filter_cnt <= trigger_filter_cnt + 1'b1;
    end
    else
        ;
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        frame_trigger_dly <= 2'b00;
    end
    else begin
        frame_trigger_dly <= {frame_trigger_dly[0], frame_trigger};
    end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        line_cnt_vld <= 1'b0;
    end
    else if(frame_trigger_dly[1] == 1'b1 && trigger_filter_cnt == reg_frame_trigger_width && line_trigger_counter < reg_line_num)begin
        line_cnt_vld <= 1'b1;
    end
    else if(line_trigger_counter == reg_line_num)begin
        line_cnt_vld <= 1'b0;
    end
    else
        ;
end



always@(posedge clk or posedge rst)begin
    if(rst)begin
        line_trigger_counter <= 32'd0;
    end
    else if(trigger_out_r && line_trigger_counter < reg_line_num)begin
        line_trigger_counter <= line_trigger_counter + 1'b1;
    end
    else if(line_trigger_counter == reg_line_num)begin
        line_trigger_counter <= 32'd0;
    end
    else
        ;
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        trigger_out_temp <= 1'b0;
    end
    else if(line_cnt_vld && line_trigger)begin
        trigger_out_temp <= 1'b1;
    end
    else begin
        trigger_out_temp <= 1'b0;
    end
end


always@(posedge clk or posedge rst)begin
    if(rst)begin
        trigger_out_temp_dly <= 1'b0;
    end
    else begin
        trigger_out_temp_dly <= trigger_out_temp;
    end
end

assign trigger_out = reg_frame_trigger_en ? trigger_out_temp : line_trigger;

/******************************************************************************
*                                   INSTANCE                                  *
******************************************************************************/






/******************************************************************************
*                                     IP                                      *
******************************************************************************/






endmodule