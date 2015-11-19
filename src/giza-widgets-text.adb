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

   overriding
   procedure Draw (This : in out Gtext;
                   Ctx : in out Context'Class;
                   Force : Boolean := True)
   is
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Gframe (This), Ctx, Force => True);

      if This.Str /= null then
         Ctx.Set_Color (This.Foreground);
         Ctx.Print_In_Rect (This.Str.all, ((0, 0), This.Get_Size));
      end if;
   end Draw;

   --------------
   -- Set_Text --
   --------------

   procedure Set_Text (This : in out Gtext; Str : String) is
   begin
      This.Str := new String'(Str);
   end Set_Text;

end Giza.Widgets.Text;
