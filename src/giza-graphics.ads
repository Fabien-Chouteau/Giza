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

with Hershey_Fonts; use Hershey_Fonts;
with Giza.Colors; use Giza.Colors;

-------------------
-- Giza.Graphics --
-------------------

package Giza.Graphics is

   subtype Dim is Integer;

   type Point_T is record
      X, Y : Dim;
   end record;

   function "+" (A, B : Point_T) return Point_T is (A.X + B.X, A.Y + B.Y);
   function "-" (A, B : Point_T) return Point_T is (A.X - B.X, A.Y - B.Y);

   type Size_T is record
      W, H : Natural;
   end record;

   function "+" (A, B : Size_T) return Size_T is (A.W + B.W, A.H + B.H);
   function "-" (A, B : Size_T) return Size_T is (A.W - B.W, A.H - B.H);

   type Rect_T is record
      Org  : Point_T;
      Size : Size_T;
   end record;

   function Center (R : Rect_T) return Point_T;

   type HC_Matrix is record
      V11, V12, V13 : Float := 0.0;
      V21, V22, V23 : Float := 0.0;
      V31, V32, V33 : Float := 0.0;
   end record;

   function "*" (A, B : HC_Matrix) return HC_Matrix;
   function "*" (A : HC_Matrix; B : Point_T) return Point_T;
   function Id return HC_Matrix;
   function Rotation_Matrix (Rad : Float) return HC_Matrix;
   function Translation_Matrix (Pt : Point_T) return HC_Matrix;
   function Scale_Matrix (Scale : Float) return HC_Matrix;
   function Scale_Matrix (X, Y : Float) return HC_Matrix;

   --------------
   --  Backend --
   --------------

   type Backend is tagged private;

   procedure Set_Pixel (This : in out Backend; Pt : Point_T);
   procedure Set_Color (This : in out Backend; C : Color);
   function Size (This : Backend) return Size_T;

   -------------
   -- Context --
   -------------

   type Context is tagged private;

   procedure Save (This : in out Context);
   procedure Restore (This : in out Context);

   procedure Set_Color (This : in out Context; C : Color);
   procedure Set_Pixel (This : in out Context; Pt : Point_T);
   procedure Set_Bounds (This : in out Context; Bounds : Rect_T);
   function Bounds (This : Context) return Rect_T;
   procedure Set_Position (This : in out Context; Pt : Point_T);
   function Position (This : Context) return Point_T;
   procedure Set_Backend (This : in out Context; Bck : access Backend'Class);

   --  Drawing

   procedure Rotate (This : in out Context; Rad : Float);
   procedure Translate (This : in out Context; Pt : Point_T);
   procedure Scale (This : in out Context; Scale : Float);
   procedure Scale (This : in out Context; X, Y : Float);

   procedure Set_Line_Width (This : in out Context; Width : Positive);

   procedure Move_To (This : in out Context; Pt : Point_T);

   procedure Line_To (This : in out Context; Pt : Point_T);

   procedure Line (This : in out Context; Start, Stop : Point_T);

   procedure Rectangle (This : in out Context; Rect : Rect_T);

   procedure Fill_Rectangle (This : in out Context; Rect : Rect_T);

   procedure Cubic_Bezier
     (This : in out Context;
      P1, P2, P3, P4 : Point_T;
      N              : Positive := 20);

   procedure Circle
     (This : in out Context;
      Center : Point_T;
      Radius : Dim);

   procedure Fill_Circle
     (This : in out Context;
      Center : Point_T;
      Radius : Dim);

   --  Fonts
   procedure Set_Font (This : in out Context; Font : Font_Access);
   function Font (This : Context) return Font_Access;
   procedure Set_Font_Size (This : in out Context; Size : Float);
   function Font_Size (This : Context) return Float;
   procedure Set_Font_Spacing (This : in out Context; Spacing : Dim);
   function Font_Spacing (This : Context) return Dim;
   procedure Print (This : in out Context; C : Character);
   procedure Print (This : in out Context; Str : String);
   procedure Box (This : in out Context;
                  Str : String;
                  Top, Bottom, Left, Right : out Integer);
private

   type Backend is tagged null record;

   type State;
   type State_Ref is access all State;

   type State is record
      Bounds         : Rect_T;
      Pos            : Point_T;
      Line_Width     : Positive;
      Font           : Font_Access := Empty_Font'Access;
      Font_Size      : Float := 1.0;
      Font_Spacing   : Dim := 1;
      Transform      : HC_Matrix := Id;

      Translate_Only : Boolean := True;
      --  We only translations are used we can avoid four unecessary float
      --  multiplications for each pixel.

      Next           : State_Ref := null;
   end record;

   type Context is tagged record
      Bck  : access Backend'Class := null;
      Current_State : State;
   end record;

end Giza.Graphics;
