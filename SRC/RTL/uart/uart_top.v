/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-17  09:47:05
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-17  09:47:05
 # FilePath     : uart_top.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module uart_top(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Reg_fpga port
    output wire [15:0]          reg_mpu1_angle_x        ,
    output wire [15:0]          reg_mpu1_angle_y        ,
    output wire [15:0]          reg_mpu1_angle_z        ,
    output wire [15:0]          reg_mpu1_temp           ,
    output wire [31:0]          reg_sum_err_num         ,
    input wire                  reg_num_check_clr       ,

    input wire [7:0]            reg_mpu1_cfg_addr       ,
    input wire [15:0]           reg_mpu1_cfg_value      ,
    input wire                  reg_mpu1_cfg_req        ,
    output wire                 reg_mpu1_cfg_done       ,
    input wire [15:0]           reg_mpu1_bps            ,

    // Uart port
    input wire                  uart_rxd                ,
    output wire                 uart_txd
);



/********************************************************
*                        regs  Here                     *
********************************************************/



/********************************************************
*                        wires Here                     *
********************************************************/

// uart_rx_ctrl Inputs, Outputs, and Bidirs
    wire [7:0]                  rx_data                 ;
    wire                        rx_vld                  ;

// uart_tx_ctrl Inputs, Outputs, and Bidirs
    wire [7:0]                  tx_data                 ;
    wire                        tx_vld                  ;
    wire                        tx_ready                ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign tx_ready             = ~tx_data_busy;

    uart_rx_ctrl uart_rx_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),
        .rx_data                                        (rx_data                                        ),
        .rx_vld                                         (rx_vld                                         ),
        .reg_mpu1_angle_x                               (reg_mpu1_angle_x                               ),
        .reg_mpu1_angle_y                               (reg_mpu1_angle_y                               ),
        .reg_mpu1_angle_z                               (reg_mpu1_angle_z                               ),
        .reg_mpu1_temp                                  (reg_mpu1_temp                                  ),
        .reg_sum_err_num                                (reg_sum_err_num                                ),
        .reg_num_check_clr                              (reg_num_check_clr                              )
    );

    uart_tx_ctrl #(

        .UART_HEAD0                                     (8'hFF                                          ),
        .UART_HEAD1                                     (8'hAA                                          )
    ) uart_tx_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),
        .tx_data                                        (tx_data                                        ),
        .tx_vld                                         (tx_vld                                         ),
        .tx_ready                                       (tx_ready                                       ),
        .reg_mpu1_cfg_addr                              (reg_mpu1_cfg_addr                              ),
        .reg_mpu1_cfg_value                             (reg_mpu1_cfg_value                             ),
        .reg_mpu1_cfg_req                               (reg_mpu1_cfg_req                               ),
        .reg_mpu1_cfg_done                              (reg_mpu1_cfg_done                              )
    );


    uart_rx inst_uart_rx(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .uart_bit_width                                 (reg_mpu1_bps                                   ),
        .rx                                             (uart_rxd                                       ),
        .rx_data                                        (rx_data                                        ),
        .rx_data_vld                                    (rx_vld                                         )
    );

    uart_tx inst_uart_tx(

            .clk                                        (clk                                            ),
            .rst                                        (rst                                            ),
            .uart_bit_width                             (reg_mpu1_bps                                   ),
            .tx                                         (uart_txd                                       ),
            .tx_data                                    (tx_data                                        ),
            .tx_data_vld                                (tx_vld                                         ),
            .tx_data_busy                               (tx_data_busy                                   )
        );

endmodule