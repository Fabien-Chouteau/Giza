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

with Giza.Types; use Giza.Types;

package body Giza.Bitmap_Fonts is

   ---------------
   -- Glyph_Box --
   ---------------

   overriding procedure Glyph_Box (This : Bitmap_Font;
                                   C    : Character;
                                   Width, Height, X_Advance : out Natural;
                                   X_Offset, Y_Offset : out Integer)
   is
      Index : constant Integer := Character'Pos (C);
   begin
      if Index not in This.Glyphs'Range then
         Width := 0;
         Height := 0;
         X_Offset := 0;
         Y_Offset := 0;
         X_Advance := 0;
         return;
      end if;

      Width     := Natural (This.Glyphs (Index).Width);
      Height    := Natural (This.Glyphs (Index).Height);
      X_Advance := Natural (This.Glyphs (Index).X_Advance);
      X_Offset  := Integer (This.Glyphs (Index).X_Offset);
      Y_Offset  := Integer (This.Glyphs (Index).Y_Offset);
   end Glyph_Box;

   -----------------
   -- Print_Glyph --
   -----------------

   overriding procedure Print_Glyph (This : Bitmap_Font;
                                     Ctx  : in out Context'Class;
                                     C    : Character)
   is
      Index : constant Integer := Character'Pos (C);
      H, W, Xo, Yo, Xa : Integer;
      Bits : Unsigned_8 := 0;
      Bit  : Unsigned_8 := 0;
      Bitmap_Offset : Integer;
      Org : constant Point_T := Ctx.Position;
   begin
      if Index not in This.Glyphs'Range then
         return;
      end if;

      H := Integer (This.Glyphs (Index).Height);
      W := Integer (This.Glyphs (Index).Width);
      if H > 0 and then W > 0 then
         Xo := Integer (This.Glyphs (Index).X_Offset);
         Yo := Integer (This.Glyphs (Index).Y_Offset);
         Bitmap_Offset := Integer (This.Glyphs (Index).BitmapOffset) +
           This.Bitmap'First;
         for Y in 0 .. H - 1 loop
            for X in 0 .. W - 1 loop
               if (Bit and 7) = 0 then
                  Bits := This.Bitmap (Bitmap_Offset);
                  Bitmap_Offset := Bitmap_Offset + 1;
               end if;
               Bit := Bit + 1;

               if (Bits and 16#80#) /= 0 then
                  Ctx.Set_Pixel (Org + Point_T'(X, Y) + Point_T'(Xo, Yo));
               end if;
               Bits := Shift_Left (Bits, 1);
            end loop;
         end loop;
      end if;
      Xa := Integer (This.Glyphs (Index).X_Advance);
      Ctx.Move_To (Org + Point_T'(Xa, 0));
   end Print_Glyph;

   ---------------
   -- Y_Advance --
   ---------------

   overriding function Y_Advance (This : Bitmap_Font) return Integer is
   begin
      return Integer (This.Y_Advance);
   end Y_Advance;

end Giza.Bitmap_Fonts;
