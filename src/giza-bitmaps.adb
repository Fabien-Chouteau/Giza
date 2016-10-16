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

package body Giza.Bitmaps is

   ---------------
   -- Set_Pixel --
   ---------------

   overriding procedure Set_Pixel
     (This : in out Bitmap_Backend;
      Pt : Point_T)
   is
   begin
      This.Data.Data (Pt.X, Pt.Y) := This.Current_Color;
   end Set_Pixel;

   ---------------
   -- Set_Color --
   ---------------

   overriding procedure Set_Color
     (This : in out Bitmap_Backend;
      C : Color)
   is
   begin
      This.Current_Color := C;
   end Set_Color;

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Bitmap_Backend)
      return Size_T
   is
   begin
      return (This.W, This.H);
   end Size;

end Giza.Bitmaps;
