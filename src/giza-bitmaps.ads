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

with Giza.Colors;   use Giza.Colors;
with Giza.Backend; use Giza.Backend;
with Giza.Types;    use Giza.Types;

package Giza.Bitmaps is

   type Bitmap_Data is array (Integer range <>, Integer range <>) of Color;

   type Bitmap (W, H : Integer) is record
      Data : Bitmap_Data (1 .. H, 1 .. W) := (others => (others => Violet));
   end record;

   type Bitmap_Ref is access all Bitmap;

   --------------------
   -- Bitmap_Backend --
   --------------------

   --  Used with a Gcontext, this backend allows to draw on bitmap as if it was
   --  a screen.

   type Bitmap_Backend (W, H : Natural) is new Backend.Instance with record
      Data          : Bitmap (W, H);
      Current_Color : Color;
   end record;

   overriding
   procedure Set_Pixel (This : in out Bitmap_Backend; Pt : Point_T);

   overriding
   procedure Set_Color (This : in out Bitmap_Backend; C : Color);

   overriding
   function Size (This : Bitmap_Backend) return Size_T;

   overriding
   function Has_Double_Buffring (This : Bitmap_Backend) return Boolean is
      (False);

   type Unsigned_1 is mod 2**1 with Size => 1;
   type Unsigned_2 is mod 2**2 with Size => 2;
   type Unsigned_4 is mod 2**4 with Size => 4;
   type Unsigned_8 is mod 2**8 with Size => 8;

   generic
      type Index_Type is mod <>;
   package Indexed_Bitmaps is
      type Bitmap_Indexed_Data is array (Integer range <>, Integer range <>)
        of Index_Type;
      type Color_Palette is array (Index_Type) of Color;

      type Bitmap_Indexed (W, H : Natural) is record
         Palette : Color_Palette;
         Data : Bitmap_Indexed_Data (1 .. H, 1 .. W);
      end record;

      type Bitmap_Indexed_Ref is access all Bitmap_Indexed;
   end Indexed_Bitmaps;

   package Indexed_1bit  is new Indexed_Bitmaps (Unsigned_1);
   package Indexed_2bits is new Indexed_Bitmaps (Unsigned_2);
   package Indexed_4bits is new Indexed_Bitmaps (Unsigned_4);
   package Indexed_8bits is new Indexed_Bitmaps (Unsigned_8);
end Giza.Bitmaps;
