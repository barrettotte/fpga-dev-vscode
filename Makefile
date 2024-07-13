BUILD_DIR := build
PROJECT_DIR := project
SCRIPT_DIR := scripts

VIVADO := $(shell which vivado)
VIVADO_BIN := $(shell dirname $(VIVADO))
VIVADO_ROOT := $(shell (dirname $(VIVADO_BIN)))
VIVADO_SETTINGS := $(VIVADO_ROOT)/settings64.bat

FPGA_PART := "xc7a35tcpg236-1"
DESIGN_NAME := "blink"
TOP_MODULE := "blink"
HDL_TYPE := "v"

.PHONY:	build

all: build

build:	init_env
	vivado -mode batch -nojournal -log build/logs/vivado-build.log \
	  -source $(SCRIPT_DIR)/build.tcl \
	  -tclargs $(DESIGN_NAME) $(TOP_MODULE) $(FPGA_PART) $(HDL_TYPE)

program_board:	build
	vivado -mode batch -nojournal -log build/logs/vivado-program.log \
	  -source $(SCRIPT_DIR)/program_board.tcl \
	  -tclargs $(BUILD_DIR)/$(DESIGN_NAME).bit

clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf .Xil/*
	rm -rf $(PROJECT_DIR)/*

create_project:	init_env
	vivado -mode batch -nojournal -log build/logs/vivado-create.log \
	  -source $(SCRIPT_DIR)/create_project.tcl \
	  -tclargs $(DESIGN_NAME) $(TOP_MODULE) $(FPGA_PART) $(HDL_TYPE)

gui: init_env
	vivado -mode batch -nojournal -log build/logs/vivado-project.log \
	  -source $(SCRIPT_DIR)/gui.tcl \
	  -tclargs $(DESIGN_NAME)

init_env:
	@mkdir -p $(BUILD_DIR)/logs
	@mkdir -p $(PROJECT_DIR)
	$(VIVADO_SETTINGS)
