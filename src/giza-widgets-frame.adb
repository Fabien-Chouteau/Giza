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

   overriding
   procedure Draw (This : in out Gframe;
                   Ctx : in out Context'Class;
                   Force : Boolean := True) is
   begin
      if This.Dirty or else Force then
         if not This.BG_Disabled then
            Draw (Gbackground (This), Ctx, Force);
         end if;
         if not This.Frame_Disabled then
            Ctx.Set_Color (This.FG);
            Ctx.Rectangle (((0, 0), This.Get_Size));
         end if;
         This.Set_Dirty (False);
      end if;
   end Draw;

   --------------------
   -- Set_Foreground --
   --------------------

   procedure Set_Foreground (This : in out Gframe; FG : Color) is
   begin
      This.FG := FG;
   end Set_Foreground;

   ----------------
   -- Foreground --
   ----------------

   function Foreground (This : Gframe) return Color is (This.FG);

   -------------------
   -- Invert_Colors --
   -------------------

   procedure Invert_Colors (This : in out Gframe) is
      Tmp : Color;
   begin
      Tmp := This.FG;
      This.FG := This.Background;
      This.Set_Background (Tmp);
   end Invert_Colors;

   ------------------------
   -- Disable_Background --
   ------------------------

   procedure Disable_Background (This : in out Gframe) is
   begin
      This.BG_Disabled := True;
   end Disable_Background;

   ------------------------
   -- Disable_Foreground --
   ------------------------

   procedure Disable_Frame (This : in out Gframe) is
   begin
      This.Frame_Disabled := True;
   end Disable_Frame;
end Giza.Widgets.Frame;
