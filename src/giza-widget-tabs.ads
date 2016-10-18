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

with Giza.Widget.Frame; use Giza.Widget.Frame;
with Giza.Widget.Button; use Giza.Widget.Button;
with Giza.Widget.Composite; use Giza.Widget.Composite;
with Giza.Widget.Tiles; use Giza.Widget.Tiles;

package Giza.Widget.Tabs is

   subtype Parent is Frame.Instance;
   type Instance (Tab_Number : Natural) is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   type Instance_Ref is access all Instance'Class;

   overriding
   procedure Set_Dirty (This  : in out Instance;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Instance;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   overriding
   function On_Event
     (This : in out Instance;
      Evt  : Event_Not_Null_Ref) return Boolean;

   procedure Set_Tab
     (This  : in out Instance;
      Index : Natural;
      Title : String;
      Child : not null Widget.Reference);

   function Selected (This : Instance) return Natural;
   procedure Set_Selected (This : in out Instance; Selected : Natural);

private

   type Tab_Wrapper is record
      Widg   : Widget.Reference := null;
      Btn    : aliased Button.Instance;
      Pos    : Point_T;
   end record;

   type Wrapper_Array is array (Positive range <>) of Tab_Wrapper;

   type Instance (Tab_Number : Natural) is new Parent with record
      Init : Boolean := False;
      Selected   : Natural := 1;
      Tabs       : Wrapper_Array (1 .. Tab_Number);

      Root : aliased Composite.Instance;
      Tabs_Group : aliased Tiles.Instance (Tab_Number, Left_Right);
   end record;
end Giza.Widget.Tabs;
