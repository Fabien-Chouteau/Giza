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

package Giza.Images.Bitmap is

   ---------------------------
   -- Editable_Bitmap_Image --
   ---------------------------

   type Editable_Bitmap_Image (Width, Height : Natural) is
     new Image with private;

   overriding
   procedure Draw (This : in out Editable_Bitmap_Image;
                   Ctx  : in out Context'Class);

   overriding
   function Size (This : Editable_Bitmap_Image) return Size_T;

   procedure Set (This : in out Editable_Bitmap_Image;
                  Bmp : Giza.Bitmaps.Bitmap)
     with Pre => This.Width > Bmp.W and then This.Height > Bmp.H;

   function Get_Context (This : in out Editable_Bitmap_Image)
                         return not null Context_Ref;

   ------------------
   -- Bitmap_Image --
   ------------------

   type Bitmap_Image (Data : not null Giza.Bitmaps.Bitmap_Ref) is
     new Image with private;

   overriding
   procedure Draw (This : in out Bitmap_Image;
                   Ctx  : in out Context'Class);

   overriding
   function Size (This : Bitmap_Image) return Size_T;

   generic
      with package Bitmaps is new Giza.Bitmaps.Indexed_Bitmaps (<>);
   package Indexed_Bitmaps is

      type Bitmap_Indexed_Image (Data : not null Bitmaps.Bitmap_Indexed_Ref) is
        new Image with private;

      overriding
      procedure Draw (This : in out Bitmap_Indexed_Image;
                      Ctx  : in out Context'Class);

      overriding
      function Size (This : Bitmap_Indexed_Image) return Size_T;

   private
      type Bitmap_Indexed_Image (Data : not null Bitmaps.Bitmap_Indexed_Ref) is
        new Image with null record;
   end Indexed_Bitmaps;

private

   type Editable_Bitmap_Image (Width, Height : Natural) is
     new Image with record
      Data : aliased Giza.Bitmaps.Bitmap_Backend (Width, Height);
      Ctx  : aliased Context;
   end record;

   type Bitmap_Image (Data : not null Giza.Bitmaps.Bitmap_Ref) is
     new Image with null record;

end Giza.Images.Bitmap;
