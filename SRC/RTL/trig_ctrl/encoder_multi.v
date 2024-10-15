/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-05-18 10:00:01
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-12-11 15:42:46
#FilePath     : encoder_multi.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module encoder_multi(
    input                           clk                             ,
    input                           rst                             ,

    input                           reg_encoder_multi_en            ,
    input           [4:0]           reg_encoder_multi_coe           ,

    input                           encoder_a_in                    ,
    input                           encoder_b_in                    ,

    output  reg                     encoder_multi_a                 ,
    output  reg                     encoder_multi_b


);


/********************************************************************
*                         Regs Here                                 *
********************************************************************/
reg                 [5:0]           encoder_multi                   ;

reg                 [3:0]           encoder_a_in_dly                ;
reg                 [3:0]           encoder_b_in_dly                ;
reg                 [31:0]          encoder_cnt                     ;
reg                                 encoder_halt                    ;
reg                                 encoder_dir                     ;
reg                 [31:0]          encoder_width                   ;
reg                 [31:0]          encoder_multi_cnt               ;
reg                 [31:0]          encoder_multi_cnt_d             ;
reg                 [31:0]          encoder_multi_phase             ;
reg                 [5:0]           encoder_multi_turn_cnt          ;
reg                 [31:0]          encoder_width_lock              ;

/********************************************************************
*                         Wires Here                                *
********************************************************************/
wire                                encoder_a_in_d                  ;
wire                                encoder_a_in_r                  ;
wire                                encoder_a_in_f                  ;
wire                                encoder_b_in_d                  ;
wire                                encoder_b_in_r                  ;
wire                                encoder_b_in_f                  ;

/********************************************************************
*                         Logic Here                                *
********************************************************************/

always @ (posedge clk) begin
    encoder_a_in_dly <= {encoder_a_in_dly[2:0],encoder_a_in};
end

assign encoder_a_in_r = encoder_a_in_dly[3] == 1'b0 && encoder_a_in_dly[2] == 1'b1;
assign encoder_a_in_f = encoder_a_in_dly[3] == 1'b1 && encoder_a_in_dly[2] == 1'b0;
assign encoder_a_in_d = encoder_a_in_dly[2];

always @ (posedge clk) begin
    encoder_b_in_dly <= {encoder_b_in_dly[2:0],encoder_b_in};
end

