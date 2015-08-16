-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)         --
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

package body Giza.Graphics is

   function Char_To_Glyph_Index (C : Character) return Dim;
   function To_Scale (This : Context; A : Integer)
                      return Integer;
   procedure Draw_Glyph (This     : in out Context;
                         Charcode : Positive);

   ------------
   -- Center --
   ------------

   function Center (R : Rect_T) return Point_T is
   begin
      return (R.Org.X + R.Size.W / 2, R.Org.Y + R.Size.H / 2);
   end Center;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (This : in out Backend; Pt : Point_T) is
   begin
      --  Default backend, doing nothing...
      null;
   end Set_Pixel;

   ---------------
   -- Set_Colorr --
   ---------------

   procedure Set_Color (This : in out Backend; C : Color) is
   begin
      --  Default backend, doing nothing...
      null;
   end Set_Color;
   ----------
   -- Size --
   ----------

   function Size (This : Backend) return Size_T is
      pragma Unreferenced (This);
   begin
      --  Default backend, doing nothing...
      return (0, 0);
   end Size;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (This : in out Context; Pt : Point_T) is
      Translate : Point_T;
   begin
      if This.Bck = null
        or else
          Pt.X not in 0 .. This.Bounds.Size.W
        or else
          Pt.Y not in 0 .. This.Bounds.Size.H
      then
         --  Out of bounds
         return;
      end if;

