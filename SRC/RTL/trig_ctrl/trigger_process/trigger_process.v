/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-11-02  10:25:08
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-12-06 16:49:18
#FilePath     : trigger_process.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module trigger_process(

    input wire                  clk                     ,
    input wire                  rst                     ,

    input wire [31:0]           reg_camera_delay        ,
    input wire [31:0]           reg_camera_cycle        ,
    input wire [31:0]           reg_camera_trig_num     ,

    input wire [31:0]           reg_external_trig_num   ,
    input wire                  reg_external_trig_polar ,
    input wire [31:0]           reg_external_trig_delay ,
    input wire [31:0]           reg_external_trig_width ,
    input wire                  reg_external_trig_enable,

    input wire                  trigger_out_en          ,
    input wire                  trigger_in              ,

    output wire                 trigger_external        ,
    output wire                 trigger_camera          ,
    output wire                 trigger_core
);



/********************************************************
*                        regs  Here                     *
********************************************************/



/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        trigger_vld             ;

    // wire                        signal_temp             ;

/********************************************************
*                        logic Here                     *
********************************************************/

    trigger_delay_ctrl trigger_delay_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),
        .trigger_in                                     (trigger_in                                     ),
        .reg_camera_cycle                               (reg_camera_cycle                               ),
        .reg_camera_delay                               (reg_camera_delay                               ),//相机收到触发后一段时间曝光开始
        .reg_camera_trig_num                            (reg_camera_trig_num                            ),

        .trig_to_camera                                 (trigger_camera                                 ),
        .trig_to_core                                   (trigger_core                                   )
    );

    external_trig_ctrl external_trig_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst  |(~reg_external_trig_enable)              ),
        .reg_camera_trig_num                            (reg_camera_trig_num                            ),
        .reg_external_trig_cycle                        (reg_camera_cycle                               ),
        .reg_external_trig_enable                       (reg_external_trig_enable                       ),
        .reg_external_trig_width                        (reg_external_trig_width                        ),
        .reg_external_trig_delay                        (reg_external_trig_delay                        ),
        .reg_external_trig_polar                        (reg_external_trig_polar                        ),
        .reg_external_trig_num                          (reg_external_trig_num                          ),

        .trigger_in                                     (trigger_camera                                 ),
        .trigger_out                                    (trigger_external                               )
    );



endmodule


