# Raspberry Pi Pico BSP (Ada)

This repsitory contains build scripts and board definitions for the [Raspberry Pi Pico](https://datasheets.raspberrypi.org/pico/pico-datasheet.pdf).

## Getting started

To use this BSP, add `with "pico_bsp.gpr";` to your project. You will also need to set the linker switches and runtime in your project file.

    with "pico_bsp.gpr";

    project My_Project is

        for Runtime ("Ada") use "zfp-cortex-m0p";
        for Target use "arm-eabi";
        for Main use ("main.adb");
        for Languages use ("Ada");
        for Source_Dirs use ("src");
        for Object_Dir use "obj";
        for Create_Missing_Dirs use "True";

        package Linker is
           for Default_Switches ("Ada") use Pico_BSP.Linker_Switches;
        end Linker;

    end My_Project;

See [pico_examples](https://github.com/JeremyGrosser/pico_examples) for working example projects.

## Ravenscar support

This project can only be built using the `zfp-cortex-m0p` runtime. A [Ravenscar runtime](https://github.com/damaki/bb-runtimes/tree/rpi-pico) is available, but the linker scripts and startup code conflict with those provided here. To avoid this collision, projects not using a ZFP runtime should depend on [pico_bsp_noboot.gpr](pico_bsp_noboot.gpr).

## Community

Development discussion is happening on Gitter: [https://gitter.im/ada-lang/raspberrypi-pico](https://gitter.im/ada-lang/raspberrypi-pico)
