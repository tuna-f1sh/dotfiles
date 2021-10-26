"""
Utilities for dumping STM32 peripheral registers with tab-completion
Based on a script by vampi-the-frog

Dependencies:
    pip install -U cmsis-svd

Usage (inside gdb):

    (gdb) source /path/to/svd-dump.py
    (gdb) svd_load STMicro STM32F103xx.svd

    # Show an entire peripheral
    (gdb) svd_show USART2
    USART2 @ 0x40004400
    SR   CTS=0 LBD=0 TXE=1 TC=1 RXNE=0 IDLE=0 ORE=0 NE=0 FE=0 PE=0
    DR   DR=0
    BRR  DIV_Mantissa=19 DIV_Fraction=8
    CR1  UE=1 M=0 WAKE=0 PCE=0 PS=0 PEIE=0 TXEIE=0 TCIE=0 RXNEIE=0 IDLEIE=0 TE=1 RE=1 RWU=0 SBK=0
    CR2  LINEN=0 STOP=0 CLKEN=0 CPOL=0 CPHA=0 LBCL=0 LBDIE=0 LBDL=0 ADD=0
    CR3  CTSIE=0 CTSE=0 RTSE=0 DMAT=0 DMAR=0 SCEN=0 NACK=0 HDSEL=0 IRLP=0 IREN=0 EIE=0
    GTPR GT=0 PSC=0

    # Show just one register
    (gdb) svd_show USART2 BRR
    BRR DIV_Mantissa=19 DIV_Fraction=8

    # Show field values in hex
    (gdb) svd_show/x USART2 BRR
    BRR DIV_Mantissa=013 DIV_Fraction=8

    # Show field values in binary
    (gdb) svd_show/b USART2 BRR
    BRR DIV_Mantissa=000000010011 DIV_Fraction=1000

    # Show whole register value in binary
    (gdb) svd_show/i USART2 BRR
    BRR 00000000000000000000000100111000 DIV_Mantissa=19 DIV_Fraction=8

    # Show register offsets
    (gdb) svd_show/f USART2
    USART2 @ 0x40004400
    SR   0x0000 CTS=0 LBD=0 TXE=1 TC=1 RXNE=0 IDLE=0 ORE=0 NE=0 FE=0 PE=0
    DR   0x0004 DR=0
    BRR  0x0008 DIV_Mantissa=19 DIV_Fraction=8
    CR1  0x000c UE=1 M=0 WAKE=0 PCE=0 PS=0 PEIE=0 TXEIE=0 TCIE=0 RXNEIE=0 IDLEIE=0 TE=1 RE=1 RWU=0 SBK=0
    CR2  0x0010 LINEN=0 STOP=0 CLKEN=0 CPOL=0 CPHA=0 LBCL=0 LBDIE=0 LBDL=0 ADD=0
    CR3  0x0014 CTSIE=0 CTSE=0 RTSE=0 DMAT=0 DMAR=0 SCEN=0 NACK=0 HDSEL=0 IRLP=0 IREN=0 EIE=0
    GTPR 0x0018 GT=0 PSC=0

    # Loading from an external SVD file
    (gdb) svd_load_file /path/to/your_file.svd

Customization:
To turn on colorizing non-zero values, set colorize = True
(doesn't work in TUI mode)
"""

import gdb
import struct
from cmsis_svd.parser import SVDParser
import pkg_resources

class SVDSelector(gdb.Command):
    def __init__(self):
        super(SVDSelector, self).__init__("svd_load", gdb.COMMAND_USER)
        vendor_names = pkg_resources.resource_listdir("cmsis_svd", "data")
        self.vendors = {}
        for vendor in vendor_names:
            fnames = pkg_resources.resource_listdir("cmsis_svd", "data/%s" % vendor)
            self.vendors[vendor] = [fname for fname in fnames if fname.lower().endswith(".svd")]

    def complete(self, text, word):
        args = gdb.string_to_argv(text)
        num_args = len(args)
        if text.endswith(" "):
            num_args += 1
        if not text:
            num_args = 1

        # "svd_load <tab>" or "svd_load ST<tab>"
        if num_args == 1:
            prefix = word.lower()
            return [vendor for vendor in self.vendors if vendor.lower().startswith(prefix)]
        # "svd_load STMicro<tab>" or "svd_load STMicro STM32F1<tab>"
        elif num_args == 2 and args[0] in self.vendors:
            prefix = word.lower()
            filenames = self.vendors[args[0]]
            return [fname for fname in filenames if fname.lower().startswith(prefix)]
        return gdb.COMPLETE_NONE

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if len(args) >= 1:
            if args[0] not in self.vendors:
                raise gdb.GdbError("Invalid vendor name")
                return
            vendor_name = args[0]
            vendor_filenames = self.vendors[vendor_name]
            if len(args) == 1:
                raise gdb.GdbError("Usage: svd_load <vendor-name> <filename.svd>")
            elif len(args) >= 2:
                filename = args[1]
                try:
                    parser = SVDParser.for_packaged_svd(vendor_name, filename)
                    _svd_printer.set_device(parser.get_device())
                except IOError:
                    raise gdb.GdbError("Failed to load SVD file")
                else:
                    print("Loaded {}/{}".format(vendor_name, filename))

                    for peripheral in _svd_printer.device.peripherals:
                        print("%s @ 0x%08x" % (peripheral.name, peripheral.base_address))

        else:
            raise gdb.GdbError("Usage: svd_load <vendor-name> <filename.svd>")

