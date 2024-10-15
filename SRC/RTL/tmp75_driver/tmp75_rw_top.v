
// -----------------------------------------------------------------------------
// Copyright (c) 2022-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : tingxuan hu (Sean)
// File   : tmp75_rw_top.v
// Create : 2022-10-18 10:22:00
// Revise : 2022-10-18 10:22:00
// Editor : sublime text3, tab size (4)
// Tool   : VIVADO 2022.1
// Target : Xilinx K7
// Version: V1.0
// Description:
// -----------------------------------------------------------------------------
`timescale 1ns / 1ns

module tmp75_rw_top(
    input   wire                        clk             ,
    input   wire                        rst             ,

    inout   wire                        i2c_sda         ,
    output  wire                        i2c_scl         ,

    output  wire    [11:0]              tmp75_temp_data
    );

///////////////////////////////////////////////////////////////////////////

//parameter define
localparam      DEVICE_ADDR     =   8'b1001001_0;

localparam      st_idle         =   3'd1    ,
                st_wr_cfg       =   3'd2    ,
                st_wait         =   3'd3    ,
                st_wr_temp_reg  =   3'd4    ,
                st_wait_conv    =   3'd5    ,
                st_rd_temp      =   3'd6    ,
                st_end          =   3'd7    ;

//reg define
reg         [ 7:0]                      wr_cnt  =   8'd0;
reg         [ 7:0]                      rd_cnt  =   8'd0;
reg                                     iic_en  =   1'b0;
reg         [ 2:0]                      state   =   3'd0;
reg         [31:0]                      delay_cnt = 32'd0;
reg                                     wr_done =   1'b0;
reg         [ 7:0]                      addr            ;
reg         [ 7:0]                      devaddr         ;
reg         [15:0]                      temp_data       ;

//wire define
wire        [ 7:0]                      wr_data = 8'b0111_1000;
wire        [15:0]                      rd_data         ;
wire                                    iic_busy        ;

/////////////////////////////////////////////////////////////////////////////

assign tmp75_temp_data = {temp_data[7:0], temp_data[15:12]};

//wait for temp conv
always @(posedge clk)
    if(rst)
        delay_cnt <= 32'd0;
    else if (state == st_wait || state == st_wait_conv || state == st_end)
        delay_cnt <= delay_cnt + 1'b1;
    else
        delay_cnt <= 32'd0;

//fsm
always @(posedge clk)
    if (rst) begin
        devaddr <=  DEVICE_ADDR;
        addr    <=  8'd0;
        iic_en  <=  1'b0;
        wr_done <=  1'b0;
        rd_cnt  <=  8'd0;
        wr_cnt  <=  8'd0;
        state   <=  3'd0;
    end
    else case (state)
        st_idle: begin
            if (!wr_done) begin
                wr_done <= 1'b1;
                addr    <= 8'b0000_0001;
                state   <= st_wr_cfg;
            end
            else begin
                state <= st_wr_temp_reg;
            end
        end
        st_wr_cfg: begin
            if (!iic_busy) begin
                iic_en <= 1'b1;

                rd_cnt <= 'd0;
                wr_cnt <= 'd3; //1byte wr_data   1byte reg addr   1byte dev addr
            end
            else begin
                state <= st_wait;
            end
        end
        st_wait: begin
            iic_en <= 1'b0;
            if(delay_cnt == 32'd50000)
                state <= st_wr_temp_reg;
        end
        st_wr_temp_reg: begin
            if (!iic_busy) begin
                iic_en <= 1'b1;
                addr    <= 8'b0000_0000;
                rd_cnt <= 'd2;
                wr_cnt <= 'd2; //1byte reg addr   1byte dev addr
            end
            else begin
                state <= st_wait_conv;
            end
        end
        st_wait_conv: begin
            iic_en <= 1'b0;
            if(delay_cnt == 32'd50000)
                state <= st_rd_temp;
        end
        st_rd_temp: begin
            temp_data <= rd_data;
            state <= st_end;
        end
        st_end: begin
            if(delay_cnt == 32'd50000)
                state <= st_idle;
        end
        default: state <= st_idle;
    endcase

///////////////////////////////////////////////////////////////////////////
// wire sda_o, sda_i;
// vio_0 your_instance_name (
//   .clk(clk),              // input wire clk
//   .probe_in0(temp_data)  // input wire [15 : 0] probe_in0
// );

// // ila debug monitor signals
// reg scl_r1 = 1'b0;
// reg scl_r2 = 1'b0;
// always @(posedge clk)begin scl_r1 <= i2c_scl; scl_r2 <= scl_r1; end
// wire scl_dg = (scl_r1&&!scl_r2)||(scl_r2&&!scl_r1);
// wire sda_dg;
// ila_0 ila_debug (
//  .clk(clk), // input wire clk
//  .probe0({temp_data,rd_data,wr_cnt,rd_cnt,iic_en,iic_busy, wr_data,state,scl_r1,sda_dg,scl_dg}) // input wire [0:0] probe0
// );


    i2c_dri #(
            .WMEN_LEN(3),
            .RMEN_LEN(2),
            .CLK_DIV(499)
        ) inst_i2c_dri (
            .clk_i    (clk),
            .iic_scl  (i2c_scl),
            .iic_sda  (i2c_sda),
            .wr_data  ({wr_data,addr,devaddr}),
            .wr_cnt   (wr_cnt),
            .rd_data  (rd_data),
            .rd_cnt   (rd_cnt),
            .iic_en   (iic_en),
            .iic_mode (1'b1),
            .iic_busy (iic_busy),
            .sda_dg   (sda_dg)
        );


endmodule
