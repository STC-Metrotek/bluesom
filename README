Name
----

  CB-CV-SOM FPGA default project

Synopsys
--------

  Simple almost blank FPGA project for CV-CE-SOM (aka BlueSoM)
  board.

Description
-----------

  This project makes avaible to turn cb-cv-som board orange LED
  on flicking with given period. Duty cycle = 50%

  The register to control period:
     * CPU address : 0xC000_1000
     * 32-bit register, but only lower 16 bit are accessible;
       writing at higher 16 bit has no effect.
     * One ?? of the registers value corresponding to a millisecond. // fix me plz
     * Minimum value 0x20 (protected)

  All memory mapped items in FPGA (Base bus address/end bus address):
     * System ID Peripheral (the ID is 0x01000001) (0xC000_0000/0xC000_0007)
     * Avalon-MM interface (named "fpga_regs")     (0xC000_1000/0xC000_13ff)
     * On-Chip-Memory (4KB)                        (0xC000_2000/0xC000_2fff)

  Learn more about this system via qsys.

  If orange LED doesn't work, make sure you use the appropriate preloader binary.

Build
-----

  Use Altera Quartus-14.1 (build on other versions not tested)
  Launch it, open top.qpf and push "start compilation".

  Your .sof, .rbf will be ready in output_files/

  Build preloader:

    ! This stage shall be done only after fpga firmware building complete !

    cd hps_isw_handoff

    <your quartus path>/embedded/embedded_command_shell.sh

    bsp-create-settings --type spl --bsp-dir build --preloader-settings-dir soc_hps_0 --settings build/settings.bsp

    make -C build

Copyright
---------

  STC Metrotek, 2016

See also/references
-------------------

Date
----

  11/07/2016

Authors
-------

  Dmitry Hodyrev d.hodyrev@metrotek.spb.ru






