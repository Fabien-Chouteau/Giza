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

with Giza.Bitmaps;

package Giza.Image.Editable_Bitmap is

   subtype Parent is Image.Instance;
   type Instance (Width, Height : Natural) is
     new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Draw (This : in out Instance;
                   Ctx  : in out Context'Class);

   overriding
   function Size (This : Instance) return Size_T;

   procedure Set (This : in out Instance;
                  Bmp : Giza.Bitmaps.Bitmap)
     with Pre => This.Width > Bmp.W and then This.Height > Bmp.H;

   function Get_Context (This : in out Instance)
                         return not null Context_Ref;

private

   type Instance (Width, Height : Natural) is
     new Parent with record
      Data : aliased Giza.Bitmaps.Bitmap_Backend (Width, Height);
      Ctx  : aliased Context;
   end record;

end Giza.Image.Editable_Bitmap;