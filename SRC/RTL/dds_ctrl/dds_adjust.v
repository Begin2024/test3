/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-29  13:29:13
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-08-31 20:26:25
#FilePath     : dds_adjust.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module dds_adjust(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [13:0]           reg_adjust_gain         ,
    input wire [13:0]           reg_adjust_offset       ,
    input wire                  reg_adjust_en           ,

    input wire [13:0]           da_forward_data_in      ,
    input wire [13:0]           da_backward_data_in     ,
    input wire                  da_data_in_vld          ,

    output wire [13:0]          da_forward_data_out     ,
    output wire [13:0]          da_backward_data_out    ,
    output wire                 da_data_out_vld
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   da_data_in_vld_dly      ;

    reg [13:0]                  forward_dly       [0:3] ;
    reg [13:0]                  backward_dly      [0:3] ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire [28:0]                 forward_temp            ;
    wire [28:0]                 backward_temp           ;

/********************************************************
*                        logic Here                     *
********************************************************/

    always @ (posedge clk) begin
        da_data_in_vld_dly       <= {da_data_in_vld_dly[2:0], da_data_in_vld};
    end

    always @ (posedge clk) begin
        forward_dly[0]          <= da_forward_data_in;
        forward_dly[1]          <= forward_dly[0];
        forward_dly[2]          <= forward_dly[1];
        forward_dly[3]          <= forward_dly[2];
    end

    always @ (posedge clk) begin
        backward_dly[0]         <= da_backward_data_in;
        backward_dly[1]         <= backward_dly[0];
        backward_dly[2]         <= backward_dly[1];
        backward_dly[3]         <= backward_dly[2];
    end

    mult_gen_0 mult_gen_0_inst(

        .CLK                                            (clk                                            ),  // input wire CLK
        .A                                              (da_forward_data_in                             ),      // input wire [13 : 0] A
        .B                                              (reg_adjust_gain                                ),      // input wire [13 : 0] B
        .P                                              (forward_temp                                   )      // output wire [28 : 0] P
    );

    mult_gen_0 mult_gen_1_inst(

        .CLK                                            (clk                                            ),  // input wire CLK
        .A                                              (da_backward_data_in                            ),      // input wire [13 : 0] A
        .B                                              (reg_adjust_gain                                ),      // input wire [13 : 0] B
        .P                                              (backward_temp                                  )      // output wire [28 : 0] P
    );


    assign da_forward_data_out  = reg_adjust_en ? (forward_temp  + reg_adjust_offset) : forward_dly[3];
    assign da_backward_data_out = reg_adjust_en ? (backward_temp + reg_adjust_offset) : backward_dly[3];
    assign da_data_out_vld      = da_data_in_vld_dly[3];





// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_adjust_gain               ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_adjust_offset             ;
(* mark_debug = "true" *)    reg                                debug_reg_adjust_en                 ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_da_forward_data_in            ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_da_backward_data_in           ;
(* mark_debug = "true" *)    reg                                debug_da_data_in_vld                ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_da_forward_data_out           ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_da_backward_data_out          ;
(* mark_debug = "true" *)    reg                                debug_da_data_out_vld               ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_da_data_in_vld_dly            ;
(* mark_debug = "true" *)    reg    [28:0]                      debug_forward_temp                  ;
(* mark_debug = "true" *)    reg    [28:0]                      debug_backward_temp                 ;

always @ (posedge clk) begin
    debug_reg_adjust_gain                <= reg_adjust_gain               ;
    debug_reg_adjust_offset              <= reg_adjust_offset             ;
    debug_reg_adjust_en                  <= reg_adjust_en                 ;
    debug_da_forward_data_in             <= da_forward_data_in            ;
    debug_da_backward_data_in            <= da_backward_data_in           ;
    debug_da_data_in_vld                 <= da_data_in_vld                ;
    debug_da_forward_data_out            <= da_forward_data_out           ;
    debug_da_backward_data_out           <= da_backward_data_out          ;
    debug_da_data_out_vld                <= da_data_out_vld               ;
    debug_da_data_in_vld_dly             <= da_data_in_vld_dly            ;
    debug_forward_temp                   <= forward_temp                  ;
    debug_backward_temp                  <= backward_temp                 ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [13:0]                      debug_forward_dly                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_backward_dly                  ;

always @ (posedge clk) begin
    debug_forward_dly                    <= forward_dly[0]                   ;
    debug_backward_dly                   <= backward_dly[0]                  ;
end

endmodule

