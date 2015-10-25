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
with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Widgets.Button; use Giza.Widgets.Button;

package Giza.Widgets.Scrolling is
   type Gscroll is new Gframe with private;

   type Gscroll_Ref is access all Gscroll'Class;

   overriding
   procedure Set_Dirty (This : in out Gscroll;
                        Dirty : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Gscroll;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   overriding
   function On_Event
     (This : in out Gscroll;
      Evt  : Event_Not_Null_Ref) return Boolean;

   overriding
   procedure Draw (This : in out Gscroll;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_Child (This : in out Gscroll; Child : not null Widget_Ref);

   procedure Go_Up (This : in out Gscroll);
   procedure Go_Down (This : in out Gscroll);
   procedure Go_Left (This : in out Gscroll);
   procedure Go_Right (This : in out Gscroll);

private

   type Repeat_Event is new Timer_Event with record
      Scroll : Gscroll_Ref;
   end record;

   procedure Triggered (This : Repeat_Event);

   type Gscroll is new Gframe with record
      Repeat_Time : Time_Span := Milliseconds (100);
      Repeat_Evt  : aliased Repeat_Event;
      Child       : Widget_Ref := null;
      Up, Down    : Gbutton;
      Child_Pos   : Point_T := (0, 0);
   end record;
end Giza.Widgets.Scrolling;
