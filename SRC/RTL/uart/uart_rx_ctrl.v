 /********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-16  15:06:43
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-16  15:06:43
 # FilePath     : uart_rx_ctrl.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module uart_rx_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Uart byte in
    input wire [7:0]            rx_data                 ,
    input wire                  rx_vld                  ,

    //
    output wire [15:0]          reg_mpu1_angle_x        ,
    output wire [15:0]          reg_mpu1_angle_y        ,
    output wire [15:0]          reg_mpu1_angle_z        ,
    output wire [15:0]          reg_mpu1_temp           ,

    output wire [31:0]          reg_sum_err_num         ,
    input wire                  reg_num_check_clr
);

    localparam S_IDLE           = 8'd0;
    localparam S_START          = 8'd1;
    localparam S_CMD            = 8'd2;
    localparam S_BYTE0          = 8'd3;
    localparam S_BYTE1          = 8'd4;
    localparam S_BYTE2          = 8'd5;
    localparam S_BYTE3          = 8'd6;
    localparam S_SUM            = 8'd7;



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [7:0]                   c_state                 ;
    reg [7:0]                   n_state                 ;

    reg [7:0]                   sum_temp                ;
    reg [7:0]                   cmd_lock                ;

    reg [15:0]                  byte0_lock              ;
    reg [15:0]                  byte1_lock              ;
    reg [15:0]                  byte2_lock              ;
    reg [15:0]                  byte3_lock              ;

    reg [15:0]                  anglex_temp             ;
    reg [15:0]                  angley_temp             ;
    reg [15:0]                  anglez_temp             ;
    // Temperature_temporary
    reg [15:0]                  temp_temp               ;

    reg [3:0]                   cnt_byte                ;

    reg [31:0]                  cnt_err_num             ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        flag_start              ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign flag_start           = rx_vld && rx_data == 8'h55;





    always @ (posedge clk or posedge rst) begin : FSM_1
        if (rst == 1'b1) begin
            c_state             <= S_IDLE;
        end else begin
            c_state             <= n_state;
        end
    end

    always @ (*) begin : FSM_2
        case (c_state)
            S_IDLE :            if (flag_start == 1'b1) begin
                                    n_state = S_CMD;
                                end else begin
                                    n_state = S_START;
                                end

            S_START :           if (flag_start == 1'b1) begin
                                    n_state = S_CMD;
                                end else begin
                                    n_state = S_START;
                                end

            S_CMD :             if (rx_vld == 1'b1) begin
                                    n_state = S_BYTE0;
                                end else begin
                                    n_state = S_CMD;
                                end

            S_BYTE0 :           if (rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
                                    n_state = S_BYTE1;
                                end else begin
                                    n_state = S_BYTE0;
                                end

            S_BYTE1 :           if (rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
                                    n_state = S_BYTE2;
                                end else begin
                                    n_state = S_BYTE1;
                                end

            S_BYTE2 :           if (rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
                                    n_state = S_BYTE3;
                                end else begin
                                    n_state = S_BYTE2;
                                end

            S_BYTE3 :           if (rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
                                    n_state = S_SUM;
                                end else begin
                                    n_state = S_BYTE3;
                                end

            S_SUM :             if (rx_vld == 1'b1) begin
                                    n_state = S_IDLE;
                                end else begin
                                    n_state = S_SUM;
                                end

            default :           n_state = S_IDLE;
        endcase
    end


    // cnt
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_byte            <= 'd0;
        end else if (c_state == S_CMD && rx_vld == 1'b1) begin
            cnt_byte            <= 'd0;
        end else if (rx_vld == 1'b1) begin
            cnt_byte            <= cnt_byte + 1'b1;
        end else begin
            cnt_byte            <= cnt_byte;
        end
    end

    // Uart load
        // cmd lock
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cmd_lock            <= 'd0;
        end else if (c_state == S_CMD && rx_vld == 1'b1) begin
            cmd_lock            <= rx_data;
        end else begin
            cmd_lock            <= cmd_lock;
        end
    end

        // byte0 lock
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            byte0_lock          <= 'd0;
        end else if (c_state == S_BYTE0 && rx_vld == 1'b1 && cnt_byte[0] == 1'b0) begin
            byte0_lock          <= {8'd0, rx_data};
        end else if (c_state == S_BYTE0 && rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
            byte0_lock          <= {rx_data, byte0_lock[7:0]};
        end else begin
            byte0_lock          <= byte0_lock;
        end
    end

        // byte1 lock
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            byte1_lock          <= 'd0;
        end else if (c_state == S_BYTE1 && rx_vld == 1'b1 && cnt_byte[0] == 1'b0) begin
            byte1_lock          <= {8'd0, rx_data};
        end else if (c_state == S_BYTE1 && rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
            byte1_lock          <= {rx_data, byte1_lock[7:0]};
        end else begin
            byte1_lock          <= byte1_lock;
        end
    end

        // byte2 lock
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            byte2_lock          <= 'd0;
        end else if (c_state == S_BYTE2 && rx_vld == 1'b1 && cnt_byte[0] == 1'b0) begin
            byte2_lock          <= {8'd0, rx_data};
        end else if (c_state == S_BYTE2 && rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
            byte2_lock          <= {rx_data, byte2_lock[7:0]};
        end else begin
            byte2_lock          <= byte2_lock;
        end
    end

        // byte3 lock
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            byte3_lock          <= 'd0;
        end else if (c_state == S_BYTE3 && rx_vld == 1'b1 && cnt_byte[0] == 1'b0) begin
            byte3_lock          <= {8'd0, rx_data};
        end else if (c_state == S_BYTE3 && rx_vld == 1'b1 && cnt_byte[0] == 1'b1) begin
            byte3_lock          <= {rx_data, byte3_lock[7:0]};
        end else begin
            byte3_lock          <= byte3_lock;
        end
    end

    // Uart check sum
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sum_temp            <= 'd0;
        end else if (c_state == S_IDLE && rx_vld == 1'b0) begin
            sum_temp            <= 'd0;
        end else if (rx_vld == 1'b1) begin
            sum_temp            <= sum_temp + rx_data;
        end else begin
            sum_temp            <= sum_temp;
        end
    end

    // angle refresh
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            anglex_temp         <= 'd0;
        end else if (c_state == S_SUM && cmd_lock == 8'h53) begin
            anglex_temp         <= byte0_lock;
        end else begin
            anglex_temp         <= anglex_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            angley_temp         <= 'd0;
        end else if (c_state == S_SUM && cmd_lock == 8'h53) begin
            angley_temp         <= byte1_lock;
        end else begin
            angley_temp         <= angley_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            anglez_temp         <= 'd0;
        end else if (c_state == S_SUM && cmd_lock == 8'h53) begin
            anglez_temp         <= byte2_lock;
        end else begin
            anglez_temp         <= anglez_temp;
        end
    end

    // Temperature_temporary
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            temp_temp           <= 'd0;
        end else if (c_state == S_SUM) begin
            temp_temp           <= byte3_lock;
        end else begin
            temp_temp           <= temp_temp;
        end
    end

    // Check sum count
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_err_num         <= 'd0;
        end else if (reg_num_check_clr == 1'b1) begin
            cnt_err_num         <= 'd0;
        end else if (c_state == S_SUM && rx_vld == 1'b1 && rx_data != sum_temp) begin
            cnt_err_num         <= cnt_err_num + 1'b1;
        end else begin
            cnt_err_num         <= cnt_err_num;
        end
    end



    // Output
    assign reg_sum_err_num      = cnt_err_num;

    assign reg_mpu1_angle_x     = anglex_temp;
    assign reg_mpu1_angle_y     = angley_temp;
    assign reg_mpu1_angle_z     = anglez_temp;

    assign reg_mpu1_temp        = temp_temp; // Temperature_temporary


endmodule