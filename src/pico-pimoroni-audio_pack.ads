with RP.Device;
with RP.GPIO;
with Pico.Audio_I2S;

package Pico.Pimoroni.Audio_Pack is

   I2S  : Pico.Audio_I2S.I2S_Device
      (Data  => Pico.GP9'Access,
       BCLK  => Pico.GP10'Access,
       LRCLK => Pico.GP11'Access,
       PIO   => RP.Device.PIO_0'Access,
       SM    => 0);

   MUTE : RP.GPIO.GPIO_Point := Pico.GP22;

end Pico.Pimoroni.Audio_Pack;
