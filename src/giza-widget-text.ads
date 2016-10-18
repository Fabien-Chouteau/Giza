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

with Giza.Widget.Frame; use Giza.Widget.Frame;

package Giza.Widget.Text is

   subtype Parent is Frame.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   type Instance_Ref is access all Instance'Class;

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   procedure Set_Text (This : in out Instance; Str : String);
   function Text (This : Instance) return String;

private
   type String_Access is access all String;

   type Instance is new Parent with record
      Str : String_Access := null;
   end record;
end Giza.Widget.Text;
