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

package body Giza.Widgets.Composite is

   procedure Free is new Ada.Unchecked_Deallocation (Wrapper, Wrapper_Ref);

   -----------
   -- Dirty --
   -----------

   overriding function Dirty
     (This : Composite_Widget)
      return Boolean
   is
      Ref : Wrapper_Ref := This.List;
   begin
      while Ref /= null loop
         if Ref.Widg.Dirty then
            return True;
         end if;
         Ref := Ref.Next;
      end loop;
      return False;
   end Dirty;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Composite_Widget;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      Ref : Wrapper_Ref := This.List;
   begin
      while Ref /= null loop
         if Ref.Widg.Dirty or else Force then
            Ctx.Save;
            Ctx.Translate (Ref.Pos);
            --  Ctx.Set_Bounds ((My_Bounds.Org + Ref.Pos, Ref.Widg.Get_Size));
            Ctx.Set_Position ((0, 0));
            Draw (Ref.Widg.all, Ctx, Force);
            Ctx.Restore;
         end if;
         Ref := Ref.Next;
      end loop;
   end Draw;

   --------------
   -- On_Click --
   --------------

   procedure On_Click
     (This  : in out Composite_Widget;
      Pos   : Point_T;
      CType : Click_Type)
   is
      Ref : Wrapper_Ref := This.List;
   begin
      while Ref /= null loop
         --  Check if event is within the Widget
         if Pos.X in Ref.Pos.X .. Ref.Pos.X + Ref.Widg.Size.W
           and then
             Pos.Y in Ref.Pos.Y .. Ref.Pos.Y + Ref.Widg.Size.H
         then
         --  Translate position into child coordinates
            Ref.Widg.On_Click (Pos - Ref.Pos, CType);
         end if;
         Ref := Ref.Next;
      end loop;
   end On_Click;

   ---------------
   -- Add_Child --
   ---------------

   procedure Add_Child
     (This  : in out Composite_Widget;
      Child : not null Widget_Ref;
      Pos   : Point_T)
   is
   begin
      if Pos.X not in 0 .. This.Size.W
        or else
          Pos.Y not in 0 .. This.Size.H
        or else
          Pos.X + Child.Size.W not in 0 .. This.Size.W
        or else
          Pos.Y + Child.Size.H not in 0 .. This.Size.H
      then
         --  Doesn't fit
         return;
      end if;

      This.List := new Wrapper'(Pos  => Pos,
                                Widg => Child,
                                Next => This.List);
   end Add_Child;

   ------------------
   -- Remove_Child --
   ------------------

   procedure Remove_Child
     (This  : in out Composite_Widget;
      Child : not null Widget_Ref)
   is
      Curr, Prev : Wrapper_Ref := null;
   begin
      Curr := This.List;
      while Curr /= null and then Curr.Widg /= Child loop
         Prev := Curr;
         Curr := Curr.Next;
      end loop;

      if Curr /= null then
         if Prev = null then
            This.List := Curr.Next;
         else
            Prev.Next := Curr.Next;
         end if;
         Free (Curr);
      end if;
   end Remove_Child;
end Giza.Widgets.Composite;
