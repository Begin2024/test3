/********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2024-01-08 10:59:44
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-10-15 11:47:56
#FilePath     : ins_2d5lvs_top.v
#Description  : ---
#Copyright (c) 2024 by Insnex.com, All Rights Reserved.
********************************************************************/
/********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2024-01-08 10:59:44
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-07-10 13:37:26
#FilePath     : ins_2d5lvs_top.v
#Description  : ---
#Copyright (c) 2024 by Insnex.com, All Rights Reserved.
********************************************************************/
/********************************************************************
#Author       : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#Date         : 2023-12-06 16:25:01
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2024-02-02 10:15:27
#FilePath     : ins_2d5lvs_top.v
#Description  : ---
#Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/
/********************************************************************
 # Author       : yir  --  zhuangzhuang.rong@insnex.com
 # Date         : 2023-08-15  16:01:23
#LastEditors  : Pengfei.Zhou  --  pengfei.zhou@insnex.com
#LastEditTime : 2023-12-06 16:43:54
#FilePath     : ins_2d5lvs_top.v
 # Description  : ---
 # Copyright (c) 2023 by Insnex.com, All Rights Reserved.
********************************************************************/

module ins_2d5lvs_top(

    input wire                  sys_clk                 ,
    input wire                  sys_rst_n               ,

    // Leval driver
    output wire                 amp_en                  ,
    output wire                 fpga_dac_pd             ,
    output wire                 led_anode_en            ,

    // Laser
    // output wire                 laser_0                 ,
    // output wire                 laser_1                 ,

    // Trigger
    input wire                  io_input_0              ,
    input wire                  io_input_1              ,
    input wire                  encoder_in_a            ,
    input wire                  encoder_in_b            ,

    output wire                 trigger_external        ,
    output wire                 io_output_24v           ,
    output wire                 trigger_slaver          ,
    output wire                 io_output_diff          ,
    // input wire                  trigger_master          ,
    // output wire                 trigger_l1_slaver       ,
    // input wire                  trigger_l1_master       ,

    // Uart test
    input wire                  test_uart_rxd           ,
    output wire                 test_uart_txd           ,

    // Uart test
    input wire                  rs485_uart_rxd          ,
    output wire                 rs485_uart_txd          ,

    // Uart MPU1
    // input wire                  mpu1_uart_rxd           ,
    // output wire                 mpu1_uart_txd           ,

    // IIC MPU0
    // inout wire                  mpu0_iic_sda            ,
    // output wire                 mpu0_iic_scl            ,

    // IIC temp
    inout wire                  tmp75_iic_sda           ,
    output wire                 tmp75_iic_scl           ,

    // SPI flash
//    inout wire                  flash_spi_mosi          ,
    inout wire [1:0]            flash_spi_io            ,
    // inout wire                  flash_spi_sck           ,
    inout wire                  flash_spi_cs_n          ,

    // Stm32 flash
    // inout wire [1:0]            stm32_spi_io            ,
    inout wire                  stm32_spi_io_test,
    inout wire                  stm32_spi_sck           ,
    inout wire                  stm32_spi_cs_n          ,
    input wire                  stm32_spi_spisel        ,

    // GPIO [3:0]
        // [0] : RS485_SEL [1] : LED0
    inout wire [3:0]            gpio_io                 ,

    // PHY
    // inout wire                  phy_mdio                ,
    // output wire                 phy_mdc                 ,

    // output wire                 phy_rst                 ,

    // input wire [3:0]            rgmii_rxd               ,
    // input wire                  rgmii_rx_ctrl           ,
    // input wire                  rgmii_rx_clk            ,

    // output wire [3:0]           rgmii_txd               ,
    // output wire                 rgmii_tx_ctrl           ,
    // output wire                 rgmii_tx_clk            ,

    // DAC
    output wire [7:0]           dac_clk                 ,
    output wire [7:0]           dac_wrt                 ,
    output wire [7:0]           dac_mos                 ,

    output wire [13:0]          dac_data_0              ,
    output wire [13:0]          dac_data_1              ,
    output wire [13:0]          dac_data_2              ,
    output wire [13:0]          dac_data_3              ,

    output wire [11:0]          dac_sw_x_0              ,
    output wire [11:0]          dac_sw_x_1              ,
    output wire [11:0]          dac_sw_x_2              ,
    output wire [11:0]          dac_sw_x_3              ,
    output wire [11:0]          dac_sw_y_0              ,
    output wire [11:0]          dac_sw_y_1              ,
    output wire [11:0]          dac_sw_y_2              ,
    output wire [11:0]          dac_sw_y_3

    // LED
    // output wire                 led
);

    localparam TIME_10MS        = 125_0000              ;

/********************************************************
*                        regs  Here                     *
********************************************************/

    reg [31:0]                  cnt_phy                 ;

    reg [31:0]                  reg_io_in_0_num         ;
    reg [31:0]                  reg_io_in_1_num         ;
    reg [31:0]                  reg_encoder_a_num       ;
    reg [31:0]                  reg_encoder_b_num       ;
    reg [31:0]                  reg_io_out_num          ;
    reg [31:0]                  reg_mos_req_num         ;
    reg [31:0]                  reg_mos_ack_num         ;
    reg [31:0]                  reg_dds_req_num         ;
    reg [31:0]                  reg_dds_ack_num         ;
    reg [31:0]                  reg_dac_req_num         ;
    reg [31:0]                  reg_dac_ack_num         ;
    reg [31:0]                  reg_sw_req_num          ;
    reg [31:0]                  reg_sw_ack_num          ;
    reg [31:0]                  reg_reg_req_num         ;
    reg [31:0]                  reg_reg_ack_num         ;

    reg [31:0]                  reg_trigger_in_num      ;

    reg [31:0]                  cnt_lps                 ;
    reg [31:0]                  cnt_sec                 ;
    reg [31:0]                  reg_lps                 ;
    reg [31:0]                  reg_trigger_miss        ;


/********************************************************
*                        wires Here                     *
********************************************************/

    wire                        clk                     ;
    wire                        rst                     ;
    wire                        clk_epc                 ;
    wire                        rst_epc                 ;
    wire                        clk_bd                  ;
    wire                        rst_bd                  ;

    wire [3:0]                  gpio_rtl_0_tri_i        ;
    wire [3:0]                  gpio_rtl_0_tri_o        ;
    wire [3:0]                  gpio_rtl_0_tri_t        ;

//    wire                        mdio_rtl_0_mdio_i       ;
//    wire                        mdio_rtl_0_mdio_o       ;
//    wire                        mdio_rtl_0_mdio_t       ;
    wire [1:0]                  flash_spi_io_i          ;
    wire [1:0]                  flash_spi_io_o          ;
    wire [1:0]                  flash_spi_io_t          ;

