# fpga-dev-vscode

Simple FPGA development workflow with VS Code.

The goal of this workflow is to avoid opening Vivado GUI.
The example in this repo is a simple 1Hz LED blink using Basys 3 Artix-7 board (XC7A35TCPG236-1).

## Development

This assumes Windows with WSL is used for FPGA development, it is required to use GTKWave.

### Requirements

- WSL
- Vivado 2024.1+
- GTKWave

Verify Vivado is installed and its binaries (`xilinx/Vivado/2024.1/bin`) are in system path with `vivado -version`.
Also, verify GTKWave is installed on WSL with `wsl -e gtkwave --version`.

### Workflow

```sh
# build bitstream file
./vivado.ps1 build

# simulate specific module testbench and generate waveform
$env:SIM_MODULE='blink'; ./vivado.ps1 simulate

# open waveform in gtkwave via WSL
wsl -e gtkwave build/blink_tb.vcd

# build and upload bitstream to FPGA
make program_board
./vivado.ps1 program_board
```

Optionally, you can still develop in project mode with the following:

```sh
# create Vivado project
./vivado.ps1 create_project

# open Vivado project in GUI
./vivado.ps1 gui
```

## References

- [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- [Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
- https://projectf.io/posts/vivado-tcl-build-script/
