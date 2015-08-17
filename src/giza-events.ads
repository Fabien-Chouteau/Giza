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
   type Event_Access is access all Event'Class;
   type Event_Not_Null_Access is not null access all Event'Class;

   --  Built-in events
   type Click_Type is (Click_None, Click_Press, Click_Release, Click_Move);
   type Click_Event is new Event with record
      CType : Click_Type := Click_None;
      Pos   : Point_T := (0, 0);
   end record;
   type Click_Event_Ref is not null access constant Click_Event'Class;

   type Basic_Timer_Callback is access procedure;
   type Timer_Event is new Event with record
      Callback : Basic_Timer_Callback;
   end record;
   type Timer_Event_Ref is not null access constant Timer_Event'Class;

   procedure Triggered (Timer : in out Timer_Event);
end Giza.Events;
