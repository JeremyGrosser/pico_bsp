with Interfaces; use Interfaces;
with Pico.Audio_I2S_PIO;
with HAL; use HAL;
with RP; use RP;

package body Pico.Audio_I2S is

   procedure Program_Init
      (This   : in out I2S_Device;
       Offset : PIO_Address)
   is
   begin
      This.Config := Default_SM_Config;
      Set_Out_Pins (This.Config, This.Data.Pin, 1);
      Set_Sideset_Pins (This.Config, This.BCLK.Pin);
      Set_Sideset (This.Config, 2, False, False);
      Set_Out_Shift (This.Config, False, True, 32);
      Set_Wrap (This.Config,
          Wrap        => Offset + Pico.Audio_I2S_PIO.Audio_I2s_Wrap,
          Wrap_Target => Offset + Pico.Audio_I2S_PIO.Audio_I2s_Wrap_Target);

      Set_Config (This.PIO.all, This.SM, This.Config);
      SM_Initialize (This.PIO.all, This.SM, Offset, This.Config);

      Set_Pin_Direction (This.PIO.all, This.SM, This.Data.Pin, Output);
      Set_Pin_Direction (This.PIO.all, This.SM, This.BCLK.Pin, Output);
      Set_Pin_Direction (This.PIO.all, This.SM, This.LRCLK.Pin, Output);

      Execute (This.PIO.all, This.SM, PIO_Instruction (Offset + Pico.Audio_I2S_PIO.Offset_entry_point));
   end Program_Init;

   overriding
   procedure Set_Frequency
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency)
   is
      Sample_Rate       : constant Hertz :=
         Hertz (HAL.Audio.Audio_Frequency'Enum_Rep (Frequency));
      Sample_Bits       : constant := 16;
      Cycles_Per_Sample : constant := 2;
   begin
      Set_Clock_Frequency (This.Config, Sample_Rate * Sample_Bits * This.Channels * Cycles_Per_Sample);
      Set_Config (This.PIO.all, This.SM, This.Config);
   end Set_Frequency;

   procedure Initialize
      (This      : in out I2S_Device;
       Frequency : HAL.Audio.Audio_Frequency;
       Channels  : Channel_Count := 1)
   is
      SM_Offset : constant PIO_Address := 0;
      AF        : constant RP.GPIO.GPIO_Function := RP.PIO.GPIO_Function (This.PIO.all);
   begin
      This.Data.Configure (Output, Pull_Both, AF);
      This.BCLK.Configure (Output, Pull_Both, AF);
      This.LRCLK.Configure (Output, Pull_Both, AF);

      Enable (This.PIO.all);
      Load (This.PIO.all,
          Prog   => Pico.Audio_I2S_PIO.Audio_I2s_Program_Instructions,
          Offset => SM_Offset);

      Program_Init (This, SM_Offset);
      Set_Frequency (This, Frequency);

      Set_Enabled (This.PIO.all, This.SM, True);
   end Initialize;

   function Twos_Complement (I : Integer_16)
      return UInt16
   is
   begin
      if I < 0 then
         return not UInt16 (I * (-1));
      else
         return UInt16 (I);
      end if;
   end Twos_Complement;

   overriding
   procedure Transmit
      (This : in out I2S_Device;
       Data : HAL.Audio.Audio_Buffer)
   is
      U : UInt32;
      I : Integer := Data'First;
   begin
      while I < Data'Last loop
         if This.Channels > 1 then
            U := Shift_Left (UInt32 (Twos_Complement (Data (I))), 16)
                 or UInt32 (Twos_Complement (Data (I + 1)));
            I := I + 2;
         else
            U := UInt32 (Twos_Complement (Data (I + 1)));
            I := I + 1;
         end if;
         Put (This.PIO.all, This.SM, U);
      end loop;
   end Transmit;

   overriding
   procedure Receive
      (This : in out I2S_Device;
       Data : out HAL.Audio.Audio_Buffer)
   is
      D : UInt32;
   begin
      for I in Data'Range loop
         Get (This.PIO.all, This.SM, D);
         Data (I) := Integer_16 (D);
      end loop;
   end Receive;

end Pico.Audio_I2S;
