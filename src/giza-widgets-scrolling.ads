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

package Giza.Widgets.Scrolling is
   type Gscroll is new Gframe with private;

   type Gscroll_Ref is access all Gscroll'Class;

   overriding
   procedure Set_Dirty (This : in out Gscroll;
                        Dirty : Boolean := True);

   overriding
   function On_Click
     (This  : in out Gscroll;
      Pos   : Point_T;
      CType : Click_Type) return Boolean;

   overriding
   procedure Draw (This : in out Gscroll;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_Child (This : in out Gscroll; Child : not null Widget_Ref);

private
   type Gscroll is new Gframe with record
      Child     : Widget_Ref := null;
      Up, Down  : Gbutton;
      Child_Pos : Point_T := (0, 0);
   end record;
end Giza.Widgets.Scrolling;
