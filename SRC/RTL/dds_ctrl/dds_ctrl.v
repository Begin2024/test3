/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-10-26  11:20:21
 # LastEditors  : yir  --  zhuangzhuang.rong@insnex.com
 # LastEditTime : 2023-10-26  11:20:21
 # FilePath     : dds_ctrl new.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module dds_ctrl(

    input wire                  clk                     ,
    input wire                  rst                     ,

    // Reg_fpga port
    input wire [9:0]            reg_dds_inc             ,
    input wire [31:0]           reg_dds_ack_time        ,
    input wire [13:0]           reg_current_offset      ,

    output wire [13:0]          reg_ram_rdata           ,
    output wire                 reg_ram_done            ,
    input wire                  reg_ram_whrl            ,
    input wire [9:0]            reg_ram_addr            ,
    input wire [13:0]           reg_ram_wdata           ,
    input wire                  reg_ram_req             ,
    input wire                  reg_ram_cfg_en          ,

    // Core_controller port
    input wire [15:0]           dds_full_time           ,
    input wire [9:0]            dds_addr_base           ,
    input wire [9:0]            dds_addr                ,
    input wire                  dds_refresh             ,
    input wire                  dds_req                 ,
    output wire                 dds_ack                 ,
    output wire [167:0]         dds_time_forward        ,
    output wire [167:0]         dds_time_backward
);



/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [3:0]                   dds_req_dly             ;
    reg [9:0]                   dds_addr_dly            ;

    reg [9:0]                   dds_addra_lock          ;
    reg [9:0]                   dds_addrb_lock          ;

    reg [3:0]                   ram_req_dly             ;
    reg                         ram_whrl_dly            ;
    reg [9:0]                   ram_addr_dly            ;
    reg [13:0]                  ram_wdata_dly           ;

    reg                         ram_done                ;
    reg [13:0]                  ram_dout                ;

    reg [31:0]                  shift_loop_left         ;

    reg [3:0]                   refresh_dly             ;

    reg [167:0]                 dds_data_forward        ;
    reg [167:0]                 dds_data_backward       ;
    reg [167:0]                 data_forward_lock       ;
    reg [167:0]                 data_backward_lock      ;

    reg [167:0]                 time_forward_temp       ;
    reg [167:0]                 time_backward_temp      ;
    reg                         ack_temp                ;

    reg [31:0]                  cnt_ack                 ;

    reg [1:0]                   flag_ram_region         ;

/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        dds_req_r               ;
    wire                        ram_req_r               ;
    wire                        refresh_r               ;
    wire                        refresh_f               ;

    wire [13:0]                 douta                   ;
    wire [13:0]                 doutb                   ;
    wire [13:0]                 dina                    ;
    wire [13:0]                 dinb                    ;
    wire [9:0]                  addra                   ;
    wire [9:0]                  addrb                   ;
    wire                        wea                     ;
    wire                        web                     ;

    wire [29:0]                 douta_time              ;
    wire [29:0]                 doutb_time              ;

    // wire [167:0]                dds_offset_forward      ;
    // wire [167:0]                dds_offset_backward     ;