//    wire                        flash_spi_miso_i        ;
//    wire                        flash_spi_miso_o        ;
//    wire                        flash_spi_miso_t        ;
    // wire                        flash_spi_sck_i         ;
    // wire                        flash_spi_sck_o         ;
    // wire                        flash_spi_sck_t         ;
    wire                        flash_spi_cs_n_i        ;
    wire                        flash_spi_cs_n_o        ;
    wire                        flash_spi_cs_n_t        ;

    // Stm 32
    wire                   stm32_spi_io_i          ;
    wire                   stm32_spi_io_o          ;
    wire                   stm32_spi_io_t          ;

    wire                        stm32_spi_sck_i         ;
    wire                        stm32_spi_sck_o         ;
    wire                        stm32_spi_sck_t         ;

    wire                        stm32_spi_cs_n_i        ;
    wire                        stm32_spi_cs_n_o        ;
    wire                        stm32_spi_cs_n_t        ;

    wire                        phy_reset_bd            ;

    wire                        sensor_trigger_req      ;
    wire                        trigger_core            ;
    wire                        trigger_core_in         ;

    wire                        mos_val                 ;
    wire                        mos_req                 ;
    wire                        mos_ack                 ;

    wire [9:0]                  dds_addr                ;
    wire                        dds_req                 ;
    wire                        dds_ack                 ;
    wire [167:0]                dds_time_forward        ;
    wire [167:0]                dds_time_backward       ;
    wire                        dds_refresh             ;
    wire [9:0]                  step_inc                ;
    wire [9:0]                  dds_addr_base           ;

    wire [3:0]                  dac_mos_x               ;
    wire [3:0]                  dac_mos_y               ;

    wire [14*8-1:0]             dac_val                 ;
    wire [7:0]                  dac_req                 ;
    wire                        dac_ack                 ;
    // wire                        dac_clock               ;
    // wire                        dac_write               ;
    wire [13:0]                 dac_data_x0             ;
    wire [13:0]                 dac_data_x1             ;
    wire [13:0]                 dac_data_x2             ;
    wire [13:0]                 dac_data_x3             ;

    wire [12*8-1:0]             sw_val                  ;
    wire [1:0]                  sw_req                  ;
    wire                        sw_ack                  ;

    wire [15:0]                 epc_addr                ;
    wire [31:0]                 epc_wrdata              ;
    wire                        epc_cs_n                ;
    wire                        epc_rnw                 ;
    wire [31:0]                 epc_data                ;
    wire [31:0]                 epc_rddata              ;
    wire                        epc_rdy                 ;

    wire                        reg_req                 ;
    wire                        reg_whrl                ;
    wire [31:0]                 reg_addr                ;
    wire [31:0]                 reg_wdata               ;
    wire                        reg_ack                 ;
    wire [31:0]                 reg_rdata               ;

    wire                        reg_soft_reset          ;
    wire [11:0]                 reg_device_temp          ;

    wire                        reg_phy_rst             ;

    wire [31:0]                 reg_mos_ack_time        ;
    wire [31:0]                 reg_dds_ack_time        ;
    wire [31:0]                 reg_dac_ack_time        ;
    wire [31:0]                 reg_sw_ack_time         ;
    wire [7:0]                  reg_mos_en              ;

    wire [11:0]                 reg_mainboard_temp      ;

    wire                        reg_iic_whrl            ;
    wire [6:0]                  reg_iic_dev_addr        ;
    wire [7:0]                  reg_iic_addr            ;
    wire [7:0]                  reg_iic_wdata           ;
    wire [7:0]                  reg_iic_rdata           ;
    wire                        reg_iic_req             ;
    wire                        reg_iic_done            ;

    wire [1:0]                  reg_laser_status        ;

    wire [15:0]                 reg_mpu1_angle_x        ;
    wire [15:0]                 reg_mpu1_angle_y        ;
    wire [15:0]                 reg_mpu1_angle_z        ;
    wire [15:0]                 reg_mpu1_temp           ;
    wire [7:0]                  reg_mpu1_cfg_addr       ;
    wire [15:0]                 reg_mpu1_cfg_value      ;
    wire                        reg_mpu1_cfg_req        ;
    wire                        reg_mpu1_cfg_done       ;
    wire [15:0]                 reg_mpu1_bps            ;

    wire [31:0]                 reg_soft_trigger_cycle  ;
    wire [31:0]                 reg_soft_trigger_num    ;
    wire                        reg_soft_trigger_en     ;
    wire [31:0]                 reg_trigger_cycle       ;
    wire [31:0]                 reg_trigger_num         ;
    wire [3:0]                  reg_trigger_mode        ;
    wire [31:0]                 reg_trigger_width       ;
    wire [31:0]                 reg_trigger_delay       ;
    wire [31:0]                 reg_trigger_pulse       ;
    wire [1:0]                  reg_trigger_polar       ;
    wire                        reg_trigger_en          ;
    wire                        reg_encoder_phase       ;
    wire [3:0]                  reg_encoder_cnt_mode    ;
    wire [3:0]                  reg_encoder_dis_mode    ;
    wire [31:0]                 reg_encoder_ignore      ;
    wire [31:0]                 reg_encoder_div         ;
    wire [31:0]                 reg_encoder_width       ;
    wire [31:0]                 reg_encoder_location    ;
    wire                        reg_encoder_multi_en    ;
    wire [4:0]                  reg_encoder_multi_coe   ;
    wire [31:0]                 reg_encoder_a_cnt       ;
    wire [31:0]                 reg_encoder_b_cnt       ;
    wire                        reg_encoder_clr         ;
    wire                        reg_encoder_en          ;
    wire                        reg_status_cnt_clr      ;

    wire [31:0]                 reg_l1_trigger_in_num    ;
    wire [31:0]                 reg_l1_soft_trigger_cycle;
    wire [31:0]                 reg_l1_soft_trigger_num  ;
    wire                        reg_l1_soft_trigger_en   ;
    wire [31:0]                 reg_l1_trigger_cycle     ;
    wire [31:0]                 reg_l1_trigger_num       ;
    wire [3:0]                  reg_l1_trigger_mode      ;
    wire [31:0]                 reg_l1_trigger_width     ;
    wire [31:0]                 reg_l1_trigger_delay     ;
    wire [31:0]                 reg_l1_trigger_pulse     ;
    wire [1:0]                  reg_l1_trigger_polar     ;
    wire                        reg_l1_trigger_en        ;
    wire                        reg_l1_encoder_phase     ;
    wire [3:0]                  reg_l1_encoder_cnt_mode  ;
    wire [3:0]                  reg_l1_encoder_dis_mode  ;
    wire [31:0]                 reg_l1_encoder_ignore    ;
    wire [31:0]                 reg_l1_encoder_div       ;
    wire [31:0]                 reg_l1_encoder_width     ;
    wire [31:0]                 reg_l1_encoder_location  ;
    wire                        reg_l1_encoder_multi_en  ;
    wire [4:0]                  reg_l1_encoder_multi_coe ;
    wire [31:0]                 reg_l1_encoder_a_cnt     ;
    wire [31:0]                 reg_l1_encoder_b_cnt     ;
    wire                        reg_l1_encoder_clr       ;
    wire                        reg_l1_encoder_en        ;
    wire                        reg_l1_status_cnt_clr    ;
    wire [7:0]                  reg_trigger_level        ;

    wire                        reg_slave_device        ;


    wire [5:0]                  reg_trigger_multi_en    ;
    wire [11:0]                 reg_led_polar           ;
    wire [31:0]                 reg_led_cnt_max         ;

    wire [31:0]                 reg_trig_start_0        ;
    wire [31:0]                 reg_trig_end_0          ;
    wire [31:0]                 reg_trig_start_1        ;
    wire [31:0]                 reg_trig_end_1          ;
    wire [31:0]                 reg_trig_start_2        ;
    wire [31:0]                 reg_trig_end_2          ;
    wire [31:0]                 reg_trig_start_3        ;
    wire [31:0]                 reg_trig_end_3          ;
    wire [31:0]                 reg_trig_start_4        ;
    wire [31:0]                 reg_trig_end_4          ;
    wire [31:0]                 reg_trig_start_5        ;
    wire [31:0]                 reg_trig_end_5          ;
    wire                        reg_trig_out_polar      ;
    wire [31:0]                 reg_led_pwm_start_0     ;
    wire [31:0]                 reg_led_pwm_end_0       ;
    wire [31:0]                 reg_led_pwm_start_1     ;
    wire [31:0]                 reg_led_pwm_end_1       ;
    wire [31:0]                 reg_led_pwm_start_2     ;
    wire [31:0]                 reg_led_pwm_end_2       ;
    wire [31:0]                 reg_led_pwm_start_3     ;
    wire [31:0]                 reg_led_pwm_end_3       ;
    wire [31:0]                 reg_led_pwm_start_4     ;
    wire [31:0]                 reg_led_pwm_end_4       ;
    wire [31:0]                 reg_led_pwm_start_5     ;
    wire [31:0]                 reg_led_pwm_end_5       ;
    wire [31:0]                 reg_led_pwm_start_6     ;
    wire [31:0]                 reg_led_pwm_end_6       ;
    wire [31:0]                 reg_led_pwm_start_7     ;
    wire [31:0]                 reg_led_pwm_end_7       ;
    wire [31:0]                 reg_led_pwm_start_8     ;
    wire [31:0]                 reg_led_pwm_end_8       ;
    wire [31:0]                 reg_led_pwm_start_9     ;
    wire [31:0]                 reg_led_pwm_end_9       ;
    wire [31:0]                 reg_led_pwm_start_10    ;
    wire [31:0]                 reg_led_pwm_end_10      ;
    wire [31:0]                 reg_led_pwm_start_11    ;
    wire [31:0]                 reg_led_pwm_end_11      ;

    wire [11:0]                 led_pwm                 ;

    wire [31:0]                 reg_camera_trig_num     ;


    wire [31:0]                 reg_external_trig_num   ;
    wire                        reg_external_trig_polar ;
    wire [31:0]                 reg_external_trig_delay ;
    wire [31:0]                 reg_external_trig_width ;
    wire                        reg_external_trig_enable;


    wire [9:0]                  reg_dds_phase           ;
    wire [9:0]                  reg_dds_inc             ;
    wire [31:0]                 reg_exp_cycle           ;
    wire [31:0]                 reg_trigger_gap         ;
    wire [31:0]                 reg_pic_num             ;
    wire [11:0]                 reg_sw_status           ;
    wire [7:0]                  reg_sw_shift            ;
    wire [31:0]                 reg_sw_loop_gap         ;
    wire [31:0]                 reg_sw_loop_num         ;
    wire [9:0]                  reg_dds_phase_offset    ;

    wire                        reg_dds_direction_x     ;
    wire                        reg_dds_direction_y     ;

    wire [13:0]                 reg_current_offset      ;
    wire [13:0]                 reg_dac_value_forward   ;
    wire [13:0]                 reg_dac_value_backward  ;
    wire [31:0]                 reg_sw_wait             ;
    wire [31:0]                 reg_camera_delay        ;
    wire [31:0]                 reg_camera_cycle        ;
    wire                        reg_dac_req             ;

    wire [9:0]                  reg_dds_phase_y         ;

    wire [13:0]                 reg_dac_value_x0        ;
    wire [11:0]                 reg_sw_value_x0         ;
    wire                        reg_mos_value_x0        ;
    wire                        reg_trigger_req_x0      ;

    wire [13:0]                 reg_dac_value_x1        ;
    wire [11:0]                 reg_sw_value_x1         ;
    wire                        reg_mos_value_x1        ;
    wire                        reg_trigger_req_x1      ;

    wire [13:0]                 reg_dac_value_x2        ;
    wire [11:0]                 reg_sw_value_x2         ;
    wire                        reg_mos_value_x2        ;
    wire                        reg_trigger_req_x2      ;

    wire [13:0]                 reg_dac_value_x3        ;
    wire [11:0]                 reg_sw_value_x3         ;
    wire                        reg_mos_value_x3        ;
    wire                        reg_trigger_req_x3      ;

    wire [13:0]                 reg_dac_value_y0        ;
    wire [11:0]                 reg_sw_value_y0         ;
    wire                        reg_mos_value_y0        ;
    wire                        reg_trigger_req_y0      ;

    wire [13:0]                 reg_dac_value_y1        ;
    wire [11:0]                 reg_sw_value_y1         ;
    wire                        reg_mos_value_y1        ;
    wire                        reg_trigger_req_y1      ;

    wire [13:0]                 reg_dac_value_y2        ;
    wire [11:0]                 reg_sw_value_y2         ;
    wire                        reg_mos_value_y2        ;
    wire                        reg_trigger_req_y2      ;

    wire [13:0]                 reg_dac_value_y3        ;
    wire [11:0]                 reg_sw_value_y3         ;
    wire                        reg_mos_value_y3        ;
    wire                        reg_trigger_req_y3      ;

    wire                        reg_core_en             ;
    wire [3:0]                  reg_core_mode           ;

        // Step
    wire                        reg_step_en             ;
    wire [31:0]                 reg_step_pic_num        ;
    wire [31:0]                 reg_step_x_seq          ;
    wire [31:0]                 reg_step_y_seq          ;
        // Step cfg
    wire [9:0]                  reg_step_phase_0        ;
    wire [9:0]                  reg_step_phase_1        ;
    wire [9:0]                  reg_step_phase_2        ;
    wire [9:0]                  reg_step_phase_3        ;
    wire [9:0]                  reg_step_phase_4        ;
    wire [9:0]                  reg_step_phase_5        ;
    wire [9:0]                  reg_step_phase_6        ;
    wire [9:0]                  reg_step_phase_7        ;
    wire [9:0]                  reg_step_phase_8        ;
    wire [9:0]                  reg_step_phase_9        ;
    wire [9:0]                  reg_step_phase_10       ;
    wire [9:0]                  reg_step_phase_11       ;
    wire [9:0]                  reg_step_phase_12       ;
    wire [9:0]                  reg_step_phase_13       ;
    wire [9:0]                  reg_step_phase_14       ;
    wire [9:0]                  reg_step_phase_15       ;
    wire [9:0]                  reg_step_phase_16       ;
    wire [9:0]                  reg_step_phase_17       ;
    wire [9:0]                  reg_step_phase_18       ;
    wire [9:0]                  reg_step_phase_19       ;
    wire [9:0]                  reg_step_phase_20       ;
    wire [9:0]                  reg_step_phase_21       ;
    wire [9:0]                  reg_step_phase_22       ;
    wire [9:0]                  reg_step_phase_23       ;
    wire [9:0]                  reg_step_phase_24       ;
    wire [9:0]                  reg_step_phase_25       ;
    wire [9:0]                  reg_step_phase_26       ;
    wire [9:0]                  reg_step_phase_27       ;
    wire [9:0]                  reg_step_phase_28       ;
    wire [9:0]                  reg_step_phase_29       ;
    wire [9:0]                  reg_step_phase_30       ;
    wire [9:0]                  reg_step_phase_31       ;

    wire [9:0]                  reg_step_inc_0          ;
    wire [9:0]                  reg_step_inc_1          ;
    wire [9:0]                  reg_step_inc_2          ;
    wire [9:0]                  reg_step_inc_3          ;
    wire [9:0]                  reg_step_inc_4          ;
    wire [9:0]                  reg_step_inc_5          ;
    wire [9:0]                  reg_step_inc_6          ;
    wire [9:0]                  reg_step_inc_7          ;
    wire [9:0]                  reg_step_inc_8          ;
    wire [9:0]                  reg_step_inc_9          ;
    wire [9:0]                  reg_step_inc_10         ;
    wire [9:0]                  reg_step_inc_11         ;
    wire [9:0]                  reg_step_inc_12         ;
    wire [9:0]                  reg_step_inc_13         ;
    wire [9:0]                  reg_step_inc_14         ;
    wire [9:0]                  reg_step_inc_15         ;
    wire [9:0]                  reg_step_inc_16         ;
    wire [9:0]                  reg_step_inc_17         ;
    wire [9:0]                  reg_step_inc_18         ;
    wire [9:0]                  reg_step_inc_19         ;
    wire [9:0]                  reg_step_inc_20         ;
    wire [9:0]                  reg_step_inc_21         ;
    wire [9:0]                  reg_step_inc_22         ;
    wire [9:0]                  reg_step_inc_23         ;
    wire [9:0]                  reg_step_inc_24         ;
    wire [9:0]                  reg_step_inc_25         ;
    wire [9:0]                  reg_step_inc_26         ;
    wire [9:0]                  reg_step_inc_27         ;
    wire [9:0]                  reg_step_inc_28         ;
    wire [9:0]                  reg_step_inc_29         ;
    wire [9:0]                  reg_step_inc_30         ;
    wire [9:0]                  reg_step_inc_31         ;

    wire [9:0]                  reg_step_base_0         ;
    wire [9:0]                  reg_step_base_1         ;
    wire [9:0]                  reg_step_base_2         ;
    wire [9:0]                  reg_step_base_3         ;
    wire [9:0]                  reg_step_base_4         ;
    wire [9:0]                  reg_step_base_5         ;
    wire [9:0]                  reg_step_base_6         ;
    wire [9:0]                  reg_step_base_7         ;
    wire [9:0]                  reg_step_base_8         ;
    wire [9:0]                  reg_step_base_9         ;
    wire [9:0]                  reg_step_base_10        ;
    wire [9:0]                  reg_step_base_11        ;
    wire [9:0]                  reg_step_base_12        ;
    wire [9:0]                  reg_step_base_13        ;
    wire [9:0]                  reg_step_base_14        ;
    wire [9:0]                  reg_step_base_15        ;
    wire [9:0]                  reg_step_base_16        ;
    wire [9:0]                  reg_step_base_17        ;
    wire [9:0]                  reg_step_base_18        ;
    wire [9:0]                  reg_step_base_19        ;
    wire [9:0]                  reg_step_base_20        ;
    wire [9:0]                  reg_step_base_21        ;
    wire [9:0]                  reg_step_base_22        ;
    wire [9:0]                  reg_step_base_23        ;
    wire [9:0]                  reg_step_base_24        ;
    wire [9:0]                  reg_step_base_25        ;
    wire [9:0]                  reg_step_base_26        ;
    wire [9:0]                  reg_step_base_27        ;
    wire [9:0]                  reg_step_base_28        ;
    wire [9:0]                  reg_step_base_29        ;
    wire [9:0]                  reg_step_base_30        ;
    wire [9:0]                  reg_step_base_31        ;

    wire                        reg_ram_cfg_en          ;
    wire                        reg_ram_whrl            ;
    wire [9:0]                  reg_ram_addr            ;
    wire [13:0]                 reg_ram_wdata           ;
    wire [13:0]                 reg_ram_rdata           ;
    wire                        reg_ram_req             ;
    wire                        reg_ram_done            ;
    wire [9:0]                  reg_wave_start_addr     ;
    wire [9:0]                  reg_wave_end_addr       ;

    wire                        reg_adjust_en           ;
    wire [13:0]                 reg_adjust_gain         ;
    wire [13:0]                 reg_adjust_offset       ;

    wire                        reg_num_check_clr       ;

    wire [31:0]                 reg_sum_err_num         ;


    wire                        trigger_miss_flag       ;
    wire [15:0]                 reg_core_status         ;

    wire                        iic_sda_ctrl            ;
    wire                        iic_scl                 ;
    wire                        iic_sda_i               ;
    wire                        iic_sda_o               ;


    wire                        laser_0                 ;
    wire                        laser_1                 ;

    wire                        mpu1_uart_rxd           ;
    wire                        mpu1_uart_txd           ;

    wire                        mpu0_iic_sda            ;
    wire                        mpu0_iic_scl            ;

    wire [9:0]                  dds_inc                 ;

    wire                        trigger_in_en           ;

    wire                        reset                   ;

    wire                        trigger_master          ;

    wire                        filtered_trigger        ;

    wire [31:0]                 reg_rtc_us_h              ;

    wire [31:0]                 reg_rtc_us_l              ;

    wire                         reg_io_output_en       ;

    wire                        io_output;

    wire                        reg_dac_en;

    wire                        reg_frame_trigger_en;

    wire                        frame_trigger_out;

    wire   [31:0]                 reg_line_num;


