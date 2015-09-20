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

package body Giza.Widgets.Text is

   ----------
   -- Draw --
   ----------

   procedure Draw (This : in out Gtext;
                   Ctx : in out Context'Class;
                   Force : Boolean := True)
   is
      Top, Bottom, Left, Right : Integer;
      Pt : Point_T;
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Gframe (This), Ctx);

      if This.Str /= null then
         Pt := Center (((0, 0), This.Get_Size));
         Ctx.Box (This.Str.all, Top, Bottom, Left, Right);
         Pt.X := Pt.X - (Right - Left) / 2;
         Ctx.Move_To (Pt);
         Ctx.Print (This.Str.all);
      end if;
   end Draw;

   --------------
   -- Set_Text --
   --------------

   procedure Set_Text (This : in out Gtext; Str : access String) is
   begin
      This.Str := Str;
   end Set_Text;

end Giza.Widgets.Text;
