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

package Giza.Widget.Background is

   subtype Parent is Widget.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Reference is access all Class;

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   procedure Set_Background (This : in out Instance; BG : Color);
   function Get_Background (This : Instance) return Color;

   procedure Set_Rounded (This   : in out Instance;
                          Radius : Dim);
   --  Set to 0 (default) to disable rounded corners

   function Radius (This : Instance) return Dim;

private
   type Instance is new Parent with record
      BG     : Color := White;
      Radius : Dim   := 0;
   end record;
end Giza.Widget.Background;
