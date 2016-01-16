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

with Interfaces; use Interfaces;
with Giza.Graphics; use Giza.Graphics;

package Giza.Bitmap_Fonts is

   type Bitmap_Font is new Font with private;

   overriding
   procedure Glyph_Box (This : Bitmap_Font;
                        C    : Character;
                        Top, Bottom, Left, Right : out Integer);

--     overriding
--     procedure Print (This : Bitmap_Font;
--                      Ctx  : in out Context'Class;
--                      Str  : String);

   overriding
   procedure Print_Glyph (This : Bitmap_Font;
                          Ctx  : in out Context'Class;
                          C    : Character);

--     overriding
--     procedure Print (This   : Bitmap_Font;
--                      Ctx    : in out Context'Class;
--                      Str    : String;
--                      Bounds : Rect_T);
--     overriding
--     procedure Box (This                     : Bitmap_Font;
--                    Str                      : String;
--                    Top, Bottom, Left, Right : out Integer);

private
   type Font_Bitmap is array (Positive range <>) of Unsigned_8;
   type Font_Bitmap_Ref is not null access constant Font_Bitmap;

   type Bitmap_Glyph is record
      BitmapOffset       : Unsigned_16;
      Width, Height      : Unsigned_8;
      X_Advance          : Unsigned_8;
      X_Offset, Y_Offset : Integer_8;
   end record;

   type Glyph_Array is array (Positive range <>) of Bitmap_Glyph;
   type Glyph_Array_Ref is not null access constant Glyph_Array;

   type Bitmap_Font is new Font with record
      Bitmap      : Font_Bitmap_Ref;
      Glyphs      : Glyph_Array_Ref;
      First, Last : Unsigned_8;
      Y_Advance   : Unsigned_8;
   end record;
end Giza.Bitmap_Fonts;
