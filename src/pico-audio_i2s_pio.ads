--------------------------------------------------------
-- This file is autogenerated by pioasm; do not edit! --
--------------------------------------------------------

pragma Style_Checks (Off);

with RP.PIO;

package Pico.Audio_I2S_PIO is

   ---------------
   -- Audio_I2s --
   ---------------

   Audio_I2s_Wrap_Target : constant := 0;
   Audio_I2s_Wrap        : constant := 7;

   Offset_entry_point : constant := 7;

   Audio_I2s_Program_Instructions : RP.PIO.Program := (
                    --  .wrap_target
         16#7001#,  --   0: out    pins, 1         side 2     
         16#1840#,  --   1: jmp    x--, 0          side 3     
         16#6001#,  --   2: out    pins, 1         side 0     
         16#e82e#,  --   3: set    x, 14           side 1     
         16#6001#,  --   4: out    pins, 1         side 0     
         16#0844#,  --   5: jmp    x--, 4          side 1     
         16#7001#,  --   6: out    pins, 1         side 2     
         16#f82e#); --   7: set    x, 14           side 3     
                    --  .wrap

end Pico.Audio_I2S_PIO;
