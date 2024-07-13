# build settings
set design_name "blink"
set top_module "blink"
set fpga_part "xc7a35tcpg236-1"

# read design sources
read_verilog "rtl/${top_module}.v"

# read simulation sources
read_verilog "tb/${top_module}_tb.v"

# read constraints
read_xdc "constraints/basys3.xdc"

# synthesis
synth_design -top "${top_module}" -part "${fpga_part}"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "build/${design_name}.bit"
