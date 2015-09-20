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

package body Giza.GUI is

   type Wrapper;
   type Wrapper_Ref is access all Wrapper;

   type Wrapper is record
      Win : not null Window_Ref;
      Next : Wrapper_Ref := null;
   end record;

   procedure Free is new Ada.Unchecked_Deallocation (Wrapper, Wrapper_Ref);

   Drawing_Context : access Context'Class := null;
   Drawing_Backend : access Backend'Class := null;

   --  Window stack
   Stack : Wrapper_Ref := null;

   ----------
   -- Push --
   ----------

   procedure Push (Win : not null Window_Ref) is
   begin

      if Stack /= null then
         Stack.Win.On_Hidden;
      end if;

      Stack := new Wrapper'(Win => Win,
                            Next => Stack);

      Win.Set_Size (Drawing_Backend.Size);

      Win.On_Pushed;

      if Drawing_Context /= null then
         Stack.Win.Draw (Drawing_Context.all);
      end if;
   end Push;

   ---------
   -- Pop --
   ---------

   procedure Pop is
      Tmp : Wrapper_Ref := Stack;
   begin
      if Tmp /= null then
         Stack := Tmp.Next;
         Free (Tmp);

         if Stack /= null then
            Stack.Win.On_Displayed;
         end if;
      end if;
   end Pop;

   -----------------
   -- Set_Context --
   -----------------

   procedure Set_Context (Ctx : access Context'Class) is
   begin
      Drawing_Context := Ctx;
      if Drawing_Context /= null then
         Drawing_Context.Set_Backend (Drawing_Backend);
      end if;
   end Set_Context;

   -----------------
   -- Set_Backend --
   -----------------

   procedure Set_Backend (Bck : access Backend'Class) is

   begin
      Drawing_Backend := Bck;
      if Drawing_Context /= null then
         Drawing_Context.Set_Backend (Bck);
      end if;
   end Set_Backend;

   ----------------
   -- Event_Sync --
   ----------------

   protected Event_Sync is
      entry Wait_For_Event (Evt : out Event_Access);
      procedure Emit (Evt : not null access Event'Class);
   private
      Has_Event : Boolean;
      Even     : access Event'Class := null;
   end Event_Sync;

   ----------------
   -- Event_Sync --
   ----------------

   protected body Event_Sync is

      --------------------
      -- Wait_For_Event --
      --------------------

      entry Wait_For_Event (Evt : out Event_Access) when Has_Event is
      begin
         Evt := Event_Access (Even);

         Has_Event := False;
         Even := null;
      end Wait_For_Event;

      ----------
      -- Emit --
      ----------

      procedure Emit (Evt : not null access Event'Class) is
      begin
         --  TODO: make it a list of events...
         Has_Event := True;
         Even := Evt;
      end Emit;
   end Event_Sync;

   ----------
   -- Emit --
   ----------

   procedure Emit (Evt : not null access Event'Class) is
   begin
      Event_Sync.Emit (Evt);
   end Emit;

   ----------------
   -- Event_Loop --
   ----------------

   procedure Event_Loop is
      Event : Event_Access;
      Event_Handled : Boolean;
   begin
      loop
         Event_Sync.Wait_For_Event (Event);
         if Event /= null and then Stack /= null then
            if Event.all in Timer_Event then
               Timer_Event'Class (Event.all).Triggered;
            else
               Event_Handled :=
                 Stack.Win.On_Builtin_Event (Event_Not_Null_Access (Event));
            end if;
         end if;

         if Stack /= null
           and then
            Drawing_Context /= null
           and then
            Event_Handled
         then
            Stack.Win.Draw (Drawing_Context.all, False);
         end if;
      end loop;
   end Event_Loop;
end Giza.GUI;