/********************************************************
*                        logic Here                     *
********************************************************/

    // Edge sync 1 cycle
    assign dds_req_r            = dds_req_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_req_dly         <= 'd0;
        end else begin
            dds_req_dly         <= {dds_req_dly[2:0], dds_req};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_addr_dly        <= 'd0;
        end else begin
            dds_addr_dly        <= dds_addr;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            flag_ram_region     <= 'd0;
        end else if (dds_req_r == 1'b1 && dds_addr < 10'd512) begin
            flag_ram_region     <= 2'b00;
        end else if (dds_req_r == 1'b1 && dds_addr >= 10'd512 && dds_addr < 10'd800) begin
            flag_ram_region     <= 2'b01;
        end else begin
            flag_ram_region     <= flag_ram_region;
        end
    end


    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            shift_loop_left     <= 'd0;
        end else if (dds_req_r == 1'b1 || refresh_r == 1'b1) begin
            shift_loop_left     <= 'd1;
        end else if (refresh_f == 1'b1) begin
            shift_loop_left     <= 'd0;
        end else if (dds_refresh == 1'b1) begin
            shift_loop_left     <= {shift_loop_left[30:0], shift_loop_left[31]};
        end else if (shift_loop_left[31] == 1'b1) begin
            shift_loop_left     <= 'd0;
        end else begin
            shift_loop_left     <= {shift_loop_left[30:0], shift_loop_left[31]};
        end
    end

    // CMD lock 2cycle
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_addra_lock      <= 'd0;
        end else if ((dds_req_r == 1'b1) || (refresh_r == 1'b1) || (shift_loop_left[11:0] == 12'd0)) begin
            if (dds_addr >= 10'd864) begin // >= 288*3
                dds_addra_lock  <= dds_addr - 10'd864;
            end else if (dds_addr >= 10'd576) begin // >= 288*2
                dds_addra_lock  <= dds_addr - 10'd576;
            end else if (dds_addr >= 10'd288) begin // >= 288*1
                dds_addra_lock  <= dds_addr - 10'd288;
            end else begin
                dds_addra_lock  <= dds_addr;
            end
        end else if (shift_loop_left[10:0] > 'd0) begin
            if ((dds_addra_lock + reg_dds_inc) >= 10'd288) begin // >= 288
                dds_addra_lock  <= dds_addra_lock + reg_dds_inc - 10'd288;
            end else begin
                dds_addra_lock  <= dds_addra_lock + reg_dds_inc;
            end
        end else begin
            dds_addra_lock      <= dds_addra_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_addrb_lock      <= 'd0;
        end else if (dds_req_r == 1'b1 || refresh_r == 1'b1 || shift_loop_left[11:0] == 'd0) begin
            if ((dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2)) >= 10'd864) begin // >= 288*3
                dds_addrb_lock  <= dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2) - 10'd864;
            end else if ((dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2)) >= 576) begin // >= 288*2
                dds_addrb_lock  <= dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2) - 10'd576;
            end else if ((dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2)) >= 288) begin // >= 288*1
                dds_addrb_lock  <= dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2) - 10'd288;
            end else begin
                dds_addrb_lock  <= dds_addr + (reg_dds_inc << 2'd3) + (reg_dds_inc << 2'd2);
            end
        end else if (shift_loop_left[10:0] > 'd0) begin
            if ((dds_addrb_lock + reg_dds_inc) >= 10'd288) begin // >= 288
                dds_addrb_lock  <= dds_addrb_lock + reg_dds_inc - 10'd288;
            end else begin
                dds_addrb_lock  <= dds_addrb_lock + reg_dds_inc;
            end
        end else begin
            dds_addrb_lock      <= dds_addrb_lock;
        end
    end


    // Reg ram request
    assign ram_req_r            = ram_req_dly == 4'b0001;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            ram_req_dly         <= 'd0;
        end else begin
            ram_req_dly         <= {ram_req_dly[2:0], reg_ram_req};
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            ram_addr_dly        <= 'd0;
            ram_whrl_dly        <= 'd0;
            ram_wdata_dly       <= 'd0;
        end else begin
            ram_addr_dly        <= reg_ram_addr;
            ram_whrl_dly        <= reg_ram_whrl;
            ram_wdata_dly       <= reg_ram_wdata;
        end
    end


    // Dual bram port
    assign wea                  = reg_ram_cfg_en ? ram_whrl_dly  : 1'b0;
    assign addra                = reg_ram_cfg_en ? ram_addr_dly  : (dds_addra_lock + dds_addr_base);
    assign dina                 = reg_ram_cfg_en ? ram_wdata_dly : 14'd0;

    assign web                  = 1'b0;
    assign addrb                = dds_addrb_lock + dds_addr_base;
    assign dinb                 = 14'd0;

    blk_mem_gen_0 blk_mem_gen_0_inst (

        .clka                                           (clk                                            ),  // input wire clka
        .wea                                            (wea                                            ),  // input wire [0 : 0] wea
        .addra                                          (addra                                          ),  // input wire [9 : 0] addra
        .dina                                           (dina                                           ),  // input wire [13 : 0] dina
        .douta                                          (douta                                          ),  // output wire [13 : 0] douta
        .clkb                                           (clk                                            ),  // input wire clkb
        .web                                            (web                                            ),  // input wire [0 : 0] web
        .addrb                                          (addrb                                          ),  // input wire [9 : 0] addrb
        .dinb                                           (dinb                                           ),  // input wire [13 : 0] dinb
        .doutb                                          (doutb                                          )   // output wire [13 : 0] doutb
    );


    // Reg ram read
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            ram_done            <= 1'b1;
        end else if (ram_req_r == 1'b1) begin
            ram_done            <= 1'b0;
        end else if (ram_req_dly[2] == 1'b1) begin // Bram latency = 2
            ram_done            <= 1'b1;
        end else begin
            ram_done            <= ram_done;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            ram_dout            <= 'd0;
        end else if (ram_req_dly[2] == 1'b1) begin // Bram latency = 2
            ram_dout            <= douta;
        end else begin
            ram_dout            <= ram_dout;
        end
    end

    assign reg_ram_done         = ram_done;
    assign reg_ram_rdata        = ram_dout;


    // Dout
    assign refresh_r            = refresh_dly == 4'b0001;
    assign refresh_f            = refresh_dly == 4'b1110;

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            refresh_dly         <= 'd0;
        end else begin
            refresh_dly         <= {refresh_dly[2:0], dds_refresh};
        end
    end

    // [15]
    mult_gen_0 mult_gen_forward (

        .CLK                                            (clk                                            ),  // input wire CLK
        .A                                              (douta - reg_current_offset                     ),  // input wire [13 : 0] A
        .B                                              (dds_full_time                                  ),  // input wire [15 : 0] B
        .P                                              (douta_time                                     )   // output wire [29 : 0] P
    );

    mult_gen_0 mult_gen_backward (

        .CLK                                            (clk                                            ),  // input wire CLK
        .A                                              (doutb - reg_current_offset                     ),  // input wire [13 : 0] A
        .B                                              (dds_full_time                                  ),  // input wire [15 : 0] B
        .P                                              (doutb_time                                     )   // output wire [29 : 0] P
    );



    // [16:5] Lock douta/doutb group
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_data_forward    <= 'd0;
        end else if (shift_loop_left[16:5] > 1'b0) begin
            dds_data_forward    <= {douta_time[14 +: 14], dds_data_forward[167:14]}; // douta_time/0x4000
        end else begin
            dds_data_forward    <= dds_data_forward;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dds_data_backward   <= 'd0;
        end else if (shift_loop_left[16:5] > 1'b0) begin
            dds_data_backward   <= {doutb_time[14 +: 14], dds_data_backward[167:14]}; // doutb_time/0x4000
        end else begin
            dds_data_backward   <= dds_data_backward;
        end
    end

    //[18]
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            data_forward_lock   <= 'd0;
        end else if (shift_loop_left[17] == 1'b1) begin
            data_forward_lock   <= dds_data_forward;
        end else begin
            data_forward_lock   <= data_forward_lock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            data_backward_lock  <= 'd0;
        end else if (shift_loop_left[17] == 1'b1) begin
            data_backward_lock  <= dds_data_backward;
        end else begin
            data_backward_lock  <= data_backward_lock;
        end
    end

    // ack & data
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            ack_temp            <= 1'b0;
        end else if (dds_refresh == 1'b1) begin
            ack_temp            <= 1'b0;
        end else if (dds_req_r == 1'b1) begin
            ack_temp            <= 1'b1;
        end else if (dds_ack == 1'b1) begin
            ack_temp            <= 1'b0;
        end else begin
            ack_temp            <= ack_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            cnt_ack             <= 'd0;
        end else if (dds_req_r == 1'b1) begin
            cnt_ack             <= 'd1;
        end else if (dds_ack == 1'b1) begin
            cnt_ack             <= 'd0;
        end else if (cnt_ack > 'd0) begin
            cnt_ack             <= cnt_ack + 1'b1;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            time_forward_temp   <= 'd0;
        end else if (dds_req_r == 1'b1) begin
            time_forward_temp   <= data_forward_lock;
        end else begin
            time_forward_temp   <= time_forward_temp;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            time_backward_temp  <= 'd0;
        end else if (dds_req_r == 1'b1) begin
            time_backward_temp  <= data_backward_lock;
        end else begin
            time_backward_temp  <= time_backward_temp;
        end
    end

    // Output
    assign dds_ack              = ack_temp && (cnt_ack >= reg_dds_ack_time - 1'b1);
    assign dds_time_forward     = time_forward_temp;
    assign dds_time_backward    = time_backward_temp;



// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_dds_inc                   ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_dds_ack_time              ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_current_offset            ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_ram_rdata                 ;
(* mark_debug = "true" *)    reg                                debug_reg_ram_done                  ;
(* mark_debug = "true" *)    reg                                debug_reg_ram_whrl                  ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_reg_ram_addr                  ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_reg_ram_wdata                 ;
(* mark_debug = "true" *)    reg                                debug_reg_ram_req                   ;
(* mark_debug = "true" *)    reg                                debug_reg_ram_cfg_en                ;

(* mark_debug = "true" *)    reg    [15:0]                      debug_dds_full_time                 ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr                      ;
(* mark_debug = "true" *)    reg                                debug_dds_refresh                   ;
(* mark_debug = "true" *)    reg                                debug_dds_req                       ;
(* mark_debug = "true" *)    reg                                debug_dds_ack                       ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_dds_time_forward              ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_dds_time_backward             ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_dds_req_dly                   ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addr_dly                  ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addra_lock                ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_dds_addrb_lock                ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_ram_req_dly                   ;
(* mark_debug = "true" *)    reg                                debug_ram_whrl_dly                  ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_ram_addr_dly                  ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_ram_wdata_dly                 ;
(* mark_debug = "true" *)    reg                                debug_ram_done                      ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_ram_dout                      ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_shift_loop_left               ;
(* mark_debug = "true" *)    reg    [3:0]                       debug_refresh_dly                   ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_dds_data_forward              ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_dds_data_backward             ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_data_forward_lock             ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_data_backward_lock            ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_time_forward_temp             ;
(* mark_debug = "true" *)    reg    [167:0]                     debug_time_backward_temp            ;
(* mark_debug = "true" *)    reg                                debug_ack_temp                      ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_cnt_ack                       ;
(* mark_debug = "true" *)    reg                                debug_dds_req_r                     ;
(* mark_debug = "true" *)    reg                                debug_ram_req_r                     ;
(* mark_debug = "true" *)    reg                                debug_refresh_r                     ;
(* mark_debug = "true" *)    reg                                debug_refresh_f                     ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_douta                         ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_doutb                         ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dina                          ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dinb                          ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_addra                         ;
(* mark_debug = "true" *)    reg    [9:0]                       debug_addrb                         ;
(* mark_debug = "true" *)    reg                                debug_wea                           ;
(* mark_debug = "true" *)    reg                                debug_web                           ;
(* mark_debug = "true" *)    reg    [29:0]                      debug_douta_time                    ;
(* mark_debug = "true" *)    reg    [29:0]                      debug_doutb_time                    ;
// (* mark_debug = "true" *)    reg    [167:0]                     debug_dds_offset_forward            ;
// (* mark_debug = "true" *)    reg    [167:0]                     debug_dds_offset_backward           ;

always @ (posedge clk) begin
    debug_reg_dds_inc                    <= reg_dds_inc                   ;
    debug_reg_dds_ack_time               <= reg_dds_ack_time              ;
    debug_reg_current_offset             <= reg_current_offset            ;
    debug_reg_ram_rdata                  <= reg_ram_rdata                 ;
    debug_reg_ram_done                   <= reg_ram_done                  ;
    debug_reg_ram_whrl                   <= reg_ram_whrl                  ;
    debug_reg_ram_addr                   <= reg_ram_addr                  ;
    debug_reg_ram_wdata                  <= reg_ram_wdata                 ;
    debug_reg_ram_req                    <= reg_ram_req                   ;
    debug_reg_ram_cfg_en                 <= reg_ram_cfg_en                ;

    debug_dds_full_time                  <= dds_full_time                 ;
    debug_dds_addr                       <= dds_addr                      ;
    debug_dds_refresh                    <= dds_refresh                   ;
    debug_dds_req                        <= dds_req                       ;
    debug_dds_ack                        <= dds_ack                       ;
    debug_dds_time_forward               <= dds_time_forward              ;
    debug_dds_time_backward              <= dds_time_backward             ;
    debug_dds_req_dly                    <= dds_req_dly                   ;
    debug_dds_addr_dly                   <= dds_addr_dly                  ;
    debug_dds_addra_lock                 <= dds_addra_lock                ;
    debug_dds_addrb_lock                 <= dds_addrb_lock                ;
    debug_ram_req_dly                    <= ram_req_dly                   ;
    debug_ram_whrl_dly                   <= ram_whrl_dly                  ;
    debug_ram_addr_dly                   <= ram_addr_dly                  ;
    debug_ram_wdata_dly                  <= ram_wdata_dly                 ;
    debug_ram_done                       <= ram_done                      ;
    debug_ram_dout                       <= ram_dout                      ;
    debug_shift_loop_left                <= shift_loop_left               ;
    debug_refresh_dly                    <= refresh_dly                   ;
    debug_dds_data_forward               <= dds_data_forward              ;
    debug_dds_data_backward              <= dds_data_backward             ;
    debug_data_forward_lock              <= data_forward_lock             ;
    debug_data_backward_lock             <= data_backward_lock            ;
    debug_time_forward_temp              <= time_forward_temp             ;
    debug_time_backward_temp             <= time_backward_temp            ;
    debug_ack_temp                       <= ack_temp                      ;
    debug_cnt_ack                        <= cnt_ack                       ;
    debug_dds_req_r                      <= dds_req_r                     ;
    debug_ram_req_r                      <= ram_req_r                     ;
    debug_refresh_r                      <= refresh_r                     ;
    debug_refresh_f                      <= refresh_f                     ;
    debug_douta                          <= douta                         ;
    debug_doutb                          <= doutb                         ;
    debug_dina                           <= dina                          ;
    debug_dinb                           <= dinb                          ;
    debug_addra                          <= addra                         ;
    debug_addrb                          <= addrb                         ;
    debug_wea                            <= wea                           ;
    debug_web                            <= web                           ;
    debug_douta_time                     <= douta_time                    ;
    debug_doutb_time                     <= doutb_time                    ;
    // debug_dds_offset_forward             <= dds_offset_forward            ;
    // debug_dds_offset_backward            <= dds_offset_backward           ;
end

endmodule








