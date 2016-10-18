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

package body Giza.Widget.Frame is

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context'Class;
                   Force : Boolean := True) is
   begin
      if This.Dirty or else Force then
         if not This.BG_Disabled then
            Draw (Background.Instance (This), Ctx, Force);
         end if;
         if not This.Frame_Disabled then
            Ctx.Set_Color (This.FG);
            Ctx.Rounded_Rectangle (((0, 0), This.Get_Size), This.Radius);
         end if;
         if not This.Img_Disabled and then This.Img /= null then
            Ctx.Translate (((This.Get_Size.W - This.Img.Size.W) / 2,
                           (This.Get_Size.H - This.Img.Size.H) / 2));
            This.Img.Draw (Ctx);
         end if;
         This.Set_Dirty (False);
      end if;
   end Draw;

   --------------------
   -- Set_Foreground --
   --------------------

   procedure Set_Foreground (This : in out Instance; FG : Color) is
   begin
      This.FG := FG;
   end Set_Foreground;

   --------------------
   -- Get_Foreground --
   --------------------

   function Get_Foreground (This : Instance) return Color is (This.FG);

   -------------------
   -- Invert_Colors --
   -------------------

   procedure Invert_Colors (This : in out Instance) is
      Tmp_C   : Color;
      Tmp_Img : Image.Ref;
   begin
      Tmp_C := This.FG;
      This.FG := This.Get_Background;
      This.Set_Background (Tmp_C);

      Tmp_Img := This.Invert_Img;
      This.Invert_Img := This.Img;
      This.Img := Tmp_Img;
   end Invert_Colors;

   ---------------
   -- Set_Image --
   ---------------

   procedure Set_Image (This : in out Instance;
                        Img  : not null Image.Ref)
   is
   begin
      This.Img := Img;
      This.Img_Disabled := False;
   end Set_Image;

   ----------------------
   -- Set_Invert_Image --
   ----------------------

   procedure Set_Invert_Image (This : in out Instance;
                               Img  : not null Image.Ref)
   is
   begin
      This.Invert_Img := Img;
      This.Img_Disabled := False;
   end Set_Invert_Image;

   ------------------------
   -- Disable_Background --
   ------------------------

   procedure Disable_Background (This : in out Instance) is
   begin
      This.BG_Disabled := True;
   end Disable_Background;

   -------------------
   -- Disable_Frame --
   -------------------

   procedure Disable_Frame (This : in out Instance) is
   begin
      This.Frame_Disabled := True;
   end Disable_Frame;

   -------------------
   -- Disable_Image --
   -------------------

   procedure Disable_Image (This : in out Instance) is
   begin
      This.Img_Disabled := True;
   end Disable_Image;

end Giza.Widget.Frame;
