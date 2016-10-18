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

with Giza.Widget.Text;
use Giza.Widget;

package Giza.Widget.Button is

   subtype Parent is Text.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   function On_Click
     (This  : in out Instance;
      Pos   : Point_T) return Boolean;

   overriding
   function On_Click_Released
     (This  : in out Instance) return Boolean;

   function Active (This : Instance) return Boolean;

   procedure Set_Active (This : in out Instance; Active : Boolean := True);
   procedure Set_Toggle (This : in out Instance; Toggle : Boolean := True);

private
   type Instance is new Parent with record
      Is_Active : Boolean := False;
      Is_Toggle : Boolean := False;
   end record;
end Giza.Widget.Button;
