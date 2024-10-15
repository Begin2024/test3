/*
 * @Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
 * @Date         : 2024-01-08 10:59:44
 * @LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
 * @LastEditTime : 2024-05-22 15:50:16
 * @FilePath     : define.h
 * @Description  : ---
 * Copyright (c) 2024 by Insnex.com, All Rights Reserved.
 */
`define             COMPANY             32'h0049_4e53   // INS
`define             DEVICE              32'h4944_4643   // IDFC
`define             DEVICE_SUB          32'h3235_3138   // 2518(3235_3138),0505(30353035)

`define             INTERFACETYPE       8'h50           // P,   G:gige(47); C:cameralink(43);P:pcie(50)
`define             PIXELTYPE           8'h4D           // M,   M:mono(4D); C:color(43)
`define             DPITYPE             8'h42           // A,   A:50fps(41); B:100fps(42); C: fps(43); D: fps(44)
`define             SPEEDTYPE           8'h42           // B,   A:highspeed; B:mediumspeed; C:lowspeed

`define             PROPERTY            {`INTERFACETYPE, `PIXELTYPE, `DPITYPE, `SPEEDTYPE}

`define             XILINX              1
`define             UDLY                1

`define             SPI_CS              1'b0

`define             WRDI                8'h04
`define             WREN                8'h06
`define             BE                  8'hC7
`define             SE                  8'h20
`define             RDSR                8'h05
`define             RDID                8'h9F
`define             WRSR                8'h01
`define             PP                  8'h02
`define             READ                8'h03
`define             READ_F              8'h0B

`define             MDIO_ADDR           2'b00
`define             MDIO_WRITE          2'b01
`define             MDIO_READ           2'b11
`define             MDIO_READINC        2'b10

`define REV {`HASH,`SEQNUM}
`define YEAR_MOUTH_DATE  {`YEAR, `MONTH, `DATE}
`define HOUR_MINUTE  {`HOUR, `MINUTE}

