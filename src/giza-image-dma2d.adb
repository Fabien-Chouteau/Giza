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

with Giza.Colors; use Giza.Colors;

package body Giza.Image.DMA2D is

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Instance)
      return Size_T
   is
   begin
      return (This.W, This.H);
   end Size;

   -------------------
   -- To_Giza_Color --
   -------------------

   function To_Giza_Color (C : DMA2D_Color) return Giza.Colors.Color is
     (R => RGB_Component (C.R),
      G => RGB_Component (C.G),
      B => RGB_Component (C.B));

   ---------------
   -- Get_Pixel --
   ---------------

   function Get_Pixel (This : Instance; Pt : Point_T) return DMA2D_Color is
   begin
      case This.Mode is
         when RGB888 => null;
            return This.RGB888_Data
              ((Pt.X + This.RGB888_Data'First) + (Pt.Y * This.W));
         when L4 => null;
            declare
               Index : constant Natural :=
                 (Pt.X + This.L4_Data'First) + Pt.Y * This.W;
               B : constant Unsigned_8 :=
                 This.L4_Data (Index / 2);
            begin
               if Index mod 2 = 0 then
                  return This.L4_CLUT (Unsigned_4 (B and 16#0F#));
               else
                  return This.L4_CLUT (Unsigned_4 ((B and 16#F0#) / 2**4));
               end if;
            end;
         when L8 =>
            return This.L8_CLUT
              (This.L8_Data ((Pt.X + This.L8_Data'First) + Pt.Y * This.W));
      end case;
   end Get_Pixel;

   ---------------
   -- Get_Pixel --
   ---------------

   function Get_Pixel (This : Instance; Pt : Point_T) return Giza.Colors.Color
   is (To_Giza_Color (Get_Pixel (This, Pt)));

end Giza.Image.DMA2D;
