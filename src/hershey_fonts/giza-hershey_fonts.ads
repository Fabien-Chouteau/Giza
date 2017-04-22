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

with Interfaces;
with Giza.Context; use Giza.Context;
with Giza.Font; use Giza.Font;

package Giza.Hershey_Fonts is

   subtype Parent is Font.Instance;
   type Hershey_Font (Number_Of_Glyphs : Natural) is new Parent with private;

   overriding
   procedure Glyph_Box (This : Hershey_Font;
                        C    : Character;
                        Width, Height, X_Advance : out Natural;
                        X_Offset, Y_Offset : out Integer);

   overriding
   procedure Print_Glyph (This : Hershey_Font;
                          Ctx  : in out Context.Class;
                          C    : Character);

   overriding
   function Y_Advance (This : Hershey_Font) return Integer;

private

   type Coord is new Interfaces.Integer_8 with Size => 8;

   type Vect is record
      X, Y : Coord;
   end record with Pack;

   Raise_Pen : constant Vect := (Coord'Last, Coord'Last);

   type Vect_Array is array (Natural range <>) of Vect with Pack;

   type Glyph (Number_Of_Vectors : Natural) is record
      Width, Height, Y_Offset, X_Offset : Coord;
      Vects                   : Vect_Array (1 .. Number_Of_Vectors);
   end record;

   type Glyph_Access is not null access constant Glyph;

   subtype Glyph_Index is Positive;

   type Glyph_Access_Array is array (Positive range <>) of Glyph_Access;

   type Hershey_Font (Number_Of_Glyphs : Natural) is new Parent with record
      Glyphs : Glyph_Access_Array (1 .. Number_Of_Glyphs);
      Y_Advance : Coord;
   end record;

   Empty_Glyph : aliased constant Glyph :=
     (Number_Of_Vectors => 0,
      Width => 0,
      Height => 0,
      Y_Offset => 0,
      X_Offset => 0,
      Vects => (others => (Raise_Pen)));

end Giza.Hershey_Fonts;
