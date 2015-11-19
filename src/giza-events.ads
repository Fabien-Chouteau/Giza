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

with Giza.Graphics; use Giza.Graphics;

package Giza.Events is

   type Event is abstract tagged null record;
   type Event_Ref is access constant Event'Class;
   type Event_Not_Null_Ref is not null access constant Event'Class;

   --  Built-in events

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
