with HAL; use HAL;
with RP;  use RP;
with System;

package Pico.Pimoroni.Audio_Pack is

   Sample_Bits : constant := 16;
   Sample_Rate : constant Hertz := 44_100;

   type Sample is new Integer range -2 ** (Sample_Bits - 1) .. 2 ** (Sample_Bits - 1) - 1
      with Size => Sample_Bits;

   type Sample_Array is array (Integer range <>) of Sample;

   procedure Initialize;
   --  This will configure the required peripherals and pins for the RGB Keypad:
   --   - SPI1
   --   - GP9  I2S Data
   --   - GP10 I2S BCK
   --   - GP11 I2S LRCK
   --   - GP22 MUTE

   procedure Write
      (Samples : Sample_Array);

end Pico.Pimoroni.Audio_Pack;
