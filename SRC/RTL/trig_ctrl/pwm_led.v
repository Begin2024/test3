/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-30 10:59:24
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2022-11-23 09:19:56
#FilePath     : pwm_led.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/
module pwm_led(
    input                           clk                             ,
    input                           rst                             ,

    input           [5:0]           led_pwm_start                   ,
    input           [5:0]           led_pwm_polar                   , // 1'b0:default low.active high; 1'b1:default high.active low

    input           [31:0]          led_pwm_width_0                 ,
    input           [31:0]          led_pwm_toggle_width_0          ,

    input           [31:0]          led_pwm_width_1                 ,
    input           [31:0]          led_pwm_toggle_width_1          ,

    input           [31:0]          led_pwm_width_2                 ,
    input           [31:0]          led_pwm_toggle_width_2          ,

    input           [31:0]          led_pwm_width_3                 ,
    input           [31:0]          led_pwm_toggle_width_3          ,

    input           [31:0]          led_pwm_width_4                 ,
    input           [31:0]          led_pwm_toggle_width_4          ,

    input           [31:0]          led_pwm_width_5                 ,
    input           [31:0]          led_pwm_toggle_width_5          ,

    output          [5:0]           led_pwm
);

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/

reg                 [5:0]           led_pwm_start_d                 ;
reg                 [31:0]          led_pwm_cnt             [0:5]   ;
reg                 [5:0]           led_pwm_vld                     ;

/********************************************************************
*                        Wires Here                                 *
********************************************************************/

wire                [5:0]           led_pwm_start_r                 ;

wire                [31:0]          led_pwm_width           [0:5]   ;
wire                [31:0]          led_pwm_toggle_width    [0:5]   ;


/********************************************************************
*                        Logic Here                                 *
********************************************************************/

assign led_pwm_width[0] = led_pwm_width_0;
assign led_pwm_width[1] = led_pwm_width_1;
assign led_pwm_width[2] = led_pwm_width_2;
assign led_pwm_width[3] = led_pwm_width_3;
assign led_pwm_width[4] = led_pwm_width_4;
assign led_pwm_width[5] = led_pwm_width_5;

assign led_pwm_toggle_width[0] = led_pwm_toggle_width_0;
assign led_pwm_toggle_width[1] = led_pwm_toggle_width_1;
assign led_pwm_toggle_width[2] = led_pwm_toggle_width_2;
assign led_pwm_toggle_width[3] = led_pwm_toggle_width_3;
assign led_pwm_toggle_width[4] = led_pwm_toggle_width_4;
assign led_pwm_toggle_width[5] = led_pwm_toggle_width_5;

genvar i ;

generate
for (i = 0 ; i <= 5 ; i = i+1)
begin : led_gen

    always @ (posedge clk,posedge rst) begin
        if (rst == 1'b1) begin
            led_pwm_start_d[i] <= 1'h0;
        end else begin
            led_pwm_start_d[i] <= led_pwm_start[i];
        end
    end

    assign led_pwm_start_r[i] = led_pwm_start[i] == 1'b1 && led_pwm_start_d[i] == 1'b0;

    always @ (posedge clk,posedge rst) begin
        if (rst == 1'b1) begin
            led_pwm_cnt[i] <= 32'h0;
        end else if (led_pwm_cnt[i] == led_pwm_width[i]) begin
            led_pwm_cnt[i] <= 32'h0;
        end else if (led_pwm_start_d[i] == 'h0) begin
            led_pwm_cnt[i] <= 32'h0;
        end else begin
            led_pwm_cnt[i] <= led_pwm_cnt[i] + 1'b1;
        end
    end


    // always @ (posedge clk,posedge rst) begin
    //     if (rst == 1'b1) begin
    //         led_pwm_cnt[i] <= 32'h0;
    //     end else if (led_pwm_cnt[i] == led_pwm_width[i]) begin
    //         led_pwm_cnt[i] <= 32'h0;
    //     end else if (led_pwm_start_r[i] == 1'b1) begin
    //         led_pwm_cnt[i] <= 32'h1;
    //     end else if (led_pwm_cnt[i] != 32'h0) begin
    //         led_pwm_cnt[i] <= led_pwm_cnt[i] + 1'b1;
    //     end else if (led_pwm_start_d[i] == 'h0) begin
    //         led_pwm_cnt[i] <= 32'h0;
    //     end
    // end

    always @ (posedge clk,posedge rst) begin
        if (rst == 1'b1) begin
            led_pwm_vld[i] <= 1'h0;
        end else if ((led_pwm_cnt[i] > 32'h0) && (led_pwm_cnt[i] <= led_pwm_toggle_width[i])) begin
            led_pwm_vld[i] <= 1'h1;
        end else begin
            led_pwm_vld[i] <= 1'h0;
        end
    end

    assign led_pwm[i] = led_pwm_vld[i] ^ led_pwm_polar[i];
end
endgenerate

endmodule

