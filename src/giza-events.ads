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

with Giza.Types; use Giza.Types;

package Giza.Events is

   type Event is abstract tagged null record;
   type Event_Ref is access constant Event'Class;
   type Event_Not_Null_Ref is not null access constant Event'Class;

   --  Built-in events

   type Redraw_Event is new Event with null record;
   type Redraw_Event_Ref is not null access constant Redraw_Event'Class;

   type Position_Event is new Event with record
      Pos   : Point_T := (0, 0);
   end record;
   type Position_Event_Ref is not null access constant Position_Event'Class;

   type Click_Event is new Position_Event with record
      Something : Boolean;
   end record;
   type Click_Event_Ref is not null access all Click_Event'Class;
   type Click_Event_Constant_Ref is not null access constant Click_Event'Class;

   type Click_Released_Event is new Event with record
      Something : Boolean;
   end record;

   type Click_Released_Event_Ref is not null access all
     Click_Released_Event'Class;

   type Timer_Event is new Event with null record;
   type Timer_Event_Not_Null_Ref is not null access constant Timer_Event'Class;

   function Triggered (Timer : Timer_Event) return Boolean is (True);

   type Basic_Timer_Callback is access function return Boolean;
   type Basic_Timer_Event is new Timer_Event with record
      Callback : Basic_Timer_Callback;
   end record;

   overriding
   function Triggered (Timer : Basic_Timer_Event) return Boolean;

end Giza.Events;
