------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)        --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

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