assign encoder_b_in_r = encoder_b_in_dly[3] == 1'b0 && encoder_b_in_dly[2] == 1'b1;
assign encoder_b_in_f = encoder_b_in_dly[3] == 1'b1 && encoder_b_in_dly[2] == 1'b0;
assign encoder_b_in_d = encoder_b_in_dly[2];

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi <= 6'b0;
    end else if (reg_encoder_multi_en == 1'b1) begin
        encoder_multi <= reg_encoder_multi_coe + 1'b1;
    end else begin
        encoder_multi <= 1'b1;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_cnt <= 32'b0;
    end else if (encoder_a_in_r == 1'b1) begin
        encoder_cnt <= 32'b0;
    end else if (encoder_cnt == 32'hffff_ffff) begin
        encoder_cnt <= 32'hffff_ffff;
    end else begin
        encoder_cnt <= encoder_cnt + 1'b1;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_width <= 32'b0;
    end else if (encoder_a_in_r == 1'b1) begin
        encoder_width <= encoder_cnt;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_dir <= 1'b0;
    end else if (encoder_a_in_r == 1'b1) begin
        encoder_dir <= encoder_b_in_d;              //1'b0:forward;1'b1:backward
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi_cnt <= 32'b0;
    end else if (encoder_halt == 1'b1) begin
        encoder_multi_cnt <= encoder_multi_cnt;
    end else if ((encoder_dir == 1'b0) && (encoder_width                     <= encoder_multi + encoder_multi_cnt)) begin
        encoder_multi_cnt <= encoder_multi_cnt + encoder_multi - encoder_width;
    end else if ((encoder_dir == 1'b1) && (encoder_multi_cnt                 <= encoder_multi)) begin
        encoder_multi_cnt <= encoder_width + encoder_multi_cnt - encoder_multi;
    end else if (encoder_dir == 1'b0) begin
        encoder_multi_cnt <= encoder_multi_cnt + encoder_multi;
    end else if (encoder_dir == 1'b1 && encoder_multi_cnt > encoder_width) begin //!
        encoder_multi_cnt <= encoder_width - encoder_multi;
    end else if (encoder_dir == 1'b1) begin
        encoder_multi_cnt <= encoder_multi_cnt - encoder_multi;
    end else
        ;
end

always @ (posedge clk) begin
    encoder_multi_cnt_d <= encoder_multi_cnt;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi_phase <= 32'b0;
    end else if (encoder_a_in_r == 1'b1 && encoder_multi_cnt >= encoder_cnt) begin
        encoder_multi_phase <= encoder_cnt;
    end else if (encoder_a_in_r == 1'b1) begin
        encoder_multi_phase <= encoder_multi_cnt;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi_turn_cnt <= 6'b0;
    end else if (encoder_a_in_r == 1'b1) begin
        encoder_multi_turn_cnt <= 6'b0;
    end else if (encoder_halt == 1'b1) begin
        encoder_multi_turn_cnt <= encoder_multi_turn_cnt;
    end else if (((encoder_dir == 1'b0) && (encoder_multi_cnt >= encoder_multi_phase) && (encoder_multi_cnt                 - encoder_multi_phase < encoder_multi)) ||
                 ((encoder_dir == 1'b0) && (encoder_multi_cnt <  encoder_multi_phase) && (encoder_multi_cnt + encoder_width - encoder_multi_phase < encoder_multi)) ||
                 ((encoder_dir == 1'b1) && (encoder_multi_cnt <= encoder_multi_phase) && (encoder_multi_phase                 - encoder_multi_cnt < encoder_multi)) ||
                 ((encoder_dir == 1'b1) && (encoder_multi_cnt >  encoder_multi_phase) && (encoder_multi_phase + encoder_width - encoder_multi_cnt < encoder_multi)) )begin
        encoder_multi_turn_cnt <= encoder_multi_turn_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_halt <= 1'b0;
    end else begin
        encoder_halt <= encoder_multi_turn_cnt > encoder_multi;
    end
end

// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         encoder_multi_a <= 1'b0;
//     end else if ((encoder_multi_cnt >= 32'h0) && (encoder_multi_cnt < {1'b0,encoder_width[31:1]})) begin //encoder_a is high while encoder_multi_cnt in [0,1/2)
//         encoder_multi_a <= 1'b1;
//     end else begin
//         encoder_multi_a <= 1'b0;
//     end
// end
// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         encoder_multi_b <= 1'b0;
//     end else if ((encoder_multi_cnt >= {2'b00,encoder_width[31:2]}) && (encoder_multi_cnt < ({1'b0,encoder_width[31:1]} + {2'b0,encoder_width[31:2]}))) begin //encoder_b is high while encoder_multi_cnt in [1/4,3/4)
//         encoder_multi_b <= 1'b1;
//     end else begin
//         encoder_multi_b <= 1'b0;
//     end
// // end
// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         encoder_multi_a <= 1'b0;
//     end else if ((encoder_multi_cnt <= encoder_multi) && (encoder_multi_cnt + encoder_multi > encoder_multi)) begin //encoder_a is high while encoder_multi_cnt in [0,1/2)
//         encoder_multi_a <= 1'b1;
//     end else if ((encoder_multi_cnt <= {1'b0,encoder_width[31:1]}) && (encoder_multi_cnt + encoder_multi > {1'b0,encoder_width[31:1]})) begin //encoder_a is high while encoder_multi_cnt in [0,1/2)
//         encoder_multi_a <= 1'b0;
//     end else
//         ;
// end
// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         encoder_multi_b <= 1'b0;
//     end else if ((encoder_multi_cnt <= {2'b00,encoder_width[31:2]}) && (encoder_multi_cnt + encoder_multi > {2'b00,encoder_width[31:2]})) begin //encoder_b is high while encoder_multi_cnt in [1/4,3/4)
//         encoder_multi_b <= 1'b1;
//     end else if ((encoder_multi_cnt <= ({1'b0,encoder_width[31:1]} + {2'b0,encoder_width[31:2]})) && (encoder_multi_cnt + encoder_multi > ({1'b0,encoder_width[31:1]} + {2'b0,encoder_width[31:2]}))) begin //encoder_b is high while encoder_multi_cnt in [1/4,3/4)
//         encoder_multi_b <= 1'b0;
//     end else
//         ;
// end
always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_width_lock <= 32'b0;
    end else if (encoder_multi_cnt <= encoder_multi) begin //only refreash at the biginning of one cycle
        encoder_width_lock <= encoder_width;
    end else
        ;
end
always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi_a <= 1'b0;
    end else if (reg_encoder_multi_en == 1'b0) begin 
        encoder_multi_a <= encoder_a_in;
    end else if ((encoder_multi_cnt >= 32'h0) && (encoder_multi_cnt < {1'b0,encoder_width_lock[31:1]})) begin //encoder_a is high while encoder_multi_cnt in [0,1/2)
        encoder_multi_a <= 1'b1;
    end else begin
        encoder_multi_a <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        encoder_multi_b <= 1'b0;
    end else if (reg_encoder_multi_en == 1'b0) begin 
        encoder_multi_b <= encoder_b_in;
    end else if ((encoder_multi_cnt >= {2'b00,encoder_width_lock[31:2]}) && (encoder_multi_cnt < ({1'b0,encoder_width_lock[31:1]} + {2'b0,encoder_width_lock[31:2]}))) begin //encoder_b is high while encoder_multi_cnt in [1/4,3/4)
        encoder_multi_b <= 1'b1;
    end else begin
        encoder_multi_b <= 1'b0;
    end
end

endmodule
