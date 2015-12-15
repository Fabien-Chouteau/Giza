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

package Giza.Widgets.Text is

   type Gtext is new Gframe with private;

   type Gtext_Ref is access all Gtext'Class;

   overriding
   procedure Draw (This : in out Gtext;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_Text (This : in out Gtext; Str : String);
   function Text (This : Gtext) return String;

private
   type String_Access is access all String;

   type Gtext is new Gframe with record
      Str : String_Access := null;
   end record;
end Giza.Widgets.Text;
