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

with Ada.Unchecked_Deallocation;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;

package body Giza.Graphics is

   procedure Free is new Ada.Unchecked_Deallocation (State, State_Ref);

   function Char_To_Glyph_Index (C : Character) return Glyph_Index;
   function To_Scale (This : Context; A : Integer)
                      return Integer;
   procedure Draw_Glyph (This     : in out Context;
                         Charcode : Positive);

   function Transform (This : Context; Pt : Point_T) return Point_T;

   ------------
   -- Center --
   ------------

   function Center (R : Rect_T) return Point_T is
   begin
      return (R.Org.X + R.Size.W / 2, R.Org.Y + R.Size.H / 2);
   end Center;

   ---------------
   -- Intersect --
   ---------------

   function Intersection (A, B : Rect_T) return Rect_T is
      P1 : constant Point_T := A.Org;
      P2 : constant Point_T := A.Org + (A.Size.W, A.Size.H);
      P3 : constant Point_T := B.Org;
      P4 : constant Point_T := B.Org + (B.Size.W, B.Size.H);

      Ret1, Ret2 : Point_T;
      H, W : Natural;
   begin
      Ret1.X := Dim'Max (P1.X, P3.X);
      Ret1.Y := Dim'Max (P1.Y, P3.Y);
      Ret2.X := Dim'Min (P2.X, P4.X);
      Ret2.Y := Dim'Min (P2.Y, P4.Y);

      if Ret2.X - Ret1.X < 0 then
         W := 0;
      else
         W := Ret2.X - Ret1.X;
      end if;

      if Ret2.Y - Ret1.Y < 0 then
         H := 0;
      else
         H := Ret2.Y - Ret1.Y;
      end if;
      return (Ret1, (W, H));
   end Intersection;

   ---------
   -- "*" --
   ---------

   function "*" (A, B : HC_Matrix) return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := A.V11 * B.V11 + A.V12 * B.V21 + A.V13 * B.V31;
      Res.V12 := A.V11 * B.V12 + A.V12 * B.V22 + A.V13 * B.V32;
      Res.V13 := A.V11 * B.V13 + A.V12 * B.V23 + A.V13 * B.V33;

      Res.V21 := A.V21 * B.V11 + A.V22 * B.V21 + A.V23 * B.V31;
      Res.V22 := A.V21 * B.V12 + A.V22 * B.V22 + A.V23 * B.V32;
      Res.V23 := A.V21 * B.V13 + A.V22 * B.V23 + A.V23 * B.V33;

      Res.V31 := A.V31 * B.V11 + A.V32 * B.V21 + A.V33 * B.V31;
      Res.V32 := A.V31 * B.V12 + A.V32 * B.V22 + A.V33 * B.V32;
      Res.V33 := A.V31 * B.V13 + A.V32 * B.V23 + A.V33 * B.V33;
      return Res;
   end "*";

   ---------
   -- "*" --
   ---------

   function "*" (A : HC_Matrix; B : Point_T) return Point_T is
      Res : Point_T;
   begin
      Res.X := Dim (Float (B.X) * A.V11 + Float (B.Y) * A.V12 + 1.0 * A.V13);
      Res.Y := Dim (Float (B.X) * A.V21 + Float (B.Y) * A.V22 + 1.0 * A.V23);
      return Res;
   end "*";

   --------
   -- Id --
   --------

   function Id return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := 1.0;
      Res.V22 := 1.0;
      Res.V33 := 1.0;
      return Res;
   end Id;

   ---------------------
   -- Rotation_Matrix --
   ---------------------

   function Rotation_Matrix (Rad : Float) return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := Cos (Rad);
      Res.V12 := -Sin (Rad);
      Res.V21 := Sin (Rad);
      Res.V22 := Cos (Rad);
      Res.V33 := 1.0;
      return Res;
   end Rotation_Matrix;

   ------------------------
   -- Translation_Matrix --
   ------------------------

   function Translation_Matrix (Pt : Point_T) return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := 1.0;
      Res.V22 := 1.0;
      Res.V33 := 1.0;
      Res.V13 := Float (Pt.X);
      Res.V23 := Float (Pt.Y);
      return Res;
   end Translation_Matrix;

   ------------------
   -- Scale_Matrix --
   ------------------

   function Scale_Matrix (Scale : Float) return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := Scale;
      Res.V22 := Scale;
      Res.V33 := 1.0;
      return Res;
   end Scale_Matrix;

   ------------------
   -- Scale_Matrix --
   ------------------

   function Scale_Matrix (X, Y : Float) return HC_Matrix is
      Res : HC_Matrix;
   begin
      Res.V11 := X;
      Res.V22 := Y;
      Res.V33 := 1.0;
      return Res;
   end Scale_Matrix;

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
   -- Transform --
   ---------------

   function Transform (This : Context; Pt : Point_T) return Point_T is
   begin
      if This.Current_State.Translate_Only then
         return ((Pt.X + Dim (This.Current_State.Transform.V13),
                  Pt.Y + Dim (This.Current_State.Transform.V23)));
      else
         return This.Current_State.Transform * Pt;
      end if;
   end Transform;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (This : in out Context; Pt : Point_T) is
      Target : constant Point_T := Transform (This, Pt);
   begin

      if This.Bounds.Size.W /= 0 and then This.Bounds.Size.H /= 0 then
         if This.Bck /= null
           and then
             Pt.X in This.Bounds.Org.X .. This.Bounds.Size.W
           and then
             Pt.Y in This.Bounds.Org.Y .. This.Bounds.Size.H
         then
            This.Bck.Set_Pixel (Target);
