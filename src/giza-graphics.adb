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

   function Transform (This : Context; Pt : Point_T) return Point_T;

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
      Start_2 : constant Point_T := Transform (This, Start);
      Stop_2 : constant Point_T := Transform (This, Stop);
   begin
      if This.Bck /= null then
         This.Bck.Line (Start_2, Stop_2);
      end if;
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   procedure Rectangle (This : in out Context; Rect : Rect_T) is
      Start : constant Point_T := Transform (This, Rect.Org);
      Stop  : constant Point_T := Transform (This, Rect.Org + Rect.Size);
   begin
      if This.Bck /= null then
         This.Bck.Rectangle (Start, Stop);
      end if;
   end Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   procedure Fill_Rectangle (This : in out Context; Rect : Rect_T) is
      Start : constant Point_T := Transform (This, Rect.Org);
      Stop  : constant Point_T := Transform (This, Rect.Org + Rect.Size);
   begin
      if This.Bck /= null then
         This.Bck.Fill_Rectangle (Start, Stop);
      end if;
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
         This.Line (Center, Center +
                      Size_T'(Dim (Cos (Angle) * Float (Radius)),
                        Dim (-Sin (Angle) * Float (Radius))));

         Angle := Angle + 0.5;
      end loop;

      This.Line (Center, Center + Size_T'(Dim (Cos (To) * Float (Radius)),
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
            This.Set_Pixel (Pt + Size_T'(W - 1, H - 1));
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
            This.Set_Pixel (Pt + Size_T'(W - 1, H - 1));
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
            This.Set_Pixel (Pt + Size_T'(W - 1, H - 1));
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
            This.Set_Pixel (Pt + Size_T'(W - 1, H - 1));
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
            This.Set_Pixel (Pt + Size_T'(W - 1, H - 1));
         end loop;
      end loop;
   end Copy_Bitmap;

   --------------
   -- Set_Font --
   --------------

   procedure Set_Font (This : in out Context; Font : Font_Ref) is
   begin
      This.Current_State.Font := Font;
   end Set_Font;

   --------------
   -- Get_Font --
   --------------

   function Get_Font (This : Context) return Font_Ref is
     (This.Current_State.Font);

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Context; C : Character) is
   begin
      if This.Get_Font /= null then
         null;
         This.Get_Font.Print_Glyph (This, C);
      end if;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Context; Str : String) is
      Org : constant Point_T := This.Position;
      Font : constant Font_Ref := This.Get_Font;
   begin
      if Font /= null then
         for C of Str loop
            if C = ASCII.LF then
               This.Move_To ((Org.X, This.Position.Y + Font.Y_Advance));
            else
               This.Get_Font.Print_Glyph (This, C);
            end if;
         end loop;
      end if;
   end Print;

   -------------------
   -- Print_In_Rect --
   -------------------

   procedure Print_In_Rect (This : in out Context;
                            Str : String;
                            Box : Rect_T)
   is
      Font : constant Font_Ref := This.Get_Font;
      Org_X : Dim;
      Top, Bottom, Left, Right : Integer;
      X_Offset, Y_Offset : Integer;
      Width, Height, X_Advance : Integer;
   begin
      if Font = null then
         return;
      end if;

      This.Box (Str, Top, Bottom, Left, Right, Max_Width => Box.Size.W);

      Width := Right - Left;
      Height := Bottom - Top;

      if Width <= 0 or else Height <= 0 then
         return;
      end if;

      --  Center text block in the bounds
      X_Offset := -Left + (Box.Size.W - Width) / 2;
      Y_Offset := -Top + (Box.Size.H - Height) / 2;
      This.Move_To (Box.Org + Point_T'(X_Offset, Y_Offset));

      Org_X := This.Position.X;

      for C of Str loop
         if C = ASCII.LF then
            This.Move_To ((Org_X, This.Position.Y + Font.Y_Advance));
         else
            Font.Glyph_Box
              (C, Width, Height, X_Advance, X_Offset, Y_Offset);

            if This.Position.X - Org_X + X_Offset + Width > Box.Size.W then
               This.Move_To ((Org_X, This.Position.Y + Font.Y_Advance));
            end if;

            This.Get_Font.Print_Glyph (This, C);
         end if;
      end loop;
   end Print_In_Rect;

   ---------
   -- Box --
   ---------

   procedure Box (This : Context;
                  Str : String;
                  Top, Bottom, Left, Right : out Integer;
                  Max_Width : Natural := 0)
   is
      Font : constant Font_Ref := This.Get_Font;
      Width, Height, X_Advance : Natural;
      X_Offset, Y_Offset : Integer;
      Pt, TL, BR : Point_T := (0, 0);
   begin
      Left := 0;
      Right := 0;
      Top := 0;
      Bottom := 0;
      if Font = null then
         return;
      end if;

      for C of Str loop
         if C = ASCII.LF then
            Pt := (0, Pt.Y + Font.Y_Advance);
         else
            Font.Glyph_Box
              (C, Width, Height, X_Advance, X_Offset, Y_Offset);

            if Width /= 0 and then Height /= 0 then
               if Max_Width /= 0
                 and then
                   Pt.X + X_Offset + Width > Max_Width
               then
                  Pt := (0, Pt.Y + Font.Y_Advance);
               end if;

               TL := Pt + Point_T'(X_Offset, Y_Offset);
               BR := TL + Point_T'(Width, Height);

               Left   := Integer'Min (Left, TL.X);
               Top    := Integer'Min (Top, TL.Y);
               Right  := Integer'Max (Right, BR.X);
               Bottom := Integer'Max (Bottom, BR.Y);
            end if;

            Pt := Pt + Point_T'(X_Advance, 0);
         end if;
      end loop;
   end Box;

end Giza.Graphics;
