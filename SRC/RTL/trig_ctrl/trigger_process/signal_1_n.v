/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-11-01  17:44:49
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-11-01  17:44:49
 # FilePath     : signal_1_n.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module signal_1_n(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [31:0]           signal_cycle            ,
    input wire [31:0]           signal_n                ,

    input wire                  signal_in               ,
    output wire                 signal_out
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   signal_in_dly           ;

    reg [31:0]                  signal_cycle_lock       ;
    reg [31:0]                  signal_n_lock           ;

    reg [31:0]                  cnt_signal_cycle        ;
    reg [31:0]                  cnt_signal_n            ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        signal_in_r             ;

    wire                        ena                     ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign signal_in_r          = signal_in_dly == 4'b0001 && (cnt_signal_n == 'd0) && (cnt_signal_cycle == 'h3FFF_FFFF);

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            signal_in_dly       <= 'd0;
        end else begin
            signal_in_dly       <= {signal_in_dly[2:0], signal_in};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            signal_cycle_lock   <= 'd0;
            signal_n_lock       <= 'd0;
        end else if (signal_in_r == 1'b1) begin
            signal_cycle_lock   <= signal_cycle;
            signal_n_lock       <= signal_n;
        end else begin
            signal_cycle_lock   <= signal_cycle_lock;
            signal_n_lock       <= signal_n_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_signal_n        <= 'd0;
        end else if ((cnt_signal_n >= signal_n_lock - 1'b1) && (cnt_signal_cycle >= signal_cycle_lock) && (signal_cycle_lock > 'd0) && (cnt_signal_cycle != 'h3FFF_FFFF)) begin
            cnt_signal_n        <= 'd0;
        end else if ((cnt_signal_cycle >= signal_cycle_lock) && (signal_cycle_lock > 'd0) && (cnt_signal_cycle != 'h3FFF_FFFF)) begin
            cnt_signal_n        <= cnt_signal_n + 1'b1;
        end else begin
            cnt_signal_n        <= cnt_signal_n;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_signal_cycle    <= 'h3FFF_FFFF;
        end else if (signal_in_r == 1'b1) begin
            cnt_signal_cycle    <= signal_cycle;
        end else if (cnt_signal_cycle >= 'h3FFF_FFFF) begin
            cnt_signal_cycle    <= 'h3FFF_FFFF;
        end else if ((cnt_signal_n >= signal_n_lock) && (cnt_signal_cycle >= (signal_cycle_lock - 'hA)) && (signal_cycle_lock > 'd0)) begin
            cnt_signal_cycle    <= 'h3FFF_FFFF;
        end else if ((cnt_signal_cycle >= signal_cycle_lock) && (signal_cycle_lock > 'd0)) begin
            cnt_signal_cycle    <= 'd0;
        end else begin
            cnt_signal_cycle    <= cnt_signal_cycle + 1'b1;
        end
    end

    assign signal_out           = (cnt_signal_cycle == signal_cycle_lock) && (signal_cycle_lock > 'd0);


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [3:0]                       debug_signal_in_dly                 ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_signal_cycle_lock             ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_signal_n_lock                 ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_signal_cycle              ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_signal_n                  ;
(* mark_debug = "true" *)    reg                                debug_signal_in_r                   ;

always @ (posedge clk) begin
    debug_signal_in_dly                  <= signal_in_dly                 ;
    debug_signal_cycle_lock              <= signal_cycle_lock             ;
    debug_signal_n_lock                  <= signal_n_lock                 ;
    debug_cnt_signal_cycle               <= cnt_signal_cycle              ;
    debug_cnt_signal_n                   <= cnt_signal_n                  ;
    debug_signal_in_r                    <= signal_in_r                   ;
end

endmodule
