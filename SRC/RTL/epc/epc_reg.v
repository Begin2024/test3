/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-12-21 17:09:36
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-07-03 19:23:17
#FilePath     : epc_register.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/
module epc_reg(

    input                           clk                             ,
    input                           clk_50m                         ,
    input                           rst                             ,

    input           [15:0]          epc_addr                        ,
    input           [31:0]          epc_wrdata                      ,
    input                           epc_cs_n                        ,
    input                           epc_rnw                         ,
    output          [31:0]          epc_rddata                      ,
    output                          epc_rdy                         ,

    output                          reg_req                         ,
    output                          reg_whrl                        ,
    output          [31:0]          reg_addr                        ,
    output          [31:0]          reg_wdata                       ,
    input                           reg_ack                         ,
    input           [31:0]          reg_rdata

);


/********************************************************************
*                         Regs Here                                 *
********************************************************************/
reg                                 epc_cs_n_d                      ;

/********************************************************************
*                         Wires Here                                *
********************************************************************/
wire                                epc_cs_n_f                      ;

wire                [56:0]          req_din                         ;
wire                                req_wr_en                       ;
wire                                req_rd_en                       ;
wire                [56:0]          req_dout                        ;
wire                                req_full                        ;
wire                                req_empty                       ;
wire                                req_prog_full                   ;
wire                                req_prog_empty                  ;

wire                [31:0]          ack_din                         ;
wire                                ack_wr_en                       ;
wire                                ack_rd_en                       ;
wire                [31:0]          ack_dout                        ;
wire                                ack_full                        ;
wire                                ack_empty                       ;
wire                                ack_prog_full                   ;
wire                                ack_prog_empty                  ;

/********************************************************************
*                         Logic Here                                *
********************************************************************/
always @ (posedge clk_50m ) begin
    epc_cs_n_d <= epc_cs_n;
end

assign epc_cs_n_f = epc_cs_n_d == 1'b1 && epc_cs_n == 1'b0;

// assign reg_req      = epc_cs_n_f;
// assign reg_whrl     = ~epc_rnw;
// assign reg_addr     = {8'h0,epc_addr};
// assign reg_wdata    = epc_wrdata;

// assign epc_rddata   = reg_rdata;
// assign epc_rdy      = reg_ack;

fifo_57_64_fwft u_fifo_57_64_fwft (
    .wr_clk                                 (clk_50m                                ),  // input wire wr_clk
    .rd_clk                                 (clk                                    ),  // input wire rd_clk
    .rst                                    (rst                                    ),  // input wire rst
    .din                                    (req_din                                ),  // input wire [56 : 0] din
    .wr_en                                  (req_wr_en                              ),  // input wire wr_en
    .rd_en                                  (req_rd_en                              ),  // input wire rd_en
    .dout                                   (req_dout                               ),  // output wire [56 : 0] dout
    .full                                   (req_full                               ),  // output wire full
    .empty                                  (req_empty                              ),  // output wire empty
    .prog_full                              (req_prog_full                          ),  // output wire prog_full
    .prog_empty                             (req_prog_empty                         )   // output wire prog_empty
);