--           else
--              Put_Line ("Set_Pixel out of bounds: Pt:" & To_String (Pt) &
--                       " bounds: " & To_String (This.Bounds));
         end if;
      else
         if This.Bck /= null then
            This.Bck.Set_Pixel (Target);
         end if;
      end if;
   end Set_Pixel;

   ----------
   -- Save --
   ----------

   procedure Save (This : in out Context) is
   begin
      This.Current_State.Next := new State'(This.Current_State);
   end Save;

   -------------
   -- Restore --
   -------------

   procedure Restore (This : in out Context) is
      Tmp : State_Ref;
   begin
      Tmp := This.Current_State.Next;
      if Tmp /= null then
         This.Current_State := Tmp.all;
         Free (Tmp);
      else
         Put_Line ("Invalid graphic context Restore...");
      end if;
   end Restore;

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color (This : in out Context; C : Color) is
   begin
      if This.Bck /= null then
         This.Bck.Set_Color (C);
      end if;
   end Set_Color;

   ----------------
   -- Set_Bounds --
   ----------------

   procedure Set_Bounds (This : in out Context; Bounds : Rect_T) is
   begin
      This.Current_State.Bounds := Intersection (This.Current_State.Bounds,
                                              Bounds);
   end Set_Bounds;

   ------------
   -- Bounds --
   ------------

   function Bounds (This : Context) return Rect_T is
     (This.Current_State.Bounds);

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position (This : in out Context; Pt : Point_T) is
   begin
      This.Current_State.Pos := Pt;
   end Set_Position;

   --------------
   -- Position --
   --------------

   function Position (This : Context) return Point_T is
   begin
      return This.Current_State.Pos;
   end Position;

   -----------------
   -- Set_Backend --
   -----------------

   procedure Set_Backend (This : in out Context; Bck : access Backend'Class) is
   begin
      This.Bck := Bck;
      if Bck /= null then
         This.Current_State.Bounds := ((0, 0), Bck.Size);
      end if;
   end Set_Backend;

   ------------
   -- Rotate --
   ------------

   procedure Rotate (This : in out Context; Rad : Float) is
   begin
      This.Current_State.Transform :=
        This.Current_State.Transform * Rotation_Matrix (Rad);
      This.Current_State.Translate_Only := False;
   end Rotate;

   ---------------
   -- Translate --
   ---------------

   procedure Translate (This : in out Context; Pt : Point_T) is
   begin
      This.Current_State.Transform :=
        This.Current_State.Transform * Translation_Matrix (Pt);

      This.Current_State.Bounds :=
        (This.Current_State.Bounds.Org - Pt, This.Current_State.Bounds.Size);
   end Translate;

   -----------
   -- Scale --
   -----------

   procedure Scale (This : in out Context; Scale : Float) is
   begin
      This.Scale (Scale, Scale);
   end Scale;

   -----------
   -- Scale --
   -----------

   procedure Scale (This : in out Context; X, Y : Float) is
   begin
      This.Current_State.Transform :=
        This.Current_State.Transform * Scale_Matrix (X, Y);
      This.Current_State.Translate_Only := False;
   end Scale;

   --------------------
   -- Set_Line_Width --
   --------------------

   procedure Set_Line_Width (This : in out Context; Width : Positive) is
   begin
      This.Current_State.Line_Width := Width;
   end Set_Line_Width;

   ----------------
   -- Line_Width --
   ----------------

   function Line_Width (This : Context) return Positive is
     (This.Current_State.Line_Width);

   -------------
   -- Move_To --
   -------------

   procedure Move_To (This : in out Context; Pt : Point_T) is
   begin
      This.Current_State.Pos := Pt;
   end Move_To;

   -------------
   -- Line_To --
   -------------

   procedure Line_To (This : in out Context; Pt : Point_T) is
   begin
      This.Line (This.Current_State.Pos, Pt);
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
      R2 : constant Dim := Radius ** 2;
      Cx : Dim;
      Line_Width : constant Positive := This.Line_Width;
   begin
      This.Set_Line_Width (1);

      --  Draw every horizontal lines of the circle
      for Cy in -Radius .. Radius loop
         Cx := Dim (Sqrt (Float (R2 - Cy ** 2)));
         This.Line (Start => (Center.X - Cx, Center.Y + Cy),
                    Stop  => (Center.X + Cx, Center.Y + Cy));
      end loop;

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Fill_Circle;

   procedure Fill_Arc
     (This     : in out Context;
      Center   : Point_T;
      Radius   : Dim;
      From, To : Float)
   is
      Line_Width : constant Positive := This.Line_Width;
      Angle : Float;
   begin
      This.Set_Line_Width (1);

      --  Until we have a real fill arc algorithm...
      Angle := From;
      while Angle < To loop
         This.Line (Center, Center + (Dim (Cos (Angle) * Float (Radius)),
                    Dim (-Sin (Angle) * Float (Radius))));

         Angle := Angle + 0.5;
      end loop;

      This.Line (Center, Center + (Dim (Cos (To) * Float (Radius)),
                 Dim (-Sin (To) * Float (Radius))));

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Fill_Arc;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Context;
      Bmp    : Bitmap;
      Pt     : Point_T)
   is
   begin
      This.Set_Position (Pt);
      for W in 1 .. Bmp.W loop
         for H in 1 .. Bmp.H loop
            This.Set_Color (Bmp.Data (H, W));
            This.Set_Pixel (Pt + (W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Context;
      Bmp    : Bitmap_Indexed_1bit;
      Pt     : Point_T)
   is
   begin
      This.Set_Position (Pt);
      for W in 1 .. Bmp.W loop
         for H in 1 .. Bmp.H loop
            This.Set_Color (Bmp.Palette (Bmp.Data (H, W)));
            This.Set_Pixel (Pt + (W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   procedure Copy_Bitmap
     (This   : in out Context;
      Bmp    : Bitmap_Indexed_2bits;
      Pt     : Point_T)
   is
   begin
      This.Set_Position (Pt);
      for W in 1 .. Bmp.W loop
         for H in 1 .. Bmp.H loop
            This.Set_Color (Bmp.Palette (Bmp.Data (H, W)));
            This.Set_Pixel (Pt + (W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   procedure Copy_Bitmap
     (This   : in out Context;
      Bmp    : Bitmap_Indexed_4bits;
      Pt     : Point_T)
   is
   begin
      This.Set_Position (Pt);
      for W in 1 .. Bmp.W loop
         for H in 1 .. Bmp.H loop
            This.Set_Color (Bmp.Palette (Bmp.Data (H, W)));
            This.Set_Pixel (Pt + (W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   procedure Copy_Bitmap
     (This   : in out Context;
      Bmp    : Bitmap_Indexed_8bits;
      Pt     : Point_T)
   is
   begin
      This.Set_Position (Pt);
      for W in 1 .. Bmp.W loop
         for H in 1 .. Bmp.H loop
            This.Set_Color (Bmp.Palette (Bmp.Data (H, W)));
            This.Set_Pixel (Pt + (W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   --------------
   -- Set_Font --
   --------------

   procedure Set_Font (This : in out Context; Font : Font_Access) is
   begin
      This.Current_State.Font := Font;
   end Set_Font;

   -------------------
   -- Set_Font_Size --
   -------------------

   procedure Set_Font_Size (This : in out Context; Size : Float) is
   begin
      This.Current_State.Font_Size := Size;
   end Set_Font_Size;

   ----------------------
   -- Set_Font_Spacing --
   ----------------------

   procedure Set_Font_Spacing (This : in out Context; Spacing : Dim) is
   begin
      This.Current_State.Font_Spacing := Spacing;
   end Set_Font_Spacing;

   ----------
   -- Font --
   ----------

   function Font (This : Context) return Font_Access is
     (This.Current_State.Font);

   ---------------
   -- Font_Size --
   ---------------

   function Font_Size (This : Context) return Float is
      (This.Current_State.Font_Size);

   ------------------
   -- Font_Spacing --
   ------------------

   function Font_Spacing (This : Context) return Dim is
      (This.Current_State.Font_Spacing);

   -------------------------
   -- Char_To_Glyph_Index --
   -------------------------

   function Char_To_Glyph_Index (C : Character) return Glyph_Index is
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
                         Charcode : Glyph_Index)
   is
      Last : Vect := Raise_Pen;
      G : Glyph_Access := Empty_Glyph'Access;
      Center : Point_T;
   begin

      if Charcode not in This.Font.Glyphs'Range then
         return;
      end if;

      G := This.Current_State.Font.Glyphs (Charcode);
      Center := (This.Position.X + To_Scale (This, -G.Left),
                 This.Position.Y);

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
      This.Move_To
        ((Center.X + To_Scale (This, This.Font_Spacing + G.Right), Center.Y));
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

   -------------------
   -- Print_In_Rect --
   -------------------

   procedure Print_In_Rect (This : in out Context;
                            Str : String;
                            Box : Rect_T)
   is
      Top, Bottom, Left, Right : Integer;
      Pt : Point_T;
      H, W : Integer;
      Ratio, Ratio_H, Ratio_W : Float;
   begin
      if Str'Length = 0 then
         return;
      end if;

      This.Set_Font_Size (1.0);

      Pt := Center (Box);
      This.Box (Str, Top, Bottom, Left, Right);
      H := Bottom - Top;
      W := Right - Left;
      Ratio_W := Float (Box.Size.W) / Float (W);
      Ratio_H := Float (Box.Size.H) / Float (H);
      Ratio := (if Ratio_H < Ratio_W then  Ratio_H else Ratio_W);
      Pt.X := Pt.X - Integer ((Float (W) / 2.0) * Ratio);
      This.Move_To (Pt);
      This.Set_Font_Size (Ratio);
      This.Print (Str);
   end Print_In_Rect;

   ---------
   -- Box --
   ---------

   procedure Box (This : in out Context;
                  Str : String;
                  Top, Bottom, Left, Right : out Integer)
   is
      T, B, L, R : Integer := 0;
      G : Glyph_Access := Empty_Glyph'Access;
      Index : Glyph_Index;
   begin

      L := 0;
      R := L;

      for C of Str loop
         Index := Char_To_Glyph_Index (C);

         if Index in This.Font.Glyphs'Range then
            G := This.Font.Glyphs (Index);
            if G.Top < T then
               T := G.Top;
            end if;

            if G.Bottom > B then
               B := G.Bottom;
            end if;

            R := R + (G.Right - G.Left) + This.Font_Spacing;
         end if;
      end loop;

      Top := This.Position.Y + To_Scale (This, T);
      Bottom := This.Position.Y + To_Scale (This, B);
      Left := This.Position.X + To_Scale (This, L);
      Right := This.Position.X + To_Scale (This, R);
   end Box;

end Giza.Graphics;
