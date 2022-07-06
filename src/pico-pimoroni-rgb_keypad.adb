--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;      use HAL;
with HAL.SPI;  use HAL.SPI;
with HAL.I2C;  use HAL.I2C;

with RP.I2C_Master;
with RP.SPI;
with RP.Device;

package body Pico.Pimoroni.RGB_Keypad is

   SPI      : RP.SPI.SPI_Port renames RP.Device.SPI_0;
   SPI_CLK  : RP.GPIO.GPIO_Point renames Pico.GP18;
   SPI_MOSI : RP.GPIO.GPIO_Point renames Pico.GP19;
   SPI_CS   : RP.GPIO.GPIO_Point renames Pico.GP17;

   INT     : RP.GPIO.GPIO_Point renames Pico.GP3;

   I2C     : RP.I2C_Master.I2C_Master_Port renames RP.Device.I2CM_0;
   I2C_SDA : RP.GPIO.GPIO_Point renames Pico.GP4;
   I2C_SCL : RP.GPIO.GPIO_Point renames Pico.GP5;

   Button_State : UInt16 := 0;

   Nbr_Of_LEDs : constant := 16;

   LED_Data : SPI_Data_8b (1 .. 4 + Nbr_Of_LEDs * 4 + 4) :=
     (0, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      2#111_00000#, 0, 0, 0,
      0, 0, 0, 0
     );

   INT_Handler : Change_Handler := null;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      SPI.Configure
         ((Role => RP.SPI.Master,
           Baud => 20_000_000,
           others => <>));

      SPI_CS.Configure (Output);
      SPI_CS.Set;

      SPI_CLK.Configure (Output, Floating, RP.GPIO.SPI);
      SPI_MOSI.Configure (Output, Floating, RP.GPIO.SPI);

      I2C.Configure (400_000);

      I2C_SDA.Configure (Output, Pull_Up, RP.GPIO.I2C);
      I2C_SCL.Configure (Output, Pull_Up, RP.GPIO.I2C);

      INT.Configure (Input, Floating);
   end Initialize;

   ---------
   -- Set --
   ---------

   procedure Set (P          : Pad;
                  R, G, B    : HAL.UInt8;
                  Brightness : HAL.UInt5 := HAL.UInt5'Last)
   is
      Index : constant Natural := LED_Data'First + 4 + Natural (P) * 4;
   begin

      LED_Data (Index) := 2#111_00000# or UInt8 (Brightness);
      LED_Data (Index + 1) := B;
      LED_Data (Index + 2) := G;
      LED_Data (Index + 3) := R;
   end Set;

   -------------
   -- Set_HSV --
   -------------

   procedure Set_HSV (P          : Pad;
                      H, S, V    : HAL.UInt8;
                      Brightness : HAL.UInt5 := HAL.UInt5'Last)
   is
      R, G, B : UInt8;

      Region, Remainder : UInt32;
      A, Q, T : UInt8;
   begin
      if S = 0 then
         R := V;
         G := V;
         B := V;
      else

         Region := UInt32 (H / 43);
         Remainder := (UInt32 (H) - (Region * 43)) * 6;

         A := UInt8 (Shift_Right (UInt32 (V) * (255 - UInt32 (S)), 8));

         Q := UInt8 (Shift_Right (UInt32 (V) *
                     (255 - Shift_Right (UInt32 (S) * Remainder, 8)), 8));

         T := UInt8 (Shift_Right (UInt32 (V) *
                     (255 - Shift_Right (UInt32 (S) *
                        (255 - Remainder), 8)), 8));

         case (Region) is
            when      0 => R := V; G := T; B := A;
            when      1 => R := Q; G := V; B := A;
            when      2 => R := A; G := V; B := T;
            when      3 => R := A; G := Q; B := V;
            when      4 => R := T; G := A; B := V;
            when others => R := V; G := A; B := Q;
         end case;
      end if;

      Set (P, R, G, B, Brightness);
   end Set_HSV;

   ---------
   -- Get --
   ---------

   procedure Get (P          :     Pad;
                  R, G, B    : out HAL.UInt8;
                  Brightness : out HAL.UInt5)
   is
      Index : constant Natural := LED_Data'First + 4 + Natural (P) * 4;
   begin

      Brightness := UInt5 (LED_Data (Index) and 2#000_11111#);
      B := LED_Data (Index + 1);
      G := LED_Data (Index + 2);
      R := LED_Data (Index + 3);
   end Get;

   ------------
   -- Update --
   ------------

   procedure Update is
      Status : SPI_Status;
   begin
      SPI_CS.Clear;
      SPI.Transmit (LED_Data, Status);
      SPI_CS.Set;

      declare
         Status : I2C_Status;
         Data : I2C_Data (1 .. 2) := (others => 255);
      begin

         --  HAL.I2C expects 8-bit address (with R/W bit as 0)

         I2C.Mem_Read (Addr          => 16#40#,
                       Mem_Addr      => 0,
                       Mem_Addr_Size => Memory_Size_8b,
                       Data          => Data,
                       Status        => Status);

         Button_State :=
           not (UInt16 (Data (1)) or Shift_Left (UInt16 (Data (2)), 8));
      end;
   end Update;

   -------------
   -- Pressed --
   -------------

   function Pressed (P : Pad) return Boolean is
   begin
      return (Button_State and Shift_Left (UInt16 (1), Natural (P))) /= 0;
   end Pressed;

   ------------------------
   -- Keypad_INT_Handler --
   ------------------------

   procedure Keypad_INT_Handler
      (Pin     : RP.GPIO.GPIO_Pin;
       Trigger : RP.GPIO.Interrupt_Triggers)
   is
      pragma Unreferenced (Pin);
      pragma Unreferenced (Trigger);
   begin
      if INT_Handler /= null then
         INT_Handler.all;
      end if;
   end Keypad_INT_Handler;

   ------------
   -- Attach --
   ------------

   procedure Attach
      (Handler : Change_Handler)
   is
   begin
      --  INT is active-low and falls when any pad is pressed or released.
      --  An external 10k pullup resistor is connected, no internal pullup is needed.
      INT_Handler := Handler;
      INT.Set_Interrupt_Handler (Keypad_INT_Handler'Access);
      INT.Enable_Interrupt (RP.GPIO.Falling_Edge);
   end Attach;

end Pico.Pimoroni.RGB_Keypad;
