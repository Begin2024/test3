/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-29 15:59:20
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-06-28 15:30:58
#FilePath     : trigger_top.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/
module trigger_top(
    input                           clk                         ,
    input                           rst                         ,

    input       [31:0]              reg_soft_trigger_cycle      ,
    input       [31:0]              reg_soft_trigger_num        ,
    input                           reg_soft_trigger_en         ,

    input       [31:0]              reg_trigger_cycle           ,
    input                           reg_trigger_en              ,
    input       [ 3:0]              reg_trigger_mode            ,
    input       [31:0]              reg_trigger_num             ,
    input       [31:0]              reg_trigger_delay           ,
    input       [31:0]              reg_trigger_width           ,
    input       [31:0]              reg_trigger_pulse           ,
    input                           io_input_0                  ,
    input                           io_input_1                  ,

    input                           reg_encoder_en              ,
    input       [31:0]              reg_encoder_ignore          ,
    input       [ 3:0]              reg_encoder_cnt_mode        ,
    input       [ 3:0]              reg_encoder_dis_mode        ,
    input       [31:0]              reg_encoder_div             ,
    input       [31:0]              reg_encoder_width           ,
    input                           encoder_a_in                ,
    input                           encoder_b_in                ,

    output                          trigger

);

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/
// reg             [199:0]             trigger_shift               ;
reg             [3:0]               trigger_shift               ;



/********************************************************************
*                        Wires Here                                 *
********************************************************************/
wire                                soft_trigger                ;
wire                                io_trigger                  ;
wire                                encoder_trigger             ;
wire                                hw_trigger_ctrl             ;
wire                                trigger_wire                ;
wire                                ctrl_enable                 ;


/********************************************************************
*                        Logic Here                                 *
********************************************************************/



soft_trigger u_soft_trigger(
    .clk                                    (clk                                    ),  //  input
    .rst                                    (rst                                    ),  //  input

    .reg_soft_trigger_cycle                 (reg_soft_trigger_cycle                 ),  //  input [31:0]
    .reg_soft_trigger_num                   (reg_soft_trigger_num                   ),  //  input [31:0]
    .reg_soft_trigger_en                    (reg_soft_trigger_en                    ),  //  input

    .soft_trigger                           (soft_trigger                           )   //  output

);


trigger_io u_trigger_io(
    .clk                                    (clk                                    ),  //  input
    .rst                                    (rst                                    ),  //  input

    .reg_trigger_cycle                      (reg_trigger_cycle                      ),  //  input [31:0]
    .reg_trigger_en                         (reg_trigger_en                         ),  //  input
    .reg_trigger_mode                       (reg_trigger_mode                       ),  //  input [3:0]
    .reg_trigger_num                        (reg_trigger_num                        ),  //  input [31:0]
    .reg_trigger_delay                      (reg_trigger_delay                      ),  //  input [31:0]
    .reg_trigger_width                      (reg_trigger_width                      ),  //  input [31:0]
    .reg_trigger_pulse                      (reg_trigger_pulse                      ),  //  input [31:0]
    .io_input_0                             (io_input_0                             ),  //  input
    .io_input_1                             (io_input_1                             ),  //  input

    .io_trigger                             (io_trigger                             )   //  output

);


trigger_encoder u_trigger_encoder(
    .clk                                    (clk                                    ),  //  input
    .rst                                    (rst                                    ),  //  input

    .reg_encoder_en                         (reg_encoder_en                         ),  //  input
    .reg_encoder_ignore                     (reg_encoder_ignore                     ),  //  input [31:0]
    .reg_encoder_cnt_mode                   (reg_encoder_cnt_mode                   ),  //  input [3:0]
    .reg_encoder_dis_mode                   (reg_encoder_dis_mode                   ),  //  input [3:0]
    .reg_encoder_div                        (reg_encoder_div                        ),  //  input [15:0]
    .reg_encoder_width                      (reg_encoder_width                      ),  //  input [31:0]

    .encoder_a_in                           (encoder_a_in                           ),  //  input
    .encoder_b_in                           (encoder_b_in                           ),  //  input

    .encoder_trigger                        (encoder_trigger                        )   //  output

);


assign trigger_wire =    (reg_soft_trigger_en   == 1'b1 && soft_trigger     == 1'b1)
                    ||   (reg_trigger_en        == 1'b1 && io_trigger       == 1'b1)
                    ||   (reg_encoder_en        == 1'b1 && encoder_trigger  == 1'b1);

// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         trigger_shift <= 200'h0;
//     end else if (trigger_wire == 1'b1) begin
//         trigger_shift <= {200{1'b1}};
//     end else begin
//         trigger_shift <= {trigger_shift[198:0],1'b0};
//     end
// end

// assign trigger = trigger_shift[199];

// always @ (posedge clk,posedge rst) begin
//     if (rst ==1'b1) begin
//         trigger_shift <= 4'h0;
//     end else if (trigger_wire == 1'b1) begin
//         trigger_shift <= {4{1'b1}};
//     end else begin
//         trigger_shift <= {trigger_shift[2:0],1'b0};
//     end
// end

assign trigger = trigger_wire;




(* dont_touch = "true" *)reg                            debug_io_input_0               ;
(* dont_touch = "true" *)reg                            debug_io_input_1               ;
(* dont_touch = "true" *)reg                            debug_trigger               ;
(* dont_touch = "true" *)reg [3:0]                      debug_trigger_shift               ;
(* dont_touch = "true" *)reg                            debug_soft_trigger               ;
(* dont_touch = "true" *)reg                            debug_io_trigger               ;
(* dont_touch = "true" *)reg                            debug_encoder_trigger               ;
(* dont_touch = "true" *)reg                            debug_hw_trigger_ctrl               ;
(* dont_touch = "true" *)reg                            debug_trigger_wire               ;
(* dont_touch = "true" *)reg                            debug_ctrl_enable               ;

always @ (posedge clk) begin
    debug_io_input_0 <= io_input_0;
end
always @ (posedge clk) begin
    debug_io_input_1 <= io_input_1;
end
always @ (posedge clk) begin
    debug_trigger <= trigger;
end
always @ (posedge clk) begin
    debug_trigger_shift <= trigger_shift;
end
always @ (posedge clk) begin
    debug_soft_trigger <= soft_trigger;
end
always @ (posedge clk) begin
    debug_io_trigger <= io_trigger;
end
always @ (posedge clk) begin
    debug_encoder_trigger <= encoder_trigger;
end
always @ (posedge clk) begin
    debug_hw_trigger_ctrl <= hw_trigger_ctrl;
end
always @ (posedge clk) begin
    debug_trigger_wire <= trigger_wire;
end
always @ (posedge clk) begin
    debug_ctrl_enable <= ctrl_enable;
end








endmodule

