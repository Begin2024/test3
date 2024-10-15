/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-29 17:27:42
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-10-07 17:53:19
#FilePath     : trigger_encoder.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/
module trigger_encoder(
    input                           clk                             ,
    input                           rst                             ,

    input                           reg_encoder_en                  ,
    input           [31:0]          reg_encoder_ignore              ,
    input           [ 3:0]          reg_encoder_cnt_mode            ,
    input           [ 3:0]          reg_encoder_dis_mode            ,
    input           [31:0]          reg_encoder_div                 ,
    input           [31:0]          reg_encoder_width               ,

    input                           encoder_a_in                    ,
    input                           encoder_b_in                    ,

    output                          encoder_trigger

);

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/
reg                 [3:0]           encoder_a_in_dly                ;
reg                 [31:0]          encoder_a_in_deburr_cnt         ;
reg                                 encoder_a_in_deburr             ;

reg                 [3:0]           encoder_b_in_dly                ;
reg                 [31:0]          encoder_b_in_deburr_cnt         ;
reg                                 encoder_b_in_deburr             ;

reg                 [3:0]           encoder_a_d                     ;
reg                 [3:0]           encoder_b_d                     ;

reg                 [64:0]          enc1_cnt                        ;
reg                 [64:0]          enc2_cnt                        ;
reg                 [64:0]          enc3_cnt                        ;
reg                 [64:0]          enc4_cnt                        ;
reg                 [64:0]          enc_cnt                         ;
reg                 [64:0]          enc_cnt_last                    ;

reg                                 enc_add                         ;
reg                                 enc_sub                         ;

reg                                 enc1_trigger                    ;
reg                                 enc2_trigger                    ;
reg                                 enc3_trigger                    ;
reg                                 enc4_trigger                    ;

reg                 [31:0]          encoder_ignore_a_cnt            ;
reg                 [31:0]          encoder_ignore_b_cnt            ;
reg                                 encoder_ignore_a_done           ;
reg                                 encoder_ignore_b_done           ;
reg                 [31:0]          encoder_ignore_cnt              ;
reg                                 encoder_ignore_done             ;

/********************************************************************
*                        Wires Here                                 *
********************************************************************/

wire                                encoder_a_r                     ;
wire                                encoder_b_r                     ;
wire                                encoder_a_f                     ;
wire                                encoder_a                       ;
wire                                encoder_b_f                     ;
wire                                encoder_b                       ;

// wire                [64:0]          enc_cnt                         ;

wire                [63:0]          enc_diff_pos                    ;
wire                [63:0]          enc_diff_neg                    ;



/********************************************************************
*                        Logic Here                                 *
********************************************************************/

always @ (posedge clk) begin
    encoder_a_in_dly <= {encoder_a_in_dly[2:0],encoder_a_in};
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_a_in_deburr_cnt <= 32'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_a_in_deburr_cnt <= 32'b0;
    end else if (encoder_a_in_dly[3] == encoder_a_in_dly[2]) begin
        encoder_a_in_deburr_cnt <= encoder_a_in_deburr_cnt + 1'b1;
    end else begin
        encoder_a_in_deburr_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_a_in_deburr <= 1'b0;
    end else if (encoder_a_in_deburr_cnt == reg_encoder_width) begin
        encoder_a_in_deburr <= encoder_a_in_dly[2];
    end else begin
        encoder_a_in_deburr <= encoder_a_in_deburr;
    end
end

