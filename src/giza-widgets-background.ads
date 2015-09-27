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

with Giza.Colors; use Giza.Colors;

package Giza.Widgets.Background is
   type Gbackground is new Widget with private;

   overriding
   procedure Draw (This : in out Gbackground;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_Background (This : in out Gbackground; BG : Color);
   function Background (This : Gbackground) return Color;
private
   type Gbackground is new Widget with record
      BG : Color := White;
   end record;
end Giza.Widgets.Background;
