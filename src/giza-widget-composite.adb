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

with Ada.Unchecked_Deallocation;
with Giza.Widget.Background; use Giza.Widget.Background;

package body Giza.Widget.Composite is

   procedure Free is new Ada.Unchecked_Deallocation (Wrapper, Wrapper_Ref);

   ---------------
   -- Set_Dirty --
   ---------------

   overriding
   procedure Set_Dirty (This  : in out Instance;
                        Dirty : Boolean := True)
   is
      Ref : Wrapper_Ref := This.List;
   begin
      Set_Dirty (Parent (This), Dirty);
      while Ref /= null loop
         Ref.Widg.Set_Dirty (Dirty);
         Ref := Ref.Next;
      end loop;
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This  : in out Instance;
      Ctx   : in out Context.Class;
      Force : Boolean := True)
   is
      Ref : Wrapper_Ref := This.List;
   begin
      Draw (Parent (This), Ctx, Force);
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
     (This : in out Instance;
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
     (This : in out Instance;
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
     (This  : in out Instance;
      Child : not null Widget.Reference;
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
     (This  : in out Instance;
      Child : not null Widget.Reference)
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

end Giza.Widget.Composite;
