# Raspberry Pi Pico BSP (Ada)

This repsitory contains build scripts and board definitions for the [Raspberry Pi Pico](https://datasheets.raspberrypi.org/pico/pico-datasheet.pdf).

Currently, this project can only be built using the zfp-cortex-m0p runtime. A Ravenscar runtime is available, but the linker scripts and startup code conflict with those provided here. See [damaki's bb-runtimes](https://github.com/damaki/bb-runtimes/tree/rpi-pico) for more info.

To use this BSP, add `with "pico_bsp.gpr";` to your project. You will also need to pull the linker switches into your project file.

    package Linker is
       for Default_Switches ("Ada") use Pico_BSP.Linker_Switches;
    end Linker;

Example projects for are available in the [pico_examples](https://github.com/JeremyGrosser/pico_examples) repository.

Development discussion is happening on Gitter: [https://gitter.im/ada-lang/raspberrypi-pico](https://gitter.im/ada-lang/raspberrypi-pico)
