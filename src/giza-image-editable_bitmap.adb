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

package body Giza.Image.Editable_Bitmap is

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Instance)
      return Size_T
   is
   begin
      return (This.Width, This.Height);
   end Size;

   ---------
   -- Set --
   ---------

   procedure Set
     (This : in out Instance;
      Bmp  : Giza.Bitmaps.Bitmap)
   is
   begin
--        This.Ctx.Set_Backend (This.Data'Unchecked_Access);
      This.Ctx.Copy_Bitmap (Bmp, (0, 0));
   end Set;

   -----------------
   -- Get_Context --
   -----------------

   function Get_Context
     (This : in out Instance)
      return not null Context.Ref
   is
   begin
--        This.Ctx.Set_Backend (This.Data'Unchecked_Access);
      return This.Ctx'Unchecked_Access;
   end Get_Context;

   ----------
   -- Data --
   ----------

   function Data (This : Instance) return Giza.Bitmaps.Bitmap is
   begin
      return This.Data;
   end Data;

end Giza.Image.Editable_Bitmap;
