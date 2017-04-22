------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)        --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

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
