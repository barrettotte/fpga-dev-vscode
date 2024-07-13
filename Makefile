BUILD_DIR := build
SCRIPT_DIR := vivado

VIVADO := $(shell which vivado)
VIVADO_BIN := $(shell dirname $(VIVADO))
VIVADO_ROOT := $(shell (dirname $(VIVADO_BIN)))
VIVADO_SETTINGS := $(VIVADO_ROOT)/settings64.bat

.PHONY:	build

all: build

create_project:	init_env
	vivado -mode batch -nojournal -log build/logs/vivado-create.log -source $(SCRIPT_DIR)/create_project.tcl

build:	init_env
	vivado -mode batch -nojournal -log build/logs/vivado-build.log -source $(SCRIPT_DIR)/build.tcl

program_board:	build
	vivado -mode batch -nojournal -log build/logs/vivado-program.log -source $(SCRIPT_DIR)/program_board.tcl

clean:
	rm -rf $(BUILD_DIR)/*

init_env:
	@mkdir -p $(BUILD_DIR)/logs
	$(VIVADO_SETTINGS)
