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

with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package body Giza.Types is

   ------------
   -- Center --
   ------------

   function Center (R : Rect_T) return Point_T is
   begin
      return (R.Org.X + R.Size.W / 2, R.Org.Y + R.Size.H / 2);
   end Center;

   ------------------
   -- Intersection --
   ------------------

   function Intersection (A, B : Rect_T) return Rect_T is
      P1 : constant Point_T := A.Org;
      P2 : constant Point_T := A.Org + A.Size;
      P3 : constant Point_T := B.Org;
      P4 : constant Point_T := B.Org + B.Size;

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

end Giza.Types;
