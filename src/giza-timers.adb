------------------------------------------------------------------------------
--                                                                          --
--                                  Giza                                    --
--                                                                          --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)        --
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
with Ada.Real_Time.Timing_Events; use Ada.Real_Time.Timing_Events;
with Giza.GUI; use Giza.GUI;
with System;

package body Giza.Timers is

   type Wrapper;
   type Wrapper_Access is access all Wrapper;

   type Wrapper is record
      Event   : Timer_Event_Not_Null_Ref;
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
      pragma Priority (System.Interrupt_Priority'Last);

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
     (Timer : Timer_Event_Not_Null_Ref;
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
               Emit (Event_Not_Null_Ref (Tmp.Event));

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
