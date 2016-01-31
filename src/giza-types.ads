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

package Giza.Types is
   subtype Dim is Integer;

   type Point_T is record
      X, Y : Dim;
   end record;

   function To_String (Pt : Point_T) return String is
      ("(X:" & Pt.X'Img & ", Y:" & Pt.Y'Img & ")");

   function "+" (A, B : Point_T) return Point_T is (A.X + B.X, A.Y + B.Y);
   function "-" (A, B : Point_T) return Point_T is (A.X - B.X, A.Y - B.Y);

   type Size_T is record
      W, H : Natural;
   end record;

   function To_String (Size : Size_T) return String is
      ("(W:" & Size.W'Img & ", H:" & Size.H'Img & ")");

   function "+" (A, B : Size_T) return Size_T is (A.W + B.W, A.H + B.H);
   function "-" (A, B : Size_T) return Size_T is (A.W - B.W, A.H - B.H);
   function "*" (A : Size_T; B : Integer) return Size_T is (A.W * B, A.H * B);
   function "/" (A : Size_T; B : Integer) return Size_T is (A.W / B, A.H / B);

   type Rect_T is record
      Org  : Point_T;
      Size : Size_T;
   end record;

   function "+" (A : Rect_T; B : Size_T) return Rect_T is
     (A.Org, A.Size + B);
   function "+" (B : Size_T; A : Rect_T) return Rect_T is
     (A.Org, A.Size + B);

   function "+" (A : Rect_T; B : Point_T) return Rect_T is
     (A.Org + B, A.Size);

   function "+" (B : Point_T; A : Rect_T) return Rect_T is
     (A.Org + B, A.Size);

   function "+" (A : Point_T; B : Size_T) return Point_T is
     (A.X + B.W, A.Y + B.H);
   function "+" (A : Size_T; B : Point_T) return Point_T is
     (A.W + B.X, A.H + B.Y);

   function To_String (Rect : Rect_T) return String is
     ("(Org:" & To_String (Rect.Org) &
        ", Size:" & To_String (Rect.Size) & ")");

   function Center (R : Rect_T) return Point_T;

   function Intersection (A, B : Rect_T) return Rect_T;

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

end Giza.Types;
