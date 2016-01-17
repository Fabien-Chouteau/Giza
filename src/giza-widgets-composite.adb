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

   ---------------
   -- Set_Dirty --
   ---------------

   overriding
   procedure Set_Dirty (This : in out Composite_Widget;
                        Dirty : Boolean := True)
   is
      Ref : Wrapper_Ref := This.List;
   begin
      while Ref /= null loop
         Ref.Widg.Set_Dirty (Dirty);
         Ref := Ref.Next;
      end loop;
   end Set_Dirty;

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
         Ctx.Save;
         Ctx.Translate (Ref.Pos);
         Ctx.Set_Bounds (((0, 0), Ref.Widg.Get_Size));
         Ctx.Set_Position ((0, 0));
         Draw (Ref.Widg.all, Ctx, Force);
         Ctx.Restore;
         Ref := Ref.Next;
      end loop;
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding
   function On_Position_Event
     (This : in out Composite_Widget;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
      Ref     : Wrapper_Ref := This.List;
      Handled : Boolean := False;
   begin
      while Ref /= null loop
         --  Check if event is within the Widget
         if Pos.X in Ref.Pos.X .. Ref.Pos.X + Ref.Widg.Size.W
           and then
             Pos.Y in Ref.Pos.Y .. Ref.Pos.Y + Ref.Widg.Size.H
         then
            --  Translate position into child coordinates and propagate
            Handled := Handled or
              Ref.Widg.On_Position_Event (Evt, Pos - Ref.Pos);
         end if;
         Ref := Ref.Next;
      end loop;
      return Handled;
   end On_Position_Event;

   --------------
   -- On_Event --
   --------------

   overriding
   function On_Event
     (This : in out Composite_Widget;
      Evt  : Event_Not_Null_Ref) return Boolean
   is
      Ref     : Wrapper_Ref := This.List;
      Handled : Boolean := False;
   begin

      while Ref /= null loop
         Handled := Handled or Ref.Widg.On_Event (Evt);
         Ref := Ref.Next;
      end loop;
      return Handled;
   end On_Event;

   ---------------
   -- Add_Child --
   ---------------

   procedure Add_Child
     (This  : in out Composite_Widget;
      Child : not null Widget_Ref;
      Pos   : Point_T)
   is
   begin
      if Pos.X not in 0 .. This.Get_Size.W
        or else
          Pos.Y not in 0 .. This.Get_Size.H
        or else
          Pos.X + Child.Size.W not in 0 .. This.Get_Size.W
        or else
          Pos.Y + Child.Size.H not in 0 .. This.Get_Size.H
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
