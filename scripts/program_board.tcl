# program board using bitstream created during build script

set bitstream_file [lindex $argv 0]

open_hw_manager
connect_hw_server
current_hw_target
open_hw_target

set_property PROGRAM.FILE "${bitstream_file}" [current_hw_device]

program_hw_devices [current_hw_device]
