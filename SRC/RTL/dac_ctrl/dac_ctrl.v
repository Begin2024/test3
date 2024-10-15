`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/08/14 17:53:51
// Design Name:
// Module Name: dac_ctrl
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module dac_ctrl(
    input  clk,
    input  rst,

    output [7:0]    dac_clk,
    output [7:0]    dac_wrt,

    output  [13:0]  dac1_data,
    output  [13:0]  dac2_data,
    output  [13:0]  dac3_data,
    output  [13:0]  dac4_data,

    // output  [13:0]  dac1_data_y,
    // output  [13:0]  dac2_data_y,
    // output  [13:0]  dac3_data_y,
    // output  [13:0]  dac4_data_y,

    input   [111:0] dac_val     ,
    input   [7:0]   dac_req     ,
    output   reg    dac_ack     ,
    input           reg_dac_en  ,

    input   [31:0]  reg_dac_time
);



/******************************************************************************
*                                   CONFIG                                    *
******************************************************************************/


/******************************************************************************
*                                    WIRE                                     *
******************************************************************************/
    wire [7:0]dac_ack_bus;

    wire [13:0] dac_data [0:7];

    wire ack_clr        ;

    wire [13:0] dac1_data_x;
    wire [13:0] dac2_data_x;
    wire [13:0] dac3_data_x;
    wire [13:0] dac4_data_x;

    wire [13:0] dac1_data_y;
    wire [13:0] dac2_data_y;
    wire [13:0] dac3_data_y;
    wire [13:0] dac4_data_y;


/******************************************************************************
*                                     REG                                     *
******************************************************************************/
    reg  [7:0]  dac_req_dly;


    reg [7:0] dac_req_lock;

    reg [1:0] flag;

/******************************************************************************
*                                    LOGIC                                    *
******************************************************************************/

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            dac_req_lock <= 'd0;
        end else if (dac_ack_bus == dac_req_lock && dac_ack_bus > 'd0) begin
            dac_req_lock <= 'd0;
        end else if (dac_req_dly == 'd0 && dac_req != 'd0) begin
            dac_req_lock <= dac_req;
        end else begin
            dac_req_lock <= dac_req_lock;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            dac_req_dly<=0;
        end
        else begin
            dac_req_dly<=dac_req;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            dac_ack<=0;
        end
        else if(dac_ack_bus == dac_req_lock && dac_ack_bus > 'd0)begin
            dac_ack<=1'b1;
        end
        else begin
            dac_ack<=0;
        end
    end

    assign ack_clr              = dac_ack_bus==dac_req_lock && dac_ack_bus > 'd0;

/******************************************************************************
*                                   INSTANCE                                  *
******************************************************************************/

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            flag <= 'b00;
        end else if (dac_req_lock == 'h0F) begin
            flag <= 'b01;
        end else if (dac_req_lock == 'hF0) begin
            flag <= 'b10;
        end else begin
            flag <= flag;
        end
    end

    assign dac1_data           = flag[0] ? dac1_data_x : (flag[1] ? dac1_data_y : 'd0);
    assign dac2_data           = flag[0] ? dac2_data_x : (flag[1] ? dac2_data_y : 'd0);
    assign dac3_data           = flag[0] ? dac3_data_x : (flag[1] ? dac3_data_y : 'd0);
    assign dac4_data           = flag[0] ? dac4_data_x : (flag[1] ? dac4_data_y : 'd0);

    assign dac1_data_x         = dac_data[1];
    assign dac2_data_x         = dac_data[0];
    assign dac3_data_x         = dac_data[2];
    assign dac4_data_x         = dac_data[3];

    // assign dac1_data_y         = dac_data[4];
    // assign dac2_data_y         = dac_data[6];
    // assign dac3_data_y         = dac_data[5];
    // assign dac4_data_y         = dac_data[7];
    assign dac1_data_y         = dac_data[5];
    assign dac2_data_y         = dac_data[7];
    assign dac3_data_y         = dac_data[4];
    assign dac4_data_y         = dac_data[6];

    genvar i;

    generate for (i = 0; i < 8; i = i + 1) begin : LOOP_DAC

        dac_driver  dac_driver_inst (

            .clk                        ( clk            ),
            .rst                        ( rst            ),
            .dac_val                    ( dac_val[(i*14 + 13) : (i*14)]        ),
            .dac_req                    ( dac_req_dly[i]        ),
            .reg_dac_time               ( reg_dac_time   ),

            .ack_clr                    ( ack_clr           ),
            .dac_data                   ( dac_data[i]       ),
            .dac_ack                    ( dac_ack_bus[i]        )
        );

        ODDR #(
            .DDR_CLK_EDGE                           ("SAME_EDGE"                            ),  // "OPPOSITE_EDGE" or "SAME_EDGE"
            .INIT                                   (1'b0                                   ),  // Initial value of Q: 1'b0 or 1'b1
            .SRTYPE                                 ("SYNC"                                 )   // Set/Reset type: "SYNC" or "ASYNC"
        ) ODDR_inst0 (
            .Q                                      (dac_clk[i]                                 ),  // 1-bit DDR output
            .C                                      (clk                                ),  // 1-bit clock input
            .CE                                     (reg_dac_en                                   ),  // 1-bit clock enable input
            .D1                                     (1'b0                                   ),  // 1-bit data input (positive edge)
            .D2                                     (1'b1                                   ),  // 1-bit data input (negative edge)
            .R                                      (1'b0                                   ),  // 1-bit reset
            .S                                      (rst                                   )   // 1-bit set
        );

        ODDR #(
            .DDR_CLK_EDGE                           ("SAME_EDGE"                            ),  // "OPPOSITE_EDGE" or "SAME_EDGE"
            .INIT                                   (1'b0                                   ),  // Initial value of Q: 1'b0 or 1'b1
            .SRTYPE                                 ("SYNC"                                 )   // Set/Reset type: "SYNC" or "ASYNC"
        ) ODDR_inst1 (
            .Q                                      (dac_wrt[i]                                 ),  // 1-bit DDR output
            .C                                      (clk                                ),  // 1-bit clock input
            .CE                                     (reg_dac_en                                   ),  // 1-bit clock enable input
            .D1                                     (1'b0                                   ),  // 1-bit data input (positive edge)
            .D2                                     (1'b1                                   ),  // 1-bit data input (negative edge)
            .R                                      (1'b0                                   ),  // 1-bit reset
            .S                                      (rst                                   )   // 1-bit set
        );
    end
    endgenerate

/*
    dac_driver  dac_driver_1 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[13:0]        ),
    .dac_req                 ( dac_req_dly[0]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac1_data_x       ),
    .dac_ack                 ( dac_ack_bus[0]        )
);


    dac_driver  dac_driver_2 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[27:14]        ),
    .dac_req                 ( dac_req_dly[1]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac2_data_x       ),
    .dac_ack                 ( dac_ack_bus[1]        )
);


    dac_driver  dac_driver_3 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[41:28]        ),
    .dac_req                 ( dac_req_dly[2]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac3_data_x       ),
    .dac_ack                 ( dac_ack_bus[2]        )
);


    dac_driver  dac_driver_4 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[55:42]        ),
    .dac_req                 ( dac_req_dly[3]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac4_data_x       ),
    .dac_ack                 ( dac_ack_bus[3]        )
);


    dac_driver  dac_driver_5 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[69:56]        ),
    .dac_req                 ( dac_req_dly[4]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac1_data_y       ),
    .dac_ack                 ( dac_ack_bus[4]        )
);


    dac_driver  dac_driver_6 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[83:70]        ),
    .dac_req                 ( dac_req_dly[5]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac2_data_y       ),
    .dac_ack                 ( dac_ack_bus[5]        )
);


    dac_driver  dac_driver_7 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[97:84]        ),
    .dac_req                 ( dac_req_dly[6]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac3_data_y       ),
    .dac_ack                 ( dac_ack_bus[6]        )
);


    dac_driver  dac_driver_8 (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .dac_val                 ( dac_val[111:98]        ),
    .dac_req                 ( dac_req_dly[7]        ),
    .reg_dac_time            ( reg_dac_time   ),

    .dac_data                ( dac4_data_y       ),
    .dac_ack                 ( dac_ack_bus[7]        )
);

ODDR #(
    .DDR_CLK_EDGE                           ("SAME_EDGE"                            ),  // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT                                   (1'b0                                   ),  // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE                                 ("SYNC"                                 )   // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_inst0 (
    .Q                                      (dac_clk                                 ),  // 1-bit DDR output
    .C                                      (clk                                ),  // 1-bit clock input
    .CE                                     (1'b1                                   ),  // 1-bit clock enable input
    .D1                                     (1'b0                                   ),  // 1-bit data input (positive edge)
    .D2                                     (1'b1                                   ),  // 1-bit data input (negative edge)
    .R                                      (1'b0                                   ),  // 1-bit reset
    .S                                      (rst                                   )   // 1-bit set
);

ODDR #(
    .DDR_CLK_EDGE                           ("SAME_EDGE"                            ),  // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT                                   (1'b0                                   ),  // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE                                 ("SYNC"                                 )   // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_inst1 (
    .Q                                      (dac_wrt                                 ),  // 1-bit DDR output
    .C                                      (clk                                ),  // 1-bit clock input
    .CE                                     (1'b1                                   ),  // 1-bit clock enable input
    .D1                                     (1'b0                                   ),  // 1-bit data input (positive edge)
    .D2                                     (1'b1                                   ),  // 1-bit data input (negative edge)
    .R                                      (1'b0                                   ),  // 1-bit reset
    .S                                      (rst                                   )   // 1-bit set
);

*/



/******************************************************************************
*                                     IP                                      *
******************************************************************************/







// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [13:0]                      debug_dac1_data_x                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac2_data_x                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac3_data_x                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac4_data_x                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac1_data_y                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac2_data_y                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac3_data_y                   ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac4_data_y                   ;
(* mark_debug = "true" *)    reg    [111:0]                     debug_dac_val                       ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_dac_req                       ;
(* mark_debug = "true" *)    reg                                debug_dac_ack                       ;
(* mark_debug = "true" *)    reg    [31:0]                      debug_reg_dac_time                  ;

always @ (posedge clk) begin
    debug_dac1_data_x                    <= dac1_data_x                   ;
    debug_dac2_data_x                    <= dac2_data_x                   ;
    debug_dac3_data_x                    <= dac3_data_x                   ;
    debug_dac4_data_x                    <= dac4_data_x                   ;
    debug_dac1_data_y                    <= dac1_data_y                   ;
    debug_dac2_data_y                    <= dac2_data_y                   ;
    debug_dac3_data_y                    <= dac3_data_y                   ;
    debug_dac4_data_y                    <= dac4_data_y                   ;
    debug_dac_val                        <= dac_val                       ;
    debug_dac_req                        <= dac_req                       ;
    debug_dac_ack                        <= dac_ack                       ;
    debug_reg_dac_time                   <= reg_dac_time                  ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [7:0]                       debug_dac_ack_bus                   ;
(* mark_debug = "true" *)    reg                                debug_ack_clr                       ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_dac_req_dly                   ;
(* mark_debug = "true" *)    reg    [7:0]                       debug_dac_data                   ;

always @ (posedge clk) begin
    debug_dac_ack_bus                    <= dac_ack_bus                   ;
    debug_ack_clr                        <= ack_clr                       ;
    debug_dac_req_dly                    <= dac_req_dly                   ;
    debug_dac_data                       <= dac_data[0]                   ;
end




// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [7:0]                       debug_dac_req_lock                  ;

always @ (posedge clk) begin
    debug_dac_req_lock                   <= dac_req_lock                  ;
end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg    [13:0]                      debug_dac1_data                     ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac2_data                     ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac3_data                     ;
(* mark_debug = "true" *)    reg    [13:0]                      debug_dac4_data                     ;

always @ (posedge clk) begin
    debug_dac1_data                      <= dac1_data                     ;
    debug_dac2_data                      <= dac2_data                     ;
    debug_dac3_data                      <= dac3_data                     ;
    debug_dac4_data                      <= dac4_data                     ;
end

endmodule






