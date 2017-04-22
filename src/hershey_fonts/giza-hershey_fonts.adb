------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)        --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with Giza.Types; use Giza.Types;

package body Giza.Hershey_Fonts is

   function Char_To_Glyph_Index (C : Character) return Glyph_Index;

   -------------------------
   -- Char_To_Glyph_Index --
   -------------------------

   function Char_To_Glyph_Index (C : Character) return Glyph_Index is
      Ret : constant Integer := Character'Pos (C) - 31;
   begin
      if Ret not in Glyph_Index then
         return Glyph_Index'Last;
      else
         return Glyph_Index (Ret);
      end if;
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
      Ctx : in out Context.Class;
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
