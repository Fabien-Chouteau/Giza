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

limited with Giza.Graphics;

package Giza.Font is

   type Instance is interface;
   subtype Class is Instance'Class;
   type Ref is access all Class;
   type Ref_Const is access constant Class;

   procedure Glyph_Box (This : Instance;
                        C    : Character;
                        Width, Height, X_Advance : out Natural;
                        X_Offset, Y_Offset : out Integer) is abstract;

   procedure Print_Glyph (This : Instance;
                          Ctx  : in out Giza.Graphics.Context'Class;
                          C    : Character) is abstract;

   function Y_Advance (This : Instance) return Integer is abstract;

end Giza.Font;
