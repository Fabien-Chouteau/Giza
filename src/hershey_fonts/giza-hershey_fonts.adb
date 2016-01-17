package body Giza.Hershey_Fonts is

   function Char_To_Glyph_Index (C : Character) return Glyph_Index;

   -------------------------
   -- Char_To_Glyph_Index --
   -------------------------

   function Char_To_Glyph_Index (C : Character) return Glyph_Index is
   begin
      return Character'Pos (C) - 31;
   end Char_To_Glyph_Index;

   ---------------
   -- Glyph_Box --
   ---------------

   overriding
   procedure Glyph_Box (This : Hershey_Font;
                        C    : Character;
                        Width, Height, X_Advance : out Natural;
                        X_Offset, Y_Offset : out Integer)
   is
      Index : constant Glyph_Index := Char_To_Glyph_Index (C);
   begin
      if Index not in This.Glyphs'Range then
         Width := 0;
         Height := 0;
         X_Offset := 0;
         Y_Offset := 0;
         X_Advance := 0;
         return;
      end if;

      Width := Integer (This.Glyphs (Index).Right - This.Glyphs (Index).Left);
      Height := Integer (This.Glyphs (Index).Bottom - This.Glyphs (Index).Top);
--        X_Advance := Integer (This.Glyphs (Index).Right);
      X_Advance := Width;
--        X_Offset := Integer (This.Glyphs (Index).Left);
      X_Offset := 0;
      Y_Offset := Integer (This.Glyphs (Index).Top);

   end Glyph_Box;

   -----------
   -- Print --
   -----------

--     overriding procedure Print
--       (This : Hershey_Font;
--        Ctx : in out Context'Class;
--        Str : String)
--     is
--     begin
--        null;
--     end Print;

   -----------
   -- Print --
   -----------

   overriding procedure Print_Glyph
     (This : Hershey_Font;
      Ctx : in out Context'Class;
      C : Character)
   is
      Index : constant Glyph_Index := Char_To_Glyph_Index (C);
      Last : Vect := Raise_Pen;
      G : Glyph_Access := Empty_Glyph'Access;
      Org : constant Point_T := Ctx.Position;
      Offset : Point_T;
   begin
      if Index not in This.Glyphs'Range then
         return;
      end if;

      G := This.Glyphs (Index);

      Offset := Org - Point_T'(Integer (G.Left), 0);
      for Vect of G.Vects loop
         if Vect /= Raise_Pen then
            if Last /= Raise_Pen then
               Ctx.Line_To (Offset +
                              Point_T'(Integer (Vect.X), Integer (Vect.Y)));
            else
               Ctx.Move_To (Offset +
                              Point_T'(Integer (Vect.X), Integer (Vect.Y)));
            end if;
         end if;
         Last := Vect;
      end loop;
      Ctx.Move_To ((Org.X + Integer (G.Right) - Integer (G.Left), Org.Y));
   end Print_Glyph;

   -------------------
   -- Print_In_Rect --
   -------------------

--     overriding procedure Print_In_Rect
--       (This : in out Hershey_Font;
--        Ctx : in out Context'Class;
--        Str : String;
--        Bounds : Rect_T)
--     is
--        Top, Bottom, Left, Right : Integer;
--        Pt : Point_T;
--        H, W : Integer;
--        Ratio, Ratio_H, Ratio_W : Float;
--     begin
--        if Str'Length = 0 then
--           return;
--        end if;
--
--        This.Set_Font_Size (1.0);
--
--        Pt := Center (Box);
--        This.Box (Str, Top, Bottom, Left, Right);
--        H := Bottom - Top;
--        W := Right - Left;
--        Ratio_W := Float (Box.Size.W) / Float (W);
--        Ratio_H := Float (Box.Size.H) / Float (H);
--        Ratio := (if Ratio_H < Ratio_W then  Ratio_H else Ratio_W);
--        Pt.X := Pt.X - Integer ((Float (W) / 2.0) * Ratio);
--        This.Move_To (Pt);
--        This.Set_Font_Size (Ratio);
--        This.Print (Str);
--     end Print_In_Rect;

   ---------
   -- Box --
   ---------

--     overriding
--     procedure Box (This                     : Hershey_Font;
--                    Str                      : String;
--                    Top, Bottom, Left, Right : out Integer)
--     is
--        T, B, L, R : Integer := 0;
--        G : Glyph_Access := Empty_Glyph'Access;
--        Index : Glyph_Index;
--     begin
--
--        L := 0;
--        R := L;
--
--        for C of Str loop
--           Index := Char_To_Glyph_Index (C);
--
--           if Index in This.Get_Font.Glyphs'Range then
--              G := This.Get_Font.Glyphs (Index);
--              if G.Top < T then
--                 T := G.Top;
--              end if;
--
--              if G.Bottom > B then
--                 B := G.Bottom;
--              end if;
--
--              R := R + (G.Right - G.Left) + This.Font_Spacing;
--           end if;
--        end loop;
--
--        Top := This.Position.Y + To_Scale (This, T);
--        Bottom := This.Position.Y + To_Scale (This, B);
--        Left := This.Position.X + To_Scale (This, L);
--        Right := This.Position.X + To_Scale (This, R);
--     end Box;

end Giza.Hershey_Fonts;
