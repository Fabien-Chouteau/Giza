------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)        --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with Giza.Timers;

package body Giza.Widget.Scrolling is

   ---------------
   -- Triggered --
   ---------------

   overriding
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

   overriding
   procedure Set_Dirty (This : in out Instance;
                        Dirty : Boolean := True)
   is
   begin
      Set_Dirty (Parent (This), Dirty);
      This.Up.Set_Dirty (Dirty);
      This.Down.Set_Dirty (Dirty);
      if This.Child /= null then
         This.Child.Set_Dirty (Dirty);
      end if;
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This : in out Instance;
                   Ctx : in out Context.Class;
                   Force : Boolean := True)
   is
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      if This.Child /= null then
         Ctx.Save;
         Ctx.Set_Bounds (((0, 0), This.Get_Size));

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
         Ctx.Restore;
      end if;
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding
   function On_Position_Event
     (This : in out Instance;
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

   overriding
   function On_Event
     (This : in out Instance;
      Evt  : Event_Not_Null_Ref) return Boolean
   is
   begin
      return (This.Child = null or else This.Child.On_Event (Evt))
        or This.Up.On_Event (Evt) or This.Down.On_Event (Evt);

   end On_Event;

   ---------------
   -- Set_Child --
   ---------------

   procedure Set_Child (This  : in out Instance;
                        Child : not null Widget.Reference) is
   begin
      This.Child := Child;

      This.Up.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
      This.Down.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
   end Set_Child;

   -----------
   -- Go_Up --
   -----------

   procedure Go_Up (This : in out Instance) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos + Size_T'(0, 5);
         if This.Child_Pos.Y > 0 then
            This.Child_Pos.Y := 0;
         end if;
      end if;
   end Go_Up;

   -------------
   -- Go_Down --
   -------------

   procedure Go_Down (This : in out Instance) is
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

   procedure Go_Left (This : in out Instance) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos + Size_T'(5, 0);
         if This.Child_Pos.X > 0 then
            This.Child_Pos.X := 0;
         end if;
      end if;
   end Go_Left;

   --------------
   -- Go_Right --
   --------------

   procedure Go_Right (This : in out Instance) is
   begin
      if This.Child /= null then
         This.Child_Pos := This.Child_Pos - (5, 0);
         if This.Child_Pos.X < (This.Get_Size.W - This.Child.Get_Size.W) then
            This.Child_Pos.X := (This.Get_Size.W - This.Child.Get_Size.W);
         end if;
      end if;
   end Go_Right;

end Giza.Widget.Scrolling;
