/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-16  11:36:24
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-16  11:36:24
 # FilePath     : clock_manage.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module clock_manage(

    input wire                  sys_clk                 ,
    input wire                  sys_rst_n               ,

    input wire                  reg_soft_reset          ,

    // Main clock 125MHz
    output wire                 clk                     ,
    output wire                 rst                     ,

    // EPC clock
    output wire                 clk_epc                 ,
    output wire                 rst_epc

    // // Block design clock
    // output wire                 clk_bd                  ,
    // output wire                 rst_bd
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg                         rst_50                  ;
    reg                         rst_100                 ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        clk_100                 ;
    wire                        clk_50                  ;
    wire                        clk_125                 ;
    wire                        locked                  ;
    wire                        reset                   ;

    wire                        clk_bd                  ;
    wire                        rst_bd                  ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign reset                = ~sys_rst_n;

    assign clk                  = clk_125;
    assign clk_epc              = clk_50;
    assign clk_bd               = clk_125;

    assign rst                  = ~locked || reg_soft_reset;
    assign rst_epc              = rst_50;
    assign rst_bd               = rst;

    clk_wiz_0 clk_wiz_0_inst(

        .clk_125                                        (clk_125                                        ),     // output clk_125
        .clk_50                                         (clk_50                                         ),     // output clk_50
        .clk_100                                        (clk_100                                        ),     // output clk_100
    // Status and control signals
        .reset                                          (reset                                          ), // input reset
        .locked                                         (locked                                         ),       // output locked
   // Clock in ports
        .sys_clk                                        (sys_clk                                        )
    );      // input sys_clk

    always @ (posedge clk_50 or posedge rst) begin
        if (rst == 1'b1) begin
            rst_50              <= 1'b1;
        end else begin
            rst_50              <= 1'b0;
        end
    end

    always @ (posedge clk_100 or posedge rst) begin
        if (rst == 1'b1) begin
            rst_100             <= 1'b1;
        end else begin
            rst_100             <= 1'b0;
        end
    end

endmodule