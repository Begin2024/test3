/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-04-07 14:17:22
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-05-23 10:58:13
#FilePath     : encoder_phase.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module encoder_phase(
    input                           clk                             ,
    input                           rst                             ,

    input                           reg_encoder_phase               ,
    output  reg     [31:0]          reg_encoder_location            ,
    output  reg     [31:0]          reg_encoder_a_cnt               ,
    output  reg     [31:0]          reg_encoder_b_cnt               ,
    input                           reg_encoder_clr                 ,

    input                           encoder_a_in                    ,
    input                           encoder_b_in                    ,

    output                          phase_encoder_a_in              ,
    output                          phase_encoder_b_in

);


/********************************************************************
*                         Regs Here                                 *
********************************************************************/
reg                 [3:0]           encoder_a_in_dly                ;
reg                 [3:0]           encoder_b_in_dly                ;

/********************************************************************
*                         Wires Here                                *
********************************************************************/

wire                                encoder_a_in_r                  ;
wire                                encoder_a_in_f                  ;
wire                                encoder_b_in_r                  ;
wire                                encoder_b_in_f                  ;

wire                                encoder_a_in_d                  ;
wire                                encoder_b_in_d                  ;

/********************************************************************
*                         Logic Here                                *
********************************************************************/

always @ (posedge clk) begin
    encoder_a_in_dly <= {encoder_a_in_dly[2:0],encoder_a_in};
end

assign encoder_a_in_r = encoder_a_in_dly[3] == 1'b0 && encoder_a_in_dly[2] == 1'b1;
assign encoder_a_in_f = encoder_a_in_dly[3] == 1'b1 && encoder_a_in_dly[2] == 1'b0;
assign encoder_a_in_d = encoder_a_in_dly[2];

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        reg_encoder_a_cnt <= 32'b0;
    end else if (reg_encoder_clr == 1'b1) begin
        reg_encoder_a_cnt <= 32'h0;
    end else if (encoder_a_in_r == 1'b1) begin
        reg_encoder_a_cnt <= reg_encoder_a_cnt + 1'b1;
    end else
        ;
end

always @ (posedge clk) begin
    encoder_b_in_dly <= {encoder_b_in_dly[2:0],encoder_b_in};
end

assign encoder_b_in_r = encoder_b_in_dly[3] == 1'b0 && encoder_b_in_dly[2] == 1'b1;
assign encoder_b_in_f = encoder_b_in_dly[3] == 1'b1 && encoder_b_in_dly[2] == 1'b0;
assign encoder_b_in_d = encoder_b_in_dly[2];

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        reg_encoder_b_cnt <= 32'b0;
    end else if (reg_encoder_clr == 1'b1) begin
        reg_encoder_b_cnt <= 32'h0;
    end else if (encoder_b_in_r == 1'b1) begin
        reg_encoder_b_cnt <= reg_encoder_b_cnt + 1'b1;
    end else
        ;
end

assign phase_encoder_a_in = reg_encoder_phase == 1'b1 ? encoder_b_in : encoder_a_in;
assign phase_encoder_b_in = reg_encoder_phase == 1'b1 ? encoder_a_in : encoder_b_in;

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        reg_encoder_location <= 32'b0;
    end else if (reg_encoder_clr == 1'b1) begin
        reg_encoder_location <= 32'h0;
    end else if (encoder_a_in_r == 1'h1 && encoder_b_in_d == 1'b0) begin
        reg_encoder_location <= reg_encoder_location + 1'h1;
    end else if (encoder_a_in_f == 1'h1 && encoder_b_in_d == 1'b1) begin
        reg_encoder_location <= reg_encoder_location + 1'h1;
    end else if (encoder_b_in_r == 1'h1 && encoder_a_in_d == 1'b1) begin
        reg_encoder_location <= reg_encoder_location + 1'h1;
    end else if (encoder_b_in_f == 1'h1 && encoder_a_in_d == 1'b0) begin
        reg_encoder_location <= reg_encoder_location + 1'h1;
    end else if (encoder_a_in_r == 1'h1 && encoder_b_in_d == 1'b1) begin
        reg_encoder_location <= reg_encoder_location - 1'h1;
    end else if (encoder_a_in_f == 1'h1 && encoder_b_in_d == 1'b0) begin
        reg_encoder_location <= reg_encoder_location - 1'h1;
    end else if (encoder_b_in_r == 1'h1 && encoder_a_in_d == 1'b0) begin
        reg_encoder_location <= reg_encoder_location - 1'h1;
    end else if (encoder_b_in_f == 1'h1 && encoder_a_in_d == 1'b1) begin
        reg_encoder_location <= reg_encoder_location - 1'h1;
    end else begin
        reg_encoder_location <= reg_encoder_location;
    end
end


/*************************************debug******************************************/



(* mark_debug = "true" *)    reg                                debug_encoder_a_in_r                    ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_in_f                    ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_in_r                  ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_in_f                  ;
(* mark_debug = "true" *)    reg                                debug_encoder_a_in_d                     ;
(* mark_debug = "true" *)    reg                                debug_encoder_b_in_d                ;
(* mark_debug = "true" *)    reg  [3:0]                         debug_encoder_a_in_dly                ;
(* mark_debug = "true" *)    reg  [3:0]                         debug_encoder_b_in_dly                ;



always @ (posedge clk) begin
    debug_encoder_a_in_r    <=  encoder_a_in_r   ;
    debug_encoder_a_in_f    <=  encoder_a_in_f   ;
    debug_encoder_b_in_r    <=  encoder_b_in_r   ;
    debug_encoder_b_in_f    <=  encoder_b_in_f   ;
    debug_encoder_a_in_d    <=  encoder_a_in_d   ;
    debug_encoder_b_in_d    <=  encoder_b_in_d   ;
    debug_encoder_a_in_dly  <=  encoder_a_in_dly ;
    debug_encoder_b_in_dly  <=  encoder_b_in_dly ;


end

endmodule
