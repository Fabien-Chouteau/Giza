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

package body Giza.Images.Bitmap is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Editable_Bitmap_Image;
      Ctx  : in out Context'Class)
   is
   begin
      Ctx.Copy_Bitmap (Bmp => This.Data.Data,
                       Pt  => (0, 0));
   end Draw;

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Editable_Bitmap_Image)
      return Size_T
   is
   begin
      return (This.Width, This.Height);
   end Size;

   ---------
   -- Set --
   ---------

   procedure Set
     (This : in out Editable_Bitmap_Image;
      Bmp : Giza.Bitmaps.Bitmap)
   is
   begin
      This.Ctx.Set_Backend (This.Data'Access);
      This.Ctx.Copy_Bitmap (Bmp, (0, 0));
   end Set;

   -----------------
   -- Get_Context --
   -----------------

   function Get_Context
     (This : in out Editable_Bitmap_Image)
      return not null Context_Ref
   is
   begin
      This.Ctx.Set_Backend (This.Data'Unchecked_Access);
      return This.Ctx'Unchecked_Access;
   end Get_Context;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Bitmap_Image;
      Ctx  : in out Context'Class)
   is
   begin
      Ctx.Copy_Bitmap (Bmp => This.Data.all,
                       Pt  => (0, 0));
   end Draw;

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Bitmap_Image)
      return Size_T
   is
   begin
      return (This.Data.W, This.Data.H);
   end Size;

   ---------------------
   -- Indexed_Bitmaps --
   ---------------------

   package body Indexed_Bitmaps is

      ----------
      -- Draw --
      ----------

      overriding
      procedure Draw (This : in out Bitmap_Indexed_Image;
                      Ctx  : in out Context'Class)
      is
      begin
         Ctx.Set_Position ((0, 0));
         for W in 1 .. This.Data.W loop
            for H in 1 .. This.Data.H loop
               Ctx.Set_Color (This.Data.Palette (This.Data.Data (H, W)));
               Ctx.Set_Pixel (Point_T'(W - 1, H - 1));
            end loop;
         end loop;
      end Draw;

      ----------
      -- Size --
      ----------

      overriding
      function Size (This : Bitmap_Indexed_Image) return Size_T
      is
      begin
         return (This.Data.W, This.Data.H);
      end Size;
   end Indexed_Bitmaps;

end Giza.Images.Bitmap;
