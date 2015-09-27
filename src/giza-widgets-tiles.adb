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

package body Giza.Widgets.Tiles is

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Gtile;
                        Dirty : Boolean := True)
   is
   begin
      for Index in This.Widgs'Range loop
         if This.Widgs (Index) /= null then
            This.Widgs (Index).Set_Dirty (Dirty);
         end if;
      end loop;
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Gtile;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      W, H : Integer;
      Margin : constant Integer := 1;
   begin
      if This.Dirty or else Force then
         Draw (Gbackground (This), Ctx, Force);
      end if;

      W := This.Get_Size.W;
      W := W - 2 * This.Margin;
      W := W - (This.Number_Of_Widget - 1) * This.Spacing;
      W := W / This.Number_Of_Widget;

      H := This.Get_Size.H - 2 * This.Margin;

      Ctx.Save;
      Ctx.Translate ((Margin, Margin));

      for Index in This.Widgs'Range loop
         if This.Widgs (Index) /= null then
            --  Ctx.Set_Bounds ((My_Bounds.Org + Ref.Pos, Ref.Widg.Get_Size));
            This.Widgs (Index).Set_Size ((W, H));
            Ctx.Set_Position ((0, 0));
            Ctx.Save;
            Draw (This.Widgs (Index).all, Ctx, Force);
            Ctx.Restore;

            --  Translate for next tile
            Ctx.Translate ((This.Spacing + W, 0));
         end if;
      end loop;
      Ctx.Restore;
   end Draw;

   --------------
   -- On_Click --
   --------------

   overriding function On_Click
     (This  : in out Gtile;
      Pos   : Point_T;
      CType : Click_Type)
      return Boolean
   is
      W : Integer;
   begin
      W := This.Get_Size.W / This.Number_Of_Widget;

      for Index in This.Widgs'Range loop
         if Pos.X in (Index - 1) * W .. Index * W then
            return On_Click (This.Widgs (Index).all,
                             Pos - ((Index - 1) * W, 0),
                             CType);
         end if;
      end loop;
      return False;
   end On_Click;

   ---------------
   -- Set_Child --
   ---------------

   procedure Set_Child
     (This  : in out Gtile;
      Index : Positive;
      Child : Widget_Ref)
   is
   begin
      if Index in This.Widgs'Range then
         This.Widgs (Index) := Child;
      end if;
   end Set_Child;

   -----------------
   -- Set_Spacing --
   -----------------

   procedure Set_Spacing (This : in out Gtile; Spacing : Natural) is
   begin
      This.Spacing := Spacing;
   end Set_Spacing;

   ----------------
   -- Set_Margin --
   ----------------

   procedure Set_Margin (This : in out Gtile; Margin : Natural) is
   begin
      This.Margin := Margin;
   end Set_Margin;

end Giza.Widgets.Tiles;
