/*********************************************************
#        filename: sensor_exposure.v
#        author: rongzhuangzhuang
#        e-mail: zhuangzhuang.rong@insnex.com
#        description: ---
#        create:        2023-05-29 13:42:04
#        Last modified: 2023-08-18 11:42:13
*********************************************************/

module sensor_exposure(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [31:0]           reg_exposure_time       ,
    input wire [1:0]            reg_exp_chan            ,

    input wire                  trigger_in              ,

    output wire                 gmax_texp0              ,
    output wire                 gmax_texp1
);

/********************************************************
*                        regs  here                     *
********************************************************/

    reg [3:0]                   trigger_in_dly          ;
    reg [31:0]                  cnt_exp_time            ;

/********************************************************
*                        wires here                     *
********************************************************/

    wire                        trigger_in_r            ;

/********************************************************
*                        logic here                     *
********************************************************/

    assign trigger_in_r         = trigger_in_dly == 4'b0001;

    always @ (posedge clk) begin
        trigger_in_dly          <= {trigger_in_dly[2:0], trigger_in};
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_exp_time        <= 32'h7FFF_FFFF;
        end else if (trigger_in_r == 1'b1) begin
            cnt_exp_time        <= 32'd0;
        end else if (cnt_exp_time >= 32'h7FFF_FFFF) begin
            cnt_exp_time        <= 32'h7FFF_FFFF;
        end else begin
            cnt_exp_time        <= cnt_exp_time + 1'b1;
        end
    end

    // Output
    assign gmax_texp0           = reg_exp_chan == 2'd0 ? (cnt_exp_time < reg_exposure_time) : 1'b0;
    assign gmax_texp1           = reg_exp_chan == 2'd1 ? (cnt_exp_time < reg_exposure_time) : 1'b0;

 /*----------------------------DEBUG----------------------------*/

// (* mark_debug = "true" *)

(* dont_touch = "true" *)reg                            debug_trigger_in               ;
(* dont_touch = "true" *)reg                            debug_gmax_texp0               ;
(* dont_touch = "true" *)reg                            debug_gmax_texp1               ;
(* dont_touch = "true" *)reg [31:0]                     debug_reg_exposure_time               ;
(* dont_touch = "true" *)reg [1:0]                      debug_reg_exp_chan               ;
(* dont_touch = "true" *)reg [3:0]                      debug_trigger_in_dly               ;
(* dont_touch = "true" *)reg [31:0]                     debug_cnt_exp_time               ;
(* dont_touch = "true" *)reg                            debug_trigger_in_r               ;

always @ (posedge clk) begin
    debug_trigger_in <= trigger_in;
end
always @ (posedge clk) begin
    debug_gmax_texp0 <= gmax_texp0;
end
always @ (posedge clk) begin
    debug_gmax_texp1 <= gmax_texp1;
end
always @ (posedge clk) begin
    debug_reg_exposure_time <= reg_exposure_time;
end
always @ (posedge clk) begin
    debug_reg_exp_chan <= reg_exp_chan;
end
always @ (posedge clk) begin
    debug_trigger_in_dly <= trigger_in_dly;
end
always @ (posedge clk) begin
    debug_cnt_exp_time <= cnt_exp_time;
end
always @ (posedge clk) begin
    debug_trigger_in_r <= trigger_in_r;
end



endmodule