assign req_wr_en = epc_cs_n_f == 1'b1;
assign req_din   = {~epc_rnw,8'd0, epc_addr,epc_wrdata};
assign req_rd_en = req_empty == 1'b0;

assign reg_req      = req_rd_en;
assign reg_whrl     = req_dout[56];
assign reg_addr     = {8'h0,req_dout[55:32]};
assign reg_wdata    = req_dout[31:0];


fifo_32_64_fwft u_fifo_32_64_fwft (
    .wr_clk                                 (clk                                    ),  // input wire wr_clk
    .rd_clk                                 (clk_50m                                ),  // input wire rd_clk
    .rst                                    (rst                                    ),  // input wire rst
    .din                                    (ack_din                                ),  // input wire [31 : 0] din
    .wr_en                                  (ack_wr_en                              ),  // input wire wr_en
    .rd_en                                  (ack_rd_en                              ),  // input wire rd_en
    .dout                                   (ack_dout                               ),  // output wire [31 : 0] dout
    .full                                   (ack_full                               ),  // output wire full
    .empty                                  (ack_empty                              ),  // output wire empty
    .prog_full                              (ack_prog_full                          ),  // output wire prog_full
    .prog_empty                             (ack_prog_empty                         )   // output wire prog_empty
);

assign ack_wr_en = reg_ack;
assign ack_din   = reg_rdata;
assign ack_rd_en = ack_empty == 1'b0;

assign epc_rddata   = ack_dout;
assign epc_rdy      = ack_rd_en;


 /*-----------------------DEBUG------------------------*/

// (* mark_debug = "true" *)

(* mark_debug = "true" *)    reg    [56:0]                        debug_req_din                       ;

always @ (posedge clk) begin
    debug_req_din                        <= req_din       ;
end

(* mark_debug = "true" *)    reg                                  debug_req_wr_en                     ;

always @ (posedge clk) begin
    debug_req_wr_en                      <= req_wr_en         ;
end

(* mark_debug = "true" *)    reg                                  debug_req_rd_en                     ;

always @ (posedge clk) begin
    debug_req_rd_en                      <= req_rd_en         ;
end

(* mark_debug = "true" *)    reg    [56:0]                        debug_req_dout                      ;

always @ (posedge clk) begin
    debug_req_dout                       <= req_dout        ;
end

(* mark_debug = "true" *)    reg                                  debug_req_full                      ;

always @ (posedge clk) begin
    debug_req_full                       <= req_full        ;
end

(* mark_debug = "true" *)    reg                                  debug_req_empty                     ;

always @ (posedge clk) begin
    debug_req_empty                      <= req_empty         ;
end

(* mark_debug = "true" *)    reg                                  debug_req_prog_full                 ;

always @ (posedge clk) begin
    debug_req_prog_full                  <= req_prog_full             ;
end

(* mark_debug = "true" *)    reg                                  debug_req_prog_empty                ;

always @ (posedge clk) begin
    debug_req_prog_empty                 <= req_prog_empty              ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_ack_din                       ;

always @ (posedge clk) begin
    debug_ack_din                        <= ack_din       ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_wr_en                     ;

always @ (posedge clk) begin
    debug_ack_wr_en                      <= ack_wr_en         ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_rd_en                     ;

always @ (posedge clk) begin
    debug_ack_rd_en                      <= ack_rd_en         ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_ack_dout                      ;

always @ (posedge clk) begin
    debug_ack_dout                       <= ack_dout        ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_full                      ;

always @ (posedge clk) begin
    debug_ack_full                       <= ack_full        ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_empty                     ;

always @ (posedge clk) begin
    debug_ack_empty                      <= ack_empty         ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_prog_full                 ;

always @ (posedge clk) begin
    debug_ack_prog_full                  <= ack_prog_full             ;
end

(* mark_debug = "true" *)    reg                                  debug_ack_prog_empty                ;

always @ (posedge clk) begin
    debug_ack_prog_empty                 <= ack_prog_empty              ;
end


(* mark_debug = "true" *)    reg    [15:0]                        debug_epc_addr                      ;

always @ (posedge clk) begin
    debug_epc_addr                       <= epc_addr        ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_epc_wrdata                    ;

always @ (posedge clk) begin
    debug_epc_wrdata                     <= epc_wrdata          ;
end

(* mark_debug = "true" *)    reg                                  debug_epc_cs_n                      ;

always @ (posedge clk) begin
    debug_epc_cs_n                       <= epc_cs_n        ;
end

(* mark_debug = "true" *)    reg                                  debug_epc_rnw                       ;

always @ (posedge clk) begin
    debug_epc_rnw                        <= epc_rnw       ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_epc_rddata                    ;

always @ (posedge clk) begin
    debug_epc_rddata                     <= epc_rddata          ;
end

(* mark_debug = "true" *)    reg                                  debug_epc_rdy                       ;

always @ (posedge clk) begin
    debug_epc_rdy                        <= epc_rdy       ;
end

(* mark_debug = "true" *)    reg                                  debug_reg_req                       ;

always @ (posedge clk) begin
    debug_reg_req                        <= reg_req       ;
end

(* mark_debug = "true" *)    reg                                  debug_reg_whrl                      ;

always @ (posedge clk) begin
    debug_reg_whrl                       <= reg_whrl        ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_reg_addr                      ;

always @ (posedge clk) begin
    debug_reg_addr                       <= reg_addr        ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_reg_wdata                     ;

always @ (posedge clk) begin
    debug_reg_wdata                      <= reg_wdata         ;
end

(* mark_debug = "true" *)    reg                                  debug_reg_ack                       ;

always @ (posedge clk) begin
    debug_reg_ack                        <= reg_ack       ;
end

(* mark_debug = "true" *)    reg    [31:0]                        debug_reg_rdata                     ;

always @ (posedge clk) begin
    debug_reg_rdata                      <= reg_rdata         ;
end

(* mark_debug = "true" *)    reg                                  debug_epc_cs_n_d                    ;

always @ (posedge clk) begin
    debug_epc_cs_n_d                     <= epc_cs_n_d          ;
end

(* mark_debug = "true" *)    reg                                  debug_epc_cs_n_f                    ;

always @ (posedge clk) begin
    debug_epc_cs_n_f                     <= epc_cs_n_f          ;
end

endmodule