--        Put_Line ("Point X:" & Pt.X'Img
--                 & " Y:" & Pt.Y'Img);
--        Put_Line ("Origin X:" & This.Bounds.Org.X'Img
--                 & " Y:" & This.Bounds.Org.Y'Img);
      Translate := Pt + This.Bounds.Org;
--        Put_Line ("Translated X:" & Translate.X'Img
--                 & " Y:" & Translate.Y'Img);

      This.Bck.Set_Pixel (Translate);
   end Set_Pixel;

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color (This : in out Context; C : Color) is
   begin
      This.Bck.Set_Color (C);
   end Set_Color;

   ----------------
   -- Set_Bounds --
   ----------------

   procedure Set_Bounds (This : in out Context; Bounds : Rect_T) is
   begin
      This.Bounds := Bounds;
   end Set_Bounds;

   ------------
   -- Bounds --
   ------------

   function Bounds (This : Context) return Rect_T is (This.Bounds);

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position (This : in out Context; Pt : Point_T) is
   begin
      This.Pos := Pt;
   end Set_Position;

   --------------
   -- Position --
   --------------

   function Position (This : Context) return Point_T is
   begin
      return This.Pos;
   end Position;

   -----------------
   -- Set_Backend --
   -----------------

   procedure Set_Backend (This : in out Context; Bck : access Backend'Class) is
   begin
      This.Bck := Bck;
   end Set_Backend;

   --------------------
   -- Set_Line_Width --
   --------------------

   procedure Set_Line_Width (This : in out Context; Width : Positive) is
   begin
      This.Line_Width := Width;
   end Set_Line_Width;

   -------------
   -- Move_To --
   -------------

   procedure Move_To (This : in out Context; Pt : Point_T) is
   begin
      This.Pos := Pt;
   end Move_To;

   -------------
   -- Line_To --
   -------------

   procedure Line_To (This : in out Context; Pt : Point_T) is
   begin
      This.Line (This.Pos, Pt);
      This.Move_To (Pt);
   end Line_To;

   ----------
   -- Line --
   ----------

   procedure Line (This : in out Context; Start, Stop : Point_T) is
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
            This.Set_Pixel ((X, Y));
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
            This.Set_Pixel ((X, Y));
            Err := Err - DX;
            if Err < 0.0 then
               X := X + Step_X;
               Err := Err + DY;
            end if;
            Y := Y + Step_Y;
         end loop;
      end if;

      This.Set_Pixel ((X, Y));
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   procedure Rectangle (This : in out Context; Rect : Rect_T) is
      Start : constant Point_T := Rect.Org;
      Stop : constant Point_T  := (Rect.Org.X + Rect.Size.W,
                                   Rect.Org.Y + Rect.Size.H);
   begin
      This.Line (Start, (Stop.X, Start.Y));
      This.Line ((Stop.X, Start.Y), Stop);
      This.Line (Stop, (Start.X, Stop.Y));
      This.Line ((Start.X, Stop.Y), Start);
   end Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   procedure Fill_Rectangle (This : in out Context; Rect : Rect_T) is
      Start : constant Point_T := Rect.Org;
      Stop  : constant Point_T  := (Rect.Org.X + Rect.Size.W,
                                    Rect.Org.Y + Rect.Size.H);
      P1 : Point_T := Start;
      P2 : Point_T := (Start.X, Stop.Y);
   begin
      loop
         This.Line (P2, P1);
         exit when P2.X = Stop.X;
         P1.X := P1.X + 1;
         P2.X := P2.X + 1;
      end loop;
   end Fill_Rectangle;

   ------------------
   -- Cubic_Bezier --
   ------------------

   procedure Cubic_Bezier
     (This : in out Context;
      P1, P2, P3, P4 : Point_T;
      N              : Positive := 20)
   is
      Points : array (0 .. N) of Point_T;
   begin
      for I in Points'Range loop
         declare
            T : constant Float := Float (I) / Float (N);
            A : constant Float := (1.0 - T)**3;
            B : constant Float := 3.0 * T * (1.0 - T)**2;
            C : constant Float := 3.0 * T**2 * (1.0 - T);
            D : constant Float := T**3;
         begin
            Points (I).X := Dim (A * Float (P1.X) +
                                       B * Float (P2.X) +
                                       C * Float (P3.X) +
                                       D * Float (P4.X));
            Points (I).Y := Dim (A * Float (P1.Y) +
                                       B * Float (P2.Y) +
                                       C * Float (P3.Y) +
                                       D * Float (P4.Y));
         end;
      end loop;
      for I in Points'First .. Points'Last - 1 loop
         This.Line (Points (I), Points (I + 1));
      end loop;
   end Cubic_Bezier;

   ------------
   -- Circle --
   ------------

   procedure Circle
     (This : in out Context;
      Center : Point_T;
      Radius : Dim)
   is
      F     : Integer := 1 - Radius;
      ddF_X : Integer := 0;
      ddF_Y : Integer := (-2) * Radius;
      X     : Integer := 0;
      Y     : Integer := Radius;
   begin

      This.Set_Pixel ((Center.X, Center.Y + Radius));
      This.Set_Pixel ((Center.X, Center.Y - Radius));
      This.Set_Pixel ((Center.X + Radius, Center.Y));
      This.Set_Pixel ((Center.X - Radius, Center.Y));
      while X < Y loop
         if F >= 0 then
            Y := Y - 1;
            ddF_Y := ddF_Y + 2;
            F := F + ddF_Y;
         end if;
         X := X + 1;
         ddF_X := ddF_X + 2;
         F := F + ddF_X + 1;
         This.Set_Pixel ((Center.X + X, Center.Y + Y));
         This.Set_Pixel ((Center.X - X, Center.Y + Y));
         This.Set_Pixel ((Center.X + X, Center.Y - Y));
         This.Set_Pixel ((Center.X - X, Center.Y - Y));
         This.Set_Pixel ((Center.X + Y, Center.Y + X));
         This.Set_Pixel ((Center.X - Y, Center.Y + X));
         This.Set_Pixel ((Center.X + Y, Center.Y - X));
         This.Set_Pixel ((Center.X - Y, Center.Y - X));
      end loop;
   end Circle;

   -----------------
   -- Fill_Circle --
   -----------------

   procedure Fill_Circle
     (This : in out Context;
      Center : Point_T;
      Radius : Dim)
   is
      pragma Unreferenced (This, Center, Radius);
   begin
      --  Generated stub: replace with real body!
      raise Program_Error with "Unimplemented procedure Fill_Circle";
   end Fill_Circle;

   --------------
   -- Set_Font --
   --------------

   procedure Set_Font (This : in out Context; Font : Font_Access) is
   begin
      This.Font := Font;
   end Set_Font;

   -------------------
   -- Set_Font_Size --
   -------------------

   procedure Set_Font_Size (This : in out Context; Size : Float) is
   begin
      This.Font_Size := Size;
   end Set_Font_Size;

   ----------------------
   -- Set_Font_Spacing --
   ----------------------

   procedure Set_Font_Spacing (This : in out Context; Spacing : Dim) is
   begin
      This.Font_Spacing := Spacing;
   end Set_Font_Spacing;

   -------------------------
   -- Char_To_Glyph_Index --
   -------------------------

   function Char_To_Glyph_Index (C : Character) return Dim is
   begin
      return Character'Pos (C) - 31;
   end Char_To_Glyph_Index;

   --------------
   -- To_Scale --
   --------------

   function To_Scale (This : Context; A : Integer)
                      return Integer
   is
   begin
      return Integer (Float (A) * This.Font_Size);
   end To_Scale;

   ----------------
   -- Draw_Glyph --
   ----------------

   procedure Draw_Glyph (This     : in out Context;
                         Charcode : Positive)
   is
      Last : Vect := Raise_Pen;
      G : constant Glyph_Access := This.Font.Glyphs (Charcode);
      Center : constant Point_T := (This.Pos.X + To_Scale (This, -G.Left),
                                    This.Pos.Y);
   begin

      for Vect of G.Vects loop
         if Vect /= Raise_Pen then
            if Last /= Raise_Pen then
               This.Line_To
                 ((Center.X + To_Scale (This, Vect.X),
                  Center.Y + To_Scale (This, Vect.Y)));
            else
               This.Move_To
                 ((Center.X + To_Scale (This, Vect.X),
                  Center.Y + To_Scale (This, Vect.Y)));
            end if;
         end if;
         Last := Vect;
      end loop;
      This.Pos.X := Center.X + To_Scale (This, This.Font_Spacing + G.Right);
      This.Pos.Y := Center.Y;
   end Draw_Glyph;

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Context; C : Character) is
   begin
      Draw_Glyph (This, Char_To_Glyph_Index (C));
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Context; Str : String) is
   begin
      for C of Str loop
         Draw_Glyph (This, Char_To_Glyph_Index (C));
      end loop;
   end Print;

   ---------
   -- Box --
   ---------

   procedure Box (This : in out Context;
                  Str : String;
                  Top, Bottom, Left, Right : out Integer)
   is
      T, B, L, R : Integer := 0;
      G : Glyph_Access :=
        This.Font.Glyphs (Char_To_Glyph_Index (Str (Str'First)));
   begin
      L := 0;
      R := L;

      for C of Str loop
         G := This.Font.Glyphs (Char_To_Glyph_Index (C));
         if G.Top < T then
            T := G.Top;
         end if;

         if G.Bottom > B then
            B := G.Bottom;
         end if;

         R := R + (G.Right - G.Left) + This.Font_Spacing;
      end loop;

      Top := This.Pos.Y + To_Scale (This, T);
      Bottom := This.Pos.Y + To_Scale (This, B);
      Left := This.Pos.X + To_Scale (This, L);
      Right := This.Pos.X + To_Scale (This, R);
   end Box;

end Giza.Graphics;
