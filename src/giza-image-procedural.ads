-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)         --
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

with Giza.Context;

package Giza.Image.Procedural is

   type Draw_Proc_Ref is access procedure (Ctx  : in out Giza.Context.Class;
                                           Size : Size_T);

   subtype Parent is Image.Instance;
   type Instance (Proc          : not null Draw_Proc_Ref;
                  Widht, Height : Natural) is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   function Size (This : Instance) return Size_T;

private

   type Instance (Proc          : not null Draw_Proc_Ref;
                  Widht, Height : Natural) is new Parent with null record;

end Giza.Image.Procedural;
