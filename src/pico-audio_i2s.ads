with RP.PIO; use RP.PIO;
with RP.GPIO;

with HAL.Audio;

package Pico.Audio_I2S is

   type I2S_Device
      (Data  : not null access RP.GPIO.GPIO_Point;
       BCLK  : not null access RP.GPIO.GPIO_Point;
       LRCLK : not null access RP.GPIO.GPIO_Point;
       PIO   : not null access PIO_Device;
       SM    : PIO_SM)
   is limited new HAL.Audio.Audio_Stream with private;

   procedure Initialize
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency);

   overriding
   procedure Set_Frequency
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency);

   overriding
   procedure Transmit
      (This : in out I2S_Device;
       Data : HAL.Audio.Audio_Buffer);

   overriding
   procedure Receive
      (This : in out I2S_Device;
       Data : out HAL.Audio.Audio_Buffer);

private

   --  Init copied from audio_i2s.pio and translated to Ada
   procedure Program_Init
      (This   : in out I2S_Device;
       Offset : PIO_Address);

   type I2S_Device
      (Data  : not null access RP.GPIO.GPIO_Point;
       BCLK  : not null access RP.GPIO.GPIO_Point;
       LRCLK : not null access RP.GPIO.GPIO_Point;
       PIO   : not null access PIO_Device;
       SM    : PIO_SM)
   is limited new HAL.Audio.Audio_Stream with record
      Config : PIO_SM_Config;
   end record;

end Pico.Audio_I2S;
