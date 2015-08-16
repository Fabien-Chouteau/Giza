with Ada.Unchecked_Deallocation;
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

with Ada.Real_Time.Timing_Events; use Ada.Real_Time.Timing_Events;
with Giza.GUI; use Giza.GUI;

package body Giza.Timers is

   type Wrapper;
   type Wrapper_Access is access all Wrapper;

   type Wrapper is record
      Event   : not null access Timer_Event'Class;
      Timeout : Time;
      Next    : Wrapper_Access := null;
   end record;

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => Wrapper, Name => Wrapper_Access);

   TE : Timing_Event;

   ----------
   -- Sync --
   ----------

   protected Sync is
      entry Wait;
      procedure Wakeup (Event : in out Timing_Event);

      procedure Insert (Item : Wrapper_Access);
      function Next_Timeout return Time;
      procedure Pop (Item : out Wrapper_Access);
   private
      Triggered : Boolean := False;
      List : Wrapper_Access := null;
   end Sync;

   ----------
   -- Sync --
   ----------

   protected body Sync is
      entry Wait when Triggered is
      begin
         Triggered := False;
      end Wait;

      procedure Wakeup (Event : in out Timing_Event) is
         pragma Unreferenced (Event);
      begin
         Triggered := True;
      end Wakeup;

      procedure Insert (Item : Wrapper_Access) is
         Prev, Curr : Wrapper_Access := null;
      begin
         if List = null or else List.Timeout >= Item.Timeout then
            Item.Next := List;
            List := Item;

            Set_Handler (Event   => TE,
                         At_Time => List.Timeout,
                         Handler => Sync.Wakeup'Access);

         else
            Prev := List;
            Curr := List;

            while Curr /= null and then Curr.Timeout < Item.Timeout loop
               Prev := Curr;
               Curr := Curr.Next;
            end loop;

            Prev.Next := Item;
            Item.Next := Curr;
         end if;
      end Insert;

      function Next_Timeout return Time is
      begin
         return (if List /= null then
                    List.Timeout
                 else
                    Time_Last);
      end Next_Timeout;

      procedure Pop (Item : out Wrapper_Access) is
      begin
         --  Remove from list
         Item := List;
         List := List.Next;
      end Pop;

   end Sync;

   ---------------
   -- Set_Timer --
   ---------------

   procedure Set_Timer
     (Timer : not null access Timer_Event'Class;
      Timeout : Time)
   is
      Item : constant Wrapper_Access :=
        new Wrapper'(Event => Timer, Timeout => Timeout, Next => null);
   begin
      Sync.Insert (Item);
   end Set_Timer;

   ----------------
   -- Timer_Task --
   ----------------

   task Timer_Task is
   end Timer_Task;

   task body Timer_Task is
      Now : Time;
      Tmp : Wrapper_Access;
   begin
      loop
         Sync.Wait;

         --  back from timeout

         Now := Clock;
         while Sync.Next_Timeout < Now loop

            Sync.Pop (Tmp);
            if Tmp /= null then
               Emit (Tmp.Event);

               --  Destroy wrapper
               Free (Tmp);
            end if;
         end loop;

         Set_Handler (Event   => TE,
                      At_Time => Sync.Next_Timeout,
                      Handler => Sync.Wakeup'Access);
      end loop;
   end Timer_Task;

end Giza.Timers;
