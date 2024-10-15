/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2022-08-24 12:03:36
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2022-09-20 18:34:40
#FilePath     : uart_rx.v
#Description  : ---
#Copyright (c) 2022 by Insnex.com, All Rights Reserved.
********************************************************************/
module uart_rx(
    input                           clk                             ,
    input                           rst                             ,

    input           [15:0]          uart_bit_width                  ,

    input                           rx                              ,

    output  reg     [7:0]           rx_data                         ,
    output  reg                     rx_data_vld


);

parameter                           IDLE                =   4'h0    ;
parameter                           RX_SAMPLE           =   4'h1    ;

/********************************************************************
*                        Regs  Here                                 *
********************************************************************/
reg                 [2:0]           rx_dly                          ;

reg                 [3:0]           cs                              ;
reg                 [3:0]           ns                              ;

reg                 [15:0]          width_cnt                       ;
reg                 [3:0]           bit_cnt                         ;

reg                 [9:0]           rx_shift                        ;
/********************************************************************
*                        Wires Here                                 *
********************************************************************/
wire                                rx_sync                         ;
wire                                rx_sync_dly                     ;
wire                                rx_sync_r                       ;
wire                                rx_sync_f                       ;


/********************************************************************
*                        Logic Here                                 *
********************************************************************/

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        rx_dly <= 3'h0;
    end else begin
        rx_dly <= {rx_dly[1:0],rx};
    end
end

assign rx_sync = rx_dly[1];
assign rx_sync_dly = rx_dly[2];

assign rx_sync_r = rx_sync == 1'b1 && rx_sync_dly == 1'b0;
assign rx_sync_f = rx_sync == 1'b0 && rx_sync_dly == 1'b1;

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
            if (rx_sync_f == 1'b1) begin
                ns = RX_SAMPLE;
            end else begin
                ns = IDLE;
            end
        end

        RX_SAMPLE : begin
//            if (bit_cnt == 4'h9 && width_cnt == uart_bit_width) begin // 1 start + 8 bits + 1 stop
            if (bit_cnt == 4'h8 && width_cnt == uart_bit_width) begin // 1 start + 8 bits
                ns = IDLE;
            end else begin
                ns = RX_SAMPLE;
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
    end else if (cs == RX_SAMPLE && width_cnt == uart_bit_width) begin
        width_cnt <= 16'h0;
    end else if (cs == RX_SAMPLE) begin
        width_cnt <= width_cnt + 1'b1;
    end else begin
        width_cnt <= 16'h0;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        bit_cnt <= 4'h0;
    end else if (cs == RX_SAMPLE && width_cnt == uart_bit_width) begin
        bit_cnt <= bit_cnt + 1'b1;
    end else if (cs == RX_SAMPLE) begin
        bit_cnt <= bit_cnt;
    end else begin
        bit_cnt <= 4'h0;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        rx_shift <= 10'h0;
    end else if (cs == RX_SAMPLE && width_cnt == uart_bit_width[15:1]) begin  //sample the data in the mid of the bit
        rx_shift <= {rx_sync,rx_shift[9:1]};
    end else if (cs == RX_SAMPLE) begin
        rx_shift <= rx_shift;
    end else begin
        rx_shift <= 10'h0;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        rx_data <= 8'h0;
//    end else if (bit_cnt == 4'h9 && width_cnt == uart_bit_width) begin  //lock the data in the end of the last bit
//        rx_data <= rx_shift[8:1];
    end else if (bit_cnt == 4'h8 && width_cnt == uart_bit_width) begin  //lock the data in the end of the last bit(exp stop bit)
        rx_data <= rx_shift[9:2];
    end else begin
        rx_data <= rx_data;
    end
end

always @ (posedge clk , posedge rst) begin
    if (rst == 1'b1) begin
        rx_data_vld <= 1'h0;
//    end else if (bit_cnt == 4'h9 && width_cnt == uart_bit_width) begin  //lock the data in the end of the last bit
//        rx_data_vld <= 1'b1;
    end else if (bit_cnt == 4'h8 && width_cnt == uart_bit_width) begin  //lock the data in the end of the last bit
        rx_data_vld <= 1'b1;
    end else begin
        rx_data_vld <= 1'h0;
    end
end

endmodule

