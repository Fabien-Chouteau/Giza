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

with Giza.Widget.Composite;
use Giza.Widget;

package Giza.Window is

   subtype Parent is Composite.Instance;
   type Instance is abstract new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   procedure On_Pushed (This : in out Instance);

   procedure On_Init (This : in out Instance) is abstract;
   procedure On_Displayed (This : in out Instance) is abstract;
   procedure On_Hidden (This : in out Instance) is abstract;

private
   type Instance is abstract new Parent with record
      Initialized : Boolean := False;
   end record;
end Giza.Window;
