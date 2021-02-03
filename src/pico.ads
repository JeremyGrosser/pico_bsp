with RP.Clock; use RP.Clock;
with RP.GPIO;  use RP.GPIO;

package Pico is
   GP0  : aliased GPIO_Point := (Pin => 0);
   GP1  : aliased GPIO_Point := (Pin => 1);
   GP2  : aliased GPIO_Point := (Pin => 2);
   GP3  : aliased GPIO_Point := (Pin => 3);
   GP4  : aliased GPIO_Point := (Pin => 4);
   GP5  : aliased GPIO_Point := (Pin => 5);
   GP6  : aliased GPIO_Point := (Pin => 6);
   GP7  : aliased GPIO_Point := (Pin => 7);
   GP8  : aliased GPIO_Point := (Pin => 8);
   GP9  : aliased GPIO_Point := (Pin => 9);
   GP10 : aliased GPIO_Point := (Pin => 10);
   GP11 : aliased GPIO_Point := (Pin => 11);
   GP12 : aliased GPIO_Point := (Pin => 12);
   GP13 : aliased GPIO_Point := (Pin => 13);
   GP14 : aliased GPIO_Point := (Pin => 14);
   GP15 : aliased GPIO_Point := (Pin => 15);
   GP16 : aliased GPIO_Point := (Pin => 16);
   GP17 : aliased GPIO_Point := (Pin => 17);
   GP18 : aliased GPIO_Point := (Pin => 18);
   GP19 : aliased GPIO_Point := (Pin => 19);
   GP20 : aliased GPIO_Point := (Pin => 20);
   GP21 : aliased GPIO_Point := (Pin => 21);
   GP22 : aliased GPIO_Point := (Pin => 22);
   GP23 : aliased GPIO_Point := (Pin => 23);
   GP24 : aliased GPIO_Point := (Pin => 24);
   GP25 : aliased GPIO_Point := (Pin => 25);
   GP26 : aliased GPIO_Point := (Pin => 26);
   GP27 : aliased GPIO_Point := (Pin => 27);
   GP28 : aliased GPIO_Point := (Pin => 28);

   LED  : GPIO_Point renames GP25;

   XOSC_Frequency : XOSC_Hertz := 12_000_000;
end Pico;
