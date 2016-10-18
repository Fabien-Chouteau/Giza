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

with Interfaces;
with Giza.Graphics; use Giza.Graphics;
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
                          Ctx  : in out Context'Class;
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
