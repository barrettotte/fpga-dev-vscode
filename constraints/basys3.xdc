# XDC constraints for Basys 3 Artix-7 board
# Modified from https://github.com/Digilent/digilent-xdc/blob/master/Basys-3-Master.xdc

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## Clock
set_property PACKAGE_PIN W5      [get_ports i_clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk_100MHz]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0.0 5.0} [get_ports {i_clk_100MHz}]

# Buttons
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports {i_clr}]

## LEDs
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {o_clk_1Hz}]
