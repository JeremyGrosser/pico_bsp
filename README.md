# Raspberry Pi Pico BSP (Ada)

This repsitory contains build scripts and board definitions for the [Raspberry Pi Pico](https://datasheets.raspberrypi.org/pico/pico-datasheet.pdf).

There are several GNAT runtimes that work with this board. See [The Predefined Profiles](https://docs.adacore.com/gnathie_ug-docs/html/gnathie_ug/gnathie_ug/the_predefined_profiles.html) for an explanation of the differences between these.

    - zfp-cortex-m0p
    - ravenscar-full-rpi-pico-mp
    - ravenscar-full-rpi-pico-sp
    - ravenscar-sfp-rpi-pico-mp
    - ravenscar-sfp-rpi-pico-sp

If you are using a ravenscar profile, the runtime provides it's own linker scripts and startup code. Add `with "pico_bsp_ravenscar.gpr";` to your project file to include this BSP.

If you are using a zfp profile, `with "pico_bsp_zfp.gpr";` will add the startup code to `Source_Dirs`. You will need to pull the linker switches into your project file.

    package Linker is
       for Default_Switches ("Ada") use Pico_BSP.Linker_Switches;
    end Linker;

Example projects for both zfp and ravenscar are available in the [pico_examples](https://github.com/JeremyGrosser/pico_examples) repository.

Development discussion is happening on Gitter: [https://gitter.im/ada-lang/raspberrypi-pico](https://gitter.im/ada-lang/raspberrypi-pico)
