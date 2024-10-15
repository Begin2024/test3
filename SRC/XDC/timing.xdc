# set_false_path -from [get_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins design_1_inst/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]
# set_false_path -from [get_clocks -of_objects [get_pins design_1_inst/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]]
# set_clock_groups -name async_clk0_clk1 -asynchronous -group [get_clocks -include_generated_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks -include_generated_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]]
create_clock -period 10.000 [get_ports sys_clk]
set_input_jitter [get_clocks -of_objects [get_ports sys_clk]] 0.100

set_false_path -from [get_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins design_1_inst/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins design_1_inst/clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins clock_manage_inst/clk_wiz_0_inst/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_pins {reg_fpga_inst/reg_soft_reset_reg[0]/C}] -to [get_pins design_1_inst/axi_epc_0/U0/EPC_CORE_I/IPIC_DECODE_I/SYNC_REQ_GEN.SYNC_REQ_PRH_CLK_GEN.REG_SYNC_REQ/R]




set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]
# set_property BITSTREAM.CONFIG.NEXT_CONFIG_ADDR 32'h00800000 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]
set_property BITSTREAM.CONFIG.TIMER_CFG 32'h00010000 [current_design]

