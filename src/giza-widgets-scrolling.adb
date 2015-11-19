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

with Giza.Timers;

package body Giza.Widgets.Scrolling is

   ---------------
   -- Triggered --
   ---------------

   function Triggered (This : Repeat_Event)  return Boolean is
      Reset : Boolean := False;
   begin
      if This.Scroll = null then
         return False;
      end if;

      if This.Scroll.Up.Active then
         Reset := True;
         This.Scroll.Go_Up;
      elsif This.Scroll.Down.Active then
         Reset := True;
         This.Scroll.Go_Down;
      end if;

      if Reset then
         --  Reset timer
         Giza.Timers.Set_Timer (This'Unchecked_Access,
                                Clock + This.Scroll.Repeat_Time);
      end if;

      return Reset;
   end Triggered;

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Gscroll;
                        Dirty : Boolean := True)
   is
   begin
      This.Up.Set_Dirty (Dirty);
      This.Down.Set_Dirty (Dirty);
      if This.Child /= null then
         This.Child.Set_Dirty (Dirty);
      end if;
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   procedure Draw (This : in out Gscroll;
                   Ctx : in out Context'Class;
                   Force : Boolean := True)
   is
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      if This.Child /= null then
         Ctx.Save;
         Ctx.Translate (This.Child_Pos);
         This.Child.Draw (Ctx);
         Ctx.Restore;

         if This.Child_Pos.Y < 0 then
            Ctx.Save;
            This.Up.Draw (Ctx, True);
            Ctx.Restore;
         end if;

         if This.Child_Pos.Y > -(This.Child.Size.H - This.Get_Size.H) then
            Ctx.Save;
            Ctx.Translate ((0, This.Get_Size.H - This.Down.Get_Size.H));
            This.Down.Draw (Ctx, True);
            Ctx.Restore;
         end if;
      end if;
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   function On_Position_Event
     (This : in out Gscroll;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
   begin
      if This.Child /= null then
         if This.Child_Pos.Y < 0
           and then
            Evt.Pos.Y < This.Up.Get_Size.H
         then
            if This.Up.On_Position_Event (Evt, Pos)
              and then
                This.Up.Active
            then
               This.Go_Up;
               Giza.Timers.Set_Timer
                 (This.Repeat_Evt'Unchecked_Access, Clock + This.Repeat_Time);
               return True;
            end if;

         elsif This.Child_Pos.Y > -(This.Child.Size.H - This.Get_Size.H)
           and then
            Evt.Pos.Y > This.Get_Size.H - This.Up.Get_Size.H
         then

            if This.Down.On_Position_Event
              (Evt, Pos - (0, This.Get_Size.H - This.Up.Get_Size.H))
              and then
              This.Down.Active
            then
               This.Go_Down;
               This.Repeat_Evt.Scroll := This'Unchecked_Access;
               Giza.Timers.Set_Timer
                 (This.Repeat_Evt'Unchecked_Access, Clock + This.Repeat_Time);
               return True;
            end if;
         else
            return This.Child.On_Position_Event (Evt, Pos - This.Child_Pos);
         end if;
      end if;
      return False;
   end On_Position_Event;

   --------------
   -- On_Event --
   --------------

   function On_Event
     (This : in out Gscroll;
      Evt  : Event_Not_Null_Ref) return Boolean
   is
   begin
      return (This.Child = null or else This.Child.On_Event (Evt))
        or This.Up.On_Event (Evt) or This.Down.On_Event (Evt);

   end On_Event;

   ---------------
   -- Set_Child --
   ---------------

   procedure Set_Child (This : in out Gscroll; Child : not null Widget_Ref) is
   begin
      This.Child := Child;

      This.Up.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
      This.Down.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
   end Set_Child;

   -----------
   -- Go_Up --
   -----------

   procedure Go_Up (This : in out Gscroll) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos + (0, 5);
         if This.Child_Pos.Y > 0 then
            This.Child_Pos.Y := 0;
         end if;
      end if;
   end Go_Up;

   -------------
   -- Go_Down --
   -------------

   procedure Go_Down (This : in out Gscroll) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos - (0, 5);
         if This.Child_Pos.Y < This.Get_Size.H - This.Child.Get_Size.H  then
            This.Child_Pos.Y := This.Get_Size.H - This.Child.Get_Size.H;
         end if;
      end if;
   end Go_Down;

   -------------
   -- Go_Left --
   -------------

   procedure Go_Left (This : in out Gscroll) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos + (5, 0);
         if This.Child_Pos.X > 0 then
            This.Child_Pos.X := 0;
         end if;
      end if;
   end Go_Left;

   --------------
   -- Go_Right --
   --------------

   procedure Go_Right (This : in out Gscroll) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos - (5, 0);
         if This.Child_Pos.X < (This.Get_Size.W - This.Child.Get_Size.W) then
            This.Child_Pos.X := (This.Get_Size.W - This.Child.Get_Size.W);
         end if;
      end if;
   end Go_Right;

end Giza.Widgets.Scrolling;
