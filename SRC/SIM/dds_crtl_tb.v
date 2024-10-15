`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/19 14:28:33
// Design Name:
// Module Name: dds_crtl_tb
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


module dds_crtl_tb(

    );


localparam clk_period = 'd10;


    // dds_ctrl Inputs
reg   clk;
reg   rst;
reg   [9:0]  reg_dds_inc;
reg   [9:0]  dds_addr;
reg   dds_req;
reg   reg_ram_cfg_en;
reg   reg_ram_whrl;
reg   [9:0]  reg_ram_addr;
reg   [13:0]  reg_ram_wdata;
reg   reg_ram_req;
reg   [31:0]  reg_dds_time;

// dds_ctrl Outputs
wire  dds_ack;
wire  [13:0]  dds_data_forward;
wire  [13:0]  dds_data_backward;
wire  [13:0]  reg_ram_rdata;
wire  ram_done;


always #(clk_period/2) clk=~clk;


// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         dds_req<=1;
//     end
//     else if(dds_ack)begin
//         dds_req<=1'b1;
//     end
//     else begin
//         dds_req<=0;
//     end
// end

// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         dds_addr<=0;
//     end
//     else if(dds_req==1'b1)begin
//         dds_addr<=dds_addr+reg_dds_inc;
//     end
// end

initial begin
    clk=0;
    rst=1;
    reg_dds_inc=0;
    dds_req=0;
    dds_addr=0;
    reg_ram_cfg_en  =0;
    reg_ram_whrl    =0;
    reg_ram_addr    =0;
    reg_ram_wdata   =0;
    reg_ram_req     =0;
    reg_dds_time    =100;
    #(clk_period*4)rst=0;
    #(clk_period*100) @(posedge clk) dds_req<=1;dds_addr<=6;reg_dds_inc=10;
    #(clk_period) @(posedge clk) dds_req<=0;

    #(clk_period*100) @(posedge clk)dds_req<=1;dds_addr<=12;reg_dds_inc=10;
    #(clk_period) @(posedge clk)dds_req<=0;

    #(clk_period*100) @(posedge clk)dds_req<=1;dds_addr<=18;reg_dds_inc=10;
    #(clk_period) @(posedge clk)dds_req<=0;

    #(clk_period*5000) $stop;
end



dds_ctrl  u_dds_ctrl (
    .clk                     ( clk                 ),
    .rst                     ( rst                 ),
    .reg_dds_inc             ( reg_dds_inc         ),
    .dds_addr                ( dds_addr            ),
    .dds_req                 ( dds_req             ),
    .reg_ram_cfg_en          ( reg_ram_cfg_en      ),
    .reg_ram_whrl            ( reg_ram_whrl        ),
    .reg_ram_addr            ( reg_ram_addr        ),
    .reg_ram_wdata           ( reg_ram_wdata       ),
    .reg_ram_req             ( reg_ram_req         ),
    .reg_dds_time            ( reg_dds_time        ),

    .dds_ack                 ( dds_ack             ),
    .dds_data_forward        ( dds_data_forward    ),
    .dds_data_backward       ( dds_data_backward   ),
    .reg_ram_rdata           ( reg_ram_rdata       ),
    .ram_done                ( ram_done            )
);
endmodule
