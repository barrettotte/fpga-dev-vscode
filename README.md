# fpga-dev-vscode

Simple FPGA development workflow with VS Code.

The goal of this workflow is to avoid opening Vivado GUI.
The example in this repo is a simple 1Hz LED blink using Basys 3 Artix-7 board (XC7A35TCPG236-1).

## Development

I am currently using Windows for FPGA development. 
But, I'm assuming I'll make the switch to Linux at some point and I'll update my notes accordingly.

### Requirements

- Vivado 2023.2+
- GNU Make

Verify Vivado is installed and its binaries (`xilinx/Vivado/2023.2/bin`) are in system path with `vivado -version`.
Also, verify GNU Make is installed with `make -v`.

### Workflow

Edit source in VS Code, the [vscode-verilog-hdl-support](https://github.com/mshr-h/vscode-verilog-hdl-support) extension seems to work well for Verilog and Tcl.

```sh
# build bitstream file
make build

# build and upload bitstream to FPGA
make program_board

# create Vivado project
make create_project

# open Vivado project in GUI
make gui
```

## Vivado in Docker

I decided to stick with a local installation of Vivado. But, I found a
very cool post about running Vivado in Docker - https://myon.info/blog/2024/07/06/vivado-docker/

My attempt based on this post can be found in [misc/vivado-docker/](misc/vivado-docker/).

I may try this again in the future and update this repo with more notes/instructions.

## References

- [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- [Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
- https://projectf.io/posts/vivado-tcl-build-script/
