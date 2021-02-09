with HAL;

package Pico.Pimoroni.RGB_Keypad is

   procedure Initialize;
   --  This will configure the required peripherals and pins for the RGB Keypad:
   --   - SPI0
   --   - GP18 SPI Clock
   --   - GP19 SPI Master-Out Salve-In
   --   - GP17 SPI Chip-Select

   type Pad is range 0 .. 15;

   procedure Set (P          : Pad;
                  R, G, B    : HAL.UInt8;
                  Brightness : HAL.UInt5 := HAL.UInt5'Last);

   procedure Set_HSV (P          : Pad;
                      H, S, V    : HAL.UInt8;
                      Brightness : HAL.UInt5 := HAL.UInt5'Last);

   procedure Get (P          :     Pad;
                  R, G, B    : out HAL.UInt8;
                  Brightness : out HAL.UInt5);

   procedure Update;

end Pico.Pimoroni.RGB_Keypad;
