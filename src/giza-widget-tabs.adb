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

package body Giza.Widget.Tabs is

   ---------------
   -- Set_Dirty --
   ---------------

   overriding
   procedure Set_Dirty (This : in out Instance;
                        Dirty : Boolean := True)
   is
   begin
      Set_Dirty (Parent (This), Dirty);
      This.Root.Set_Dirty (Dirty);
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This : in out Instance;
                   Ctx : in out Context.Class;
                   Force : Boolean := True) is
   begin
      This.Root.Draw (Ctx, Force);
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
      if This.Root.On_Position_Event (Evt, Pos) then
         for Index in This.Tabs'Range loop
            if Index /= This.Selected
              and then
                This.Tabs (Index).Btn.Active
            then
               This.Set_Selected (Index);
               exit;
            end if;
         end loop;
         This.Tabs (This.Selected).Btn.Set_Active;
         return True;
      else
         return False;
      end if;
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
      return This.Root.On_Event (Evt);
   end On_Event;

   -------------
   -- Set_Tab --
   -------------

   procedure Set_Tab
     (This  : in out Instance;
      Index : Natural;
      Title : String;
      Child : not null Widget.Reference)
   is
      Tabs_H : constant Integer := This.Get_Size.H / 4;
   begin
      if not This.Init then
         --  Initialization (This could/should be done only once...)
         This.Root.Set_Size (This.Get_Size);
         This.Tabs_Group.Set_Size ((This.Get_Size.W, Tabs_H));
         This.Tabs_Group.Set_Background (This.Get_Foreground);
         This.Root.Add_Child (This.Tabs_Group'Unchecked_Access, (0, 0));
         This.Init := True;
      end if;

      if Index in This.Tabs'Range then
         This.Tabs (Index).Widg := Child;
         Child.Set_Size (This.Get_Size - (0, Tabs_H + 1));
         Child.Set_Dirty;
         This.Tabs (Index).Btn.Set_Text (Title);
         This.Tabs (Index).Btn.Set_Foreground (This.Get_Foreground);
         This.Tabs (Index).Btn.Set_Background (This.Get_Background);
         This.Tabs (Index).Btn.Disable_Frame;
         This.Tabs (Index).Btn.Set_Toggle (True);

         This.Tabs_Group.Set_Child (Index,
                                    This.Tabs (Index).Btn'Unchecked_Access);
         This.Set_Selected (Index);
      end if;
   end Set_Tab;

   --------------
   -- Selected --
   --------------

   function Selected (This : Instance) return Natural is (This.Selected);

   ------------------
   -- Set_Selected --
   ------------------

   procedure Set_Selected (This : in out Instance; Selected : Natural) is
   begin
      if Selected in This.Tabs'Range
        and then
         This.Tabs (Selected).Widg /= null
      then
         This.Root.Remove_Child (This.Tabs (This.Selected).Widg);
         This.Selected := Selected;
         This.Tabs (This.Selected).Widg.Set_Dirty;
         This.Root.Add_Child (This.Tabs (This.Selected).Widg,
                              (0, This.Tabs_Group.Get_Size.H + 1));

         for Index in This.Tabs'Range loop
            This.Tabs (Index).Btn.Set_Active (Index = Selected);
            This.Tabs (Index).Btn.Set_Disabled (Index = Selected);
         end loop;
      end if;
   end Set_Selected;

end Giza.Widget.Tabs;
