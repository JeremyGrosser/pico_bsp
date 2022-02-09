--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.PIO.Audio_I2S;
with RP.Device;
with RP.GPIO;

package Pico.Pimoroni.Audio_Pack is

   I2S  : RP.PIO.Audio_I2S.I2S_Device
      (Data        => Pico.GP9'Access,
       BCLK        => Pico.GP10'Access,
       LRCLK       => Pico.GP11'Access,
       PIO         => RP.Device.PIO_0'Access,
       SM          => 0,
       Channels    => 2,
       DMA_Channel => 0,
       Buffer_Size => 32);

   MUTE : RP.GPIO.GPIO_Point := Pico.GP22;

end Pico.Pimoroni.Audio_Pack;
