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
   type Gtile (Number_Of_Widget : Positive) is new Gbackground with private;

   overriding
   procedure Set_Dirty (This : in out Gtile;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This : in out Gtile;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   overriding
   function On_Click
     (This  : in out Gtile;
      Pos   : Point_T;
      CType : Click_Type) return Boolean;

   procedure Set_Child
     (This  : in out Gtile;
      Index : Positive;
      Child : Widget_Ref);

   procedure Set_Spacing (This : in out Gtile; Spacing : Natural);
   procedure Set_Margin (This : in out Gtile; Margin : Natural);
private

   type Gtile (Number_Of_Widget : Positive) is new Gbackground with record
      Widgs   : Widget_Ref_Array (1 .. Number_Of_Widget) := (others => null);
      Spacing : Natural := 2;
      Margin  : Natural := 1;
   end record;

end Giza.Widgets.Tiles;
