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

   Drawing_Context : Context_Ref := null;
   Drawing_Backend : Backend_Ref := null;

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
         Stack.Win.Draw (Drawing_Context.all, True);
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
            Stack.Win.Set_Dirty;
         end if;
      end if;
   end Pop;

   -----------------
   -- Set_Context --
   -----------------

   procedure Set_Context (Ctx : Context_Ref) is
   begin
      Drawing_Context := Ctx;
      if Drawing_Context /= null then
         Drawing_Context.Set_Backend (Drawing_Backend);
      end if;
   end Set_Context;

   -----------------
   -- Set_Backend --
   -----------------

   procedure Set_Backend (Bck : Backend_Ref) is

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
      entry Wait_For_Event (Evt : out Event_Ref);
      procedure Emit (Evt : Event_Not_Null_Ref);
   private
      Has_Event : Boolean;
      Even     : Event_Ref := null;
   end Event_Sync;

   ----------------
   -- Event_Sync --
   ----------------

   protected body Event_Sync is

      --------------------
      -- Wait_For_Event --
      --------------------

      entry Wait_For_Event (Evt : out Event_Ref) when Has_Event is
      begin
         Evt := Even;

         Has_Event := False;
         Even := null;
      end Wait_For_Event;

      ----------
      -- Emit --
      ----------

      procedure Emit (Evt : Event_Not_Null_Ref) is
      begin
         --  TODO: make it a list of events...
         Has_Event := True;
         Even := Event_Ref (Evt);
      end Emit;
   end Event_Sync;

   ----------
   -- Emit --
   ----------

   procedure Emit (Evt : Event_Not_Null_Ref) is
   begin
      Event_Sync.Emit (Evt);
   end Emit;

   ----------------
   -- Event_Loop --
   ----------------

   procedure Event_Loop is
      Event : Event_Ref;
      Event_Handled : Boolean;
   begin
      loop
         Event_Sync.Wait_For_Event (Event);
         if Event /= null and then Stack /= null then
            if Event.all in Timer_Event'Class then
               Timer_Event'Class (Event.all).Triggered;
            elsif Event.all in Position_Event'Class then
               declare
                  P_Evt : constant Position_Event_Ref :=
                    Position_Event_Ref (Event);
               begin
                  Event_Handled :=
                    Stack.Win.On_Position_Event (P_Evt, P_Evt.Pos);
               end;
            else
               Event_Handled :=
                 Stack.Win.On_Event (Event_Not_Null_Ref (Event));
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
