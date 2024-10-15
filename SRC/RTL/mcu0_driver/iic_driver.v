/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-07  11:56:31
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-08-07  11:56:31
 # FilePath     : iic_driver.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module iic_driver(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Reg_fpga port
    input wire                  reg_iic_whrl            ,
    input wire  [6:0]           reg_iic_dev_addr        ,
    input wire  [7:0]           reg_iic_addr            ,
    input wire  [7:0]           reg_iic_wdata           ,
    output wire [7:0]           reg_iic_rdata           ,
    input wire                  reg_iic_req             ,
    output wire                 reg_iic_done            ,

    // IIC port
    output wire                 iic_sda_ctrl            ,
    output wire                 iic_scl                 ,
    output wire                 iic_sda_o               ,
    input wire                  iic_sda_i
);

    // 125M时钟每个周期�??8ns  25us = 8ns * 3120
    // IIC 时钟频率 40K
    localparam T_10US            = 12'd3200             ;

    localparam S_IDLE            = 10'b00_0000_0001     ;
    localparam S_START           = 10'b00_0000_0010     ;
    localparam S_DEV_ADDR        = 10'b00_0000_0100     ;
    localparam S_ACK             = 10'b00_0000_1000     ;
    localparam S_ADDR            = 10'b00_0001_0000     ;
    localparam S_WDATA           = 10'b00_0010_0000     ;
    localparam S_RESTART         = 10'b00_0100_0000     ;
    localparam S_RDATA           = 10'b00_1000_0000     ;
    localparam S_NACK            = 10'b01_0000_0000     ;
    localparam S_STOP            = 10'b10_0000_0000     ;

/********************************************************
*                        regs  here                     *
********************************************************/

    reg                         scl_temp                ;
    reg                         sda_ctrl                ;
    reg                         sda_temp                ;
    reg                         whrl_lock               ;
    reg [6:0]                   dev_addr_lock           ;
    reg [7:0]                   wdata_lock              ;
    reg [7:0]                   addr_lock               ;

    reg [31:0]                  cnt_scl                 ;
    reg [5:0]                   cnt_bit                 ;
    reg [9:0]                   c_state                 ;
    reg [9:0]                   n_state                 ;

    reg [7:0]                   dev_addr_temp           ;
    reg [7:0]                   wdata_temp              ;
    reg [7:0]                   addr_temp               ;

    reg [7:0]                   rdata_temp              ;
    reg                         done_temp               ;

    reg [3:0]                   reg_iic_req_dly         ;

/********************************************************
*                        wires here                     *
********************************************************/

    // high fall low rise
    wire [10:0]                 qtr_scl                 ;
    wire                        scl_h                   ;
    wire                        scl_f                   ;
    wire                        scl_l                   ;
    wire                        scl_r                   ;

    wire                        reg_iic_req_r           ;

