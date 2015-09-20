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

package Giza.Widgets.Composite is
   type Composite_Widget is new Widget with private;

   overriding
   function Dirty (This : Composite_Widget) return Boolean;

   overriding
   procedure Draw (This : in out Composite_Widget;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   overriding
   procedure On_Click
     (This  : in out Composite_Widget;
      Pos   : Point_T;
      CType : Click_Type);

   procedure Add_Child
     (This  : in out Composite_Widget;
      Child : not null Widget_Ref;
      Pos   : Point_T);

   procedure Remove_Child
     (This  : in out Composite_Widget;
      Child : not null Widget_Ref);

private

   type Wrapper;
   type Wrapper_Ref is access all Wrapper;

   type Wrapper is record
      Pos  : Point_T := (0, 0);
      Widg : not null Widget_Ref;
      Next : Wrapper_Ref := null;
   end record;

   type Composite_Widget is new Widget with record
      List : Wrapper_Ref := null;
   end record;

end Giza.Widgets.Composite;
