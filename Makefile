# Vivado automation

# Repo paths
BUILD_DIR := build
LOGS_DIR := $(BUILD_DIR)/logs
PROJECT_DIR := project
SCRIPT_DIR := scripts

# Vivado paths
VIVADO := $(shell which vivado)
VIVADO_BIN := $(shell dirname $(VIVADO))
VIVADO_ROOT := $(shell (dirname $(VIVADO_BIN)))
VIVADO_SETTINGS := $(VIVADO_ROOT)/settings64.bat

# TCL args
FPGA_PART := xc7a35tcpg236-1
DESIGN_NAME := blink
TOP_MODULE := blink
SIM_MODULE := "$(TOP_MODULE)"
HDL_TYPE := v

all: build

build:	init_env
	vivado -mode batch -nojournal -log $(LOGS_DIR)/build.log \
	  -source $(SCRIPT_DIR)/build.tcl \
	  -tclargs $(DESIGN_NAME) $(TOP_MODULE) $(FPGA_PART) $(HDL_TYPE)

program_board:	build
	vivado -mode batch -nojournal -log $(LOGS_DIR)/program.log \
	  -source $(SCRIPT_DIR)/program_board.tcl \
	  -tclargs $(BUILD_DIR)/$(DESIGN_NAME).bit

create_project:	init_env
	vivado -mode batch -nojournal -log $(LOGS_DIR)/create-project.log \
	  -source $(SCRIPT_DIR)/create_project.tcl \
	  -tclargs $(DESIGN_NAME) $(TOP_MODULE) $(FPGA_PART) $(HDL_TYPE)

simulate:	init_env
	vivado -mode batch -nojournal -log $(LOGS_DIR)/simulate.log \
		-source $(SCRIPT_DIR)/simulate.tcl \
		-tclargs $(DESIGN_NAME) $(SIM_MODULE) $(FPGA_PART) $(HDL_TYPE)

gui: init_env
	vivado -mode batch -nojournal -log $(LOGS_DIR)/gui.log \
	  -source $(SCRIPT_DIR)/gui.tcl \
	  -tclargs $(DESIGN_NAME)

clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf $(PROJECT_DIR)/*
	rm -rf ./.Xil/*
	rm -rf ./*.jou
	rm -rf ./*.log
	rm -rf ./*vivado*.str
	rm -rf ./clockInfo.txt

init_env:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(LOGS_DIR)
	@mkdir -p $(PROJECT_DIR)
	$(VIVADO_SETTINGS)
