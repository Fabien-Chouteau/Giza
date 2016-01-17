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

package body Giza.Hershey_Fonts is

   function Char_To_Glyph_Index (C : Character) return Glyph_Index;

   -------------------------
   -- Char_To_Glyph_Index --
   -------------------------

   function Char_To_Glyph_Index (C : Character) return Glyph_Index is
   begin
      return Character'Pos (C) - 31;
   end Char_To_Glyph_Index;

   ---------------
   -- Glyph_Box --
   ---------------

   overriding
   procedure Glyph_Box (This : Hershey_Font;
                        C    : Character;
                        Width, Height, X_Advance : out Natural;
                        X_Offset, Y_Offset : out Integer)
   is
      Index : constant Glyph_Index := Char_To_Glyph_Index (C);
   begin
      if Index not in This.Glyphs'Range then
         Width := 0;
         Height := 0;
         X_Offset := 0;
         Y_Offset := 0;
         X_Advance := 0;
         return;
      end if;

      Width := Integer (This.Glyphs (Index).Width);
      Height := Integer (This.Glyphs (Index).Height);
      X_Advance := Width;
      X_Offset := 0;
      Y_Offset := Integer (This.Glyphs (Index).Y_Offset);

   end Glyph_Box;

   -----------------
   -- Print_Glyph --
   -----------------

   overriding procedure Print_Glyph
     (This : Hershey_Font;
      Ctx : in out Context'Class;
      C : Character)
   is
      Index : constant Glyph_Index := Char_To_Glyph_Index (C);
      Last : Vect := Raise_Pen;
      G : Glyph_Access := Empty_Glyph'Access;
      Org : constant Point_T := Ctx.Position;
      Offset : Point_T;
   begin
      if Index not in This.Glyphs'Range then
         return;
      end if;

      G := This.Glyphs (Index);

      Offset := Org - Point_T'(Integer (G.X_Offset), 0);
      for Vect of G.Vects loop
         if Vect /= Raise_Pen then
            if Last /= Raise_Pen then
               Ctx.Line_To (Offset +
                              Point_T'(Integer (Vect.X), Integer (Vect.Y)));
            else
               Ctx.Move_To (Offset +
                              Point_T'(Integer (Vect.X), Integer (Vect.Y)));
            end if;
         end if;
         Last := Vect;
      end loop;
      Ctx.Move_To ((Org.X + Integer (G.Width), Org.Y));
   end Print_Glyph;

   ---------------
   -- Y_Advance --
   ---------------

   overriding function Y_Advance (This : Hershey_Font) return Integer is
   begin
      return Integer (This.Y_Advance);
   end Y_Advance;

end Giza.Hershey_Fonts;