class SVDLoader(gdb.Command):
    def __init__(self):
        super(SVDLoader, self).__init__("svd_load_file", gdb.COMMAND_USER)

    def complete(self, text, word):
        return gdb.COMPLETE_FILENAME

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if len(args) != 1:
            raise gdb.GdbError("Usage: svd_load_file <filename.svd>")

        path = args[0]
        try:
            parser = SVDParser.for_xml_file(path)
            _svd_printer.set_device(parser.get_device())

        except IOError:
            raise gdb.GdbError("Failed to load SVD file")
        else:
            print("Loaded {}".format(path))

            for peripheral in _svd_printer.device.peripherals:
                print("%s @ 0x%08x" % (peripheral.name, peripheral.base_address))

class SVDPrinter(gdb.Command):
    colorize = False
    def __init__ (self, device=None):
        super (SVDPrinter, self).__init__ ("svd_show", gdb.COMMAND_USER)
        self.device = device
        if device:
            self.peripherals = dict((peripheral.name,peripheral) for peripheral in self.device.peripherals)
        else:
            self.periphrals = {}

    def set_device(self, device):
        self.device = device
        self.peripherals = dict((peripheral.name,peripheral) for peripheral in self.device.peripherals)
        
    def complete(self, text, word):
        if not self.device:
            return gdb.COMPLETE_NONE
        args = gdb.string_to_argv(text)

        # Skip over the /x in "svd_show/x"
        if text.startswith("/"):
            options = args[0][1:]
            args = args[1:]
            if text.startswith("/"+options):
                text = text[1+len(options):]
            if word.startswith(options):
                word = ""

        num_args = len(args)
        if text.endswith(" "):
            num_args += 1
        if not text:
            num_args = 1

        if num_args == 1:
            peripheral_names = [peripheral.name.upper() for peripheral in self.device.peripherals]
            if word:
                prefix = word.upper()
                return [name for name in peripheral_names if name.startswith(prefix)]
            else:
                return peripheral_names
        elif num_args == 2 and args[0].upper() in self.peripherals:
            periph_name = args[0].upper()
            periph = self.peripherals[periph_name]
            register_names = [register.name for register in periph.registers]
            if word:
                prefix = word.upper()
                return [name for name in register_names if name.upper().startswith(prefix)]
            return register_names
        return gdb.COMPLETE_NONE

    def dump_register(self, peripheral, register, name_width=0, options=""):
        if not name_width:
            name_width = len(register.name)
        val = struct.unpack("<L", gdb.inferiors()[0].read_memory(peripheral.base_address + register.address_offset, 4))[0];
        reg_fmt = "{name:<{width}s}"
        if "f" in options:
            reg_fmt += " 0x{offset:04x}"
        if "i" in options:
            reg_fmt += " {value:032b}"
        elif "h" in options:
            reg_fmt += " {value:08x}"
        print(reg_fmt.format(name=register.name,
                             offset=register.address_offset,
                             value=val,
                             width=name_width)),
        if "x" in options:
            field_fmt = "{name}={value:0{hex_width}x}"
            active_field_fmt = "\033[32m{name}={value:0{hex_width}x}\033[0m"
        elif "b" in options:
            field_fmt = "{name}={value:0{bit_width}b}"
            active_field_fmt = "\033[32m{name}={value:0{bit_width}b}\033[0m"
        else:
            field_fmt = "{name}={value:d}"
            active_field_fmt = "\033[32m{name}={value:d}\033[0m"
        for field in register.fields:
            fieldval = (val >> field.bit_offset) & ((1 << field.bit_width) - 1)
            hex_width = (field.bit_width + 3) // 4
            if self.colorize and fieldval > 0:
                fmt = active_field_fmt
            else:
                fmt = field_fmt
            
            print(fmt.format(name=field.name,
                             value=fieldval,
                             bit_width=field.bit_width,
                             hex_width=hex_width)),
        print
    def invoke (self, arg, from_tty):
        try:
            if not self.device:
                raise gdb.GdbError("Use svd_load to load an SVD file first")
                return

            args = gdb.string_to_argv(arg)

            # Extract formatting options
            options = ""
            if args and args[0].startswith("/"):
                options = args[0]
                args = args[1:]

            if len(args) >= 1:
                if args[0] not in self.peripherals:
                    raise gdb.GdbError("Invalid peripheral name")
                    return
                peripheral = self.peripherals[args[0]]
                if len(args) == 1:
                    print("%s @ 0x%08x" % (peripheral.name, peripheral.base_address))
                    if peripheral.registers:
                        width = max(len(reg.name) for reg in peripheral.registers) 
                        for register in peripheral.registers:
                            self.dump_register(peripheral, register, width, options)
                elif len(args) == 2:
                    for register in peripheral.registers:
                        if register.name == args[1]:
                            self.dump_register(peripheral, register, 0, options)
                            break
                    else:
                        raise gdb.GdbError("Invalid register name")
            else:
                raise gdb.GdbError("Usage: svd_show[/[x|b]fi] peripheral-name [register-name]")
        except KeyboardInterrupt:
            pass

SVDSelector()
SVDLoader()
_svd_printer = SVDPrinter()
