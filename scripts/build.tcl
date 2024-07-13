# build settings
set design_name [lindex $argv 0]
set top_module [lindex $argv 1]
set fpga_part [lindex $argv 2]
set hdl_type [lindex $argv 3]

# read files based on type
proc read_files {dir file_type} {
    switch -exact $file_type {
        "v" {
            foreach file [glob "$dir/*.v"] {
                read_verilog $file
            }
        }
        "sv" {
            foreach file [glob "$dir/*.sv"] {
                read_verilog -sv $file
            }
        }
        "vhdl" {
            foreach file [glob "$dir/*.vhd"] {
                read_vhdl $file
            }
        }
        "xdc" {
            foreach file [glob "$dir/*.xdc"] {
                read_xdc $file
            }
        }
        default {
            puts "Unknown file type: $file_type"
            exit 1
        }
    }
}

# read design sources
read_files "rtl" $hdl_type

# read simulation sources
read_files "tb" $hdl_type

# read constraints
read_files "constraints" "xdc"

# synthesis
synth_design -top "${top_module}" -part "${fpga_part}"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "build/${design_name}.bit"
