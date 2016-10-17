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

with Ada.Unchecked_Deallocation;

package body Giza.Widgets.Text is

   procedure Free is new Ada.Unchecked_Deallocation (String, String_Access);

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This : in out Instance;
                   Ctx : in out Context'Class;
                   Force : Boolean := True)
   is
      Margin_H : constant Dim := This.Get_Size.H / 30;
      Margin_W : constant Dim := This.Get_Size.W / 30;
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Parent (This), Ctx, Force => True);

      if This.Str /= null then
         Ctx.Set_Color (This.Get_Foreground);
         Ctx.Print_In_Rect (This.Str.all,
                            ((Margin_W, Margin_H),
                             This.Get_Size - (Margin_W * 2, Margin_H * 2)));
      end if;
   end Draw;

   --------------
   -- Set_Text --
   --------------

   procedure Set_Text (This : in out Instance; Str : String) is
   begin
      if This.Str /= null then
         Free (This.Str);
      end if;

      This.Str := new String'(Str);
      This.Set_Dirty;
   end Set_Text;

   ----------
   -- Text --
   ----------

   function Text (This : Instance) return String is
   begin
      if This.Str /= null then
         return This.Str.all;
      else
         return "";
      end if;
   end Text;

end Giza.Widgets.Text;
