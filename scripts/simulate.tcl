# Run simulation

# get system args
set design_name [lindex $argv 0]
set top_module [lindex $argv 1]
set fpga_part [lindex $argv 2]
set hdl_type [lindex $argv 3]
set sim_time [lindex $argv 4]

# import utils
source [file normalize "scripts/utils.tcl"]

set top_tb "${top_module}_tb"
set sim_dir "build/sim/sim-${top_module}"
set sim_fileset sim_1
set src_fileset sources_1

# setup simulation project
create_project -in_memory -part $fpga_part

switch -exact $hdl_type {
    "v" {
        set hdl_language Verilog
    }
    "sv" {
        set hdl_language SystemVerilog
    }
    "vhdl" {
        set hdl_language VHDL
    }
}
set_property target_language $hdl_language [current_project]
set_property default_lib work [current_project]

# add fileset contents
add_files -fileset $src_fileset [glob "rtl/*.${hdl_type}"]
add_files -fileset $sim_fileset [glob "tb/*.${hdl_type}"]

# setup simulation
save_project_as $sim_dir -force
set_property top $top_tb [get_fileset $sim_fileset]
set_property target_simulator "XSim" [current_project]

# simulate
launch_simulation -simset $sim_fileset -mode behavioral

# waveform
set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
  if { [llength [get_objects]] > 0} {
    add_wave /
    set_property needs_save false [current_wave_config]
  } else {
     send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
  }
}
run $sim_time

# copy over waveform
set waveform_file [file normalize "$sim_dir.sim/$sim_fileset/behav/xsim/$top_tb.vcd"]
set copy_to [file normalize "build/$top_tb.vcd"]
file copy -force $waveform_file $copy_to
puts "Exported waveform to $copy_to"
