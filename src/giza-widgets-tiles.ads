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

with Giza.Widgets.Background; use Giza.Widgets.Background;

package Giza.Widgets.Tiles is

   type Tile_Direction is (Top_Down, Bottom_Up, Right_Left, Left_Right);

   subtype Parent is Background.Instance;
   type Instance (Number_Of_Widget : Positive; Dir : Tile_Direction) is
     new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Set_Dirty (This : in out Instance;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This : in out Instance;
                   Ctx : in out Context'Class;
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

   procedure Set_Child
     (This  : in out Instance;
      Index : Positive;
      Child : Widgets.Reference);

   procedure Set_Spacing (This : in out Instance; Spacing : Natural);
   procedure Set_Margin (This : in out Instance; Margin : Natural);
private

   type Instance (Number_Of_Widget : Positive; Dir : Tile_Direction) is
     new Parent with record
      Widgs   : Widget_Ref_Array (1 .. Number_Of_Widget) := (others => null);
      Spacing : Natural := 2;
      Margin  : Natural := 1;
   end record;

end Giza.Widgets.Tiles;
