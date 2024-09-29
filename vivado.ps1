# Vivado automation

# TCL args
$design_name = 'blink'
$fpga_part = 'xc7a35tcpg236-1'
$top_module = 'blink'

# module to simulate (assumes testbench has _tb suffix)
$sim_module = if ($env:SIM_MODULE) {$env:SIM_MODULE} else {$top_module}

# v=Verilog, sv=SystemVerilog, vhdl=VHDL
$hdl_type = 'v'

########################################
# should not have to edit past here
########################################

$ErrorActionPreference = 'Stop'

# create directory at path if not exists
function Add-Dir {
    param ([string]$p)
    if (-Not (Test-Path $p)) {
        New-Item -ItemType Directory -Path $p | Out-Null
    }
}

# run vivado in batch mode with given args
function Invoke-Vivado {
    param ([string]$task, [string]$tcl_args)

    # load vivado settings into shell instance
    & $vivado_settings

    # launch vivado in batch mode and run TCL script
    $tcl_script = (Join-Path $script_dir "$task.tcl")
    $log_path = Join-Path $logs_dir "$task.log"
    $cmd = "vivado -mode batch -nojournal -log $log_path -source $tcl_script -tclargs $tcl_args"
    Write-Host "Running command: $cmd"
    Invoke-Expression $cmd
}

########################################
# main script
########################################

# validate HDL type
$valid_hdl = @('v', 'sv', 'vhdl')
if (-Not ($valid_hdl -contains $hdl_type)) {
    Write-Host "Error: HDL_TYPE must be 'v', 'sv', or 'vhdl'."
    exit 1
}

# repo paths
$build_dir = 'build'
$logs_dir = Join-Path $build_dir 'logs'
$project_dir = 'project'
$script_dir = 'scripts'

# create directories if not exist
Add-Dir $build_dir
Add-Dir $logs_dir
Add-Dir $project_dir

# vivado paths
$vivado = Get-Command vivado | Select-Object -ExpandProperty Source
$vivado_bin = Split-Path $vivado -Parent
$vivado_root = Split-Path $vivado_bin -Parent
$vivado_settings = Join-Path $vivado_root 'settings64.bat'

# execute task
$task = if ($args.Count -gt 0) {$args[0]} else {'build'}
Write-Host "Running task '$task'..."

switch ($task) {
    'clean' {
        Remove-Item -Path (Join-Path $build_dir '*') -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path (Join-Path $project_dir '*') -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path './.Xil/*' -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path './*.jou' -Force -ErrorAction SilentlyContinue
        Remove-Item -Path './*.log' -Force -ErrorAction SilentlyContinue
        Remove-Item -Path './*vivado*.str' -Force -ErrorAction SilentlyContinue
        Remove-Item -Path './clockInfo.txt' -Force -ErrorAction SilentlyContinue
        exit
    }
    'build' {
        $tcl_args = $design_name, $top_module, $fpga_part, $hdl_type
    }
    'program_board' {
        $tcl_args = (Join-Path $build_dir "$design_name.bit")
    }
    'create_project' {
        $tcl_args = $design_name, $top_module, $fpga_part, $hdl_type
    }
    'simulate' {
        $tcl_args = $design_name, $sim_module, $fpga_part, $hdl_type
    }
    'gui' {
        $tcl_args = $design_name
    }
    Default {
        Write-Host "Error: Unknown task '$task'"
        exit 2
    }
}

# run TCL script for vivado
Invoke-Vivado $task $tcl_args
Write-Host 'Done.'
