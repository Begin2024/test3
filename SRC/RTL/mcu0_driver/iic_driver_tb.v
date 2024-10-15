/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-07  11:58:50
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-07  11:58:50
 # FilePath     : iic_driver_tb.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
`timescale  1ns / 1ps

module iic_driver_tb;

// iic_driver Parameters
parameter PERIOD      = 10              ;


// iic_driver Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   reg_iic_whrl                         = 0 ;
reg   [6:0]  reg_iic_dev_addr              = 0 ;
reg   [7:0]  reg_iic_wdata                 = 0 ;
reg   [7:0]  reg_iic_addr                  = 0 ;
reg   reg_iic_req                          = 0 ;
reg   iic_sda_i                            = 0 ;

// iic_driver Outputs
wire  [7:0]  reg_iic_rdata                 ;
wire  reg_iic_done                         ;
wire  iic_sda_ctrl                         ;
wire  iic_scl                              ;
wire  iic_sda_o                            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rst <= 1'b1;
    #2000
    #(PERIOD*2) rst  =  'd0;
end

    iic_driver u_iic_driver (
        .clk                     ( clk),
        .rst                     ( rst),
        .reg_iic_whrl            ( reg_iic_whrl),
        .reg_iic_dev_addr        ( reg_iic_dev_addr[6:0] ),
        .reg_iic_wdata           ( reg_iic_wdata[7:0] ),
        .reg_iic_addr            ( reg_iic_addr[7:0]),
        .reg_iic_req             ( reg_iic_req      ),
        .iic_sda_i               ( iic_sda_i      ),

        .reg_iic_rdata           ( reg_iic_rdata[7:0] ),
        .reg_iic_done            ( reg_iic_done      ),
        .iic_sda_ctrl            ( iic_sda_ctrl      ),
        .iic_scl                 ( iic_scl      ),
        .iic_sda_o               ( iic_sda_o      )
    );

initial
begin

    #20000000
    $finish;
end


    initial begin
        #4000
        reg_iic_whrl <= 1'b1;
        reg_iic_dev_addr <= 7'b1101000;
        reg_iic_wdata <= 8'hA5;
        reg_iic_addr <= 8'h28;

        iic_sda_i <= 1'b0;

        #200
        reg_iic_req <= 1'b1;
        #20
        reg_iic_req <= 1'b0;

        #4000000
        reg_iic_whrl <= 1'b0;
        #200
        reg_iic_req <= 1'b1;
        #20
        reg_iic_req <= 1'b0;
    end

endmodule