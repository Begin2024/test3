/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-29 17:27:57
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2022-09-08 19:59:40
#FilePath     : trigger_io.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved. 
********************************************************************/
module trigger_io(
    input                           clk                             ,
    input                           rst                             ,

    input           [31:0]          reg_trigger_cycle               , //width for one trigger
    input                           reg_trigger_en                  ,
    input           [ 3:0]          reg_trigger_mode                , //trigger mode
    input           [31:0]          reg_trigger_num                 , //trigger times
    input           [31:0]          reg_trigger_delay               , //delay from meet condition to the trigger
    input           [31:0]          reg_trigger_width               , //ext_trigger min width(for deburr)
    input           [31:0]          reg_trigger_pulse               , //how many trigger for one ext-input

    input                           io_input_0                      ,
    input                           io_input_1                      ,

    output  reg                     io_trigger


);

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/

reg                 [3:0]           io_input_0_d                    ;
reg                 [3:0]           io_input_1_d                    ;
reg                                 trigger_enable_set              ;
reg                                 trigger_enable_clr              ;

reg                 [31:0]          trigger_enable_set_cnt          ;
reg                                 trigger_enable_set_delay        ;
reg                                 trigger_enable                  ;
reg                 [31:0]          trigger_cycle_cnt               ;
reg                 [31:0]          trigger_cnt                     ;

reg                 [3:0]           io_input_0_dly                  ;
reg                 [31:0]          io_input_0_deburr_cnt           ;
reg                                 io_input_0_deburr               ;
reg                 [31:0]          io_input_0_r_cnt                ;

reg                 [3:0]           io_input_1_dly                  ;
reg                 [31:0]          io_input_1_deburr_cnt           ;
reg                                 io_input_1_deburr               ;
reg                 [31:0]          io_input_1_r_cnt                ;

reg                 [31:0]          reg_trigger_delay_nozero        ;

/********************************************************************
*                        Wires Here                                 *
********************************************************************/
wire                                io_input_0_r                    ;
wire                                io_input_0_f                    ;
wire                                io_input_1_r                    ;
wire                                io_input_1_f                    ;


/********************************************************************
*                        Logic Here                                 *
********************************************************************/