/********************************************************
*                        logic Here                     *
********************************************************/


    assign trigger_core_in = trigger_core ;

    assign amp_en               = 1'b1;
    assign fpga_dac_pd          = ~reg_dac_en;
    assign led_anode_en         = 1'b0;

    // assign led                  = dac_sw_x_0[0];

//    assign laser_0              = reg_laser_status[0];
//    assign laser_1              = reg_laser_status[1];

    // assign phy_rst              = phy_reset_bd;
    // assign phy_rst              = phy_reset_bd && ~(cnt_phy > 0);

    assign dac_mos              = {dac_mos_y, dac_mos_x};

    // assign dac_clk              = {8{dac_clock}};
    // assign dac_wrt              = {8{dac_write}};
    assign dac_data_0           = dac_data_x0;
    assign dac_data_1           = dac_data_x1;
    assign dac_data_2           = dac_data_x2;
    assign dac_data_3           = dac_data_x3;

    // assign mpu0_iic_scl         = iic_scl;
    // assign mpu0_iic_sda         = iic_sda_ctrl ? iic_sda_o : 1'bz;
    assign iic_sda_i            = iic_sda_ctrl ? iic_sda_o : mpu0_iic_sda;

    assign dds_inc              = reg_step_en ? step_inc : reg_dds_inc;

    assign rst                  = reg_soft_reset || reset;

    assign trigger_master       = encoder_in_a;

    assign io_output_24v        = reg_io_output_en ? io_output:1'b0;

    assign io_output_diff       = io_output;

//    assign stm32_spi_spisel     = 1'b0;

    // always @ (posedge clk or posedge rst) begin
    //     if (rst == 1'b1) begin
    //         cnt_phy             <= 'd0;
    //     end else if (cnt_phy >= TIME_10MS - 1'b1) begin
    //         cnt_phy             <= 'd0;
    //     end else if (reg_phy_rst == 1'b1) begin
    //         cnt_phy             <= 'd1;
    //     end else if (cnt_phy > 'd0) begin
    //         cnt_phy             <= cnt_phy + 1'b1;
    //     end else begin
    //         cnt_phy             <= 'd0;
    //     end
    // end

//    IOBUF mdio_rtl_0_mdio_iobuf(

