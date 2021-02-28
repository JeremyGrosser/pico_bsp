with RP.Device;
with RP.PIO;

with Audio_I2S;

package body Pico.Pimoroni.Audio_Pack is
   I2S_DATA : RP.GPIO.GPIO_Point renames Pico.GP9;
   I2S_BCK  : RP.GPIO.GPIO_Point renames Pico.GP10;
   I2S_LRCK : RP.GPIO.GPIO_Point renames Pico.GP11;
   MUTE     : RP.GPIO.GPIO_Point renames Pico.GP22;

   procedure Initialize is
   begin
      I2S_DATA.Configure (Output, Floating, PIO0);
      I2S_BCK.Configure (Output, Floating, PIO0);
      I2S_LRCK.Configure (Output, Floating, PIO0);
      MUTE.Configure (Output);
      MUTE.Set;

      RP.PIO.Initialize;
      RP.Device.PIO_0.Configure
         (SM     => 0,
          Config =>
            (Clock_Divider => RP.PIO.To_Divider (Frequency => (Sample_Rate * 2)),
             Out_Base         => I2S_DATA,
             Out_Count        => 1,
             Sideset_Base     => I2S_BCK,
             Sideset_Count    => 1,
             Set_Base         => I2S_DATA,
             Set_Count        => 3,
             Autopull         => True,
             Shift_Out_Right  => False,
             Pull_Threshold   => 0, --  32
             Sideset_Optional => False,
             others           => <>));
      RP.Device.PIO_0.Execute (0, 16#e087#); --  set pindirs, 0b111
      RP.Device.PIO_0.Execute (0, 16#e000#); --  set pins, 0
      RP.Device.PIO_0.Load
         (SM          => 0,
          Prog        => Audio_I2S.Audio_I2s_Program_Instructions,
          Wrap_Target => Audio_I2S.Audio_I2s_Wrap_Target,
          Wrap        => Audio_I2S.Audio_I2s_Wrap,
          Offset      => Audio_I2S.Offset_entry_point);
      RP.Device.PIO_0.Enable
         ((0      => True,
           others => False));

      MUTE.Clear;
   end Initialize;

   procedure Write
      (Samples : Sample_Array)
   is
   begin
      for S of Samples loop
         -- Sample is signed but PIO only understands unsigned, convert before sending each sample.
         RP.Device.PIO_0.Transmit (0, UInt32 (S + Sample'Last));
      end loop;
   end Write;
end Pico.Pimoroni.Audio_Pack;
