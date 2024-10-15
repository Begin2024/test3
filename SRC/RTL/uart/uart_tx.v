/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-31 16:36:17
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2022-09-08 19:57:55
#FilePath     : uart_tx.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved. 
********************************************************************/
module uart_tx(
    input                           clk                             ,
    input                           rst                             ,

    input           [15:0]          uart_bit_width                  ,

    output                          tx                              ,

    input           [7:0]           tx_data                         ,
    input                           tx_data_vld                     ,
    output                          tx_data_busy

);


parameter                           IDLE                =   4'h0    ;
parameter                           TX_SEND             =   4'h1    ;

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/

reg                 [3:0]           cs                              ;
reg                 [3:0]           ns                              ;

reg                 [15:0]          width_cnt                       ;
reg                 [3:0]           bit_cnt                         ;

reg                 [9:0]           tx_shift                        ;

/********************************************************************
*                        Wires Here                                 *
********************************************************************/

wire                [7:0]           tx_din                          ;
wire                                tx_wr_en                        ;
wire                                tx_rd_en                        ;
wire                [7:0]           tx_dout                         ;
wire                                tx_full                         ;
wire                                tx_empty                        ;
wire                                tx_prog_full                    ;
wire                                tx_prog_empty                   ;




/********************************************************************
*                        Logic Here                                 *
********************************************************************/

assign tx_data_busy = tx_full;

fifo_8_64_fwft u_fifo_8_64_fwft (
    .wr_clk                                 (clk                                    ),  // input wire wr_clk
    .rd_clk                                 (clk                                    ),  // input wire rd_clk
    .rst                                    (rst                                    ),  // input wire rst
    .din                                    (tx_din                                 ),  // input wire [7 : 0] din
    .wr_en                                  (tx_wr_en                               ),  // input wire wr_en
    .rd_en                                  (tx_rd_en                               ),  // input wire rd_en
    .dout                                   (tx_dout                                ),  // output wire [7 : 0] dout
    .full                                   (tx_full                                ),  // output wire full
    .empty                                  (tx_empty                               ),  // output wire empty
    .prog_full                              (tx_prog_full                           ),  // output wire prog_full
    .prog_empty                             (tx_prog_empty                          )   // output wire prog_empty
);

assign tx_wr_en = tx_data_vld;
assign tx_din = tx_data;

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        cs <= IDLE;
    end else begin
        cs <= ns;
    end
end

always @ ( * ) begin
    case (cs)
        IDLE : begin
            if (tx_empty == 1'b0) begin
                ns = TX_SEND;
            end else begin
                ns = IDLE;
            end
        end

        TX_SEND : begin
            if (bit_cnt == 4'h9 && width_cnt == uart_bit_width) begin // 1 start + 8 bits + 1 stop
                ns = IDLE;
            end else begin
                ns = TX_SEND;
            end
        end

        default : begin
            ns = IDLE;
        end
    endcase
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        width_cnt <= 16'h0;
    end else if (cs == TX_SEND && width_cnt == uart_bit_width) begin
        width_cnt <= 16'h0;
    end else if (cs == TX_SEND) begin
        width_cnt <= width_cnt + 1'b1;
    end else begin
        width_cnt <= 16'h0;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        bit_cnt <= 4'h0;
    end else if (cs == TX_SEND && width_cnt == uart_bit_width) begin
        bit_cnt <= bit_cnt + 1'b1;
    end else if (cs == TX_SEND) begin
        bit_cnt <= bit_cnt;
    end else begin
        bit_cnt <= 4'h0;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        tx_shift <= 10'h3ff;
    end else if (cs == IDLE) begin
        tx_shift <= {tx_dout,1'b0,1'b1};  // 1 start + 8 bits + 1 stop
    end else if (cs == TX_SEND && width_cnt == uart_bit_width) begin
        tx_shift <= {1'b1,tx_shift[9:1]};  // 1 start + 8 bits + 1 stop
    end else
        ;
end

assign tx_rd_en = bit_cnt == 4'h9 && width_cnt == uart_bit_width;

assign tx = tx_shift[0];

endmodule

