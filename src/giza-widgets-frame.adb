-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)         --
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

package body Giza.Widgets.Frame is

   ----------
   -- Draw --
   ----------

   procedure Draw (This : in out Gframe; Ctx : in out Context'Class) is
   begin
      Ctx.Set_Color (This.BG);
      Ctx.Fill_Rectangle (((0, 0), This.Size));
      Ctx.Set_Color (This.FG);
      Ctx.Rectangle (((0, 0), This.Size));
      This.Set_Dirty (False);
   end Draw;

   --------------------
   -- Set_Foreground --
   --------------------

   procedure Set_Foreground (This : in out Gframe; FG : Color) is
   begin
      This.FG := FG;
   end Set_Foreground;

   --------------------
   -- Set_Background --
   --------------------

   procedure Set_Background (This : in out Gframe; BG : Color) is
   begin
      This.BG := BG;
   end Set_Background;

   ----------------
   -- Foreground --
   ----------------

   function Foreground (This : Gframe) return Color is (This.FG);

   ----------------
   -- Background --
   ----------------

   function Background (This : Gframe) return Color is (This.BG);

   -------------------
   -- Invert_Colors --
   -------------------

   procedure Invert_Colors (This : in out Gframe) is
      Tmp : Color;
   begin
      Tmp := This.FG;
      This.FG := This.BG;
      This.BG := Tmp;
   end Invert_Colors;

end Giza.Widgets.Frame;
