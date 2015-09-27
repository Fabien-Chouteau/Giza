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
with Giza.Windows; use Giza.Windows;
with Giza.Graphics; use Giza.Graphics;

package Giza.GUI is

   procedure Emit (Evt : not null access Event'Class);
   --  Put an event that will be processed by the Event_Loop

   procedure Event_Loop with No_Return;
   --  Non returning loop that will process GUI events

   procedure Set_Context (Ctx : Context_Ref);
   --  Set the context that will be used for widgets rendering

   procedure Set_Backend (Bck : Backend_Ref);
   --  Set the graphical backend that will be used for widgets rendering

   procedure Push (Win : not null Window_Ref);
   --  Push a Window to the stack and display it

   procedure Pop;
   --  Remove first Window from the stack and display the next one
end Giza.GUI;