/********************************************************
*                        logic here                     *
********************************************************/

    assign iic_sda_ctrl         = sda_ctrl;

    assign reg_iic_req_r        = reg_iic_req_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            reg_iic_req_dly     <= 'd0;
        end else begin
            reg_iic_req_dly     <= {reg_iic_req_dly[2:0], reg_iic_req};
        end
    end

    // IIC访问过程中锁存相关参�??
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            whrl_lock           <= 1'b1;
            dev_addr_lock       <= 7'b000_0000;
            wdata_lock          <= 8'd0;
            addr_lock           <= 8'd0;
        end else if (reg_iic_req_r && c_state == S_IDLE) begin
            whrl_lock           <= reg_iic_whrl;
            dev_addr_lock       <= reg_iic_dev_addr;
            wdata_lock          <= reg_iic_wdata;
            addr_lock           <= reg_iic_addr;
        end else begin
            whrl_lock           <= whrl_lock;
            dev_addr_lock       <= dev_addr_lock;
            wdata_lock          <= wdata_lock;
            addr_lock           <= addr_lock;
        end
    end

    // scl计数器， 用以控制scl输出及sda数据变化时刻
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_scl             <= (T_10US >> 1'b1) + 1'b1;
        // 使初始�?�向0的左边稍有偏移，确保�??始后能第�??时间输出起始�??
        end else if (c_state == S_IDLE) begin
            cnt_scl             <= (T_10US >> 1'b1) + 1'b1;
        end else if (cnt_scl >= T_10US-1'b1) begin
            cnt_scl             <= 32'd0;
        end else begin
            cnt_scl             <= cnt_scl + 1'b1;
        end
    end

    // 1/4个时钟周�??
    assign qtr_scl              = T_10US >> 2'd2;
    assign scl_h                = (cnt_scl == (1'd0   )) ? 1'b1 : 1'b0;
    assign scl_f                = (cnt_scl == (qtr_scl)) ? 1'b1 : 1'b0;
    assign scl_l                = (cnt_scl == (qtr_scl + qtr_scl)) ? 1'b1 : 1'b0;
    assign scl_r                = (cnt_scl == (qtr_scl + qtr_scl + qtr_scl)) ? 1'b1 : 1'b0;

    // 从scl第一个低电平�??始计�??
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_bit             <= 6'd0;
        end else if (c_state == S_IDLE) begin
            cnt_bit             <= 6'd0;
        end else if (scl_l == 1'b1) begin
            cnt_bit             <= cnt_bit + 1'b1;
        end else begin
            cnt_bit             <= cnt_bit;
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
            S_IDLE :            if (reg_iic_req_r == 1'b1) begin
                                    n_state = S_START;
                                end else begin
                                    n_state = S_IDLE;
                                end

            S_START :           if (cnt_bit == 6'd0 &&  scl_h == 1'b1) begin
                                    n_state = S_DEV_ADDR;
                                end else begin
                                    n_state = S_START;
                                end

            S_DEV_ADDR :        if ((cnt_bit == 6'd8 || cnt_bit == 6'd27) && scl_l == 1'b1) begin
                                    n_state = S_ACK;
                                end else begin
                                    n_state = S_DEV_ADDR;
                                end

            S_ACK :             if (cnt_bit == 6'd9 && scl_l == 1'b1) begin
                                    n_state = S_ADDR;
                                end else if (cnt_bit == 6'd18 && scl_l == 1'b1) begin
                                    if (whrl_lock == 1'b1) begin
                                        n_state = S_WDATA;
                                    end else begin
                                        n_state = S_RESTART;
                                    end
                                end else if (cnt_bit == 6'd27 && scl_l == 1'b1) begin
                                    n_state = S_STOP;
                                end else if (cnt_bit == 6'd28 && scl_l == 1'b1) begin
                                    n_state = S_RDATA;
                                end else begin
                                    n_state = S_ACK;
                                end

            S_ADDR :            if (cnt_bit == 6'd17 && scl_l == 1'b1) begin
                                    n_state = S_ACK;
                                end else begin
                                    n_state = S_ADDR;
                                end

            S_WDATA :           if (cnt_bit == 6'd26 && scl_l == 1'b1) begin
                                    n_state = S_ACK;
                                end else begin
                                    n_state = S_WDATA;
                                end

            S_RESTART :         if (cnt_bit == 6'd19 && scl_h == 1'b1) begin
                                    n_state = S_DEV_ADDR;
                                end else begin
                                    n_state = S_RESTART;
                                end

            S_RDATA :           if (cnt_bit == 6'd36 && scl_l == 1'b1) begin
                                    n_state = S_NACK;
                                end else begin
                                    n_state = S_RDATA;
                                end

            S_NACK :            if (cnt_bit == 6'd37 && scl_l == 1'b1) begin
                                    n_state = S_STOP;
                                end else begin
                                    n_state = S_NACK;
                                end

            S_STOP :            if (scl_l == 1'b1) begin
                                    n_state = S_IDLE;
                                end else begin
                                    n_state = S_STOP;
                                end

            default :           n_state = S_IDLE;
        endcase
    end

    // 注意:寄存器接口读写为whrl 但在本设备上为wlrh
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dev_addr_temp       <= 8'd0;
        end else if (c_state == S_START) begin
            dev_addr_temp       <= {dev_addr_lock, 1'b0};
        end else if (c_state == S_RESTART) begin
            dev_addr_temp       <= {dev_addr_lock, 1'b1};
        end else if (c_state == S_DEV_ADDR && scl_l == 1'b1) begin
            // dev_addr_temp       <= {dev_addr_temp[6:0], dev_addr_temp[7]};
            dev_addr_temp       <= dev_addr_temp << 1'b1;
        end else begin
            dev_addr_temp       <= dev_addr_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            wdata_temp          <= 8'd0;
        end else if (c_state == S_ACK) begin
            wdata_temp          <= wdata_lock;
        end else if (c_state == S_WDATA && scl_l == 1'b1) begin
            // wdata_temp          <= {wdata_temp[6:0], wdata_temp[7]};
            wdata_temp          <= wdata_temp << 1'b1;
        end else begin
            wdata_temp          <= wdata_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            addr_temp           <= 8'd0;
        end else if (c_state == S_ACK) begin
            addr_temp           <= addr_lock;
        end else if (c_state == S_ADDR && scl_l == 1'b1) begin
            // addr_temp           <= {addr_temp[6:0], addr_temp[7]};
            addr_temp           <= addr_temp << 1'b1;
        end else begin
            addr_temp           <= addr_temp;
        end
    end

    // 驱动IIC时钟信号SCL
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            scl_temp            <= 1'b1;
        end else if (c_state == S_IDLE || (c_state == S_STOP && scl_r == 1'b1)) begin
            scl_temp            <= 1'b1;
        end else if (scl_f == 1'b1 && c_state != S_STOP) begin
            scl_temp            <= 1'b0;
        end else if (scl_r == 1'b1) begin
            scl_temp            <= 1'b1;
        end else begin
            scl_temp            <= scl_temp;
        end
    end

    // 双向端口SDA控制信号sda_ctrl
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sda_ctrl            <= 1'b0;
        end else if (c_state == S_IDLE || c_state == S_ACK) begin
            sda_ctrl            <= 1'b0;
        end else if (c_state == S_RDATA) begin
            sda_ctrl            <= 1'b0;
        end else begin
            sda_ctrl            <= 1'b1;
        end
    end

    // 驱动IIC数据信号SDA
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            sda_temp            <= 1'b1;
        end else case (c_state)
            S_IDLE :            sda_temp <= 1'b1;

            S_START :           if (scl_h == 1'b1) begin
                                    sda_temp <= 1'b0;
                                end else begin
                                    sda_temp <= sda_temp;
                                end

            S_DEV_ADDR :        if (scl_l == 1'b1) begin
                                    sda_temp <= dev_addr_temp[7];
                                end else begin
                                    sda_temp <= sda_temp;
                                end

            S_RESTART :         begin
                                    if (scl_h == 1'b1) begin
                                        sda_temp <= 1'b0;
                                    end else begin
                                        sda_temp <= sda_temp;
                                    end
                                end

            S_ADDR :            sda_temp <= addr_temp[7];

            S_WDATA :           sda_temp <= wdata_temp[7];

            S_ACK :             if (cnt_bit == 'd18 && whrl_lock == 'd0) begin
                                    sda_temp <= 1'b1;
                                end else begin
                                    sda_temp <= 1'b0;
                                end

            S_RDATA :           sda_temp <= 1'b1;

            S_NACK :            if (cnt_bit == 'd37 && scl_l == 1'b1) begin
                                    sda_temp <= 1'b0;
                                end else begin
                                    sda_temp <= sda_temp;
                                end

            // S_NACK :            if (cnt_bit == 6'd36 && scl_l == 1'b1) begin
            //                         sda_temp <= 1'b1;
            //                     end else if (cnt_bit == 6'd38 && scl_l == 1'b1) begin
            //                         sda_temp <= 1'b0;
            //                     end else begin
            //                         sda_temp <= sda_temp;
            //                     end

            S_STOP :            if (scl_h == 1'b1) begin
                                    sda_temp <= 1'b1;
                                end else begin
                                    sda_temp <= sda_temp;
                                end

            default :           sda_temp <= sda_temp;
        endcase
    end

    // 寄存器接口iic读出数据
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            rdata_temp          <= 8'd0;
        end else if (c_state == S_RDATA && scl_r == 1'b1) begin
            rdata_temp          <= {rdata_temp[6:0], iic_sda_i};
        end else begin
            rdata_temp          <= rdata_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            done_temp           <= 1'b1;
        end else if (c_state != S_IDLE) begin
            done_temp           <= 1'b0;
        end else begin
            done_temp           <= 1'b1;
        end
    end

    // 输出信号
        // 控制IIC总线状�??
    assign iic_scl              = scl_temp;
    assign iic_sda_o            = sda_temp;

    assign reg_iic_rdata        = rdata_temp;
    assign reg_iic_done         = done_temp;

 /*----------------------------DEBUG----------------------------*/

// (* mark_debug = "true" *)
(* dont_touch = "true" *)reg                            debug_reg_iic_whrl               ;
(* dont_touch = "true" *)reg [6:0]                      debug_reg_iic_dev_addr               ;
(* dont_touch = "true" *)reg [7:0]                      debug_reg_iic_addr               ;
(* dont_touch = "true" *)reg [7:0]                      debug_reg_iic_wdata               ;
(* dont_touch = "true" *)reg [7:0]                      debug_reg_iic_rdata               ;
(* dont_touch = "true" *)reg                            debug_reg_iic_req               ;
(* dont_touch = "true" *)reg                            debug_reg_iic_done               ;
(* dont_touch = "true" *)reg                            debug_iic_sda_ctrl               ;
(* dont_touch = "true" *)reg                            debug_iic_scl               ;
(* dont_touch = "true" *)reg                            debug_iic_sda_o               ;
(* dont_touch = "true" *)reg                            debug_iic_sda_i               ;
(* dont_touch = "true" *)reg                            debug_scl_temp                     ;
(* dont_touch = "true" *)reg                            debug_sda_ctrl                     ;
(* dont_touch = "true" *)reg                            debug_sda_temp                     ;
(* dont_touch = "true" *)reg                            debug_whrl_lock                    ;
(* dont_touch = "true" *)reg [6:0]                      debug_dev_addr_lock                ;
(* dont_touch = "true" *)reg [7:0]                      debug_wdata_lock                   ;
(* dont_touch = "true" *)reg [7:0]                      debug_addr_lock                    ;
(* dont_touch = "true" *)reg [31:0]                     debug_cnt_scl                      ;
(* dont_touch = "true" *)reg [5:0]                      debug_cnt_bit                      ;
(* dont_touch = "true" *)reg [9:0]                      debug_c_state                      ;
(* dont_touch = "true" *)reg [9:0]                      debug_n_state                      ;
(* dont_touch = "true" *)reg [7:0]                      debug_dev_addr_temp                ;
(* dont_touch = "true" *)reg [7:0]                      debug_wdata_temp                   ;
(* dont_touch = "true" *)reg [7:0]                      debug_addr_temp                    ;
(* dont_touch = "true" *)reg [7:0]                      debug_rdata_temp                   ;
(* dont_touch = "true" *)reg                            debug_done_temp                    ;
(* dont_touch = "true" *)reg                            debug_qtr_scl               ;
(* dont_touch = "true" *)reg                            debug_scl_h                 ;
(* dont_touch = "true" *)reg                            debug_scl_f                 ;
(* dont_touch = "true" *)reg                            debug_scl_l                 ;
(* dont_touch = "true" *)reg                            debug_scl_r                 ;
(* dont_touch = "true" *)reg                            debug_reg_iic_req_r              ;
always @ (posedge clk) begin
    debug_reg_iic_req_r <= reg_iic_req_r;
end
always @ (posedge clk) begin
    debug_reg_iic_whrl <= reg_iic_whrl;
end
always @ (posedge clk) begin
    debug_reg_iic_dev_addr <= reg_iic_dev_addr;
end
always @ (posedge clk) begin
    debug_reg_iic_addr <= reg_iic_addr;
end
always @ (posedge clk) begin
    debug_reg_iic_wdata <= reg_iic_wdata;
end
always @ (posedge clk) begin
    debug_reg_iic_rdata <= reg_iic_rdata;
end
always @ (posedge clk) begin
    debug_reg_iic_req <= reg_iic_req;
end
always @ (posedge clk) begin
    debug_reg_iic_done <= reg_iic_done;
end
always @ (posedge clk) begin
    debug_iic_sda_ctrl <= iic_sda_ctrl;
end
always @ (posedge clk) begin
    debug_iic_scl <= iic_scl;
end
always @ (posedge clk) begin
    debug_iic_sda_o <= iic_sda_o;
end
always @ (posedge clk) begin
    debug_iic_sda_i <= iic_sda_i;
end
always @ (posedge clk) begin
    debug_scl_temp       <= scl_temp      ;
end
always @ (posedge clk) begin
    debug_sda_ctrl       <= sda_ctrl      ;
end
always @ (posedge clk) begin
    debug_sda_temp       <= sda_temp      ;
end
always @ (posedge clk) begin
    debug_whrl_lock      <= whrl_lock     ;
end
always @ (posedge clk) begin
    debug_dev_addr_lock  <= dev_addr_lock ;
end
always @ (posedge clk) begin
    debug_wdata_lock     <= wdata_lock    ;
end
always @ (posedge clk) begin
    debug_addr_lock      <= addr_lock     ;
end
always @ (posedge clk) begin
    debug_cnt_scl        <= cnt_scl       ;
end
always @ (posedge clk) begin
    debug_cnt_bit        <= cnt_bit       ;
end
always @ (posedge clk) begin
    debug_c_state        <= c_state       ;
end
always @ (posedge clk) begin
    debug_n_state        <= n_state       ;
end
always @ (posedge clk) begin
    debug_dev_addr_temp  <= dev_addr_temp ;
end
always @ (posedge clk) begin
    debug_wdata_temp     <= wdata_temp    ;
end
always @ (posedge clk) begin
    debug_addr_temp      <= addr_temp     ;
end
always @ (posedge clk) begin
    debug_rdata_temp     <= rdata_temp    ;
end
always @ (posedge clk) begin
    debug_done_temp      <= done_temp     ;
end
always @ (posedge clk) begin
    debug_qtr_scl <= qtr_scl;
end
always @ (posedge clk) begin
    debug_scl_h   <= scl_h  ;
end
always @ (posedge clk) begin
    debug_scl_f   <= scl_f  ;
end
always @ (posedge clk) begin
    debug_scl_l   <= scl_l  ;
end
always @ (posedge clk) begin
    debug_scl_r   <= scl_r  ;
end

endmodule
