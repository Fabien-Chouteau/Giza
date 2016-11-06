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
   -- Get_Pixel --
   ---------------

   function Get_Pixel (Bmp : Bitmap; Pt : Point_T) return Color is
   begin
      return Bmp.Data ((Pt.X + Bmp.Data'First) + (Pt.Y * (Bmp.W)));
   end Get_Pixel;

   package body Indexed_Bitmaps is

      type Raw_Array is array (Integer range <>) of Index_Type with Pack;

      ---------------
      -- Get_Pixel --
      ---------------

      function Get_Pixel (Bmp : Bitmap_Indexed; Pt : Point_T) return Color is
         Map : Raw_Array (1 .. (Bmp.H * Bmp.W));
         for Map'Address use Bmp.Data'Address;
      begin
         return Bmp.Palette (Map ((Pt.X + 1) + (Pt.Y * (Bmp.W))));
      end Get_Pixel;
   end Indexed_Bitmaps;

--     ---------------
--     -- Set_Pixel --
--     ---------------
--
--     overriding procedure Set_Pixel
--       (This : in out Bitmap_Backend;
--        Pt : Point_T)
--     is
--     begin
--        if Pt.X + 1 in This.Data.Data'Range (1)
--          and then
--           Pt.Y + 1 in This.Data.Data'Range (2)
--        then
--           This.Data.Data (Pt.X + 1, Pt.Y + 1) := This.Current_Color;
--        end if;
--     end Set_Pixel;
--
--     ---------------
--     -- Set_Color --
--     ---------------
--
--     overriding procedure Set_Color
--       (This : in out Bitmap_Backend;
--        C : Color)
--     is
--     begin
--        This.Current_Color := C;
--     end Set_Color;
--
--     ----------
--     -- Size --
--     ----------
--
--     overriding function Size
--       (This : Bitmap_Backend)
--        return Size_T
--     is
--     begin
--        return (This.W, This.H);
--     end Size;

end Giza.Bitmaps;
