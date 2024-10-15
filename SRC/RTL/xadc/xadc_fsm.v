/********************************************************************
#Author       : Tianhu.li  --  tianhu.li@insnex.com
#Date         : 2023-05-19 15:27:57
#LastEditors  : Tianhu.li  --  tianhu.li@insnex.com
#LastEditTime : 2023-05-23 20:00:56
#FilePath     : xadc_fsm.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
module xadc_fsm(
    input                           clk                             ,
    input                           rst                             ,

    input       [15:0]              do                              ,
    output  reg [6:0]               daddr                           ,
    output  reg                     den                             ,
    output  reg                     dwe                             ,
    input                           drdy                            ,
    output  reg [15:0]              di                              ,

    output  reg [11:0]              reg_device_temp                 ,

    input                           eoc_out

);


parameter                           IDLE                =   4'h0    ;
parameter                           READ_REG_0          =   4'h1    ;
parameter                           WAIT_RDY_0          =   4'h2    ;

parameter                           CLK_FEQ             =   32'd100_000_000;

/********************************************************************
*                         Regs Here                                 *
********************************************************************/

reg                 [3:0]           cs                              ;
reg                 [3:0]           ns                              ;
reg                 [3:0]           cs_d                            ;

/********************************************************************
*                         Wires Here                                *
********************************************************************/


/********************************************************************
*                         Logic Here                                *
********************************************************************/

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
            if (eoc_out == 1'b1) begin
                ns = READ_REG_0;
            end else begin
                ns = IDLE;
            end
        end

        READ_REG_0 : begin
            ns = WAIT_RDY_0;
        end

        WAIT_RDY_0 : begin
            if (drdy == 1'b1) begin
                ns = IDLE;
            end else begin
                ns = WAIT_RDY_0;
            end
        end

        default : begin
            ns = IDLE;
        end
    endcase
end


always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        daddr <= 7'b0;
    end else if (READ_REG_0 == 1'b1) begin
        daddr <= 7'b0;
    end else begin
        daddr <= 7'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        di <= 16'b0;
    end else if (READ_REG_0 == 1'b1) begin
        di <= 16'b0;
    end else begin
        di <= 16'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        den <= 1'b0;
    end else if (READ_REG_0 == 1'b1) begin
        den <= 1'b1;
    end else begin
        den <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        dwe <= 1'b0;
    end else if (READ_REG_0 == 1'b1) begin
        dwe <= 1'b0;
    end else begin
        dwe <= 1'b0;
    end
end

always @ (posedge clk,posedge rst) begin
    if (rst ==1'b1) begin
        reg_device_temp <= 12'b0;
    end else if (drdy == 1'b1) begin
        reg_device_temp <= do[15:4];
    end else
        ;
end

endmodule
