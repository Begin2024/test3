

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/18 15:39:21
// Design Name:
// Module Name: sw_ctrl_tb
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


module sw_ctrl_tb(

    );

localparam clk_period = 'd10;


// sw_ctrl Inputs
    reg   clk                                  ;
    reg   rst                                  ;
    reg   [95:0]  sw_val                       ;
    reg   [7:0]  sw_req                        ;
    reg   [31:0]  reg_sw_time                  ;

    // sw_ctrl Outputs
    wire  [11:0]  dac_sw_x1                    ;
    wire  [11:0]  dac_sw_x2                    ;
    wire  [11:0]  dac_sw_x3                    ;
    wire  [11:0]  dac_sw_x4                    ;
    wire  [11:0]  dac_sw_y1                    ;
    wire  [11:0]  dac_sw_y2                    ;
    wire  [11:0]  dac_sw_y3                    ;
    wire  [11:0]  dac_sw_y4                    ;
    wire  sw_ack                               ;


    reg [7:0]sw_req_dly;
always #(clk_period/2) clk=~clk;



initial begin
    clk=0;
    rst=1;
    reg_sw_time=10;
    #(clk_period*4)rst=0;
    #(clk_period*10000) $stop;
end


always@(posedge clk or posedge rst)begin
    if(rst)begin
        sw_req<=0;
    end
    else if(sw_ack==0)begin
        sw_req<=8'hff;
    end
    else begin
        sw_req<=0;
    end
end


always@(posedge clk or posedge rst)begin
    if(rst)begin
        sw_req_dly<=0;
    end
    else begin
        sw_req_dly<=sw_req;
    end
end

always@(posedge clk or posedge rst)begin
    if(rst)begin
        sw_val<=96'b1;
    end
    else if((~sw_req_dly[0])&&(sw_req[0]))begin
        sw_val<={sw_val[94:0],1'b0};
    end
end





    sw_ctrl  u_sw_ctrl (
        .clk                     ( clk           ),
        .rst                     ( rst           ),
        .sw_val                  ( sw_val        ),
        .sw_req                  ( sw_req        ),
        .reg_sw_time             ( reg_sw_time   ),

        .dac_sw_x1               ( dac_sw_x1     ),
        .dac_sw_x2               ( dac_sw_x2     ),
        .dac_sw_x3               ( dac_sw_x3     ),
        .dac_sw_x4               ( dac_sw_x4     ),
        .dac_sw_y1               ( dac_sw_y1     ),
        .dac_sw_y2               ( dac_sw_y2     ),
        .dac_sw_y3               ( dac_sw_y3     ),
        .dac_sw_y4               ( dac_sw_y4     ),
        .sw_ack                  ( sw_ack        )
    );






endmodule