always @ (posedge clk) begin
    encoder_b_in_dly <= {encoder_b_in_dly[2:0],encoder_b_in};
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_b_in_deburr_cnt <= 32'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_b_in_deburr_cnt <= 32'b0;
    end else if (encoder_b_in_dly[3] == encoder_b_in_dly[2]) begin
        encoder_b_in_deburr_cnt <= encoder_b_in_deburr_cnt + 1'b1;
    end else begin
        encoder_b_in_deburr_cnt <= 32'h0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_b_in_deburr <= 1'b0;
    end else if (encoder_b_in_deburr_cnt == reg_encoder_width) begin
        encoder_b_in_deburr <= encoder_b_in_dly[2];
    end else begin
        encoder_b_in_deburr <= encoder_b_in_deburr;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_ignore_a_cnt <= 32'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_ignore_a_cnt <= 32'b0;
    end else if (encoder_ignore_a_cnt == reg_encoder_ignore) begin
        encoder_ignore_a_cnt <= encoder_ignore_a_cnt;
    end else if (encoder_a_d[3] == 1'b0 && encoder_a_d[2] == 1'b1) begin
        encoder_ignore_a_cnt <= encoder_ignore_a_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_ignore_b_cnt <= 32'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_ignore_b_cnt <= 32'b0;
    end else if (encoder_ignore_b_cnt == reg_encoder_ignore) begin
        encoder_ignore_b_cnt <= encoder_ignore_b_cnt;
    end else if (encoder_b_d[3] == 1'b0 && encoder_b_d[2] == 1'b1) begin
        encoder_ignore_b_cnt <= encoder_ignore_b_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_ignore_a_done <= 1'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_ignore_a_done <= 1'b0;
    end else if (encoder_ignore_a_cnt == reg_encoder_ignore) begin
        encoder_ignore_a_done <= 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_ignore_b_done <= 1'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_ignore_b_done <= 1'b0;
    end else if (encoder_ignore_b_cnt == reg_encoder_ignore) begin
        encoder_ignore_b_done <= 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_ignore_done <= 1'b0;
    end else if (reg_encoder_en == 1'b0) begin
        encoder_ignore_done <= 1'b0;
    end else if (encoder_ignore_a_done == 1'b1 && reg_encoder_cnt_mode == 4'h0) begin   // for single port input
        encoder_ignore_done <= 1'b1;
    end else if (encoder_ignore_a_done == 1'b1 && encoder_ignore_b_done == 1'b1) begin  // for two port input
        encoder_ignore_done <= 1'b1;
    end else
        ;
end

always @ (posedge clk) begin
    encoder_a_d <= {encoder_a_d[2:0],encoder_a_in_deburr};
end

assign encoder_a_r = encoder_ignore_done && encoder_a_d[3] == 1'b0 && encoder_a_d[2] == 1'b1;
assign encoder_a_f = encoder_ignore_done && encoder_a_d[3] == 1'b1 && encoder_a_d[2] == 1'b0;
assign encoder_a   = encoder_ignore_done && encoder_a_d[2];

always @ (posedge clk) begin
    encoder_b_d <= {encoder_b_d[2:0],encoder_b_in_deburr};
end

assign encoder_b_r = encoder_ignore_done && encoder_b_d[3] == 1'b0 && encoder_b_d[2] == 1'b1;
assign encoder_b_f = encoder_ignore_done && encoder_b_d[3] == 1'b1 && encoder_b_d[2] == 1'b0;
assign encoder_b   = encoder_ignore_done && encoder_b_d[2];

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc1_cnt <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc1_cnt <= 65'b0;
    end else if (encoder_a_r == 1'h1) begin
        enc1_cnt <= enc1_cnt + 1'h1;
    end else begin
        enc1_cnt <= enc1_cnt;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc2_cnt <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc2_cnt <= 65'b0;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b0) begin
        enc2_cnt <= enc2_cnt + 1'h1;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b1) begin
        enc2_cnt <= enc2_cnt - 1'h1;
    end else begin
        enc2_cnt <= enc2_cnt;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc3_cnt <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc3_cnt <= 65'b0;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b0) begin
        enc3_cnt <= enc3_cnt + 1'h1;
    end else if (encoder_a_f == 1'h1 && encoder_b == 1'b1) begin
        enc3_cnt <= enc3_cnt + 1'h1;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b1) begin
        enc3_cnt <= enc3_cnt - 1'h1;
    end else if (encoder_a_f == 1'h1 && encoder_b == 1'b0) begin
        enc3_cnt <= enc3_cnt - 1'h1;
    end else begin
        enc3_cnt <= enc3_cnt;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc4_cnt <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc4_cnt <= 65'b0;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b0) begin
        enc4_cnt <= enc4_cnt + 1'h1;
    end else if (encoder_a_f == 1'h1 && encoder_b == 1'b1) begin
        enc4_cnt <= enc4_cnt + 1'h1;
    end else if (encoder_b_r == 1'h1 && encoder_a == 1'b1) begin
        enc4_cnt <= enc4_cnt + 1'h1;
    end else if (encoder_b_f == 1'h1 && encoder_a == 1'b0) begin
        enc4_cnt <= enc4_cnt + 1'h1;
    end else if (encoder_a_r == 1'h1 && encoder_b == 1'b1) begin
        enc4_cnt <= enc4_cnt - 1'h1;
    end else if (encoder_a_f == 1'h1 && encoder_b == 1'b0) begin
        enc4_cnt <= enc4_cnt - 1'h1;
    end else if (encoder_b_r == 1'h1 && encoder_a == 1'b0) begin
        enc4_cnt <= enc4_cnt - 1'h1;
    end else if (encoder_b_f == 1'h1 && encoder_a == 1'b1) begin
        enc4_cnt <= enc4_cnt - 1'h1;
    end else begin
        enc4_cnt <= enc4_cnt;
    end
end

//always @ (posedge clk,posedge rst) begin
//    if (rst ==1'b1) begin
//        enc_cnt <= 65'h0;
//    end else if (reg_encoder_cnt_mode == 4'h0) begin
//        enc_cnt <= enc1_cnt;
//    end else if (reg_encoder_cnt_mode == 4'h1) begin
//        enc_cnt <= enc2_cnt;
//    end else if (reg_encoder_cnt_mode == 4'h2) begin
//        enc_cnt <= enc3_cnt;
//    end else if (reg_encoder_cnt_mode == 4'h3) begin
//        enc_cnt <= enc4_cnt;
//    end else begin
//        enc_cnt <= enc1_cnt;
//    end
//end

// assign enc_cnt = reg_encoder_cnt_mode == 4'h0 ? enc1_cnt : (
//                  reg_encoder_cnt_mode == 4'h1 ? enc2_cnt : (
//                  reg_encoder_cnt_mode == 4'h2 ? enc3_cnt : (
//                  reg_encoder_cnt_mode == 4'h3 ? enc4_cnt : enc1_cnt)));

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc_cnt <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc_cnt <= 65'b0;
    end else if ((encoder_a_r == 1'h1                     ) && (reg_encoder_cnt_mode == 4'h0)) begin
        enc_cnt <= enc_cnt + 1'h1;
    end else if ((encoder_a_r == 1'h1 && encoder_b == 1'b0) && (reg_encoder_cnt_mode == 4'h1 || reg_encoder_cnt_mode == 4'h2 || reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt + 1'h1;
    end else if ((encoder_a_f == 1'h1 && encoder_b == 1'b1) && (                                reg_encoder_cnt_mode == 4'h2 || reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt + 1'h1;
    end else if ((encoder_b_r == 1'h1 && encoder_a == 1'b1) && (                                                                reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt + 1'h1;
    end else if ((encoder_b_f == 1'h1 && encoder_a == 1'b0) && (                                                                reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt + 1'h1;
    end else if ((encoder_a_r == 1'h1 && encoder_b == 1'b1) && (reg_encoder_cnt_mode == 4'h1 || reg_encoder_cnt_mode == 4'h2 || reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt - 1'h1;
    end else if ((encoder_a_f == 1'h1 && encoder_b == 1'b0) && (                                reg_encoder_cnt_mode == 4'h2 || reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt - 1'h1;
    end else if ((encoder_b_r == 1'h1 && encoder_a == 1'b0) && (                                                                reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt - 1'h1;
    end else if ((encoder_b_f == 1'h1 && encoder_a == 1'b1) && (                                                                reg_encoder_cnt_mode == 4'h3)) begin
        enc_cnt <= enc_cnt - 1'h1;
    end else begin
        enc_cnt <= enc_cnt;
    end
end

//forward or backward
always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc_add <= 1'h0;
    end else if (reg_encoder_cnt_mode == 4'h0) begin
        enc_add <= encoder_a_r == 1'b1;
    end else if (reg_encoder_cnt_mode == 4'h1) begin
        enc_add <= encoder_a_r == 1'h1 && encoder_b == 1'b0;
    end else if (reg_encoder_cnt_mode == 4'h2) begin
        enc_add <= (encoder_a_r == 1'h1 && encoder_b == 1'b0) || (encoder_a_f == 1'h1 && encoder_b == 1'b1);
    end else if (reg_encoder_cnt_mode == 4'h3) begin
        enc_add <= (encoder_a_r == 1'h1 && encoder_b == 1'b0) || (encoder_a_f == 1'h1 && encoder_b == 1'b1) || (encoder_b_r == 1'h1 && encoder_a == 1'b1) || (encoder_b_f == 1'h1 && encoder_a == 1'b0);
    end else begin
        enc_add <= encoder_a_r == 1'b1;
    end
end

//assign enc_add = reg_encoder_cnt_mode == 4'h0 ? (encoder_a_r == 1'b1) : (
//                 reg_encoder_cnt_mode == 4'h1 ? (encoder_a_r == 1'h1 && encoder_b == 1'b0) : (
//                 reg_encoder_cnt_mode == 4'h2 ? ((encoder_a_r == 1'h1 && encoder_b == 1'b0) || (encoder_a_f == 1'h1 && encoder_b == 1'b1)) : (
//                 reg_encoder_cnt_mode == 4'h3 ? ((encoder_a_r == 1'h1 && encoder_b == 1'b0) || (encoder_a_f == 1'h1 && encoder_b == 1'b1) || (encoder_b_r == 1'h1 && encoder_a == 1'b1) || (encoder_b_f == 1'h1 && encoder_a == 1'b0)) :  (encoder_a_r == 1'b1))));

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc_sub <= 1'h0;
    end else if (reg_encoder_cnt_mode == 4'h0) begin
        enc_sub <= 1'b0;
    end else if (reg_encoder_cnt_mode == 4'h1) begin
        enc_sub <= encoder_a_r == 1'h1 && encoder_b == 1'b1;
    end else if (reg_encoder_cnt_mode == 4'h2) begin
        enc_sub <= (encoder_a_r == 1'h1 && encoder_b == 1'b1) || (encoder_a_f == 1'h1 && encoder_b == 1'b0);
    end else if (reg_encoder_cnt_mode == 4'h3) begin
        enc_sub <= (encoder_a_r == 1'h1 && encoder_b == 1'b1) || (encoder_a_f == 1'h1 && encoder_b == 1'b0) || (encoder_b_r == 1'h1 && encoder_a == 1'b0) || (encoder_b_f == 1'h1 && encoder_a == 1'b1);
    end else begin
        enc_sub <= encoder_a_r == 1'b1;
    end
end

//assign enc_sub = reg_encoder_cnt_mode == 4'h0 ? 1'b0 : (
//                 reg_encoder_cnt_mode == 4'h1 ? (encoder_a_r == 1'h1 && encoder_b == 1'b1) : (
//                 reg_encoder_cnt_mode == 4'h2 ? ((encoder_a_r == 1'h1 && encoder_b == 1'b1) || (encoder_a_f == 1'h1 && encoder_b == 1'b0)) : (
//                 reg_encoder_cnt_mode == 4'h3 ? ((encoder_a_r == 1'h1 && encoder_b == 1'b1) || (encoder_a_f == 1'h1 && encoder_b == 1'b0) || (encoder_b_r == 1'h1 && encoder_a == 1'b0) || (encoder_b_f == 1'h1 && encoder_a == 1'b1)) :  1'b0)));

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc_cnt_last <= 65'b0;
    end else if (reg_encoder_en == 1'b0) begin
        enc_cnt_last <= 65'b0;
    end else if (reg_encoder_dis_mode == 4'h0 && enc_add == 1'b1 && enc_diff_pos == reg_encoder_div) begin
        enc_cnt_last <= enc_cnt;
    end else if (reg_encoder_dis_mode == 4'h1 && enc_add == 1'b1 && enc_diff_pos == reg_encoder_div) begin
        enc_cnt_last <= enc_cnt;
    end else if (reg_encoder_dis_mode == 4'h2 && enc_add == 1'b1 && enc_diff_pos == reg_encoder_div) begin
        enc_cnt_last <= enc_cnt;
    end else if (reg_encoder_dis_mode == 4'h2 && enc_sub == 1'b1) begin
        enc_cnt_last <= enc_cnt;
    end else if (reg_encoder_dis_mode == 4'h3 && enc_add == 1'b1 && enc_diff_pos == reg_encoder_div) begin
        enc_cnt_last <= enc_cnt;
    end else if (reg_encoder_dis_mode == 4'h3 && enc_sub == 1'b1 && enc_diff_neg == reg_encoder_div) begin
        enc_cnt_last <= enc_cnt;
    end else
        ;
end

assign enc_diff_pos[63:0] = enc_cnt - enc_cnt_last;
assign enc_diff_neg[63:0] = enc_cnt_last - enc_cnt;

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc1_trigger <= 1'b0;
    end else if (enc_add == 1'b1 && enc_cnt == 65'h0 && enc_cnt_last == 65'h0) begin
        enc1_trigger <= 1'b1;
    end else if (enc_add == 1'b1 && enc_diff_pos == {32'h0,reg_encoder_div}) begin
        enc1_trigger <= 1'b1;
    end else begin
        enc1_trigger <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc2_trigger <= 1'b0;
    end else if (enc_add == 1'b1 && enc_cnt == 65'h0 && enc_cnt_last == 65'h0) begin
        enc2_trigger <= 1'b1;
    end else if (enc_add == 1'b1 && enc_diff_pos == {32'h0,reg_encoder_div}) begin
        enc2_trigger <= 1'b1;
    end else begin
        enc2_trigger <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc3_trigger <= 1'b0;
    end else if (enc_add == 1'b1 && enc_cnt == 65'h0 && enc_cnt_last == 65'h0) begin
        enc3_trigger <= 1'b1;
    end else if (enc_add == 1'b1 && enc_diff_pos == {32'h0,reg_encoder_div}) begin
        enc3_trigger <= 1'b1;
    end else begin
        enc3_trigger <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        enc4_trigger <= 1'b0;
    end else if (enc_add == 1'b1 && enc_cnt == 65'h0 && enc_cnt_last == 65'h0) begin
        enc4_trigger <= 1'b1;
    end else if (enc_add == 1'b1 && enc_diff_pos == {32'h0,reg_encoder_div}) begin
        enc4_trigger <= 1'b1;
    end else if (enc_sub == 1'b1 && enc_diff_neg == {32'h0,reg_encoder_div}) begin
        enc4_trigger <= 1'b1;
    end else begin
        enc4_trigger <= 1'b0;
    end
end

assign encoder_trigger =    reg_encoder_dis_mode == 4'h0 ? enc1_trigger : (
                            reg_encoder_dis_mode == 4'h1 ? enc2_trigger : (
                            reg_encoder_dis_mode == 4'h2 ? enc3_trigger : (
                            reg_encoder_dis_mode == 4'h3 ? enc4_trigger : enc1_trigger)));






// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg                                debug_rst                           ;
(* mark_debug = "true" *)    reg                                debug_reg_encoder_en                ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_encoder_ignore            ;
(* mark_debug = "true" *)    reg    [ 3:0]                      debug_reg_encoder_cnt_mode          ;
(* mark_debug = "true" *)    reg    [ 3:0]                      debug_reg_encoder_dis_mode          ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_encoder_div               ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_encoder_width             ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_in                  ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_in                  ;
(* mark_debug = "true" *)    reg                                debug_encoder_trigger               ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_encoder_a_in_dly              ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_encoder_a_in_deburr_cnt       ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_in_deburr           ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_encoder_b_in_dly              ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_encoder_b_in_deburr_cnt       ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_in_deburr           ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_encoder_a_d                   ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_encoder_b_d                   ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc1_cnt                      ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc2_cnt                      ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc3_cnt                      ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc4_cnt                      ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc_cnt                       ;
(* mark_debug = "true" *)    reg    [64:0]                      debug_enc_cnt_last                  ;
(* mark_debug = "true" *)    reg                                debug_enc_add                       ;
(* mark_debug = "true" *)    reg                                debug_enc_sub                       ;
(* mark_debug = "true" *)    reg                                debug_enc1_trigger                  ;
(* mark_debug = "true" *)    reg                                debug_enc2_trigger                  ;
(* mark_debug = "true" *)    reg                                debug_enc3_trigger                  ;
(* mark_debug = "true" *)    reg                                debug_enc4_trigger                  ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_encoder_ignore_a_cnt          ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_encoder_ignore_b_cnt          ;
(* mark_debug = "true" *)    reg                                debug_encoder_ignore_a_done         ;
(* mark_debug = "true" *)    reg                                debug_encoder_ignore_b_done         ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_encoder_ignore_cnt            ;
(* mark_debug = "true" *)    reg                                debug_encoder_ignore_done           ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_r                   ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_r                   ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_f                   ;
(* mark_debug = "true" *)    reg                                debug_encoder_a                     ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_f                   ;
(* mark_debug = "true" *)    reg                                debug_encoder_b                     ;
(* mark_debug = "true" *)    reg    [63:0]                      debug_enc_diff_pos                  ;
(* mark_debug = "true" *)    reg    [63:0]                      debug_enc_diff_neg                  ;

always @ (posedge clk) begin
    debug_rst                            <= rst                           ;
    debug_reg_encoder_en                 <= reg_encoder_en                ;
    debug_reg_encoder_ignore             <= reg_encoder_ignore            ;
    debug_reg_encoder_cnt_mode           <= reg_encoder_cnt_mode          ;
    debug_reg_encoder_dis_mode           <= reg_encoder_dis_mode          ;
    debug_reg_encoder_div                <= reg_encoder_div               ;
    debug_reg_encoder_width              <= reg_encoder_width             ;
    debug_encoder_a_in                   <= encoder_a_in                  ;
    debug_encoder_b_in                   <= encoder_b_in                  ;
    debug_encoder_trigger                <= encoder_trigger               ;
    debug_encoder_a_in_dly               <= encoder_a_in_dly              ;
    debug_encoder_a_in_deburr_cnt        <= encoder_a_in_deburr_cnt       ;
    debug_encoder_a_in_deburr            <= encoder_a_in_deburr           ;
    debug_encoder_b_in_dly               <= encoder_b_in_dly              ;
    debug_encoder_b_in_deburr_cnt        <= encoder_b_in_deburr_cnt       ;
    debug_encoder_b_in_deburr            <= encoder_b_in_deburr           ;
    debug_encoder_a_d                    <= encoder_a_d                   ;
    debug_encoder_b_d                    <= encoder_b_d                   ;
    debug_enc1_cnt                       <= enc1_cnt                      ;
    debug_enc2_cnt                       <= enc2_cnt                      ;
    debug_enc3_cnt                       <= enc3_cnt                      ;
    debug_enc4_cnt                       <= enc4_cnt                      ;
    debug_enc_cnt                        <= enc_cnt                       ;
    debug_enc_cnt_last                   <= enc_cnt_last                  ;
    debug_enc_add                        <= enc_add                       ;
    debug_enc_sub                        <= enc_sub                       ;
    debug_enc1_trigger                   <= enc1_trigger                  ;
    debug_enc2_trigger                   <= enc2_trigger                  ;
    debug_enc3_trigger                   <= enc3_trigger                  ;
    debug_enc4_trigger                   <= enc4_trigger                  ;
    debug_encoder_ignore_a_cnt           <= encoder_ignore_a_cnt          ;
    debug_encoder_ignore_b_cnt           <= encoder_ignore_b_cnt          ;
    debug_encoder_ignore_a_done          <= encoder_ignore_a_done         ;
    debug_encoder_ignore_b_done          <= encoder_ignore_b_done         ;
    debug_encoder_ignore_cnt             <= encoder_ignore_cnt            ;
    debug_encoder_ignore_done            <= encoder_ignore_done           ;
    debug_encoder_a_r                    <= encoder_a_r                   ;
    debug_encoder_b_r                    <= encoder_b_r                   ;
    debug_encoder_a_f                    <= encoder_a_f                   ;
    debug_encoder_a                      <= encoder_a                     ;
    debug_encoder_b_f                    <= encoder_b_f                   ;
    debug_encoder_b                      <= encoder_b                     ;
    debug_enc_diff_pos                   <= enc_diff_pos                  ;
    debug_enc_diff_neg                   <= enc_diff_neg                  ;
end

endmodule










