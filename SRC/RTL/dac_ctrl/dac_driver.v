`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/14 17:54:35
// Design Name:
// Module Name: dac_driver
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

module dac_driver (
    input wire clk,
    input wire rst,

    input wire ack_clr,
    output reg [13:0] dac_data,

    output reg         dac_ack,
    input  wire [13:0] dac_val,
    input  wire        dac_req,

    input wire [31:0] reg_dac_time
);



  /******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/






  /******************************************************************************
*                                    WIRE                                     *
******************************************************************************/






  /******************************************************************************
*                                     REG                                     *
******************************************************************************/

  reg [31:0] cnt_dac_time;
  reg [ 1:0] dac_req_dly;
  reg        dac_req_rise;
  reg [13:0] dac_val_lock;




  /******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dac_req_dly <= 0;
    end else begin
      dac_req_dly <= {dac_req_dly[0], dac_req};
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dac_req_rise <= 0;
    end else if ((!dac_req_dly[1]) & (dac_req_dly[0])) begin
      dac_req_rise <= 1'b1;
    end else begin
      dac_req_rise <= 0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dac_val_lock <= 0;
    end else if (dac_req_rise == 1'b1) begin
      dac_val_lock <= dac_val;
    end else;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      cnt_dac_time <= 32'b0;
    end else if (dac_req_rise == 1'b1) begin
      cnt_dac_time <= 32'b1;
    end else if (cnt_dac_time >= (reg_dac_time - 1'b1)) begin
      cnt_dac_time <= 32'b0;
    end else if (cnt_dac_time > 32'b0) begin
      cnt_dac_time <= cnt_dac_time + 1'b1;
    end else;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dac_data <= 0;
    end else begin
      dac_data <= dac_val_lock;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      dac_ack <= 0;
    end else if (ack_clr == 1'b1) begin
      dac_ack <= 1'b0;
    end else if (cnt_dac_time >= (reg_dac_time - 1'b1)) begin
      dac_ack <= 1'b1;
    end else begin
      dac_ack <= dac_ack;
    end
  end


  /******************************************************************************
*                                   INSTANCE                                  *
******************************************************************************/






  /******************************************************************************
*                                     IP                                      *
******************************************************************************/








(* mark_debug = "true" *)    reg                                debug_ack_clr                       ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac_data                      ;
(* mark_debug = "true" *)    reg                                debug_dac_ack                       ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac_val                       ;
(* mark_debug = "true" *)    reg                                debug_dac_req                       ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_dac_time                  ;

always @ (posedge clk) begin
    debug_ack_clr                        <= ack_clr                       ;
    debug_dac_data                       <= dac_data                      ;
    debug_dac_ack                        <= dac_ack                       ;
    debug_dac_val                        <= dac_val                       ;
    debug_dac_req                        <= dac_req                       ;
    debug_reg_dac_time                   <= reg_dac_time                  ;
end

(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_dac_time                  ;
(* mark_debug = "true" *)    reg    [ 1:0]                      debug_dac_req_dly                   ;
(* mark_debug = "true" *)    reg                                debug_dac_req_rise                  ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac_val_lock                  ;

always @ (posedge clk) begin
    debug_cnt_dac_time                   <= cnt_dac_time                  ;
    debug_dac_req_dly                    <= dac_req_dly                   ;
    debug_dac_req_rise                   <= dac_req_rise                  ;
    debug_dac_val_lock                   <= dac_val_lock                  ;
end

endmodule



