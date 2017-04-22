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

with Interfaces; use Interfaces;
with Giza.Context; use Giza.Context;
with Giza.Font; use Giza.Font;

package Giza.Bitmap_Fonts is

   subtype Parent is Font.Instance;
   type Bitmap_Font is new Parent with private;

   overriding
   procedure Glyph_Box (This : Bitmap_Font;
                        C    : Character;
                        Width, Height, X_Advance : out Natural;
                        X_Offset, Y_Offset : out Integer);

   overriding
   procedure Print_Glyph (This : Bitmap_Font;
                          Ctx  : in out Context.Class;
                          C    : Character);

   overriding
   function Y_Advance (This : Bitmap_Font) return Integer;

private
   type Font_Bitmap is array (Positive range <>) of Unsigned_8;
   type Font_Bitmap_Ref is not null access constant Font_Bitmap;

   type Bitmap_Glyph is record
      BitmapOffset       : Unsigned_16;
      Width, Height      : Unsigned_8;
      X_Advance          : Unsigned_8;
      X_Offset, Y_Offset : Integer_8;
   end record;

   type Glyph_Array is array (16#20# .. 16#7E#) of Bitmap_Glyph;
   type Glyph_Array_Ref is not null access constant Glyph_Array;

   type Bitmap_Font is new Parent with record
      Bitmap      : Font_Bitmap_Ref;
      Glyphs      : Glyph_Array_Ref;
      Y_Advance   : Unsigned_8;
   end record;
end Giza.Bitmap_Fonts;
