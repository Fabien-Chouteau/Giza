with bmp_test_rgb24;
with bmp_test_indexed_1bit;
with bmp_test_indexed_2bits;
with bmp_test_indexed_4bits;
with bmp_test_indexed_8bits;
with bmp_test_rgb24_dma2d;
with bmp_test_indexed_1bit_dma2d;
with bmp_test_indexed_2bits_dma2d;
with bmp_test_indexed_4bits_dma2d;
with bmp_test_indexed_8bits_dma2d;

package body Test_Images is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This  : in out Images_Window;
      Ctx   : in out Giza.Context.Class;
      Force : Boolean := True)
   is
      X : Natural := 0;
      Y : Natural := 0;
   begin
      Draw (Parent (This), Ctx, Force);

      Ctx.Draw_Image (bmp_test_rgb24.Image, (X, Y));
      X := X + bmp_test_rgb24.Image.Size.W;

      Ctx.Draw_Image (bmp_test_rgb24_dma2d.Image.all, (X, Y));
      X := 0;
      Y := Y + bmp_test_rgb24_dma2d.Image.Size.H + 10;

      Ctx.Draw_Image (bmp_test_indexed_8bits.Image, (X, Y));
      X := X + bmp_test_indexed_8bits.Image.Size.W;

      Ctx.Draw_Image (bmp_test_indexed_8bits_dma2d.Image.all, (X, Y));
      X := 0;
      Y := Y + bmp_test_indexed_8bits_dma2d.Image.Size.H  + 10;

      Ctx.Draw_Image (bmp_test_indexed_4bits.Image, (X, Y));
      X := X + bmp_test_indexed_4bits.Image.Size.W;

      Ctx.Draw_Image (bmp_test_indexed_4bits_dma2d.Image.all, (X, Y));
      X := 0;
      Y := Y + bmp_test_indexed_4bits_dma2d.Image.Size.H  + 10;

      Ctx.Draw_Image (bmp_test_indexed_2bits.Image, (X, Y));
      X := X + bmp_test_indexed_2bits.Image.Size.W;

      Ctx.Draw_Image (bmp_test_indexed_2bits_dma2d.Image.all, (X, Y));
      X := 0;
      Y := Y + bmp_test_indexed_2bits_dma2d.Image.Size.H  + 10;

      Ctx.Draw_Image (bmp_test_indexed_1bit.Image, (X, Y));
      X := X + bmp_test_indexed_1bit.Image.Size.W;

      Ctx.Draw_Image (bmp_test_indexed_1bit_dma2d.Image.all, (X, Y));
   end Draw;

end Test_Images;
