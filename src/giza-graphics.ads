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

   type Rect_T is record
      Org  : Point_T;
      Size : Size_T;
   end record;

   function Center (R : Rect_T) return Point_T;

   type Backend is tagged private;

   procedure Set_Pixel (This : in out Backend; Pt : Point_T);
   procedure Set_Color (This : in out Backend; C : Color);
   function Size (This : Backend) return Size_T;

   type Context is tagged private;

   procedure Set_Color (This : in out Context; C : Color);
   procedure Set_Pixel (This : in out Context; Pt : Point_T);
   procedure Set_Bounds (This : in out Context; Bounds : Rect_T);
   function Bounds (This : Context) return Rect_T;
   procedure Set_Position (This : in out Context; Pt : Point_T);
   function Position (This : Context) return Point_T;
   procedure Set_Backend (This : in out Context; Bck : access Backend'Class);

   --  Drawing

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
   procedure Set_Font_Size (This : in out Context; Size : Float);
   procedure Set_Font_Spacing (This : in out Context; Spacing : Dim);
   procedure Print (This : in out Context; C : Character);
   procedure Print (This : in out Context; Str : String);
   procedure Box (This : in out Context;
                  Str : String;
                  Top, Bottom, Left, Right : out Integer);
private

   type Backend is tagged null record;

   type Context is tagged record
      Bck  : access Backend'Class := null;
      Bounds : Rect_T;
      Pos    : Point_T;

      Line_Width : Positive;

      FG, BG : Color;

      Font : Font_Access := Empty_Font'Access;
      Font_Size : Float := 1.0;
      Font_Spacing : Dim := 1;
   end record;

end Giza.Graphics;
