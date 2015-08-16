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

   function Dirty (This : Widget) return Boolean;
   procedure Set_Dirty (This : in out Widget; Dirty : Boolean);
   procedure Draw (This : in out Widget; Ctx : in out Context'Class) is null;

   procedure Set_Size (This : in out Widget; Size : Size_T);
   function Get_Size (This : Widget) return Size_T;

   procedure On_Builtin_Event
     (This : in out Widget;
      Evt : Event_Not_Null_Access) is abstract;
   procedure On_Custom_Event
     (This : in out Widget;
      Evt : Event_Not_Null_Access) is null;
   --  This subprogram should be overriden when custom event are used

private
   type Widget is abstract tagged record
      Is_Dirty : Boolean := True;
      Size : Size_T := (0, 0);
--        Next : access Widget'Class := null;
   end record;
end Giza.Widgets;
