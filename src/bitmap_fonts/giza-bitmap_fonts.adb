
package body Giza.Bitmap_Fonts is

   overriding
   procedure Glyph_Box (This : Bitmap_Font;
                        C    : Character;
                        Top, Bottom, Left, Right : out Integer) is
      Index : constant Integer := Character'Pos (C);
   begin
      if Index not in Integer (This.First) .. Integer (This.Last) then
         Top := 0;
         Bottom := 0;
         Left := 0;
         Right := 0;
      end if;
      Top := Integer (This.Glyphs (Index).Y_Offset);
      Left := Integer (This.Glyphs (Index).X_Offset);
      Bottom := Top + Integer (This.Glyphs (Index).Height);
      Right := Left + Integer (This.Glyphs (Index).Width);
   end Glyph_Box;

--     overriding
--     procedure Print (This : Bitmap_Font;
--                      Ctx  : in out Context'Class;
--                      Str  : String)
--     is
--     begin
--        null;
--     end Print;

   overriding
   procedure Print_Glyph (This : Bitmap_Font;
                          Ctx  : in out Context'Class;
                          C    : Character)
   is
      Index : Integer := Character'Pos (C);
      H, W, Xo, Yo, Xa : Integer;
      Bits : Unsigned_8 := 0;
      Bit  : Unsigned_8 := 0;
      Bitmap_Offset : Integer;
      Center : constant Point_T := Ctx.Position;
   begin
      if Index not in Integer (This.First) .. Integer (This.Last) then
         return;
      end if;

      Index := Index - Integer (This.First) + This.Glyphs'First;
      H := Integer (This.Glyphs (Index).Height);
      W := Integer (This.Glyphs (Index).Width);
      if H > 0 and then W > 0 then
         Xo := Integer (This.Glyphs (Index).X_Offset);
         Yo := Integer (This.Glyphs (Index).Y_Offset);
         Xa := Integer (This.Glyphs (Index).X_Advance);
         Bitmap_Offset := Integer (This.Glyphs (Index).BitmapOffset) +
           This.Bitmap'First;

         for Y in 1 .. H loop
            for X in 1 .. W loop
               if (Bit and 7) = 0 then
                  Bits := This.Bitmap (Bitmap_Offset);
                  Bitmap_Offset := Bitmap_Offset + 1;
               end if;
               Bit := Bit + 1;

               if (Bits and 16#80#) /= 0 then
                  Ctx.Set_Pixel
                    (Center + Point_T'(X, Y) +
                         Point_T'(Xo, Yo) +
                         Point_T'(0, 20));
               end if;
               Bits := Shift_Left (Bits, 1);
            end loop;
         end loop;
         Ctx.Move_To (Center + Point_T'(Xa, 0));
      end if;
   end Print_Glyph;

--     overriding
--     procedure Print (This   : Bitmap_Font;
--                      Ctx    : in out Context'Class;
--                      Str    : String;
--                      Bounds : Rect_T)
--     is
--     begin
--        null;
--     end Print;
--     overriding
--     procedure Box (This                     : Bitmap_Font;
--                    Str                      : String;
--                    Top, Bottom, Left, Right : out Integer)
--     is
--     begin
--        null;
--     end Box;

end Giza.Bitmap_Fonts;
