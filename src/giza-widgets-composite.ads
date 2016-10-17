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

with Giza.Widgets.Background;

package Giza.Widgets.Composite is

   subtype Parent is Background.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Set_Dirty (This  : in out Instance;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context'Class;
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

   procedure Add_Child
     (This  : in out Instance;
      Child : not null Widgets.Reference;
      Pos   : Point_T);

   procedure Remove_Child
     (This  : in out Instance;
      Child : not null Widgets.Reference);

private

   type Wrapper;
   type Wrapper_Ref is access all Wrapper;

   type Wrapper is record
      Pos  : Point_T := (0, 0);
      Widg : not null Widgets.Reference;
      Next : Wrapper_Ref := null;
   end record;

   type Instance is new Parent with record
      List : Wrapper_Ref := null;
   end record;

end Giza.Widgets.Composite;
