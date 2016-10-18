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
with Giza.Context; use Giza.Context;
with Giza.Types; use Giza.Types;

package Giza.Widget is

   type Instance is abstract tagged private;
   subtype Class is Instance'Class;
   type Reference is access all Class;

   type Widget_Ref_Array is array (Positive range <>) of Reference;

   function Dirty (This : Instance) return Boolean;
   procedure Set_Dirty (This : in out Instance; Dirty : Boolean := True);
   procedure Draw (This : in out Instance;
                   Ctx : in out Context.Class;
                   Force : Boolean := True) is null;

   procedure Set_Disabled (This : in out Instance; Disabled : Boolean := True);
   --  When a Instance is disabled, it will no longer react to events

   procedure Set_Size (This : in out Instance; Size : Size_T);
   function Get_Size (This : Instance) return Size_T;

   function On_Position_Event
     (This : in out Instance;
      Evt : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   function On_Event
     (This : in out Instance;
      Evt : Event_Not_Null_Ref) return Boolean;

   function On_Click
     (This  : in out Instance;
      Pos   : Point_T) return Boolean is (False);

   function On_Click_Released
     (This  : in out Instance) return Boolean is (False);

private
   type Instance is abstract tagged record
      Is_Dirty    : Boolean := True;
      Is_Disabled : Boolean := False;
      Size : Size_T := (0, 0);
--        Next : access Instance'Class := null;
   end record;
end Giza.Widget;
