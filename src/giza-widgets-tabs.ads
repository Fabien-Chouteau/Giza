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

with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Widgets.Composite; use Giza.Widgets.Composite;
with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;

package Giza.Widgets.Tabs is
   type Gtabs (Tab_Number : Natural) is new Gframe with private;

   type Gtabs_Ref is access all Gtabs'Class;

   overriding
   procedure Set_Dirty (This : in out Gtabs;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This : in out Gtabs;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   overriding
   function On_Click
     (This  : in out Gtabs;
      Pos   : Point_T;
      CType : Click_Type) return Boolean;

   procedure Set_Tab
     (This  : in out Gtabs;
      Index : Natural;
      Title : String;
      Child : not null Widget_Ref);

   function Selected (This : Gtabs) return Natural;
   procedure Set_Selected (This : in out Gtabs; Selected : Natural);

private

   type Tab_Wrapper is record
      Widg   : Widget_Ref := null;
      Button : aliased Gbutton;
      Pos    : Point_T;
   end record;

   type Wrapper_Array is array (Positive range <>) of Tab_Wrapper;

   type Gtabs (Tab_Number : Natural) is new Gframe with record
      Init : Boolean := False;
      Selected   : Natural := 1;
      Tabs       : Wrapper_Array (1 .. Tab_Number);

      Root : aliased Composite_Widget;
      Tabs_Group : aliased Gtile (Tab_Number, Left_Right);
   end record;
end Giza.Widgets.Tabs;
