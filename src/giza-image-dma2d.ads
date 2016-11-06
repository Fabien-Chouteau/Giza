-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)         --
--                                                                           --
--                                                                           --
--    Giza is free software: you can redistribute it and/or modify it        --
--    under the terms of the GNU General Public License as published by      --
--    the Free Software Foundation, either version 3 of the License, or      --
--    (at your option) any later version.                                    --
--                                                                           --
--    Giza is distributed in the hope that it will be useful, but WITHOUT    --
--    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY     --
--    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public        --
--    License for more details.                                              --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with Giza. If not, see <http://www.gnu.org/licenses/>.           --
--                                                                           --
-------------------------------------------------------------------------------

--  This package provides Image bitmap implementation formated for STM32 DMA2D
--  hardware acceleration. A slow copy these bitmaps is supported in the
--  default backend so they can be used on any platform.

with Giza.Image;
with Giza.Colors;

package Giza.Image.DMA2D is

   type Color_Mode is (RGB888, L8, L4);

   type Unsigned_4 is mod 2**4 with Size => 4;
   type Unsigned_8 is mod 2**8 with Size => 8;

   type DMA2D_Color is record
      R : Unsigned_8;
      G : Unsigned_8;
      B : Unsigned_8;
   end record;

   for DMA2D_Color use record
      B at 0 range 0 .. 7;
      G at 1 range 0 .. 7;
      R at 2 range 0 .. 7;
   end record;

   type L8_CLUT_T is array (Unsigned_8) of DMA2D_Color with Pack;
   type L4_CLUT_T is array (Unsigned_4) of DMA2D_Color with Pack;

   type L8_CLUT_Acces_Const is access constant L8_CLUT_T;
   type L4_CLUT_Acces_Const is access constant L4_CLUT_T;

   type L8_Data_T is array (Natural range <>) of Unsigned_8 with Pack;
   type L4_Data_T is array (Natural range <>) of Unsigned_8 with Pack;
   type RGB888_Data_T is array (Natural range <>) of DMA2D_Color with Pack;

   type L8_Data_Access_Const     is access constant L8_Data_T;
   type L4_Data_Access_Const     is access constant L4_Data_T;
   type RGB888_Data_Access_Const is access constant RGB888_Data_T;

   subtype Parent is Giza.Image.Instance;
   type Instance (Mode         : Color_Mode;
                  Length, W, H : Natural) is new Parent with
      record
         case Mode is
            when RGB888 =>
               RGB888_Data : not null RGB888_Data_Access_Const;
            when L4 =>
               L4_CLUT : not null L4_CLUT_Acces_Const;
               L4_Data : not null L4_Data_Access_Const;
            when L8 =>
               L8_CLUT : not null L8_CLUT_Acces_Const;
               L8_Data : not null L8_Data_Access_Const;
         end case;
      end record;

   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   function Size (This : Instance) return Size_T;

   function To_Giza_Color (C : DMA2D_Color) return Giza.Colors.Color
     with Inline_Always;

   function Get_Pixel (This : Instance; Pt : Point_T) return DMA2D_Color
     with Pre => Pt.X in 0 .. (This.W - 1) and then Pt.Y in 0 .. (This.W - 1);
   function Get_Pixel (This : Instance; Pt : Point_T) return Giza.Colors.Color
     with Pre => Pt.X in 0 .. (This.W - 1) and then Pt.Y in 0 .. (This.W - 1);

end Giza.Image.DMA2D;
