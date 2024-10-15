/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-11-01  17:34:29
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-11-01  17:34:29
 # FilePath     : signal_delay.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module signal_delay(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [31:0]           delay_value             ,

    input wire                  signal_in               ,
    output wire                 signal_out
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   signal_in_dly           ;
    reg [31:0]                  delay_value_lock        ;
    reg [31:0]                  cnt_delay               ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        signal_in_r             ;

/********************************************************
*                        logic Here                     *
********************************************************/

    assign signal_in_r          = signal_in_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            signal_in_dly       <= 'd0;
        end else begin
            signal_in_dly       <= {signal_in_dly[2:0], signal_in};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            delay_value_lock    <= 'd0;
        end else if (signal_in_r == 1'b1) begin
            delay_value_lock    <= delay_value;
        end else begin
            delay_value_lock    <= delay_value_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_delay           <= 'h3FFF_FFFF;
        end else if (signal_in_r == 1'b1) begin
            cnt_delay           <= 'd1;
        end else if (cnt_delay >= 'h3FFF_FFFF) begin
            cnt_delay           <= 'h3FFF_FFFF;
        end else begin
            cnt_delay           <= cnt_delay + 1'b1;
        end
    end

    assign signal_out = (cnt_delay == delay_value_lock - 1'b1) && (delay_value_lock > 'd0);


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [3:0]                       debug_signal_in_dly                 ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_delay_value_lock              ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_delay                     ;
(* mark_debug = "true" *)    reg                                debug_signal_in_r                   ;

always @ (posedge clk) begin
    debug_signal_in_dly                  <= signal_in_dly                 ;
    debug_delay_value_lock               <= delay_value_lock              ;
    debug_cnt_delay                      <= cnt_delay                     ;
    debug_signal_in_r                    <= signal_in_r                   ;
end

endmodule
