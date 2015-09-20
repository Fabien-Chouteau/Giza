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

with Giza.Widgets.Composite; use Giza.Widgets.Composite;
with Giza.Graphics; use Giza.Graphics;

package Giza.Windows is

   type Window is abstract new Composite_Widget with private;
   type Window_Ref is access all Window'Class;

   overriding
   procedure Draw (This : in out Window;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure On_Pushed (This : in out Window);

   procedure On_Init (This : in out Window) is abstract;
   procedure On_Displayed (This : in out Window) is abstract;
   procedure On_Hidden (This : in out Window) is abstract;

private
   type Window is abstract new Composite_Widget with record
      Initialized : Boolean := False;
   end record;
end Giza.Windows;
