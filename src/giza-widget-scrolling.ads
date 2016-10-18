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

with Ada.Real_Time; use Ada.Real_Time;
with Giza.Widget.Frame; use Giza.Widget.Frame;
with Giza.Widget.Button;
use Giza;
use Giza.Widget;

package Giza.Widget.Scrolling is

   subtype Parent is Frame.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Set_Dirty (This  : in out Instance;
                        Dirty : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Instance;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   overriding
   function On_Event
     (This : in out Instance;
      Evt  : Event_Not_Null_Ref) return Boolean;

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   procedure Set_Child (This  : in out Instance;
                        Child : not null Widget.Reference);

   procedure Go_Up (This : in out Instance);
   procedure Go_Down (This : in out Instance);
   procedure Go_Left (This : in out Instance);
   procedure Go_Right (This : in out Instance);

private

   type Repeat_Event is new Timer_Event with record
      Scroll : Ref;
   end record;

   overriding
   function Triggered (This : Repeat_Event) return Boolean;

   type Instance is new Parent with record
      Repeat_Time : Time_Span := Milliseconds (100);
      Repeat_Evt  : aliased Repeat_Event;
      Child       : Widget.Reference := null;
      Up, Down    : Button.Instance;
      Child_Pos   : Point_T := (0, 0);
   end record;
end Giza.Widget.Scrolling;
