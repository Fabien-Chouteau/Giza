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

package body Giza.Widgets.Composite is

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
      Ctx : in out Context'Class)
   is
      Ref : Wrapper_Ref := This.List;
      My_Bounds : constant Rect_T  := Ctx.Bounds;
      My_Pos    : constant Point_T := Ctx.Position;
   begin
      while Ref /= null loop
         if Ref.Widg.Dirty then
            Ctx.Set_Bounds ((My_Bounds.Org + Ref.Pos, Ref.Widg.Get_Size));
            Ctx.Set_Position ((0, 0));
            Draw (Ref.Widg.all, Ctx);
         end if;
         Ref := Ref.Next;
      end loop;
      Ctx.Set_Bounds (My_Bounds);
      Ctx.Set_Position (My_Pos);
   end Draw;

   ----------------------
   -- On_Builtin_Event --
   ----------------------

   overriding procedure On_Builtin_Event
     (This : in out Composite_Widget;
      Evt : Event_Not_Null_Access)
   is
   begin
      if Evt.all in Click_Event then
         declare
            Ref : Wrapper_Ref := This.List;
            Click : constant Click_Event_Access := Click_Event_Access (Evt);
            Click_Pos : constant Point_T := Click.Pos;
         begin
            while Ref /= null loop
               --  Translate position into child coordinates
               Click.Pos := Click_Pos - Ref.Pos;

               --  Check if event is within the Widget and do something
               if Click.Pos.X in 0 .. Ref.Widg.Size.W
                 and then
                  Click.Pos.Y in 0 .. Ref.Widg.Size.H
               then
                  Ref.Widg.On_Builtin_Event (Evt);
               end if;
               Ref := Ref.Next;
            end loop;
         end;
      else
         On_Custom_Event (This, Evt);
      end if;
   end On_Builtin_Event;

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

end Giza.Widgets.Composite;