always @ (posedge clk) begin
    io_input_0_dly <= {io_input_0_dly[2:0],io_input_0};
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_0_deburr_cnt <= 32'b0;
    end else if (reg_trigger_en == 1'b0) begin
        io_input_0_deburr_cnt <= 32'b0;
//    end else if (io_input_0_dly[3] == io_input_0_dly[2]) begin
    end else if (io_input_0 == 1'b1) begin 
        io_input_0_deburr_cnt <= io_input_0_deburr_cnt + 1'b1;
    end else begin
        io_input_0_deburr_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_0_deburr <= 1'b0;
    end else if (reg_trigger_en == 1'b0) begin 
        io_input_0_deburr <= 1'b0;
    end else if (io_input_0_deburr_cnt == reg_trigger_width - 1'b1) begin
//        io_input_0_deburr <= io_input_0_dly[2];
        io_input_0_deburr <= io_input_0;
    end else begin
        io_input_0_deburr <= io_input_0;
    end
end

always @ (posedge clk) begin
    io_input_0_d <= {io_input_0_d[2:0],io_input_0_deburr};
end

assign io_input_0_r = io_input_0_d[3] == 1'b0 && io_input_0_d[2] == 1'b1;
assign io_input_0_f = io_input_0_d[3] == 1'b1 && io_input_0_d[2] == 1'b0;

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_0_r_cnt <= 32'b0;
    end else if (trigger_enable_set == 1'b1) begin
        io_input_0_r_cnt <= 32'b0;
    end else if (io_input_0_r == 1'b1 && reg_trigger_mode == 4'h6) begin
        io_input_0_r_cnt <= io_input_0_r_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk) begin
    io_input_1_dly <= {io_input_1_dly[2:0],io_input_1};
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_1_deburr_cnt <= 32'b0;
    end else if (reg_trigger_en == 1'b0) begin
        io_input_1_deburr_cnt <= 32'b0;
//    end else if (io_input_1_dly[3] == io_input_1_dly[2]) begin
    end else if (io_input_1 == 1'b1) begin 
        io_input_1_deburr_cnt <= io_input_1_deburr_cnt + 1'b1;
    end else begin
        io_input_1_deburr_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_1_deburr <= 1'b0;
    end else if (reg_trigger_en == 1'b0) begin 
        io_input_1_deburr <= 1'b0;
    end else if (io_input_1_deburr_cnt == reg_trigger_width - 1'b1) begin
        io_input_1_deburr <= io_input_1;
    end else begin
        io_input_1_deburr <= io_input_1;
    end
end

always @ (posedge clk) begin
    io_input_1_d <= {io_input_1_d[2:0],io_input_1_deburr};
end

assign io_input_1_r = io_input_1_d[3] == 1'b0 && io_input_1_d[2] == 1'b1;
assign io_input_1_f = io_input_1_d[3] == 1'b1 && io_input_1_d[2] == 1'b0;

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_input_1_r_cnt <= 32'b0;
    end else if (trigger_enable_set == 1'b1) begin
        io_input_1_r_cnt <= 32'b0;
    end else if (io_input_1_r == 1'b1 && reg_trigger_mode == 4'h7) begin
        io_input_1_r_cnt <= io_input_1_r_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_enable_set <= 1'b0;
    end else if (reg_trigger_en == 1'b1) begin
        case (reg_trigger_mode)

            4'h0 : begin                                // TCM1,io_input_0 as start,io_input_1 as stop
                if (io_input_0_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h1 : begin                                // TCM1,io_input_1 as start,io_input_0 as stop
                if (io_input_1_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h2 : begin                                // TCM2,io_input_0 as start,fixed trigger numbers for one input pulse
                if (io_input_0_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h3 : begin                                // TCM2,io_input_1 as start,fixed trigger numbers for one input pulse
                if (io_input_1_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h4 : begin                                // TCM3,io_input_0 as valid,rise as start and fall as stop
                if (io_input_0_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h5 : begin                                // TCM3,io_input_1 as valid,rise as start and fall as stop
                if (io_input_1_r == 1'b1) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h6 : begin                                // TCM4,io_input_0 as pulse,fixed pulses make one (or more) trigger
                if (io_input_0_r_cnt == reg_trigger_pulse) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end

            4'h7 : begin                                // TCM4,io_input_1 as pulse,fixed pulses make one (or more) trigger
                if (io_input_1_r_cnt == reg_trigger_pulse) begin
                    trigger_enable_set <= 1'b1;
                end else begin
                    trigger_enable_set <= 1'b0;
                end
            end


            default : trigger_enable_set <= 1'b0;
        endcase
    end else begin
        trigger_enable_set <= 1'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_enable_clr <= 1'b0;
    end else if (reg_trigger_en == 1'b0) begin
        trigger_enable_clr <= 1'b1;
    end else if (trigger_enable == 1'b1) begin
        case (reg_trigger_mode)

            4'h0 : begin                                // TCM1,io_input_0 as start,io_input_1 as stop
                if (io_input_1_r == 1'b1) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h1 : begin                                // TCM1,io_input_1 as start,io_input_0 as stop
                if (io_input_0_r == 1'b1) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h2 : begin                                // TCM2,io_input_0 as start,fixed trigger numbers for one input pulse
                if (trigger_cnt == reg_trigger_num) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h3 : begin                                // TCM2,io_input_0 as start,fixed trigger numbers for one input pulse
                if (trigger_cnt == reg_trigger_num) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h4 : begin                                // TCM3,io_input_0 as valid,rise as start and fall as stop
                if (io_input_0_f == 1'b1) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h5 : begin                                // TCM3,io_input_1 as valid,rise as start and fall as stop
                if (io_input_1_f == 1'b1) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h6 : begin                                // TCM4,io_input_0 as pulse,fixed pulses make one (or more) trigger
                if (trigger_cnt == reg_trigger_num) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            4'h7 : begin                                // TCM4,io_input_1 as pulse,fixed pulses make one (or more) trigger
                if (trigger_cnt == reg_trigger_num) begin
                    trigger_enable_clr <= 1'b1;
                end else begin
                    trigger_enable_clr <= 1'b0;
                end
            end

            default : trigger_enable_clr <= 1'b0;
        endcase
    end else begin
        trigger_enable_clr <= 1'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_enable_set_cnt <= 32'b0;
    end else if (reg_trigger_en == 1'b0) begin
        trigger_enable_set_cnt <= 32'b0;
    end else if (trigger_enable_set_delay == 1'b1) begin
        trigger_enable_set_cnt <= 32'b0;
    end else if (trigger_enable_set == 1'b1) begin
        trigger_enable_set_cnt <= 32'h1;
    end else if (trigger_enable_set_cnt != 32'h0) begin
        trigger_enable_set_cnt <= trigger_enable_set_cnt + 1'h1;
    end else begin
        trigger_enable_set_cnt <= 32'h0;
    end
end

// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         reg_trigger_delay_nozero <= 32'h0;
//     end else if (reg_trigger_delay == 32'h0) begin
//         reg_trigger_delay_nozero <= 32'h1;
//     end else begin
//         reg_trigger_delay_nozero <= reg_trigger_delay;
//     end
// end

// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         trigger_enable_set_delay <= 1'b0;
//     end else if (trigger_enable_set_cnt == reg_trigger_delay_nozero) begin
//         trigger_enable_set_delay <= 1'b1;
//     end else begin
//         trigger_enable_set_delay <= 1'b0;
//     end
// end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_enable_set_delay <= 1'b0;
    end else if (reg_trigger_delay == 32'h0 && trigger_enable_set == 1'b1) begin
        trigger_enable_set_delay <= 1'b1;
    end else if (reg_trigger_delay != 32'h0 && trigger_enable_set_cnt == reg_trigger_delay - 'd7) begin
        trigger_enable_set_delay <= 1'b1;
    end else begin
        trigger_enable_set_delay <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_enable <= 1'b0;
    end else if (trigger_enable_clr == 1'b1) begin
        trigger_enable <= 1'b0;
    end else if (trigger_enable_set_delay == 1'b1) begin
        trigger_enable <= 1'b1;
    end else begin
        trigger_enable <= trigger_enable;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_cycle_cnt <= 32'b0;
    end else if (reg_trigger_en == 1'b0) begin
        trigger_cycle_cnt <= 32'b0;
    end else if (io_trigger == 1'b1) begin
        trigger_cycle_cnt <= 32'b0;
    end else if (trigger_enable == 1'b1) begin
        trigger_cycle_cnt <= trigger_cycle_cnt + 1'b1;
    end else begin
        trigger_cycle_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        io_trigger <= 1'b0;
    end else if (io_trigger == 1'b1) begin
        io_trigger <= 1'b0;
    end else if (trigger_enable_set_delay == 1'b1) begin
        io_trigger <= 1'b1;
    end else if (trigger_cycle_cnt == reg_trigger_cycle - 'd2) begin
        io_trigger <= 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        trigger_cnt <= 32'h0;
    end else if (reg_trigger_en == 1'b0) begin
        trigger_cnt <= 32'h0;
    end else if (trigger_enable == 1'b0) begin
        trigger_cnt <= 32'h0;
    end else if (io_trigger == 1'b1) begin
        trigger_cnt <= trigger_cnt + 1'b1;
    end else
        ;
end


(* dont_touch = "true" *)reg                            debug_io_input_0               ;
(* dont_touch = "true" *)reg                            debug_io_input_1               ;
(* dont_touch = "true" *)reg                            debug_io_trigger               ;
(* dont_touch = "true" *)reg [3:0]                      debug_io_input_0_d               ;
(* dont_touch = "true" *)reg [3:0]                      debug_io_input_1_d               ;
(* dont_touch = "true" *)reg                            debug_trigger_enable_set               ;
(* dont_touch = "true" *)reg                            debug_trigger_enable_clr               ;
(* dont_touch = "true" *)reg [31:0]                     debug_trigger_enable_set_cnt               ;
(* dont_touch = "true" *)reg                            debug_trigger_enable_set_delay               ;
(* dont_touch = "true" *)reg                            debug_trigger_enable               ;
(* dont_touch = "true" *)reg [31:0]                     debug_trigger_cycle_cnt               ;
(* dont_touch = "true" *)reg [31:0]                     debug_trigger_cnt               ;
(* dont_touch = "true" *)reg [3:0]                      debug_io_input_0_dly               ;
(* dont_touch = "true" *)reg [31:0]                     debug_io_input_0_deburr_cnt               ;
(* dont_touch = "true" *)reg                            debug_io_input_0_deburr               ;
(* dont_touch = "true" *)reg [31:0]                     debug_io_input_0_r_cnt               ;
(* dont_touch = "true" *)reg [3:0]                      debug_io_input_1_dly               ;
(* dont_touch = "true" *)reg [31:0]                     debug_io_input_1_deburr_cnt               ;
(* dont_touch = "true" *)reg                            debug_io_input_1_deburr               ;
(* dont_touch = "true" *)reg [31:0]                     debug_io_input_1_r_cnt               ;
(* dont_touch = "true" *)reg                            debug_io_input_0_r               ;
(* dont_touch = "true" *)reg                            debug_io_input_0_f               ;
(* dont_touch = "true" *)reg                            debug_io_input_1_r               ;
(* dont_touch = "true" *)reg                            debug_io_input_1_f               ;

always @ (posedge clk) begin
    debug_io_input_0 <= io_input_0;
end
always @ (posedge clk) begin
    debug_io_input_1 <= io_input_1;
end
always @ (posedge clk) begin
    debug_io_trigger <= io_trigger;
end
always @ (posedge clk) begin
    debug_io_input_0_d <= io_input_0_d;
end
always @ (posedge clk) begin
    debug_io_input_1_d <= io_input_1_d;
end
always @ (posedge clk) begin
    debug_trigger_enable_set <= trigger_enable_set;
end
always @ (posedge clk) begin
    debug_trigger_enable_clr <= trigger_enable_clr;
end
always @ (posedge clk) begin
    debug_trigger_enable_set_cnt <= trigger_enable_set_cnt;
end
always @ (posedge clk) begin
    debug_trigger_enable_set_delay <= trigger_enable_set_delay;
end
always @ (posedge clk) begin
    debug_trigger_enable <= trigger_enable;
end
always @ (posedge clk) begin
    debug_trigger_cycle_cnt <= trigger_cycle_cnt;
end
always @ (posedge clk) begin
    debug_trigger_cnt <= trigger_cnt;
end
always @ (posedge clk) begin
    debug_io_input_0_dly <= io_input_0_dly;
end
always @ (posedge clk) begin
    debug_io_input_0_deburr_cnt <= io_input_0_deburr_cnt;
end
always @ (posedge clk) begin
    debug_io_input_0_deburr <= io_input_0_deburr;
end
always @ (posedge clk) begin
    debug_io_input_0_r_cnt <= io_input_0_r_cnt;
end
always @ (posedge clk) begin
    debug_io_input_1_dly <= io_input_1_dly;
end
always @ (posedge clk) begin
    debug_io_input_1_deburr_cnt <= io_input_1_deburr_cnt;
end
always @ (posedge clk) begin
    debug_io_input_1_deburr <= io_input_1_deburr;
end
always @ (posedge clk) begin
    debug_io_input_1_r_cnt <= io_input_1_r_cnt;
end
always @ (posedge clk) begin
    debug_io_input_0_r <= io_input_0_r;
end
always @ (posedge clk) begin
    debug_io_input_0_f <= io_input_0_f;
end
always @ (posedge clk) begin
    debug_io_input_1_r <= io_input_1_r;
end
always @ (posedge clk) begin
    debug_io_input_1_f <= io_input_1_f;
end

endmodule

