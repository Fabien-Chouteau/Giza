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
with Giza.Graphics; use Giza.Graphics;

package Giza.Widgets is
   type Widget is abstract tagged private;
   type Widget_Ref is access all Widget'Class;
   type Not_Null_Widget_Ref is not null access all Widget'Class;

   type Widget_Ref_Array is array (Positive range <>) of Widget_Ref;

   function Dirty (This : Widget) return Boolean;
   procedure Set_Dirty (This : in out Widget; Dirty : Boolean := True);
   procedure Draw (This : in out Widget;
                   Ctx : in out Context'Class;
                   Force : Boolean := True) is null;

   procedure Set_Disabled (This : in out Widget; Disabled : Boolean := True);
   --  When a widget is disabled, it will no longer react to events

   procedure Set_Size (This : in out Widget; Size : Size_T);
   function Get_Size (This : Widget) return Size_T;

   function On_Position_Event
     (This : in out Widget;
      Evt : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   function On_Event
     (This : in out Widget;
      Evt : Event_Not_Null_Ref) return Boolean;

   function On_Click
     (This  : in out Widget;
      Pos   : Point_T) return Boolean is (False);

   function On_Click_Released
     (This  : in out Widget) return Boolean is (False);

private
   type Widget is abstract tagged record
      Is_Dirty    : Boolean := True;
      Is_Disabled : Boolean := False;
      Size : Size_T := (0, 0);
--        Next : access Widget'Class := null;
   end record;
end Giza.Widgets;
