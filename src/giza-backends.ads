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
with Giza.Colors; use Giza.Colors;

package Giza.Backends is

   type Backend is abstract tagged private;
   type Backend_Ref is access all Backend'Class;

   procedure Set_Pixel (This : in out Backend; Pt : Point_T) is abstract;
   procedure Set_Color (This : in out Backend; C : Color) is abstract;
   function Size (This : Backend) return Size_T is abstract;
   function Has_Double_Buffring (This : Backend) return Boolean is abstract;
   procedure Swap_Buffers (This : in out Backend) is null;

   procedure Line (This : in out Backend; Start, Stop : Point_T);
   procedure Rectangle (This : in out Backend; Start, Stop : Point_T);
   procedure Fill_Rectangle (This : in out Backend; Start, Stop : Point_T);

private

   type Backend is abstract tagged null record;

end Giza.Backends;