//        .I                                              (mdio_rtl_0_mdio_o                              ),
//        .IO                                             (phy_mdio                                       ),
//        .O                                              (mdio_rtl_0_mdio_i                              ),
//        .T                                              (mdio_rtl_0_mdio_t                              )
//    );

    genvar h;

    generate
        for (h = 0; h < 4; h = h + 1'b1) begin
            IOBUF gpio_rtl_0_gpio_iobuf(

                .I                                              (gpio_rtl_0_tri_o[h]                              ),
                .IO                                             (gpio_io[h]                                       ),
                .O                                              (gpio_rtl_0_tri_i[h]                              ),
                .T                                              (gpio_rtl_0_tri_t[h]                              )
            );
    end
    endgenerate

    genvar c;

    generate
        for (c = 0; c < 2; c = c + 1'b1) begin

            IOBUF spi_rtl_0_io_iobuf(

                .I                                              (flash_spi_io_o[c]                            ),
                .IO                                             (flash_spi_io[c]                              ),
                .O                                              (flash_spi_io_i[c]                            ),
                .T                                              (flash_spi_io_t[c]                            )
            );

            //  IOBUF spi_rtl_1_io_iobuf(

            //     .I                                              (stm32_spi_io_o[c]                            ),
            //     .IO                                             (stm32_spi_io[c]                              ),
            //     .O                                              (stm32_spi_io_i[c]                            ),
            //     .T                                              (stm32_spi_io_t[c]                            )
            // );
    end
    endgenerate

        IOBUF spi_rtl_1_io_iobuf(

                .I                                              (stm32_spi_io_o                            ),
                .IO                                             (stm32_spi_io_test                              ),
                .O                                              (stm32_spi_io_i                            ),
                .T                                              (stm32_spi_io_t                            )
            );


//    IOBUF spi_rtl_0_io1_iobuf(

//        .I                                              (flash_spi_miso_o                               ),
//        .IO                                             (flash_spi_miso                                 ),
//        .O                                              (flash_spi_miso_i                               ),
//        .T                                              (flash_spi_miso_t                               )
//    );

    // IOBUF spi_rtl_0_sck_iobuf(

    //     .I                                              (flash_spi_sck_o                                ),
    //     .IO                                             (flash_spi_sck                                  ),
    //     .O                                              (flash_spi_sck_i                                ),
    //     .T                                              (flash_spi_sck_t                                )
    // );

    IOBUF spi_rtl_0_ss_iobuf_0(

        .I                                              (flash_spi_cs_n_o                               ),
        .IO                                             (flash_spi_cs_n                                 ),
        .O                                              (flash_spi_cs_n_i                               ),
        .T                                              (flash_spi_cs_n_t                               )
    );

    IOBUF spi_rtl_1_ss_iobuf_0(

        .I                                              (stm32_spi_cs_n_o                               ),
        .IO                                             (stm32_spi_cs_n                                 ),
        .O                                              (stm32_spi_cs_n_i                               ),
        .T                                              (stm32_spi_cs_n_t                               )
    );

    IOBUF spi_rtl_1_sck_iobuf_0(

        .I                                              (stm32_spi_sck_o                               ),
        .IO                                             (stm32_spi_sck                                 ),
        .O                                              (stm32_spi_sck_i                               ),
        .T                                              (stm32_spi_sck_t                               )
    );

    clock_manage clock_manage_inst(

        .sys_clk                                        (sys_clk                                        ),
        .sys_rst_n                                      (sys_rst_n                                      ),

        .reg_soft_reset                                 (1'b0                                           ),

        .clk                                            (clk                                            ),
        .rst                                            (reset                                          ),
        .clk_epc                                        (clk_epc                                        ),
        .rst_epc                                        (rst_epc                                        )
    );

    xadc_top xadc_top_inst(

        .clk                                            (clk                                            ),  // input
        .rst                                            (rst                                            ),  // input

        .reg_device_temp                                (reg_device_temp                                )   // output      [11:0]
    );

    uart_top uart_top_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_mpu1_angle_x                               (reg_mpu1_angle_x                               ),
        .reg_mpu1_angle_y                               (reg_mpu1_angle_y                               ),
        .reg_mpu1_angle_z                               (reg_mpu1_angle_z                               ),
        .reg_mpu1_temp                                  (reg_mpu1_temp                                  ),

        .reg_sum_err_num                                (reg_sum_err_num                                ),
        .reg_num_check_clr                              (reg_num_check_clr                              ),

        .reg_mpu1_cfg_addr                              (reg_mpu1_cfg_addr                              ),
        .reg_mpu1_cfg_value                             (reg_mpu1_cfg_value                             ),
        .reg_mpu1_cfg_req                               (reg_mpu1_cfg_req                               ),
        .reg_mpu1_cfg_done                              (reg_mpu1_cfg_done                              ),
        .reg_mpu1_bps                                   (reg_mpu1_bps                                   ),

        .uart_rxd                                       (mpu1_uart_rxd                                  ),
        .uart_txd                                       (mpu1_uart_txd                                  )
    );

    iic_driver iic_driver_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_iic_whrl                                   (reg_iic_whrl                                   ),
        .reg_iic_dev_addr                               (reg_iic_dev_addr                               ),
        .reg_iic_addr                                   (reg_iic_addr                                   ),
        .reg_iic_wdata                                  (reg_iic_wdata                                  ),
        .reg_iic_rdata                                  (reg_iic_rdata                                  ),
        .reg_iic_req                                    (reg_iic_req                                    ),
        .reg_iic_done                                   (reg_iic_done                                   ),

        .iic_sda_ctrl                                   (iic_sda_ctrl                                   ),  // output wire
        .iic_scl                                        (iic_scl                                        ),  // output wire
        .iic_sda_o                                      (iic_sda_o                                      ),  // output wire
        .iic_sda_i                                      (iic_sda_i                                      )   // input wire

        // .iic_scl                                        (mpu0_iic_scl                                   ),
        // .iic_sda                                        (mpu0_iic_sda                                   )
    );

    tmp75_rw_top tmp75_rw_top_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .i2c_sda                                        (tmp75_iic_sda                                  ),
        .i2c_scl                                        (tmp75_iic_scl                                  ),

        .tmp75_temp_data                                (reg_mainboard_temp                             )
    );

    mos_ctrl mos_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .dac_mos_x                                      (dac_mos_x                                      ),
        .dac_mos_y                                      (dac_mos_y                                      ),

        .mos_ack                                        (mos_ack                                        ),
        .mos_val                                        (mos_val                                        ),
        .mos_req                                        (mos_req                                        ),
        .reg_mos_en                                     (reg_mos_en                                     ),
        .reg_mos_time                                   (reg_mos_ack_time                               )
    );

    dac_ctrl dac_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .dac_clk                                        (dac_clk                                        ),
        .dac_wrt                                        (dac_wrt                                        ),
        .dac1_data                                      (dac_data_x0                                    ),
        .dac2_data                                      (dac_data_x1                                    ),
        .dac3_data                                      (dac_data_x2                                    ),
        .dac4_data                                      (dac_data_x3                                    ),
        // .dac1_data_y                                    (                                               ),
        // .dac2_data_y                                    (                                               ),
        // .dac3_data_y                                    (                                               ),
        // .dac4_data_y                                    (                                               ),
        .dac_val                                        (dac_val                                        ),
        .dac_req                                        (dac_req                                        ),
        .dac_ack                                        (dac_ack                                        ),
        .reg_dac_en                                     (reg_dac_en                                     ),
        .reg_dac_time                                   (reg_dac_ack_time                               )
    );

    dds_ctrl dds_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_dds_inc                                    (dds_inc                                        ),
        .reg_dds_ack_time                               (reg_dds_ack_time                               ),
        .reg_current_offset                             (reg_current_offset                             ),

        // .reg_adjust_en                                  (reg_adjust_en                                  ),
        // .reg_adjust_gain                                (reg_adjust_gain                                ),
        // .reg_adjust_offset                              (reg_adjust_offset                              ),

        .dds_full_time                                  (reg_sw_ack_time[15:0]                          ),
        .dds_addr_base                                  (dds_addr_base                                  ),
        .dds_addr                                       (dds_addr                                       ),
        .dds_refresh                                    (dds_refresh                                    ),
        .dds_ack                                        (dds_ack                                        ),
        .dds_req                                        (dds_req                                        ),
        .dds_time_forward                               (dds_time_forward                               ),
        .dds_time_backward                              (dds_time_backward                              ),

        .reg_ram_rdata                                  (reg_ram_rdata                                  ),
        .reg_ram_done                                   (reg_ram_done                                   ),
        .reg_ram_whrl                                   (reg_ram_whrl                                   ),
        .reg_ram_addr                                   (reg_ram_addr                                   ),
        .reg_ram_wdata                                  (reg_ram_wdata                                  ),
        .reg_ram_req                                    (reg_ram_req                                    ),
        .reg_ram_cfg_en                                 (reg_ram_cfg_en                                 )
    );

    sw_ctrl sw_ctrl_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_sw_ack_time                                (reg_sw_ack_time                                ),

        .dac_sw_x1                                      (dac_sw_x_0                                     ),
        .dac_sw_x2                                      (dac_sw_x_1                                     ),
        .dac_sw_x3                                      (dac_sw_x_2                                     ),
        .dac_sw_x4                                      (dac_sw_x_3                                     ),
        .dac_sw_y1                                      (dac_sw_y_0                                     ),
        .dac_sw_y2                                      (dac_sw_y_1                                     ),
        .dac_sw_y3                                      (dac_sw_y_2                                     ),
        .dac_sw_y4                                      (dac_sw_y_3                                     ),

        // X Y 顺序确认
        .sw_ack                                         (sw_ack                                         ),
        .sw_time_forward                                (dds_time_forward                               ),
        .sw_time_backward                               (dds_time_backward                              ),
        .sw_req                                         (sw_req                                         )
    );




    core_controller #(

        .BANK_NUM                                       (8'd8                                           ),
        .SW_NUM                                         (8'd12                                          )
    ) core_controller_inst(

        .clk                                            (clk                                            ),
        .rst                                            (rst                                            ),

        .reg_dds_phase                                  (reg_dds_phase                                  ),
        .reg_dds_inc                                    (reg_dds_inc                                    ),
        .reg_exp_cycle                                  (reg_exp_cycle                                  ),
        .reg_trigger_gap                                (reg_trigger_gap                                ),
        .reg_pic_num                                    (reg_pic_num                                    ),
        .reg_sw_status                                  (reg_sw_status                                  ),
        .reg_sw_shift                                   (reg_sw_shift                                   ),
        .reg_sw_loop_gap                                (reg_sw_loop_gap                                ),
        .reg_sw_loop_num                                (reg_sw_loop_num                                ),
        .reg_dds_phase_offset                           (reg_dds_phase_offset                           ),
        .reg_dds_direction_x                            (reg_dds_direction_x                            ),
        .reg_dds_direction_y                            (reg_dds_direction_y                            ),
        .reg_dac_value_forward                          (reg_dac_value_forward                          ),
        .reg_dac_value_backward                         (reg_dac_value_backward                         ),
        .reg_sw_wait                                    (reg_sw_wait                                    ),
        .reg_dac_req                                    (reg_dac_req                                    ),

        .reg_dds_phase_y                                (reg_dds_phase_y                                ),

        .reg_step_en                                    (reg_step_en                                    ),
        .reg_step_pic_num                               (reg_step_pic_num                               ),
        .reg_step_x_seq                                 (reg_step_x_seq                                 ),
        .reg_step_y_seq                                 (reg_step_y_seq                                 ),
        .reg_step_phase_0                               (reg_step_phase_0                               ),
        .reg_step_phase_1                               (reg_step_phase_1                               ),
        .reg_step_phase_2                               (reg_step_phase_2                               ),
        .reg_step_phase_3                               (reg_step_phase_3                               ),
        .reg_step_phase_4                               (reg_step_phase_4                               ),
        .reg_step_phase_5                               (reg_step_phase_5                               ),
        .reg_step_phase_6                               (reg_step_phase_6                               ),
        .reg_step_phase_7                               (reg_step_phase_7                               ),
        .reg_step_phase_8                               (reg_step_phase_8                               ),
        .reg_step_phase_9                               (reg_step_phase_9                               ),
        .reg_step_phase_10                              (reg_step_phase_10                              ),
        .reg_step_phase_11                              (reg_step_phase_11                              ),
        .reg_step_phase_12                              (reg_step_phase_12                              ),
        .reg_step_phase_13                              (reg_step_phase_13                              ),
        .reg_step_phase_14                              (reg_step_phase_14                              ),
        .reg_step_phase_15                              (reg_step_phase_15                              ),
        .reg_step_phase_16                              (reg_step_phase_16                              ),
        .reg_step_phase_17                              (reg_step_phase_17                              ),
        .reg_step_phase_18                              (reg_step_phase_18                              ),
        .reg_step_phase_19                              (reg_step_phase_19                              ),
        .reg_step_phase_20                              (reg_step_phase_20                              ),
        .reg_step_phase_21                              (reg_step_phase_21                              ),
        .reg_step_phase_22                              (reg_step_phase_22                              ),
        .reg_step_phase_23                              (reg_step_phase_23                              ),
        .reg_step_phase_24                              (reg_step_phase_24                              ),
        .reg_step_phase_25                              (reg_step_phase_25                              ),
        .reg_step_phase_26                              (reg_step_phase_26                              ),
        .reg_step_phase_27                              (reg_step_phase_27                              ),
        .reg_step_phase_28                              (reg_step_phase_28                              ),
        .reg_step_phase_29                              (reg_step_phase_29                              ),
        .reg_step_phase_30                              (reg_step_phase_30                              ),
        .reg_step_phase_31                              (reg_step_phase_31                              ),
        .reg_step_inc_0                                 (reg_step_inc_0                                 ),
        .reg_step_inc_1                                 (reg_step_inc_1                                 ),
        .reg_step_inc_2                                 (reg_step_inc_2                                 ),
        .reg_step_inc_3                                 (reg_step_inc_3                                 ),
        .reg_step_inc_4                                 (reg_step_inc_4                                 ),
        .reg_step_inc_5                                 (reg_step_inc_5                                 ),
        .reg_step_inc_6                                 (reg_step_inc_6                                 ),
        .reg_step_inc_7                                 (reg_step_inc_7                                 ),
        .reg_step_inc_8                                 (reg_step_inc_8                                 ),
        .reg_step_inc_9                                 (reg_step_inc_9                                 ),
        .reg_step_inc_10                                (reg_step_inc_10                                ),
        .reg_step_inc_11                                (reg_step_inc_11                                ),
        .reg_step_inc_12                                (reg_step_inc_12                                ),
        .reg_step_inc_13                                (reg_step_inc_13                                ),
        .reg_step_inc_14                                (reg_step_inc_14                                ),
        .reg_step_inc_15                                (reg_step_inc_15                                ),
        .reg_step_inc_16                                (reg_step_inc_16                                ),
        .reg_step_inc_17                                (reg_step_inc_17                                ),
        .reg_step_inc_18                                (reg_step_inc_18                                ),
        .reg_step_inc_19                                (reg_step_inc_19                                ),
        .reg_step_inc_20                                (reg_step_inc_20                                ),
        .reg_step_inc_21                                (reg_step_inc_21                                ),
        .reg_step_inc_22                                (reg_step_inc_22                                ),
        .reg_step_inc_23                                (reg_step_inc_23                                ),
        .reg_step_inc_24                                (reg_step_inc_24                                ),
        .reg_step_inc_25                                (reg_step_inc_25                                ),
        .reg_step_inc_26                                (reg_step_inc_26                                ),
        .reg_step_inc_27                                (reg_step_inc_27                                ),
        .reg_step_inc_28                                (reg_step_inc_28                                ),
        .reg_step_inc_29                                (reg_step_inc_29                                ),
        .reg_step_inc_30                                (reg_step_inc_30                                ),
        .reg_step_inc_31                                (reg_step_inc_31                                ),
        .reg_step_base_0                                (reg_step_base_0                                ),
        .reg_step_base_1                                (reg_step_base_1                                ),
        .reg_step_base_2                                (reg_step_base_2                                ),
        .reg_step_base_3                                (reg_step_base_3                                ),
        .reg_step_base_4                                (reg_step_base_4                                ),
        .reg_step_base_5                                (reg_step_base_5                                ),
        .reg_step_base_6                                (reg_step_base_6                                ),
        .reg_step_base_7                                (reg_step_base_7                                ),
        .reg_step_base_8                                (reg_step_base_8                                ),
        .reg_step_base_9                                (reg_step_base_9                                ),
        .reg_step_base_10                               (reg_step_base_10                               ),
        .reg_step_base_11                               (reg_step_base_11                               ),
        .reg_step_base_12                               (reg_step_base_12                               ),
        .reg_step_base_13                               (reg_step_base_13                               ),
        .reg_step_base_14                               (reg_step_base_14                               ),
        .reg_step_base_15                               (reg_step_base_15                               ),
        .reg_step_base_16                               (reg_step_base_16                               ),
        .reg_step_base_17                               (reg_step_base_17                               ),
        .reg_step_base_18                               (reg_step_base_18                               ),
        .reg_step_base_19                               (reg_step_base_19                               ),
        .reg_step_base_20                               (reg_step_base_20                               ),
        .reg_step_base_21                               (reg_step_base_21                               ),
        .reg_step_base_22                               (reg_step_base_22                               ),
        .reg_step_base_23                               (reg_step_base_23                               ),
        .reg_step_base_24                               (reg_step_base_24                               ),
        .reg_step_base_25                               (reg_step_base_25                               ),
        .reg_step_base_26                               (reg_step_base_26                               ),
        .reg_step_base_27                               (reg_step_base_27                               ),
        .reg_step_base_28                               (reg_step_base_28                               ),
        .reg_step_base_29                               (reg_step_base_29                               ),
        .reg_step_base_30                               (reg_step_base_30                               ),
        .reg_step_base_31                               (reg_step_base_31                               ),

        .reg_dac_value_x0                               (reg_dac_value_x0                               ),
        .reg_sw_value_x0                                (reg_sw_value_x0                                ),
        .reg_mos_value_x0                               (reg_mos_value_x0                               ),
        .reg_trigger_req_x0                             (reg_trigger_req_x0                             ),
        .reg_dac_value_x1                               (reg_dac_value_x1                               ),
        .reg_sw_value_x1                                (reg_sw_value_x1                                ),
        .reg_mos_value_x1                               (reg_mos_value_x1                               ),
        .reg_trigger_req_x1                             (reg_trigger_req_x1                             ),
        .reg_dac_value_x2                               (reg_dac_value_x2                               ),
        .reg_sw_value_x2                                (reg_sw_value_x2                                ),
        .reg_mos_value_x2                               (reg_mos_value_x2                               ),
        .reg_trigger_req_x2                             (reg_trigger_req_x2                             ),
        .reg_dac_value_x3                               (reg_dac_value_x3                               ),
        .reg_sw_value_x3                                (reg_sw_value_x3                                ),
        .reg_mos_value_x3                               (reg_mos_value_x3                               ),
        .reg_trigger_req_x3                             (reg_trigger_req_x3                             ),
        .reg_dac_value_y0                               (reg_dac_value_y0                               ),
        .reg_sw_value_y0                                (reg_sw_value_y0                                ),
        .reg_mos_value_y0                               (reg_mos_value_y0                               ),
        .reg_trigger_req_y0                             (reg_trigger_req_y0                             ),
        .reg_dac_value_y1                               (reg_dac_value_y1                               ),
        .reg_sw_value_y1                                (reg_sw_value_y1                                ),
        .reg_mos_value_y1                               (reg_mos_value_y1                               ),
        .reg_trigger_req_y1                             (reg_trigger_req_y1                             ),
        .reg_dac_value_y2                               (reg_dac_value_y2                               ),
        .reg_sw_value_y2                                (reg_sw_value_y2                                ),
        .reg_mos_value_y2                               (reg_mos_value_y2                               ),
        .reg_trigger_req_y2                             (reg_trigger_req_y2                             ),
        .reg_dac_value_y3                               (reg_dac_value_y3                               ),
        .reg_sw_value_y3                                (reg_sw_value_y3                                ),
        .reg_mos_value_y3                               (reg_mos_value_y3                               ),
        .reg_trigger_req_y3                             (reg_trigger_req_y3                             ),

        .reg_core_mode                                  (reg_core_mode                                  ),
        .reg_core_en                                    (reg_core_en                                    ),
        .reg_core_status                                (reg_core_status                                ),

        .reg_wave_start_addr                            (reg_wave_start_addr                            ),
        .reg_wave_end_addr                              (reg_wave_end_addr                              ),

        .trigger_in_en                                  (trigger_in_en                                  ),
        .trigger_in                                     (trigger_core_in              ),
        .sensor_trigger_req                             (                                               ),
        .trigger_miss_flag                               (trigger_miss_flag                               ),

        .mos_val                                        (mos_val                                        ),
        .mos_req                                        (mos_req                                        ),
        .mos_ack                                        (mos_ack                                        ),

        .dds_refresh                                    (dds_refresh                                    ),
        .dds_addr                                       (dds_addr                                       ),
        .dds_req                                        (dds_req                                        ),
        .dds_ack                                        (dds_ack                                        ),
        // .dds_data_forward                               (dds_data_forward                               ),
        // .dds_data_backward                              (dds_data_backward                              ),
        .step_inc                                       (step_inc                                       ),
        .dds_addr_base                                  (dds_addr_base                                  ),

        .dac_val                                        (dac_val                                        ),
        .dac_req                                        (dac_req                                        ),
        .dac_ack                                        (dac_ack                                        ),

        .sw_val                                         (sw_val                                         ),
        .sw_req                                         (sw_req                                         ),
        .sw_ack                                         (sw_ack                                         )
    );

    trigger_ctrl trigger_ctrl_inst(

        .clk                                            (clk                                            ),  // input wire
        .rst                                            (rst                                            ),  // input wire

        .reg_camera_delay                               (reg_camera_delay                               ),
        .reg_camera_cycle                               (reg_camera_cycle                               ),
        .reg_camera_trig_num                            (reg_camera_trig_num                            ),


        .reg_external_trig_num                          (reg_external_trig_num                          ),
        .reg_external_trig_polar                        (reg_external_trig_polar                        ),
        .reg_external_trig_delay                        (reg_external_trig_delay                        ),
        .reg_external_trig_width                        (reg_external_trig_width                        ),
        .reg_external_trig_enable                       (reg_external_trig_enable                       ),

        // .trigger_req                                    (sensor_trigger_req                             ),
        .io_output                                      (io_output                                      ),
        .reg_trig_out_polar                             (reg_trig_out_polar                             ),

        .ext_trigger_0                                  (io_input_0                                     ),  // input wire
        .ext_trigger_1                                  (io_input_1                                     ),  // input wire

        .encoder_in_a                                   (encoder_in_a                                   ),
        .encoder_in_b                                   (encoder_in_b                                   ),

        .reg_status_cnt_clr                             (reg_status_cnt_clr                             ),  // input wire


        .reg_soft_trigger_cycle                         (reg_soft_trigger_cycle                         ),  // input wire [31:0]
        .reg_soft_trigger_num                           (reg_soft_trigger_num                           ),  // input wire [31:0]
        .reg_soft_trigger_en                            (reg_soft_trigger_en                            ),  // input wire

        .reg_trigger_cycle                              (reg_trigger_cycle                              ),  // input wire [31:0]
        .reg_trigger_num                                (reg_trigger_num                                ),  // input wire [31:0]
        .reg_trigger_mode                               (reg_trigger_mode                               ),  // input wire [3:0]
        .reg_trigger_delay                              (reg_trigger_delay                              ),  // input wire [31:0]
        .reg_trigger_width                              (reg_trigger_width                              ),  // input wire [31:0]
        .reg_trigger_pulse                              (reg_trigger_pulse                              ),  // input wire [31:0]
        .reg_trigger_polar                              (reg_trigger_polar                              ),  // input wire [1:0]
        .reg_trigger_en                                 (reg_trigger_en                                 ),  // input wire



        .reg_encoder_phase                              (reg_encoder_phase                              ),  // input wire
        .reg_encoder_cnt_mode                           (reg_encoder_cnt_mode                           ),  // input wire [3:0]
        .reg_encoder_dis_mode                           (reg_encoder_dis_mode                           ),  // input wire [3:0]
        .reg_encoder_ignore                             (reg_encoder_ignore                             ),  // input wire [31:0]
        .reg_encoder_div                                (reg_encoder_div                                ),  // input wire [31:0]
        .reg_encoder_width                              (reg_encoder_width                              ),  // input wire [31:0]
        .reg_encoder_location                           (reg_encoder_location                           ),  // input wire [31:0]
        .reg_encoder_multi_coe                          (reg_encoder_multi_coe                          ),  // input wire [31:0]
        .reg_encoder_multi_en                           (reg_encoder_multi_en                           ),  // input wire
        .reg_encoder_a_cnt                              (reg_encoder_a_cnt                              ),  // input wire [31:0]
        .reg_encoder_b_cnt                              (reg_encoder_b_cnt                              ),  // input wire [31:0]
        .reg_encoder_clr                                (reg_encoder_clr                                ),  // input wire
        .reg_encoder_en                                 (reg_encoder_en                                 ),

        // Level 1
        .reg_l1_status_cnt_clr                          (reg_l1_status_cnt_clr                          ),  // input wire
        .reg_l1_soft_trigger_cycle                      (reg_l1_soft_trigger_cycle                      ),  // input wire [31:0]
        .reg_l1_soft_trigger_num                        (reg_l1_soft_trigger_num                        ),  // input wire [31:0]
        .reg_l1_soft_trigger_en                         (reg_l1_soft_trigger_en                         ),  // input wire

        .reg_l1_trigger_cycle                           (reg_l1_trigger_cycle                           ),  // input wire [31:0]
        .reg_l1_trigger_num                             (reg_l1_trigger_num                             ),  // input wire [31:0]
        .reg_l1_trigger_mode                            (reg_l1_trigger_mode                            ),  // input wire [3:0]
        .reg_l1_trigger_delay                           (reg_l1_trigger_delay                           ),  // input wire [31:0]
        .reg_l1_trigger_width                           (reg_l1_trigger_width                           ),  // input wire [31:0]
        .reg_l1_trigger_pulse                           (reg_l1_trigger_pulse                           ),  // input wire [31:0]
        .reg_l1_trigger_polar                           (reg_l1_trigger_polar                           ),  // input wire [1:0]
        .reg_l1_trigger_en                              (reg_l1_trigger_en                              ),  // input wire

        .reg_l1_encoder_phase                           (reg_l1_encoder_phase                           ),  // input wire
        .reg_l1_encoder_cnt_mode                        (reg_l1_encoder_cnt_mode                        ),  // input wire [3:0]
        .reg_l1_encoder_dis_mode                        (reg_l1_encoder_dis_mode                        ),  // input wire [3:0]
        .reg_l1_encoder_ignore                          (reg_l1_encoder_ignore                          ),  // input wire [31:0]
        .reg_l1_encoder_div                             (reg_l1_encoder_div                             ),  // input wire [31:0]
        .reg_l1_encoder_width                           (reg_l1_encoder_width                           ),  // input wire [31:0]
        .reg_l1_encoder_location                        (reg_l1_encoder_location                        ),  // input wire [31:0]
        .reg_l1_encoder_multi_coe                       (reg_l1_encoder_multi_coe                       ),  // input wire [31:0]
        .reg_l1_encoder_multi_en                        (reg_l1_encoder_multi_en                        ),  // input wire
        .reg_l1_encoder_a_cnt                           (reg_l1_encoder_a_cnt                           ),  // input wire [31:0]
        .reg_l1_encoder_b_cnt                           (reg_l1_encoder_b_cnt                           ),  // input wire [31:0]
        .reg_l1_encoder_clr                             (reg_l1_encoder_clr                             ),  // input wire
        .reg_l1_encoder_en                              (reg_l1_encoder_en                              ),

        .reg_trigger_level                              (reg_trigger_level                              ),

        .reg_slave_device                               (reg_slave_device                               ),  // input wire
        .trigger_to_slave                               (trigger_slaver                                 ),  // output wire
        .trigger_from_master                            (trigger_master                                 ),  // input wire

        .reg_led_polar                                  (reg_led_polar                                  ),
        .reg_led_cnt_max                                (reg_led_cnt_max                                ),
        .reg_led_pwm_start_0                            (reg_led_pwm_start_0                            ),
        .reg_led_pwm_end_0                              (reg_led_pwm_end_0                              ),
        .reg_led_pwm_start_1                            (reg_led_pwm_start_1                            ),
        .reg_led_pwm_end_1                              (reg_led_pwm_end_1                              ),
        .reg_led_pwm_start_2                            (reg_led_pwm_start_2                            ),
        .reg_led_pwm_end_2                              (reg_led_pwm_end_2                              ),
        .reg_led_pwm_start_3                            (reg_led_pwm_start_3                            ),
        .reg_led_pwm_end_3                              (reg_led_pwm_end_3                              ),
        .reg_led_pwm_start_4                            (reg_led_pwm_start_4                            ),
        .reg_led_pwm_end_4                              (reg_led_pwm_end_4                              ),
        .reg_led_pwm_start_5                            (reg_led_pwm_start_5                            ),
        .reg_led_pwm_end_5                              (reg_led_pwm_end_5                              ),
        .reg_led_pwm_start_6                            (reg_led_pwm_start_6                            ),
        .reg_led_pwm_end_6                              (reg_led_pwm_end_6                              ),
        .reg_led_pwm_start_7                            (reg_led_pwm_start_7                            ),
        .reg_led_pwm_end_7                              (reg_led_pwm_end_7                              ),
        .reg_led_pwm_start_8                            (reg_led_pwm_start_8                            ),
        .reg_led_pwm_end_8                              (reg_led_pwm_end_8                              ),
        .reg_led_pwm_start_9                            (reg_led_pwm_start_9                            ),
        .reg_led_pwm_end_9                              (reg_led_pwm_end_9                              ),
        .reg_led_pwm_start_10                           (reg_led_pwm_start_10                           ),
        .reg_led_pwm_end_10                             (reg_led_pwm_end_10                             ),
        .reg_led_pwm_start_11                           (reg_led_pwm_start_11                           ),
        .reg_led_pwm_end_11                             (reg_led_pwm_end_11                             ),
        .reg_trig_start_0                               (reg_trig_start_0                               ),
        .reg_trig_end_0                                 (reg_trig_end_0                                 ),
        .reg_trig_start_1                               (reg_trig_start_1                               ),
        .reg_trig_end_1                                 (reg_trig_end_1                                 ),
        .reg_trig_start_2                               (reg_trig_start_2                               ),
        .reg_trig_end_2                                 (reg_trig_end_2                                 ),
        .reg_trig_start_3                               (reg_trig_start_3                               ),
        .reg_trig_end_3                                 (reg_trig_end_3                                 ),
        .reg_trig_start_4                               (reg_trig_start_4                               ),
        .reg_trig_end_4                                 (reg_trig_end_4                                 ),
        .reg_trig_start_5                               (reg_trig_start_5                               ),
        .reg_trig_end_5                                 (reg_trig_end_5                                 ),
        .reg_trigger_multi_en                           (reg_trigger_multi_en                           ),

        .led_pwm                                        (led_pwm                                        ),

        .trigger_out_en                                 (trigger_in_en                                  ),
        .trigger_external                               (trigger_external                               ),
        .trigger_core                                   (trigger_core                                   ),
        .reg_frame_trigger_en                           (reg_frame_trigger_en                               ),
        .reg_line_num                                   (reg_line_num                                       ),
        .filtered_trigger                               (filtered_trigger                               ),
        // .gmax_texp0                                     (gmax_texp0                                      ),  // output wire
        // .gmax_texp1                                     (gmax_texp1                                      )   // output wire
        .reg_rtc_us_h                                     (reg_rtc_us_h                                     ),
        .reg_rtc_us_l                                     (reg_rtc_us_l                                     )
    );

    design_1 design_1_inst(

        .EPC_INTF_0_addr                                (epc_addr                                       ),
        .EPC_INTF_0_ads                                 (                                               ),
        .EPC_INTF_0_be                                  (                                               ),
        .EPC_INTF_0_burst                               (                                               ),
        .EPC_INTF_0_clk                                 (clk_epc                                        ),
        .EPC_INTF_0_cs_n                                (epc_cs_n                                       ),
        .EPC_INTF_0_data_i                              (epc_rddata                                     ),
        .EPC_INTF_0_data_o                              (epc_wrdata                                     ),
        .EPC_INTF_0_data_t                              (                                               ),
        .EPC_INTF_0_rd_n                                (                                               ),
        .EPC_INTF_0_rdy                                 (epc_rdy                                        ),
        .EPC_INTF_0_rnw                                 (epc_rnw                                        ),
        .EPC_INTF_0_rst                                 (rst                                            ),
        .EPC_INTF_0_wr_n                                (                                               ),

        .clk_in1_0                                      (clk                                            ),
        // .mdio_rtl_0_mdc                                 (phy_mdc                                        ),
        // .mdio_rtl_0_mdio_i                              (mdio_rtl_0_mdio_i                              ),
        // .mdio_rtl_0_mdio_o                              (mdio_rtl_0_mdio_o                              ),
        // .mdio_rtl_0_mdio_t                              (mdio_rtl_0_mdio_t                              ),

        .reset                                          (reset                                            ),
        // .reset_rtl_0                                    (phy_reset_bd                                   ),

        // .rgmii_rtl_0_rd                                 (rgmii_rxd                                      ),
        // .rgmii_rtl_0_rx_ctl                             (rgmii_rx_ctrl                                  ),
        // .rgmii_rtl_0_rxc                                (rgmii_rx_clk                                   ),
        // .rgmii_rtl_0_td                                 (rgmii_txd                                      ),
        // .rgmii_rtl_0_tx_ctl                             (rgmii_tx_ctrl                                  ),
        // .rgmii_rtl_0_txc                                (rgmii_tx_clk                                   ),

        .spi_rtl_0_io0_i                                (flash_spi_io_i[0]                              ),
        .spi_rtl_0_io0_o                                (flash_spi_io_o[0]                              ),
        .spi_rtl_0_io0_t                                (flash_spi_io_t[0]                              ),
        .spi_rtl_0_io1_i                                (flash_spi_io_i[1]                              ),
        .spi_rtl_0_io1_o                                (flash_spi_io_o[1]                              ),
        .spi_rtl_0_io1_t                                (flash_spi_io_t[1]                              ),
//        .spi_rtl_0_io2_i                                (flash_spi_io_i[2]                              ),
//        .spi_rtl_0_io2_o                                (flash_spi_io_o[2]                              ),
//        .spi_rtl_0_io2_t                                (flash_spi_io_t[2]                              ),
//        .spi_rtl_0_io3_i                                (flash_spi_io_i[3]                              ),
//        .spi_rtl_0_io3_o                                (flash_spi_io_o[3]                              ),
//        .spi_rtl_0_io3_t                                (flash_spi_io_t[3]                              ),

//        .spi_rtl_0_io1_i                                (flash_spi_miso_i                               ),
//        .spi_rtl_0_io1_o                                (flash_spi_miso_o                               ),
//        .spi_rtl_0_io1_t                                (flash_spi_miso_t                               ),
        // .spi_rtl_0_sck_i                                (flash_spi_sck_i                                ),
        // .spi_rtl_0_sck_o                                (flash_spi_sck_o                                ),
        // .spi_rtl_0_sck_t                                (flash_spi_sck_t                                ),
        .spi_rtl_0_ss_i                                 (flash_spi_cs_n_i                               ),
        .spi_rtl_0_ss_o                                 (flash_spi_cs_n_o                               ),
        .spi_rtl_0_ss_t                                 (flash_spi_cs_n_t                               ),

        .spi_rtl_1_io0_i                                (stm32_spi_io_i                           ),
        .spi_rtl_1_io0_o                                (stm32_spi_io_o                           ),
        .spi_rtl_1_io0_t                                (stm32_spi_io_t                           ),
        // .spi_rtl_1_io1_i                                (stm32_spi_io_i[1]                           ),
        // .spi_rtl_1_io1_o                                (stm32_spi_io_o[1]                           ),
        // .spi_rtl_1_io1_t                                (stm32_spi_io_t[1]                           ),
        .spi_rtl_1_io1_i                                (                           ),
        .spi_rtl_1_io1_o                                (                           ),
        .spi_rtl_1_io1_t                                (                           ),

        .spi_rtl_1_sck_i                                (stm32_spi_sck_i                           ),
        .spi_rtl_1_sck_o                                (stm32_spi_sck_o                           ),
        .spi_rtl_1_sck_t                                (stm32_spi_sck_t                           ),
        .spi_rtl_1_spisel                               (stm32_spi_spisel                           ),
        .spi_rtl_1_ss_i                                 (stm32_spi_cs_n_i                           ),
        .spi_rtl_1_ss_o                                 (stm32_spi_cs_n_o                           ),
        .spi_rtl_1_ss_t                                 (stm32_spi_cs_n_t                           ),

        .gpio_rtl_0_tri_i                               (gpio_rtl_0_tri_i                               ),
        .gpio_rtl_0_tri_o                               (gpio_rtl_0_tri_o                               ),
        .gpio_rtl_0_tri_t                               (gpio_rtl_0_tri_t                               ),

        .uart_rtl_0_rxd                                 (test_uart_rxd                                  ),
        .uart_rtl_0_txd                                 (test_uart_txd                                  ),

        .uart_rtl_1_rxd                                 (rs485_uart_rxd                                 ),
        .uart_rtl_1_txd                                 (rs485_uart_txd                                 )
    );

    epc_reg epc_reg_inst(

        .clk                                            (clk                                            ),
        .clk_50m                                        (clk_epc                                        ),
        .rst                                            (rst                                            ),

        .epc_addr                                       (epc_addr                                       ),
        .epc_wrdata                                     (epc_wrdata                                     ),
        .epc_cs_n                                       (epc_cs_n                                       ),
        .epc_rnw                                        (epc_rnw                                        ),
        .epc_rddata                                     (epc_rddata                                     ),
        .epc_rdy                                        (epc_rdy                                        ),

        .reg_req                                        (reg_req                                        ),
        .reg_whrl                                       (reg_whrl                                       ),
        .reg_addr                                       (reg_addr                                       ),
        .reg_wdata                                      (reg_wdata                                      ),
        .reg_ack                                        (reg_ack                                        ),
        .reg_rdata                                      (reg_rdata                                      )
    );

    reg_fpga reg_fpga_inst(

        .clk                                            (clk                                            ),
        .rst                                            (reset                                          ),
        .reg_req                                        (reg_req                                        ),
        .reg_whrl                                       (reg_whrl                                       ),
        .reg_addr                                       (reg_addr                                       ),
        .reg_wdata                                      (reg_wdata                                      ),
        .reg_ack                                        (reg_ack                                        ),
        .reg_rdata                                      (reg_rdata                                      ),

        .reg_soft_reset                                 (reg_soft_reset                                 ),
        .reg_device_temp                                (reg_device_temp                                ),

//        .reg_phy_rst                                    (reg_phy_rst                                    ),

        .reg_mos_ack_time                               (reg_mos_ack_time                               ),
        .reg_dds_ack_time                               (reg_dds_ack_time                               ),
        .reg_dac_ack_time                               (reg_dac_ack_time                               ),
        .reg_sw_ack_time                                (reg_sw_ack_time                                ),
        .reg_mos_en                                     (reg_mos_en                                     ),
        .reg_mainboard_temp                             (reg_mainboard_temp                             ),

//        .reg_iic_whrl                                   (reg_iic_whrl                                   ),
//        .reg_iic_dev_addr                               (reg_iic_dev_addr                               ),
//        .reg_iic_addr                                   (reg_iic_addr                                   ),
//        .reg_iic_wdata                                  (reg_iic_wdata                                  ),
//        .reg_iic_rdata                                  (reg_iic_rdata                                  ),
//        .reg_iic_req                                    (reg_iic_req                                    ),
//        .reg_iic_done                                   (reg_iic_done                                   ),

//        .reg_laser_status                               (reg_laser_status                               ),

//        .reg_mpu1_angle_x                               (reg_mpu1_angle_x                               ),
//        .reg_mpu1_angle_y                               (reg_mpu1_angle_y                               ),
//        .reg_mpu1_angle_z                               (reg_mpu1_angle_z                               ),
//        .reg_mpu1_temp                                  (reg_mpu1_temp                                  ),
//        .reg_mpu1_cfg_addr                              (reg_mpu1_cfg_addr                              ),
//        .reg_mpu1_cfg_value                             (reg_mpu1_cfg_value                             ),
//        .reg_mpu1_cfg_req                               (reg_mpu1_cfg_req                               ),
//        .reg_mpu1_cfg_done                              (reg_mpu1_cfg_done                              ),
//        .reg_mpu1_bps                                   (reg_mpu1_bps                                   ),

        .reg_trigger_in_num                             (reg_trigger_in_num                             ),
        .reg_soft_trigger_cycle                         (reg_soft_trigger_cycle                         ),
        .reg_soft_trigger_num                           (reg_soft_trigger_num                           ),
        .reg_soft_trigger_en                            (reg_soft_trigger_en                            ),
        .reg_trigger_cycle                              (reg_trigger_cycle                              ),
        .reg_trigger_num                                (reg_trigger_num                                ),
        .reg_trigger_mode                               (reg_trigger_mode                               ),
        .reg_trigger_width                              (reg_trigger_width                              ),
        .reg_trigger_delay                              (reg_trigger_delay                              ),
        .reg_trigger_pulse                              (reg_trigger_pulse                              ),
        .reg_trigger_polar                              (reg_trigger_polar                              ),
        .reg_trigger_en                                 (reg_trigger_en                                 ),
        .reg_encoder_phase                              (reg_encoder_phase                              ),
        .reg_encoder_cnt_mode                           (reg_encoder_cnt_mode                           ),
        .reg_encoder_dis_mode                           (reg_encoder_dis_mode                           ),
        .reg_encoder_ignore                             (reg_encoder_ignore                             ),
        .reg_encoder_div                                (reg_encoder_div                                ),
        .reg_encoder_width                              (reg_encoder_width                              ),
        .reg_encoder_location                           (reg_encoder_location                           ),
        .reg_encoder_multi_en                           (reg_encoder_multi_en                           ),
        .reg_encoder_multi_coe                          (reg_encoder_multi_coe                          ),
        .reg_encoder_a_cnt                              (reg_encoder_a_cnt                              ),
        .reg_encoder_b_cnt                              (reg_encoder_b_cnt                              ),
        .reg_encoder_clr                                (reg_encoder_clr                                ),
        .reg_encoder_en                                 (reg_encoder_en                                 ),
        .reg_slave_device                               (reg_slave_device                               ),
        .reg_status_cnt_clr                             (reg_status_cnt_clr                             ),

        // .reg_trigger_in_num                             (reg_l1_trigger_in_num                          ),
        .reg_l1_soft_trigger_cycle                      (reg_l1_soft_trigger_cycle                      ),
        .reg_l1_soft_trigger_num                        (reg_l1_soft_trigger_num                        ),
        .reg_l1_soft_trigger_en                         (reg_l1_soft_trigger_en                         ),
        .reg_l1_trigger_cycle                           (reg_l1_trigger_cycle                           ),
        .reg_l1_trigger_num                             (reg_l1_trigger_num                             ),
        .reg_l1_trigger_mode                            (reg_l1_trigger_mode                            ),
        .reg_l1_trigger_width                           (reg_l1_trigger_width                           ),
        .reg_l1_trigger_delay                           (reg_l1_trigger_delay                           ),
        .reg_l1_trigger_pulse                           (reg_l1_trigger_pulse                           ),
        .reg_l1_trigger_polar                           (reg_l1_trigger_polar                           ),
        .reg_l1_trigger_en                              (reg_l1_trigger_en                              ),
        .reg_l1_encoder_phase                           (reg_l1_encoder_phase                           ),
        .reg_l1_encoder_cnt_mode                        (reg_l1_encoder_cnt_mode                        ),
        .reg_l1_encoder_dis_mode                        (reg_l1_encoder_dis_mode                        ),
        .reg_l1_encoder_ignore                          (reg_l1_encoder_ignore                          ),
        .reg_l1_encoder_div                             (reg_l1_encoder_div                             ),
        .reg_l1_encoder_width                           (reg_l1_encoder_width                           ),
        .reg_l1_encoder_location                        (reg_l1_encoder_location                        ),
        .reg_l1_encoder_multi_en                        (reg_l1_encoder_multi_en                        ),
        .reg_l1_encoder_multi_coe                       (reg_l1_encoder_multi_coe                       ),
        .reg_l1_encoder_a_cnt                           (reg_l1_encoder_a_cnt                           ),
        .reg_l1_encoder_b_cnt                           (reg_l1_encoder_b_cnt                           ),
        .reg_l1_encoder_clr                             (reg_l1_encoder_clr                             ),
        .reg_l1_encoder_en                              (reg_l1_encoder_en                              ),
        .reg_l1_status_cnt_clr                          (reg_l1_status_cnt_clr                          ),

        .reg_trigger_level                              (reg_trigger_level                              ),

        .reg_led_polar                                  (reg_led_polar                                  ),
        .reg_led_cnt_max                                (reg_led_cnt_max                                ),
        .reg_led_pwm_start_0                            (reg_led_pwm_start_0                            ),
        .reg_led_pwm_end_0                              (reg_led_pwm_end_0                              ),
        .reg_led_pwm_start_1                            (reg_led_pwm_start_1                            ),
        .reg_led_pwm_end_1                              (reg_led_pwm_end_1                              ),
        .reg_led_pwm_start_2                            (reg_led_pwm_start_2                            ),
        .reg_led_pwm_end_2                              (reg_led_pwm_end_2                              ),
        .reg_led_pwm_start_3                            (reg_led_pwm_start_3                            ),
        .reg_led_pwm_end_3                              (reg_led_pwm_end_3                              ),
        .reg_led_pwm_start_4                            (reg_led_pwm_start_4                            ),
        .reg_led_pwm_end_4                              (reg_led_pwm_end_4                              ),
        .reg_led_pwm_start_5                            (reg_led_pwm_start_5                            ),
        .reg_led_pwm_end_5                              (reg_led_pwm_end_5                              ),
        .reg_led_pwm_start_6                            (reg_led_pwm_start_6                            ),
        .reg_led_pwm_end_6                              (reg_led_pwm_end_6                              ),
        .reg_led_pwm_start_7                            (reg_led_pwm_start_7                            ),
        .reg_led_pwm_end_7                              (reg_led_pwm_end_7                              ),
        .reg_led_pwm_start_8                            (reg_led_pwm_start_8                            ),
        .reg_led_pwm_end_8                              (reg_led_pwm_end_8                              ),
        .reg_led_pwm_start_9                            (reg_led_pwm_start_9                            ),
        .reg_led_pwm_end_9                              (reg_led_pwm_end_9                              ),
        .reg_led_pwm_start_10                           (reg_led_pwm_start_10                           ),
        .reg_led_pwm_end_10                             (reg_led_pwm_end_10                             ),
        .reg_led_pwm_start_11                           (reg_led_pwm_start_11                           ),
        .reg_led_pwm_end_11                             (reg_led_pwm_end_11                             ),
        .reg_trig_start_0                               (reg_trig_start_0                               ),
        .reg_trig_end_0                                 (reg_trig_end_0                                 ),
        .reg_trig_start_1                               (reg_trig_start_1                               ),
        .reg_trig_end_1                                 (reg_trig_end_1                                 ),
        .reg_trig_start_2                               (reg_trig_start_2                               ),
        .reg_trig_end_2                                 (reg_trig_end_2                                 ),
        .reg_trig_start_3                               (reg_trig_start_3                               ),
        .reg_trig_end_3                                 (reg_trig_end_3                                 ),
        .reg_trig_start_4                               (reg_trig_start_4                               ),
        .reg_trig_end_4                                 (reg_trig_end_4                                 ),
        .reg_trig_start_5                               (reg_trig_start_5                               ),
        .reg_trig_end_5                                 (reg_trig_end_5                                 ),
        .reg_trigger_multi_en                           (reg_trigger_multi_en                           ),
        .reg_trig_out_polar                             (reg_trig_out_polar                             ),

        .reg_camera_trig_num                            (reg_camera_trig_num                            ),
        .reg_external_trig_num                          (reg_external_trig_num                          ),
        .reg_external_trig_polar                        (reg_external_trig_polar                        ),
        .reg_external_trig_delay                        (reg_external_trig_delay                        ),
        .reg_external_trig_width                        (reg_external_trig_width                        ),
        .reg_external_trig_enable                       (reg_external_trig_enable                       ),

        .reg_dds_phase                                  (reg_dds_phase                                  ),
        .reg_dds_inc                                    (reg_dds_inc                                    ),
        .reg_exp_cycle                                  (reg_exp_cycle                                  ),
        .reg_trigger_gap                                (reg_trigger_gap                                ),
        .reg_pic_num                                    (reg_pic_num                                    ),
        .reg_sw_status                                  (reg_sw_status                                  ),
        .reg_sw_shift                                   (reg_sw_shift                                   ),
        .reg_sw_loop_gap                                (reg_sw_loop_gap                                ),
        .reg_sw_loop_num                                (reg_sw_loop_num                                ),
        .reg_dds_phase_offset                           (reg_dds_phase_offset                           ),
        .reg_dds_direction_x                            (reg_dds_direction_x                            ),
        .reg_dds_direction_y                            (reg_dds_direction_y                            ),
        .reg_current_offset                             (reg_current_offset                             ),
        .reg_dac_value_forward                          (reg_dac_value_forward                          ),
        .reg_dac_value_backward                         (reg_dac_value_backward                         ),
        .reg_sw_wait                                    (reg_sw_wait                                    ),
        .reg_camera_delay                               (reg_camera_delay                               ),
        .reg_camera_cycle                               (reg_camera_cycle                               ),
        .reg_dac_req                                    (reg_dac_req                                    ),

        .reg_dac_value_x0                               (reg_dac_value_x0                               ),
        .reg_sw_value_x0                                (reg_sw_value_x0                                ),
        .reg_mos_value_x0                               (reg_mos_value_x0                               ),
        .reg_trigger_req_x0                             (reg_trigger_req_x0                             ),
        .reg_dac_value_x1                               (reg_dac_value_x1                               ),
        .reg_sw_value_x1                                (reg_sw_value_x1                                ),
        .reg_mos_value_x1                               (reg_mos_value_x1                               ),
        .reg_trigger_req_x1                             (reg_trigger_req_x1                             ),
        .reg_dac_value_x2                               (reg_dac_value_x2                               ),
        .reg_sw_value_x2                                (reg_sw_value_x2                                ),
        .reg_mos_value_x2                               (reg_mos_value_x2                               ),
        .reg_trigger_req_x2                             (reg_trigger_req_x2                             ),
        .reg_dac_value_x3                               (reg_dac_value_x3                               ),
        .reg_sw_value_x3                                (reg_sw_value_x3                                ),
        .reg_mos_value_x3                               (reg_mos_value_x3                               ),
        .reg_trigger_req_x3                             (reg_trigger_req_x3                             ),
        .reg_dac_value_y0                               (reg_dac_value_y0                               ),
        .reg_sw_value_y0                                (reg_sw_value_y0                                ),
        .reg_mos_value_y0                               (reg_mos_value_y0                               ),
        .reg_trigger_req_y0                             (reg_trigger_req_y0                             ),
        .reg_dac_value_y1                               (reg_dac_value_y1                               ),
        .reg_sw_value_y1                                (reg_sw_value_y1                                ),
        .reg_mos_value_y1                               (reg_mos_value_y1                               ),
        .reg_trigger_req_y1                             (reg_trigger_req_y1                             ),
        .reg_dac_value_y2                               (reg_dac_value_y2                               ),
        .reg_sw_value_y2                                (reg_sw_value_y2                                ),
        .reg_mos_value_y2                               (reg_mos_value_y2                               ),
        .reg_trigger_req_y2                             (reg_trigger_req_y2                             ),
        .reg_dac_value_y3                               (reg_dac_value_y3                               ),
        .reg_sw_value_y3                                (reg_sw_value_y3                                ),
        .reg_mos_value_y3                               (reg_mos_value_y3                               ),
        .reg_trigger_req_y3                             (reg_trigger_req_y3                             ),

        .reg_core_en                                    (reg_core_en                                    ),
        .reg_core_mode                                  (reg_core_mode                                  ),

        .reg_step_en                                    (reg_step_en                                    ),
        .reg_step_pic_num                               (reg_step_pic_num                               ),
        .reg_step_x_seq                                 (reg_step_x_seq                                 ),
        .reg_step_y_seq                                 (reg_step_y_seq                                 ),
        .reg_step_phase_0                               (reg_step_phase_0                               ),
        .reg_step_phase_1                               (reg_step_phase_1                               ),
        .reg_step_phase_2                               (reg_step_phase_2                               ),
        .reg_step_phase_3                               (reg_step_phase_3                               ),
        .reg_step_phase_4                               (reg_step_phase_4                               ),
        .reg_step_phase_5                               (reg_step_phase_5                               ),
        .reg_step_phase_6                               (reg_step_phase_6                               ),
        .reg_step_phase_7                               (reg_step_phase_7                               ),
        .reg_step_phase_8                               (reg_step_phase_8                               ),
        .reg_step_phase_9                               (reg_step_phase_9                               ),
        .reg_step_phase_10                              (reg_step_phase_10                              ),
        .reg_step_phase_11                              (reg_step_phase_11                              ),
        .reg_step_phase_12                              (reg_step_phase_12                              ),
        .reg_step_phase_13                              (reg_step_phase_13                              ),
        .reg_step_phase_14                              (reg_step_phase_14                              ),
        .reg_step_phase_15                              (reg_step_phase_15                              ),
        .reg_step_phase_16                              (reg_step_phase_16                              ),
        .reg_step_phase_17                              (reg_step_phase_17                              ),
        .reg_step_phase_18                              (reg_step_phase_18                              ),
        .reg_step_phase_19                              (reg_step_phase_19                              ),
        .reg_step_phase_20                              (reg_step_phase_20                              ),
        .reg_step_phase_21                              (reg_step_phase_21                              ),
        .reg_step_phase_22                              (reg_step_phase_22                              ),
        .reg_step_phase_23                              (reg_step_phase_23                              ),
        .reg_step_phase_24                              (reg_step_phase_24                              ),
        .reg_step_phase_25                              (reg_step_phase_25                              ),
        .reg_step_phase_26                              (reg_step_phase_26                              ),
        .reg_step_phase_27                              (reg_step_phase_27                              ),
        .reg_step_phase_28                              (reg_step_phase_28                              ),
        .reg_step_phase_29                              (reg_step_phase_29                              ),
        .reg_step_phase_30                              (reg_step_phase_30                              ),
        .reg_step_phase_31                              (reg_step_phase_31                              ),
        .reg_step_inc_0                                 (reg_step_inc_0                                 ),
        .reg_step_inc_1                                 (reg_step_inc_1                                 ),
        .reg_step_inc_2                                 (reg_step_inc_2                                 ),
        .reg_step_inc_3                                 (reg_step_inc_3                                 ),
        .reg_step_inc_4                                 (reg_step_inc_4                                 ),
        .reg_step_inc_5                                 (reg_step_inc_5                                 ),
        .reg_step_inc_6                                 (reg_step_inc_6                                 ),
        .reg_step_inc_7                                 (reg_step_inc_7                                 ),
        .reg_step_inc_8                                 (reg_step_inc_8                                 ),
        .reg_step_inc_9                                 (reg_step_inc_9                                 ),
        .reg_step_inc_10                                (reg_step_inc_10                                ),
        .reg_step_inc_11                                (reg_step_inc_11                                ),
        .reg_step_inc_12                                (reg_step_inc_12                                ),
        .reg_step_inc_13                                (reg_step_inc_13                                ),
        .reg_step_inc_14                                (reg_step_inc_14                                ),
        .reg_step_inc_15                                (reg_step_inc_15                                ),
        .reg_step_inc_16                                (reg_step_inc_16                                ),
        .reg_step_inc_17                                (reg_step_inc_17                                ),
        .reg_step_inc_18                                (reg_step_inc_18                                ),
        .reg_step_inc_19                                (reg_step_inc_19                                ),
        .reg_step_inc_20                                (reg_step_inc_20                                ),
        .reg_step_inc_21                                (reg_step_inc_21                                ),
        .reg_step_inc_22                                (reg_step_inc_22                                ),
        .reg_step_inc_23                                (reg_step_inc_23                                ),
        .reg_step_inc_24                                (reg_step_inc_24                                ),
        .reg_step_inc_25                                (reg_step_inc_25                                ),
        .reg_step_inc_26                                (reg_step_inc_26                                ),
        .reg_step_inc_27                                (reg_step_inc_27                                ),
        .reg_step_inc_28                                (reg_step_inc_28                                ),
        .reg_step_inc_29                                (reg_step_inc_29                                ),
        .reg_step_inc_30                                (reg_step_inc_30                                ),
        .reg_step_inc_31                                (reg_step_inc_31                                ),

        .reg_step_base_0                                (reg_step_base_0                                ),
        .reg_step_base_1                                (reg_step_base_1                                ),
        .reg_step_base_2                                (reg_step_base_2                                ),
        .reg_step_base_3                                (reg_step_base_3                                ),
        .reg_step_base_4                                (reg_step_base_4                                ),
        .reg_step_base_5                                (reg_step_base_5                                ),
        .reg_step_base_6                                (reg_step_base_6                                ),
        .reg_step_base_7                                (reg_step_base_7                                ),
        .reg_step_base_8                                (reg_step_base_8                                ),
        .reg_step_base_9                                (reg_step_base_9                                ),
        .reg_step_base_10                               (reg_step_base_10                               ),
        .reg_step_base_11                               (reg_step_base_11                               ),
        .reg_step_base_12                               (reg_step_base_12                               ),
        .reg_step_base_13                               (reg_step_base_13                               ),
        .reg_step_base_14                               (reg_step_base_14                               ),
        .reg_step_base_15                               (reg_step_base_15                               ),
        .reg_step_base_16                               (reg_step_base_16                               ),
        .reg_step_base_17                               (reg_step_base_17                               ),
        .reg_step_base_18                               (reg_step_base_18                               ),
        .reg_step_base_19                               (reg_step_base_19                               ),
        .reg_step_base_20                               (reg_step_base_20                               ),
        .reg_step_base_21                               (reg_step_base_21                               ),
        .reg_step_base_22                               (reg_step_base_22                               ),
        .reg_step_base_23                               (reg_step_base_23                               ),
        .reg_step_base_24                               (reg_step_base_24                               ),
        .reg_step_base_25                               (reg_step_base_25                               ),
        .reg_step_base_26                               (reg_step_base_26                               ),
        .reg_step_base_27                               (reg_step_base_27                               ),
        .reg_step_base_28                               (reg_step_base_28                               ),
        .reg_step_base_29                               (reg_step_base_29                               ),
        .reg_step_base_30                               (reg_step_base_30                               ),
        .reg_step_base_31                               (reg_step_base_31                               ),

        .reg_ram_cfg_en                                 (reg_ram_cfg_en                                 ),
        .reg_ram_whrl                                   (reg_ram_whrl                                   ),
        .reg_ram_addr                                   (reg_ram_addr                                   ),
        .reg_ram_wdata                                  (reg_ram_wdata                                  ),
        .reg_ram_rdata                                  (reg_ram_rdata                                  ),
        .reg_ram_req                                    (reg_ram_req                                    ),
        .reg_ram_done                                   (reg_ram_done                                   ),
        .reg_wave_start_addr                            (reg_wave_start_addr                            ),
        .reg_wave_end_addr                              (reg_wave_end_addr                              ),

        .reg_adjust_en                                  (reg_adjust_en                                  ),
        .reg_adjust_gain                                (reg_adjust_gain                                ),
        .reg_adjust_offset                              (reg_adjust_offset                              ),

        .reg_num_check_clr                              (reg_num_check_clr                              ),
        .reg_io_in_0_num                                (reg_io_in_0_num                                ),
        .reg_io_in_1_num                                (reg_io_in_1_num                                ),
        .reg_encoder_a_num                              (reg_encoder_a_num                              ),
        .reg_encoder_b_num                              (reg_encoder_b_num                              ),
        .reg_io_out_num                                 (reg_io_out_num                                 ),
        .reg_mos_req_num                                (reg_mos_req_num                                ),
        .reg_mos_ack_num                                (reg_mos_ack_num                                ),
        .reg_dds_req_num                                (reg_dds_req_num                                ),
        .reg_dds_ack_num                                (reg_dds_ack_num                                ),
        .reg_dac_req_num                                (reg_dac_req_num                                ),
        .reg_dac_ack_num                                (reg_dac_ack_num                                ),
        .reg_sw_req_num                                 (reg_sw_req_num                                 ),
        .reg_sw_ack_num                                 (reg_sw_ack_num                                 ),
        .reg_reg_req_num                                (reg_reg_req_num                                ),
        .reg_reg_ack_num                                (reg_reg_ack_num                                ),
        .reg_sum_err_num                                (reg_sum_err_num                                ),
        .reg_lps                                        (reg_lps                                        ),
        .reg_trigger_miss                               (reg_trigger_miss                               ),
        .reg_rtc_us_h                                   (reg_rtc_us_h                                   ),
        .reg_rtc_us_l                                   (reg_rtc_us_l                                   ),
        .reg_core_status                                (reg_core_status                                ),
        .reg_io_output_en                               (reg_io_output_en                               ),
        .reg_dac_en                                     (reg_dac_en                                     ),

        .reg_frame_trigger_en                           (reg_frame_trigger_en                            ),
        .reg_line_num                                   (reg_line_num                              )
    );








 /*-----------------------CHECK------------------------*/

// num check here

    // Edge get
    reg [3:0]                   io_in_0_dly             ;
    reg [3:0]                   io_in_1_dly             ;
    reg [3:0]                   encoder_a_dly           ;
    reg [3:0]                   encoder_b_dly           ;
    reg [3:0]                   io_out_dly              ;
    reg [3:0]                   mos_req_dly             ;
    reg [3:0]                   mos_ack_dly             ;
    reg [3:0]                   dds_req_dly             ;
    reg [3:0]                   dds_ack_dly             ;
    reg [3:0]                   dac_req_dly             ;
    reg [3:0]                   dac_ack_dly             ;
    reg [3:0]                   sw_req_dly              ;
    reg [3:0]                   sw_ack_dly              ;
    reg [3:0]                   reg_req_dly             ;
    reg [3:0]                   reg_ack_dly             ;
    reg [3:0]                   reg_trigger_in_dly      ;
    reg [3:0]                   trigger_miss_flag_dly   ;

    wire                        trigger_miss_flag_r     ;
    wire                        io_in_0_r               ;
    wire                        io_in_1_r               ;
    wire                        encoder_a_r             ;
    wire                        encoder_b_r             ;
    wire                        io_out_r                ;
    wire                        mos_req_r               ;
    wire                        mos_ack_r               ;
    wire                        dds_req_r               ;
    wire                        dds_ack_r               ;
    wire                        dac_req_r               ;
    wire                        dac_ack_r               ;
    wire                        sw_req_r                ;
    wire                        sw_ack_r                ;
    wire                        reg_req_r               ;
    wire                        reg_ack_r               ;
    wire                        trigger_in_r            ;

    always @ (posedge clk) begin
        io_in_0_dly             <= {io_in_0_dly[2:0],   io_input_0};
        io_in_1_dly             <= {io_in_1_dly[2:0],   io_input_1};
        encoder_a_dly           <= {encoder_a_dly[2:0], encoder_in_a};
        encoder_b_dly           <= {encoder_b_dly[2:0], encoder_in_b};
        io_out_dly              <= {io_out_dly[2:0],    io_output};
        mos_req_dly             <= {mos_req_dly[2:0],   mos_req};
        mos_ack_dly             <= {mos_ack_dly[2:0],   mos_ack};
        dds_req_dly             <= {dds_req_dly[2:0],   dds_req};
        dds_ack_dly             <= {dds_ack_dly[2:0],   dds_ack};
        dac_req_dly             <= {dac_req_dly[2:0],   (dac_req > 0)};
        dac_ack_dly             <= {dac_ack_dly[2:0],   dac_ack};
        sw_req_dly              <= {sw_req_dly[2:0],    (sw_req > 0)};
        sw_ack_dly              <= {sw_ack_dly[2:0],    sw_ack};
        reg_req_dly             <= {reg_req_dly[2:0],   reg_req};
        reg_ack_dly             <= {reg_ack_dly[2:0],   reg_ack};
        reg_trigger_in_dly      <= {reg_trigger_in_dly[2:0],   filtered_trigger};
        trigger_miss_flag_dly   <= {trigger_miss_flag_dly[2:0], trigger_miss_flag};
    end

    assign io_in_0_r            = io_in_0_dly           == 4'b0001;
    assign io_in_1_r            = io_in_1_dly           == 4'b0001;
    assign encoder_a_r          = encoder_a_dly         == 4'b0001;
    assign encoder_b_r          = encoder_b_dly         == 4'b0001;
    assign io_out_r             = io_out_dly            == 4'b0001;
    assign mos_req_r            = mos_req_dly           == 4'b0001;
    assign mos_ack_r            = mos_ack_dly           == 4'b0001;
    assign dds_req_r            = dds_req_dly           == 4'b0001;
    assign dds_ack_r            = dds_ack_dly           == 4'b0001;
    assign dac_req_r            = dac_req_dly           == 4'b0001;
    assign dac_ack_r            = dac_ack_dly           == 4'b0001;
    assign sw_req_r             = sw_req_dly            == 4'b0001;
    assign sw_ack_r             = sw_ack_dly            == 4'b0001;
    assign reg_req_r            = reg_req_dly           == 4'b0001;
    assign reg_ack_r            = reg_ack_dly           == 4'b0001;
    assign trigger_in_r         = reg_trigger_in_dly    == 4'b0001;
    assign trigger_miss_flag_r  = trigger_miss_flag_dly == 4'b0001;

    // Num check register
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            reg_io_in_0_num     <= 'd0;
            reg_io_in_1_num     <= 'd0;
            reg_encoder_a_num   <= 'd0;
            reg_encoder_b_num   <= 'd0;
            reg_io_out_num      <= 'd0;
            reg_mos_req_num     <= 'd0;
            reg_mos_ack_num     <= 'd0;
            reg_dds_req_num     <= 'd0;
            reg_dds_ack_num     <= 'd0;
            reg_dac_req_num     <= 'd0;
            reg_dac_ack_num     <= 'd0;
            reg_sw_req_num      <= 'd0;
            reg_sw_ack_num      <= 'd0;
            reg_reg_req_num     <= 'd0;
            reg_reg_ack_num     <= 'd0;
            reg_trigger_in_num  <= 'd0;
            reg_trigger_miss    <= 'd0;
        end else if (reg_num_check_clr == 1'b1) begin
            reg_io_in_0_num     <= 'd0;
            reg_io_in_1_num     <= 'd0;
            reg_encoder_a_num   <= 'd0;
            reg_encoder_b_num   <= 'd0;
            reg_io_out_num      <= 'd0;
            reg_mos_req_num     <= 'd0;
            reg_mos_ack_num     <= 'd0;
            reg_dds_req_num     <= 'd0;
            reg_dds_ack_num     <= 'd0;
            reg_dac_req_num     <= 'd0;
            reg_dac_ack_num     <= 'd0;
            reg_sw_req_num      <= 'd0;
            reg_sw_ack_num      <= 'd0;
            reg_reg_req_num     <= 'd0;
            reg_reg_ack_num     <= 'd0;
            reg_trigger_in_num  <= 'd0;
            reg_trigger_miss    <= 'd0;
        end else begin
            reg_io_in_0_num     <= reg_io_in_0_num + io_in_0_r;
            reg_io_in_1_num     <= reg_io_in_1_num + io_in_1_r;
            reg_encoder_a_num   <= reg_encoder_a_num + encoder_a_r;
            reg_encoder_b_num   <= reg_encoder_b_num + encoder_b_r;
            reg_io_out_num      <= reg_io_out_num + io_out_r;

            reg_mos_req_num     <= reg_mos_req_num + mos_req_r;
            reg_mos_ack_num     <= reg_mos_ack_num + mos_ack_r;
            reg_dds_req_num     <= reg_dds_req_num + dds_req_r;
            reg_dds_ack_num     <= reg_dds_ack_num + dds_ack_r;
            reg_dac_req_num     <= reg_dac_req_num + dac_req_r;
            reg_dac_ack_num     <= reg_dac_ack_num + dac_ack_r;
            reg_sw_req_num      <= reg_sw_req_num  + sw_req_r;
            reg_sw_ack_num      <= reg_sw_ack_num  + sw_ack_r;
            reg_reg_req_num     <= reg_reg_req_num + reg_req_r;
            reg_reg_ack_num     <= reg_reg_ack_num + reg_ack_r;
            reg_trigger_in_num  <= reg_trigger_in_num + trigger_in_r;
            reg_trigger_miss    <= reg_trigger_miss + trigger_miss_flag_r;
        end
    end



    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_sec <= 32'b0;
        end
        else if(cnt_sec >= 'd125_000_000 - 1'b1)begin
            cnt_sec <= 'd0;
        end
        else begin
            cnt_sec <= cnt_sec + 1'b1;
        end
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cnt_lps <= 'd0;
        end
        else if(cnt_sec >= 'd125_000_000 - 1'b1)begin
            cnt_lps <= 'd0;
        end
        else if(io_out_r == 1'b1)begin
            cnt_lps <= cnt_lps + 1'b1;
        end
        else
            ;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            reg_lps <= 'd0;
        end
        else if(cnt_sec >= 'd125_000_000 - 1'b1)begin
            reg_lps <= cnt_lps;
        end
        else
            ;
    end


// -------------------------< debug >-------------------------

(* mark_debug = "true" *)    reg                                debug_io_input_0                    ;
(* mark_debug = "true" *)    reg                                debug_io_input_1                    ;
(* mark_debug = "true" *)    reg                                debug_encoder_in_a                  ;
(* mark_debug = "true" *)    reg                                debug_encoder_in_b                  ;
(* mark_debug = "true" *)    reg                                debug_io_output                     ;
(* mark_debug = "true" *)    reg                                debug_trigger_slaver                ;
(* mark_debug = "true" *)    reg                                debug_trigger_master                ;

    (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_o0                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_i0                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_o1                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_i1                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_sck_i                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_sck_o                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_cs_n_i                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_cs_n_o                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_spisel                ;
    (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_t0                ;
    // (* mark_debug = "true" *)    reg                                debug_stm32_spi_io_test                ;
    (* mark_debug = "true" *)    reg                                debug_trigger_core_in                ;
    (* mark_debug = "true" *)    reg                                debug_trigger_core                ;


always @ (posedge clk) begin
    debug_io_input_0                     <= io_input_0                    ;
    debug_io_input_1                     <= io_input_1                    ;
    debug_encoder_in_a                   <= encoder_in_a                  ;
    debug_encoder_in_b                   <= encoder_in_b                  ;
    debug_io_output                      <= io_output                     ;
    debug_trigger_slaver                 <= trigger_slaver                ;
    debug_trigger_master                 <= trigger_master                ;
    // debug_stm32_spi_io_o0               <= stm32_spi_io_o[0]               ;
    // debug_stm32_spi_io_i0               <= stm32_spi_io_i[0]               ;
    // debug_stm32_spi_io_o1               <= stm32_spi_io_o[1]               ;
    // debug_stm32_spi_io_i1               <= stm32_spi_io_i[1]               ;
    debug_stm32_spi_sck_i               <= stm32_spi_sck_i                 ;
    debug_stm32_spi_sck_o               <= stm32_spi_sck_o                 ;
    debug_stm32_spi_cs_n_o              <= stm32_spi_cs_n_o                 ;
    debug_stm32_spi_cs_n_i              <= stm32_spi_cs_n_i                 ;
    debug_stm32_spi_spisel              <= stm32_spi_spisel                 ;
    // debug_stm32_spi_io_test             <= stm32_spi_io_test                ;

    debug_trigger_core_in               <= trigger_core_in              ;
    debug_trigger_core                  <= trigger_core;
end



endmodule
