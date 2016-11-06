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

with Giza.Image.Bitmap;
with Giza.Image.Bitmap.Indexed_1bit;
with Giza.Image.Bitmap.Indexed_2bits;
with Giza.Image.Bitmap.Indexed_4bits;
with Giza.Image.Bitmap.Indexed_8bits;
with Giza.Image.Editable_Bitmap;
with Giza.Image.DMA2D;

package body Giza.Backend is

   procedure Copy_DMA2D_Bitmap (This   : in out Instance;
                                Bmp    : Giza.Image.DMA2D.Instance;
                                Pt     : Point_T);

   -----------------------
   -- Copy_DMA2D_Bitmap --
   -----------------------

   procedure Copy_DMA2D_Bitmap (This   : in out Instance;
                                Bmp    : Giza.Image.DMA2D.Instance;
                                Pt     : Point_T)
   is
      use Giza.Image.DMA2D;
   begin
      for X in 0 .. Bmp.W - 1 loop
         for Y in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Get_Pixel (Bmp, (X, Y)));
            Set_Pixel (Class (This), Pt + Point_T'(X, Y));
         end loop;
      end loop;
   end Copy_DMA2D_Bitmap;

   ----------
   -- Line --
   ----------

   procedure Line (This : in out Instance; Start, Stop : Point_T) is
      DX     : constant Float := abs Float (Stop.X - Start.X);
      DY     : constant Float := abs Float (Stop.Y - Start.Y);
      Err    : Float;
      X      : Dim        := Start.X;
      Y      : Dim        := Start.Y;
      Step_X : Integer        := 1;
      Step_Y : Integer        := 1;

   begin
      if Start.X > Stop.X then
         Step_X := -1;
      end if;

      if Start.Y > Stop.Y then
         Step_Y := -1;
      end if;

      if DX > DY then
         Err := DX / 2.0;
         while X /= Stop.X loop
            Set_Pixel (Class (This), (X, Y));
            Err := Err - DY;
            if Err < 0.0 then
               Y := Y + Step_Y;
               Err := Err + DX;
            end if;
            X := X + Step_X;
         end loop;
      else
         Err := DY / 2.0;
         while Y /= Stop.Y loop
            Set_Pixel (Class (This), (X, Y));
            Err := Err - DX;
            if Err < 0.0 then
               X := X + Step_X;
               Err := Err + DY;
            end if;
            Y := Y + Step_Y;
         end loop;
      end if;

      Set_Pixel (Class (This), (X, Y));
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   procedure Rectangle (This : in out Instance; Start, Stop : Point_T) is
   begin
      Line (Class (This), Start, (Stop.X, Start.Y));
      Line (Class (This), (Stop.X, Start.Y), Stop);
      Line (Class (This), Stop, (Start.X, Stop.Y));
      Line (Class (This), (Start.X, Stop.Y), Start);
   end Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   procedure Fill_Rectangle (This : in out Instance; Start, Stop : Point_T) is
      P1 : Point_T := Start;
      P2 : Point_T := (Start.X, Stop.Y);
   begin
      loop
         Line (Class (This), P2, P1);
         exit when P2.X = Stop.X;
         P1.X := P1.X + 1;
         P2.X := P2.X + 1;
      end loop;
   end Fill_Rectangle;

   ----------------
   -- Draw_Image --
   ----------------

   procedure Draw_Image
     (This : in out Instance;
      Img  : Giza.Image.Class;
      Pt   : Point_T)
   is
   begin
      if Img in Giza.Image.Bitmap.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Bitmap.Instance (Img).Data.all,
                      Pt);
      elsif Img in Giza.Image.Editable_Bitmap.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Editable_Bitmap.Instance (Img).Data,
                      Pt);
      elsif Img in Giza.Image.Bitmap.Indexed_1bit.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Bitmap.Indexed_1bit.Instance (Img).Data.all,
                      Pt);
      elsif Img in Giza.Image.Bitmap.Indexed_2bits.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Bitmap.Indexed_2bits.Instance (Img).Data.all,
                      Pt);
      elsif Img in Giza.Image.Bitmap.Indexed_4bits.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Bitmap.Indexed_4bits.Instance (Img).Data.all,
                      Pt);
      elsif Img in Giza.Image.Bitmap.Indexed_8bits.Class then
         Copy_Bitmap (Class (This),
                      Giza.Image.Bitmap.Indexed_8bits.Instance (Img).Data.all,
                      Pt);
      elsif Img in Giza.Image.DMA2D.Instance then
         Copy_DMA2D_Bitmap (This, Giza.Image.DMA2D.Instance (Img), Pt);
      else
         raise Program_Error with "Unsupported image type";
      end if;
   end Draw_Image;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Bitmap;
      Pt     : Point_T)
   is
   begin
      for W in 0 .. Bmp.W - 1 loop
         for H in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Bitmaps.Get_Pixel (Bmp, (W, H)));
            Set_Pixel (Class (This), Pt + Point_T'(W, H));
         end loop;
      end loop;
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_1bit.Bitmap_Indexed;
      Pt     : Point_T)
   is
      use Giza.Bitmaps.Indexed_1bit;
   begin
      for W in 0 .. Bmp.W - 1 loop
         for H in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Get_Pixel (Bmp, (W, H)));
            Set_Pixel (Class (This), Pt + Point_T'(W, H));
         end loop;
      end loop;
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_2bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      use Giza.Bitmaps.Indexed_2bits;
   begin
      for W in 0 .. Bmp.W - 1 loop
         for H in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Get_Pixel (Bmp, (W, H)));
            Set_Pixel (Class (This), Pt + Point_T'(W, H));
         end loop;
      end loop;
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_4bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      use Giza.Bitmaps.Indexed_4bits;
   begin
      for W in 0 .. Bmp.W - 1 loop
         for H in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Get_Pixel (Bmp, (W, H)));
            Set_Pixel (Class (This), Pt + Point_T'(W, H));
         end loop;
      end loop;
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_8bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      use Giza.Bitmaps.Indexed_8bits;
   begin
      for W in 0 .. Bmp.W - 1 loop
         for H in 0 .. Bmp.H - 1 loop
            Set_Color (Class (This), Get_Pixel (Bmp, (W, H)));
            Set_Pixel (Class (This), Pt + Point_T'(W, H));
         end loop;
      end loop;
   end Copy_Bitmap;

end Giza.Backend;
