with HAL;

package Pico.Pimoroni.RGB_Keypad is

   procedure Initialize;
   --  This will configure the required peripherals and pins for the RGB Keypad:
   --   - SPI0
   --   - GP18 SPI Clock
   --   - GP19 SPI Master-Out Salve-In
   --   - GP17 SPI Chip-Select
   --   - I2C0
   --   - GP4 I2C SDA
   --   - GP5 I2C SCL

   type Pad is range 0 .. 15;

   procedure Set (P          : Pad;
                  R, G, B    : HAL.UInt8;
                  Brightness : HAL.UInt5 := HAL.UInt5'Last);
   --  Set internal color settings for the pad in Red/Green/Blue format.
   --  The color change will only be visible after a call to Update().

   procedure Set_HSV (P          : Pad;
                      H, S, V    : HAL.UInt8;
                      Brightness : HAL.UInt5 := HAL.UInt5'Last);
   --  Set internal color settings for the pad in Hue/Staturation/Value format.
   --  The color change will only be visible after a call to Update().

   procedure Get (P          :     Pad;
                  R, G, B    : out HAL.UInt8;
                  Brightness : out HAL.UInt5);
   --  Return the internal color settings for the pad Red/Green/Blue format

   procedure Update;
   --  Update the color of the LEDs and get the new state of the pads

   function Pressed (P : Pad) return Boolean;
   --  Return True if the pad was pressed during the last call to Update()

end Pico.Pimoroni.RGB_Keypad;
