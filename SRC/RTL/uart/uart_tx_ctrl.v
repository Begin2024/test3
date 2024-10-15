/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-16  17:51:41
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-16  17:51:41
 # FilePath     : uart_tx_ctrl.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module uart_tx_ctrl #(

    parameter UART_HEAD0        = 8'hFF,
    parameter UART_HEAD1        = 8'hAA
)(
    input wire                  clk                     ,
    input wire                  rst                     ,

    // Uart byte out
    output wire [7:0]           tx_data                 ,
    output wire                 tx_vld                  ,
    input wire                  tx_ready                ,

    // Reg_fpga port
    input wire [7:0]            reg_mpu1_cfg_addr       ,
    input wire [15:0]           reg_mpu1_cfg_value      ,
    input wire                  reg_mpu1_cfg_req        ,
    output wire                 reg_mpu1_cfg_done
);

    localparam S_IDLE           = 8'd0;
    localparam S_START          = 8'd1;
    localparam S_CMD            = 8'd2;
    localparam S_ADDR           = 8'd3;
    localparam S_DATAL          = 8'd4;
    localparam S_DATAH          = 8'd5;

/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [7:0]                   c_state                 ;
    reg [7:0]                   n_state                 ;

    reg [3:0]                   cfg_req_dly             ;

    reg [7:0]                   addr_lock               ;
    reg [15:0]                  value_lock              ;

    reg [7:0]                   data_temp               ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        cfg_req_r               ;

    wire                        vld_temp                ;
    wire                        done_temp               ;

/********************************************************
*                        logic Here                     *
********************************************************/

    // Frame prepare
    assign cfg_req_r            = cfg_req_dly[3:0] == 4'b0001;

    always @ (posedge clk) begin
        cfg_req_dly             <= {cfg_req_dly[2:0], reg_mpu1_cfg_req};
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            addr_lock           <= 'd0;
        end else if (c_state == S_IDLE && cfg_req_r == 1'b1) begin
            addr_lock           <= reg_mpu1_cfg_addr;
        end else begin
            addr_lock           <= addr_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            value_lock          <= 'd0;
        end else if (c_state == S_IDLE && cfg_req_r == 1'b1) begin
            value_lock          <= reg_mpu1_cfg_value;
        end else begin
            value_lock          <= value_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin : FSM_1
        if (rst == 1'b1) begin
            c_state             <= S_IDLE;
        end else begin
            c_state             <= n_state;
        end
    end


    always @ (*) begin : FSM_2
        case (c_state)
            S_IDLE :            if (cfg_req_r == 1'b1) begin
                                    n_state = S_START;
                                end else begin
                                    n_state = S_IDLE;
                                end

            S_START :           if (tx_ready == 1'b1) begin
                                    n_state = S_CMD;
                                end else begin
                                    n_state = S_START;
                                end

            S_CMD :             if (tx_ready == 1'b1) begin
                                    n_state = S_ADDR;
                                end else begin
                                    n_state = S_CMD;
                                end

            S_ADDR :            if (tx_ready == 1'b1) begin
                                    n_state = S_DATAL;
                                end else begin
                                    n_state = S_ADDR;
                                end

            S_DATAL :           if (tx_ready == 1'b1) begin
                                    n_state = S_DATAH;
                                end else begin
                                    n_state = S_DATAL;
                                end

            S_DATAH :           if (tx_ready == 1'b1) begin
                                    n_state = S_IDLE;
                                end else begin
                                    n_state = S_DATAH;
                                end

            default :           n_state = S_IDLE;
        endcase
    end


    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            data_temp           <= 'd0;
        end else begin
            case (c_state)
                S_IDLE :            if (cfg_req_r == 1'b1) begin
                                        data_temp <= UART_HEAD0;
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                S_START :           if (tx_ready == 1'b1) begin
                                        data_temp <= UART_HEAD1;
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                S_CMD :             if (tx_ready == 1'b1) begin
                                        data_temp <= addr_lock;
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                S_ADDR :            if (tx_ready == 1'b1) begin
                                        data_temp <= value_lock[7:0];
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                S_DATAL :           if (tx_ready == 1'b1) begin
                                        data_temp <= value_lock[15:8];
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                S_DATAH :           if (tx_ready == 1'b1) begin
                                        data_temp <= 'd0;
                                    end else begin
                                        data_temp <= data_temp;
                                    end

                default :           data_temp = data_temp;
            endcase
        end
    end

    assign vld_temp                 = c_state == S_IDLE ? 1'b0 : tx_ready;
    assign done_temp                = c_state == S_IDLE ? 1'b1 : 1'b0;

    // Output
    assign tx_data                  = data_temp;
    assign tx_vld                   = vld_temp;
    assign reg_mpu1_cfg_done        = done_temp;


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [7:0]                       debug_tx_data                       ;
(* mark_debug = "true" *)    reg                                debug_tx_vld                        ;
(* mark_debug = "true" *)    reg                                debug_tx_ready                      ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_reg_mpu1_cfg_addr             ;
(* mark_debug = "true" *)    reg    [15:0]                      debug_reg_mpu1_cfg_value            ;
(* mark_debug = "true" *)    reg                                debug_reg_mpu1_cfg_req              ;
(* mark_debug = "true" *)    reg                                debug_reg_mpu1_cfg_done             ;

always @ (posedge clk) begin
    debug_tx_data                        <= tx_data                       ;
    debug_tx_vld                         <= tx_vld                        ;
    debug_tx_ready                       <= tx_ready                      ;
    debug_reg_mpu1_cfg_addr              <= reg_mpu1_cfg_addr             ;
    debug_reg_mpu1_cfg_value             <= reg_mpu1_cfg_value            ;
    debug_reg_mpu1_cfg_req               <= reg_mpu1_cfg_req              ;
    debug_reg_mpu1_cfg_done              <= reg_mpu1_cfg_done             ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [7:0]                       debug_c_state                       ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_n_state                       ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_cfg_req_dly                   ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_addr_lock                     ;
(* mark_debug = "true" *)    reg    [15:0]                      debug_value_lock                    ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_data_temp                     ;
(* mark_debug = "true" *)    reg                                debug_cfg_req_r                     ;
(* mark_debug = "true" *)    reg                                debug_vld_temp                      ;
(* mark_debug = "true" *)    reg                                debug_done_temp                     ;

always @ (posedge clk) begin
    debug_c_state                        <= c_state                       ;
    debug_n_state                        <= n_state                       ;
    debug_cfg_req_dly                    <= cfg_req_dly                   ;
    debug_addr_lock                      <= addr_lock                     ;
    debug_value_lock                     <= value_lock                    ;
    debug_data_temp                      <= data_temp                     ;
    debug_cfg_req_r                      <= cfg_req_r                     ;
    debug_vld_temp                       <= vld_temp                      ;
    debug_done_temp                      <= done_temp                     ;
end

endmodule