with RP.PIO; use RP.PIO;
with RP.GPIO;

with Interfaces;
with HAL.Audio;
with HAL;

package Pico.Audio_I2S is

   --  There is only one LRCLK signal, so any more than two channels will need
   --  some external multiplexing logic.
   subtype Channel_Count is Positive range 1 .. 2;

   type I2S_Device
      (Data     : not null access RP.GPIO.GPIO_Point;
       BCLK     : not null access RP.GPIO.GPIO_Point;
       LRCLK    : not null access RP.GPIO.GPIO_Point;
       PIO      : not null access PIO_Device;
       SM       : PIO_SM;
       Channels : Channel_Count)
   is limited new HAL.Audio.Audio_Stream with private;

   procedure Initialize
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency;
       Channels  : Channel_Count := 1);

   overriding
   procedure Set_Frequency
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency);

   overriding
   procedure Transmit
      (This : in out I2S_Device;
       Data : HAL.Audio.Audio_Buffer)
   with Pre => Data'Length mod This.Channels = 0;

   --  The PIO program currently does not support I2S receive. This function
   --  will block on RX FIFO forever.
   overriding
   procedure Receive
      (This : in out I2S_Device;
       Data : out HAL.Audio.Audio_Buffer);

private

   --  Init copied from audio_i2s.pio and translated to Ada
   procedure Program_Init
      (This   : in out I2S_Device;
       Offset : PIO_Address);

   function Twos_Complement
      (I : Interfaces.Integer_16)
      return HAL.UInt16;

   type I2S_Device
      (Data     : not null access RP.GPIO.GPIO_Point;
       BCLK     : not null access RP.GPIO.GPIO_Point;
       LRCLK    : not null access RP.GPIO.GPIO_Point;
       PIO      : not null access PIO_Device;
       SM       : PIO_SM;
       Channels : Channel_Count)
   is limited new HAL.Audio.Audio_Stream with record
      Config   : PIO_SM_Config;
   end record;

end Pico.Audio_I2S;
