PREFIX		?= arm-none-eabi
GDB		:= $(PREFIX)-gdb
SCRIPT_DIR	:= scripts

ifeq ($(BMP_PORT),)
BMP_PORT_CANDIDATES := $(wildcard \
/dev/serial/by-id/usb-Black_Sphere_Technologies_Black_Magic_Probe_*-if00 \
/dev/cu.usbmodem*1)
ifeq ($(words $(BMP_PORT_CANDIDATES)),1)
BMP_PORT := $(BMP_PORT_CANDIDATES)
else
BMP_PORT = $(error Black Magic Probe gdb serial port not found, please provide the device name via the BMP_PORT variable parameter$(if \
$(BMP_PORT_CANDIDATES), (found $(BMP_PORT_CANDIDATES))))
endif
endif
%.flash: %.elf
	@printf "  BMP $(BMP_PORT) $(*).elf (flash)\n"
	$(Q)$(GDB) -nx --batch \
	           -ex 'target extended-remote $(BMP_PORT)' \
	           -x $(SCRIPT_DIR)/black_magic_probe_flash.scr \
	           $(*).elf
