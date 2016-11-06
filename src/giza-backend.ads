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

with Giza.Types;   use Giza.Types;
with Giza.Colors;  use Giza.Colors;
with Giza.Image;
with Giza.Bitmaps;
with Giza.Bitmaps.Indexed_1bit;
with Giza.Bitmaps.Indexed_2bits;
with Giza.Bitmaps.Indexed_4bits;
with Giza.Bitmaps.Indexed_8bits;

package Giza.Backend is

   type Instance is abstract tagged private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   procedure Set_Pixel (This : in out Instance; Pt : Point_T) is abstract;
   procedure Set_Color (This : in out Instance; C : Color) is abstract;
   function Size (This : Instance) return Size_T is abstract;
   function Has_Double_Buffring (This : Instance) return Boolean is abstract;
   procedure Swap_Buffers (This : in out Instance) is null;

   procedure Line (This : in out Instance; Start, Stop : Point_T);
   procedure Rectangle (This : in out Instance; Start, Stop : Point_T);
   procedure Fill_Rectangle (This : in out Instance; Start, Stop : Point_T);

   procedure Draw_Image
     (This : in out Instance;
      Img  : Giza.Image.Class;
      Pt   : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Bitmap;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_1bit.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_2bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_4bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_8bits.Bitmap_Indexed;
      Pt     : Point_T);

private

   type Instance is abstract tagged null record;

end Giza.Backend;
