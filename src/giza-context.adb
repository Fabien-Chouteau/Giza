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

with Ada.Unchecked_Deallocation;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with Giza.Image.Procedural;

package body Giza.Context is

   procedure Free is new Ada.Unchecked_Deallocation (State, State_Ref);

   function Transform (This : Instance; Pt : Point_T) return Point_T;
   function In_Bounds (This : Instance; Pt : Point_T) return Boolean;
   procedure Find_Line (This       : Instance;
                        Str        : String;
                        Start      : Integer;
                        EOL        : out Integer;
                        Next_Start : out Integer;
                        Line_Width : out Integer;
                        Max_Width  : Natural := 0);
   function Number_Of_Lines (This : in out Instance;
                             Str : String;
                             Box : Rect_T) return Natural;

   ---------------
   -- Transform --
   ---------------

   function Transform (This : Instance; Pt : Point_T) return Point_T is
   begin
      --        if This.Current_State.Translate_Only then
      return ((Pt.X + Dim (This.Current_State.Transform.V13),
              Pt.Y + Dim (This.Current_State.Transform.V23)));
      --        else
      --           return This.Current_State.Transform * Pt;
      --        end if;
   end Transform;

   ---------------
   -- In_Bounds --
   ---------------

   function In_Bounds (This : Instance; Pt : Point_T) return Boolean is
   begin
      return
        Pt.X - This.Bounds.Org.X in 0 .. This.Bounds.Size.W
        and then
          Pt.Y - This.Bounds.Org.Y in 0 .. This.Bounds.Size.H;
   end In_Bounds;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (This : in out Instance; Pt : Point_T) is
      Target : constant Point_T := Transform (This, Pt);
   begin

      if This.Bck /= null
        and then
          In_Bounds (This, Pt)
      then
         This.Bck.Set_Pixel (Target);
      end if;
   end Set_Pixel;

   ----------
   -- Save --
   ----------

   procedure Save (This : in out Instance) is
   begin
      This.Current_State.Next := new State'(This.Current_State);
   end Save;

   -------------
   -- Restore --
   -------------

   procedure Restore (This : in out Instance) is
      Tmp : State_Ref;
   begin
      Tmp := This.Current_State.Next;
      if Tmp /= null then
         This.Current_State := Tmp.all;
         Free (Tmp);
      else
         Put_Line ("Invalid graphic Instance Restore...");
      end if;
   end Restore;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Instance) is
      Cnt : Natural := 0;
      Tmp : State_Ref;
   begin
      while This.Current_State.Next /= null loop
         Tmp := This.Current_State.Next;
         This.Current_State := Tmp.all;
         Free (Tmp);
         Cnt := Cnt + 1;
      end loop;

      if Cnt /= 0 then
         Put_Line ("Warning:" & Cnt'Img &
                     " remaining Instance state(s) in the stack");
      end if;

      if This.Bck /= null then
         This.Current_State.Bounds := ((0, 0), This.Bck.Size);
         This.Current_State.Pos := (0, 0);
         This.Current_State.Transform := Id;
         This.Current_State.Translate_Only := True;
      end if;
   end Reset;

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color (This : in out Instance; C : Color) is
   begin
      if This.Bck /= null then
         This.Bck.Set_Color (C);
      end if;
   end Set_Color;

   ----------------
   -- Set_Bounds --
   ----------------

   procedure Set_Bounds (This : in out Instance; Bounds : Rect_T) is
   begin
      This.Current_State.Bounds := Intersection (This.Current_State.Bounds,
                                                 Bounds);
   end Set_Bounds;

   ------------
   -- Bounds --
   ------------

   function Bounds (This : Instance) return Rect_T is
     (This.Current_State.Bounds);

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position (This : in out Instance; Pt : Point_T) is
   begin
      This.Current_State.Pos := Pt;
   end Set_Position;

   --------------
   -- Position --
   --------------

   function Position (This : Instance) return Point_T is
   begin
      return This.Current_State.Pos;
   end Position;

   -----------------
   -- Set_Backend --
   -----------------

   procedure Set_Backend (This : in out Instance; Bck : Backend.Ref) is
   begin
      This.Bck := Bck;
      if Bck /= null then
         This.Current_State.Bounds := ((0, 0), Bck.Size);
      end if;
   end Set_Backend;

   ---------------
   -- Translate --
   ---------------

   procedure Translate (This : in out Instance; Pt : Point_T) is
   begin
      This.Current_State.Transform :=
        This.Current_State.Transform * Translation_Matrix (Pt);

      This.Current_State.Bounds :=
        (This.Current_State.Bounds.Org - Pt, This.Current_State.Bounds.Size);
   end Translate;

   --------------------
   -- Set_Line_Width --
   --------------------

   procedure Set_Line_Width (This : in out Instance; Width : Positive) is
   begin
      This.Current_State.Line_Width := Width;
   end Set_Line_Width;

   ----------------
   -- Line_Width --
   ----------------

   function Line_Width (This : Instance) return Positive is
     (This.Current_State.Line_Width);

   -------------
   -- Move_To --
   -------------

   procedure Move_To (This : in out Instance; Pt : Point_T) is
   begin
      This.Current_State.Pos := Pt;
   end Move_To;

   -------------
   -- Line_To --
   -------------

   procedure Line_To (This : in out Instance; Pt : Point_T) is
   begin
      This.Line (This.Current_State.Pos, Pt);
      This.Move_To (Pt);
   end Line_To;

   ----------
   -- Line --
   ----------

   procedure Line (This : in out Instance; Start, Stop : Point_T) is
   begin
      if This.Bck /= null
        and then
          In_Bounds (This, Start)
        and then
          In_Bounds (This, Stop)
      then
         This.Bck.Line (Transform (This, Start),
                        Transform (This, Stop));
      end if;
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   procedure Rectangle (This : in out Instance; Rect : Rect_T) is
      Start : constant Point_T := Rect.Org;
      Stop  : constant Point_T := Rect.Org + Rect.Size;
   begin
      if This.Bck /= null
        and then
          In_Bounds (This, Start)
        and then
          In_Bounds (This, Stop)
      then
         This.Bck.Rectangle (Transform (This, Start),
                             Transform (This, Stop));
      end if;
   end Rectangle;

   -----------------------
   -- Rounded_Rectangle --
   -----------------------

   procedure Rounded_Rectangle (This   : in out Instance;
                                Rect   : Rect_T;
                                Radius : Dim)
   is
      F          : Integer := 1 - Radius;
      ddF_X      : Integer := 0;
      ddF_Y      : Integer := (-2) * Radius;
      X          : Integer := 0;
      Y          : Integer := Radius;
      R_Center   : constant Point_T := Center (Rect);
      Offset_X   : constant Dim := (Rect.Size.W / 2) - Radius;
      Offset_Y   : constant Dim := (Rect.Size.H / 2) - Radius;
      Line_Width : Positive;
   begin

      if Radius = 0 then
         This.Rectangle (Rect);
         return;
      end if;

      Line_Width := This.Line_Width;
      This.Set_Line_Width (1);

      This.Line (Rect.Org + Point_T'(Radius, 0),
                 Rect.Org + Point_T'(Rect.Size.W - Radius, 0));

      This.Line (Rect.Org + Point_T'(0, Radius),
                 Rect.Org + Point_T'(0, Rect.Size.H - Radius));

      This.Line (Rect.Org + Point_T'(Radius, Rect.Size.H),
                 Rect.Org + Point_T'(Rect.Size.W - Radius, Rect.Size.H));

      This.Line (Rect.Org + Point_T'(Rect.Size.W, Radius),
                 Rect.Org + Point_T'(Rect.Size.W, Rect.Size.H - Radius));

      while X < Y loop
         if F >= 0 then
            Y := Y - 1;
            ddF_Y := ddF_Y + 2;
            F := F + ddF_Y;
         end if;
         X := X + 1;
         ddF_X := ddF_X + 2;
         F := F + ddF_X + 1;

         This.Set_Pixel
           ((R_Center.X + X + Offset_X, R_Center.Y + Y + Offset_Y));
         This.Set_Pixel
           ((R_Center.X - X - Offset_X, R_Center.Y + Y + Offset_Y));
         This.Set_Pixel
           ((R_Center.X + X + Offset_X, R_Center.Y - Y - Offset_Y));
         This.Set_Pixel
           ((R_Center.X - X - Offset_X, R_Center.Y - Y - Offset_Y));
         This.Set_Pixel
           ((R_Center.X + Y + Offset_X, R_Center.Y + X + Offset_Y));
         This.Set_Pixel
           ((R_Center.X - Y - Offset_X, R_Center.Y + X + Offset_Y));
         This.Set_Pixel
           ((R_Center.X + Y + Offset_X, R_Center.Y - X - Offset_Y));
         This.Set_Pixel
           ((R_Center.X - Y - Offset_X, R_Center.Y - X - Offset_Y));
      end loop;

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Rounded_Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   procedure Fill_Rectangle (This : in out Instance; Rect : Rect_T) is
      Inter : constant Rect_T := Intersection (Rect, This.Bounds);
      Start : constant Point_T := Transform (This, Inter.Org);
      Stop  : constant Point_T := Transform (This, Inter.Org + Inter.Size);
   begin
      if This.Bck /= null then
         This.Bck.Fill_Rectangle (Start, Stop);
      end if;
   end Fill_Rectangle;

   ----------------------------
   -- Fill_Rounded_Rectangle --
   ----------------------------

   procedure Fill_Rounded_Rectangle (This   : in out Instance;
                                     Rect   : Rect_T;
                                     Radius : Dim)
   is
      F          : Integer := 1 - Radius;
      ddF_X      : Integer := 0;
      ddF_Y      : Integer := (-2) * Radius;
      X          : Integer := 0;
      Y          : Integer := Radius;
      Line_Width : Positive;
      R_Center     : constant Point_T := Center (Rect);
      Offset_X   : constant Dim := (Rect.Size.W / 2) - Radius;
      Offset_Y   : constant Dim := (Rect.Size.H / 2) - Radius;
   begin

      if Radius = 0 then
         This.Fill_Rectangle (Rect);
         return;
      end if;

      Line_Width := This.Line_Width;
      This.Set_Line_Width (1);

      --  Draw every horizontal lines of the circle
      while X < Y loop
         if F >= 0 then
            Y := Y - 1;
            ddF_Y := ddF_Y + 2;
            F := F + ddF_Y;
         end if;
         X := X + 1;
         ddF_X := ddF_X + 2;
         F := F + ddF_X + 1;

         This.Line ((R_Center.X - X - Offset_X, R_Center.Y + Y + Offset_Y),
                    (R_Center.X + X + Offset_X, R_Center.Y + Y + Offset_Y));
         This.Line ((R_Center.X - X - Offset_X, R_Center.Y - Y - Offset_Y),
                    (R_Center.X + X + Offset_X, R_Center.Y - Y - Offset_Y));
         This.Line ((R_Center.X - Y - Offset_X, R_Center.Y + X + Offset_Y),
                    (R_Center.X + Y + Offset_X, R_Center.Y + X + Offset_Y));
         This.Line ((R_Center.X - Y - Offset_X, R_Center.Y - X - Offset_Y),
                    (R_Center.X + Y + Offset_X, R_Center.Y - X - Offset_Y));
      end loop;

      This.Fill_Rectangle ((Rect.Org + Point_T'(0, Radius),
                           Rect.Size - (0, Radius * 2)));

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Fill_Rounded_Rectangle;

   ------------------
   -- Cubic_Bezier --
   ------------------

   procedure Cubic_Bezier
     (This : in out Instance;
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
     (This : in out Instance;
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
     (This : in out Instance;
      Center : Point_T;
      Radius : Dim)
   is
      F          : Integer := 1 - Radius;
      ddF_X      : Integer := 0;
      ddF_Y      : Integer := (-2) * Radius;
      X          : Integer := 0;
      Y          : Integer := Radius;
      Line_Width : Positive;
   begin
      Line_Width := This.Line_Width;
      This.Set_Line_Width (1);

      --  Draw every horizontal lines of the circle
      while X < Y loop
         if F >= 0 then
            Y := Y - 1;
            ddF_Y := ddF_Y + 2;
            F := F + ddF_Y;
         end if;
         X := X + 1;
         ddF_X := ddF_X + 2;
         F := F + ddF_X + 1;

         This.Line ((Center.X - X, Center.Y + Y),
                    (Center.X + X, Center.Y + Y));
         This.Line ((Center.X - X, Center.Y - Y),
                    (Center.X + X, Center.Y - Y));
         This.Line ((Center.X - Y, Center.Y + X),
                    (Center.X + Y, Center.Y + X));
         This.Line ((Center.X - Y, Center.Y - X),
                    (Center.X + Y, Center.Y - X));
      end loop;

      This.Line ((Center.X - Radius, Center.Y),
                 (Center.X + Radius, Center.Y));

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Fill_Circle;

   --------------
   -- Fill_Arc --
   --------------

   procedure Fill_Arc
     (This     : in out Instance;
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
                      Point_T'(Dim (Cos (Angle) * Float (Radius)),
                        Dim (-Sin (Angle) * Float (Radius))));

         Angle := Angle + 0.5;
      end loop;

      This.Line (Center, Center + Point_T'(Dim (Cos (To) * Float (Radius)),
                 Dim (-Sin (To) * Float (Radius))));

      --  Restore line width
      This.Set_Line_Width (Line_Width);
   end Fill_Arc;

   ----------------
   -- Draw_Image --
   ----------------

   procedure Draw_Image
     (This : in out Instance;
      Img  : Giza.Image.Class;
      Pt   : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
      package Proc renames Giza.Image.Procedural;
   begin
      if Img in Giza.Image.Procedural.Class then
         declare
            Proc_Img : constant Proc.Instance := Proc.Instance (Img);
         begin
            This.Save;
            This.Translate (Pt);
            This.Set_Bounds (((0, 0), Proc_Img.Size));
            This.Set_Position ((0, 0));
            Proc_Img.Proc (This, Proc_Img.Size);
            This.Restore;
         end;
      else
         This.Bck.Draw_Image (Img, Target);
      end if;
   end Draw_Image;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Bitmap;
      Pt     : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
   begin
      This.Bck.Copy_Bitmap (Bmp, Target);
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_1bit.Bitmap_Indexed;
      Pt     : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
   begin
      This.Bck.Copy_Bitmap (Bmp, Target);
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_2bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
   begin
      This.Bck.Copy_Bitmap (Bmp, Target);
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_4bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
   begin
      This.Bck.Copy_Bitmap (Bmp, Target);
   end Copy_Bitmap;

   -----------------
   -- Copy_Bitmap --
   -----------------

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_8bits.Bitmap_Indexed;
      Pt     : Point_T)
   is
      Target : constant Point_T := Transform (This, Pt);
   begin
      This.Bck.Copy_Bitmap (Bmp, Target);
   end Copy_Bitmap;

   --------------
   -- Set_Font --
   --------------

   procedure Set_Font (This : in out Instance; Font : Giza.Font.Ref_Const) is
   begin
      This.Current_State.Font := Font;
   end Set_Font;

   --------------
   -- Get_Font --
   --------------

   function Get_Font (This : Instance) return Giza.Font.Ref_Const is
     (This.Current_State.Font);

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Instance; C : Character) is
   begin
      if This.Get_Font /= null then
         null;
         This.Get_Font.Print_Glyph (This, C);
      end if;
   end Print;

   -----------
   -- Print --
   -----------

   procedure Print (This : in out Instance; Str : String) is
      Org : constant Point_T := This.Position;
      Font : constant Giza.Font.Ref_Const := This.Get_Font;
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

   ---------------
   -- Find_Line --
   ---------------

   procedure Find_Line (This       : Instance;
                        Str        : String;
                        Start      : Integer;
                        EOL        : out Integer;
                        Next_Start : out Integer;
                        Line_Width : out Integer;
                        Max_Width  : Natural := 0)
   is
      Font : constant Giza.Font.Ref_Const := This.Get_Font;

      Width, Height, X_Advance : Natural;
      X_Offset, Y_Offset : Integer;

      Current_Width : Natural := 0;
      Split_Cur     : Integer := -1;
   begin
      if Font = null or else Str'Length = 0 then
         EOL := Start;
         Next_Start := EOL + 1;
         Line_Width := Current_Width;
         return;
      end if;

      for C in Start .. Str'Last loop
         Font.Glyph_Box
           (Str (C), Width, Height, X_Advance, X_Offset, Y_Offset);
         if Str (C) = ' ' then
            Split_Cur := C;
         elsif Str (C) = ASCII.LF then
            EOL := C - 1;
            Next_Start := C + 1;
            Line_Width := Current_Width;
            return;
         end if;
         if Max_Width /= 0
           and then
             Current_Width + X_Offset + Width > Max_Width
         then
            if Split_Cur = -1 then
               EOL := Integer'Max (Start, C - 1);
               Next_Start := EOL + 1;
               Line_Width := Current_Width;
               return;
            else
               EOL := Split_Cur - 1;
               Next_Start := Split_Cur + 1;
               Line_Width := Current_Width;
               return;
            end if;
         end if;
         Current_Width := Current_Width + X_Advance;
      end loop;
      EOL := Str'Last;
      Next_Start := EOL + 1;
      Line_Width := Current_Width;
      return;
   end Find_Line;

   ---------------------
   -- Number_Of_Lines --
   ---------------------

   function Number_Of_Lines (This : in out Instance;
                             Str : String;
                             Box : Rect_T) return Natural
   is
      Nbr : Integer := 0;
      Index, EOL, Next_Start : Integer := Str'First;
      Line_Width : Integer := 0;
   begin
      while Index <= Str'Last loop
         Find_Line (This, Str, Index, EOL, Next_Start, Line_Width, Box.Size.W);
         if EOL = -1 then
            exit;
         end if;
         Nbr := Nbr + 1;
         Index := Next_Start;
      end loop;
      return Nbr;
   end Number_Of_Lines;

   -------------------
   -- Print_In_Rect --
   -------------------

   procedure Print_In_Rect (This : in out Instance;
                            Str : String;
                            Box : Rect_T)
   is
      Font : constant Giza.Font.Ref_Const := This.Get_Font;
      Org_X : constant Dim := Box.Org.X;
      Index, EOL, Next_Start : Integer := Str'First;
      Line_Width : Integer := 0;
      Text_Height : Integer;
   begin
      if Font = null then
         return;
      end if;

      Text_Height := (Number_Of_Lines (This, Str, Box) - 1) * Font.Y_Advance;

      This.Move_To (Box.Org +
                      Point_T'(0,
                        (Box.Size.H - Text_Height) / 2));

      while Index <= Str'Last loop
         Find_Line (This, Str, Index, EOL, Next_Start, Line_Width, Box.Size.W);
         if EOL = -1 then
            exit;
         end if;
         This.Move_To ((Org_X + (Box.Size.W - Line_Width) / 2,
                       This.Position.Y));
         This.Print (Str (Index .. EOL));
         Index := Next_Start;
         This.Move_To ((Org_X, This.Position.Y + Font.Y_Advance));
      end loop;
   end Print_In_Rect;

   ---------
   -- Box --
   ---------

   procedure Box (This : Instance;
                  Str : String;
                  Rect : out Rect_T;
                  Max_Width : Natural := 0)
   is
      Font : constant Giza.Font.Ref_Const := This.Get_Font;
      Index, EOL, Next_Start : Integer := Str'First;
      Line_Width : Integer := 0;
      Pt, TL, BR : Point_T := (0, 0);

      Top, Left, Bottom, Right : Dim;
      Width, Height, X_Advance : Natural;
      X_Offset, Y_Offset : Integer;
   begin
      if Font = null then
         Rect := ((0, 0), (0, 0));
         return;
      end if;

      Top    := Dim'Last;
      Left   := Dim'Last;
      Bottom := Dim'First;
      Right  := Dim'First;

      while Index <= Str'Last loop
         Find_Line (This, Str, Index, EOL, Next_Start, Line_Width, Max_Width);
         if EOL = -1 then
            exit;
         end if;

         if Max_Width /= 0 then
            Pt.X := (Max_Width - Line_Width) / 2;
         end if;

         for C of Str (Index .. EOL) loop
            Font.Glyph_Box
              (C, Width, Height, X_Advance, X_Offset, Y_Offset);

            if Width /= 0 and then Height /= 0 then
               TL := Pt + Point_T'(X_Offset, Y_Offset);
               BR := TL + Size_T'(Width, Height);
               Left   := Integer'Min (Left, TL.X);
               Top    := Integer'Min (Top, TL.Y);
               Right  := Integer'Max (Right, BR.X);
               Bottom := Integer'Max (Bottom, BR.Y);
            end if;

            Pt := Pt + Point_T'(X_Advance, 0);
         end loop;
         Index := Next_Start;
         Pt := Point_T'(0, Pt.Y + Font.Y_Advance);
      end loop;
      Rect.Org := (Left, Top);
      Rect.Size := (Right - Left, Bottom - Top);
   end Box;

end Giza.Context;
