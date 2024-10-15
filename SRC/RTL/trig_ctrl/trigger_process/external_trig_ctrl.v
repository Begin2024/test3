`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/11/08 17:33:13
// Design Name:
// Module Name: external_trig_ctrl
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


module external_trig_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire                  trigger_in              ,

    input wire [31:0]           reg_camera_trig_num     ,

    input wire [31:0]           reg_external_trig_cycle ,
    input wire                  reg_external_trig_enable,
    input wire [31:0]           reg_external_trig_width ,
    input wire [31:0]           reg_external_trig_delay ,
    input wire                  reg_external_trig_polar ,
    input wire [31:0]           reg_external_trig_num   ,
    output wire                 trigger_out
);



/******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/

    reg [3:0]                   trigger_in_dly          ;

    reg [31:0]                  cnt_dly                 ;

    reg [31:0]                  cnt_cycle               ;

    reg [31:0]                  cnt_trigger_in          ;

    reg [31:0]                  cnt_trigger_temp        ;


/******************************************************************************
*                                     REG                                     *
******************************************************************************/

    wire                        trigger_in_r            ;

    wire                        trigger_delay           ;



/******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/

    assign trigger_in_r         = trigger_in_dly == 4'b0001;

    always @ (posedge clk) begin
        trigger_in_dly          <= {trigger_in_dly[2:0], trigger_in};
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_trigger_in      <= 'd0;
        end else if (trigger_in_r == 1'b1  && cnt_trigger_in >= reg_camera_trig_num - 1'b1) begin
            cnt_trigger_in      <= 'd0;
        end else if (trigger_in_r == 1'b1) begin
            cnt_trigger_in      <= cnt_trigger_in + 1'b1;
        end else begin
            cnt_trigger_in      <= cnt_trigger_in;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_dly             <= 32'h3FFF_FFFF;
        end else if (trigger_in_r == 1'b1 && (cnt_dly >= reg_external_trig_delay - 1'b1) && cnt_trigger_in < reg_external_trig_num) begin
            cnt_dly             <= 'd0;
        end else if (cnt_dly >= reg_external_trig_delay - 1'b1) begin
            cnt_dly             <= 32'h3FFF_FFFF;
        end else begin
            cnt_dly             <= cnt_dly + 1'b1;
        end
    end

    // assign trigger_allow        = cnt_trigger_in < reg_external_trig_num;

    assign trigger_delay        = cnt_dly == reg_external_trig_delay - 1'b1;


    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_cycle           <= 'h3FFF_FFFF;
        end else if (trigger_delay == 1'b1) begin
            cnt_cycle           <= 'd0;
        end else if (cnt_cycle >= reg_external_trig_cycle - 1'b1 && cnt_trigger_temp < reg_external_trig_num) begin
            cnt_cycle           <= 'd0;
        end else if (cnt_cycle >= reg_external_trig_cycle - 1'b1) begin
            cnt_cycle           <= 'h3FFF_FFFF;
        end else begin
            cnt_cycle           <= cnt_cycle + 1'b1;
        end
    end

    assign trigger_temp         = cnt_cycle <= reg_external_trig_width - 1'b1;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_trigger_temp    <= 'h3FFF_FFFF;
        end else if (trigger_delay == 1'b1) begin
            cnt_trigger_temp    <= 'd0;
        end else if (cnt_cycle == 'd0) begin
            cnt_trigger_temp    <= cnt_trigger_temp + 1'b1;
        end else begin
            cnt_trigger_temp    <= cnt_trigger_temp;
        end
    end

    // Since the motherboard output is reversed by optocoupler, the output signal is not reversed after the polarity reversal is asserted here
    assign trigger_out          = reg_external_trig_polar ? trigger_temp : ~trigger_temp;


    /******************************************************/

    (* mark_debug = "true" *)    reg   [31:0]                             debug_cnt_cycle                 ;
    (* mark_debug = "true" *)    reg   [31:0]                             debug_cnt_dly                 ;
    (* mark_debug = "true" *)    reg   [31:0]                             debug_cnt_trigger_in                 ;
    (* mark_debug = "true" *)    reg   [31:0]                             debug_cnt_trigger_temp                 ;
    (* mark_debug = "true" *)    reg   [3:0]                             debug_trigger_in_dly                 ;
    (* mark_debug = "true" *)    reg                                    debug_trigger_in_r                 ;
    (* mark_debug = "true" *)    reg                                    debug_trigger_delay                 ;
    (* mark_debug = "true" *)    reg                                    debug_trigger_in                 ;
    (* mark_debug = "true" *)    reg                                    debug_trigger_out                 ;




    always @ (posedge clk) begin
        debug_cnt_cycle         <=  cnt_cycle         ;
        debug_cnt_dly           <=  cnt_dly           ;
        debug_cnt_trigger_in    <=  cnt_trigger_in    ;
        debug_cnt_trigger_temp  <=  cnt_trigger_temp  ;
        debug_trigger_in_dly    <=  trigger_in_dly    ;
        debug_trigger_in_r      <=  trigger_in_r      ;
        debug_trigger_delay     <=  trigger_delay     ;
        debug_trigger_in        <=  trigger_in        ;
        debug_trigger_out       <=  trigger_out       ;

    end


endmodule