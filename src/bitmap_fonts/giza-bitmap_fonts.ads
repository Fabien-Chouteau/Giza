with Interfaces; use Interfaces;

package Giza.Bitmap_Fonts is
   type Font_Bitmap is array (Positive range <>) of Unsigned_8;
   type Font_Bitmap_Ref is not null access constant Font_Bitmap;

   type Bitmap_Glyph is record
      BitmapOffset       : Unsigned_16;
      Width, Height      : Unsigned_8;
      X_Advance          : Unsigned_8;
      X_Offset, Y_Offset : Integer_8;
   end record;

   type Glyph_Array is array (Positive range <>) of Bitmap_Glyph;
   type Glyph_Array_Ref is not null access constant Glyph_Array;

   type Bitmap_Font is record
      Bitmap      : Font_Bitmap_Ref;
      Glyphs      : Glyph_Array_Ref;
      First, Last : Unsigned_8;
      Y_Advance   : Unsigned_8;
   end record;
end Giza.Bitmap_Fonts;
