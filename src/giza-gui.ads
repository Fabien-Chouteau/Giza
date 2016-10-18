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

with Giza.Events; use Giza.Events;
with Giza.Window; use Giza.Window;
with Giza.Context; use Giza.Context;
with Giza.Backend; use Giza.Backend;

package Giza.GUI is

   procedure Emit (Evt : Event_Not_Null_Ref);
   --  Put an event that will be processed by the Event_Loop

   procedure Event_Loop with No_Return;
   --  Non returning loop that will process GUI events

   procedure Set_Context (Ctx : Context.Ref);
   --  Set the context that will be used for widgets rendering

   procedure Set_Backend (Bck : Backend.Ref);
   --  Set the graphical backend that will be used for widgets rendering

   procedure Push (Win : not null Giza.Window.Ref);
   --  Push a Window to the stack and display it

   procedure Pop;
   --  Remove first Window from the stack and display the next one
end Giza.GUI;
