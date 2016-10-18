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

with Giza.Colors;   use Giza.Colors;
with Giza.Bitmaps;  use Giza.Bitmaps;
with Giza.Types;    use Giza.Types;
with Giza.Font;    use Giza.Font;
with Giza.Backend; use Giza.Backend;

package Giza.Context is

   type Instance is tagged private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   procedure Save (This : in out Instance);
   procedure Restore (This : in out Instance);
   procedure Reset (This : in out Instance);

   procedure Set_Color (This : in out Instance; C : Color);
   procedure Set_Pixel (This : in out Instance; Pt : Point_T);
   procedure Set_Bounds (This : in out Instance; Bounds : Rect_T);
   function Bounds (This : Instance) return Rect_T;
   procedure Set_Position (This : in out Instance; Pt : Point_T);
   function Position (This : Instance) return Point_T;
   procedure Set_Backend (This : in out Instance; Bck : Backend.Ref);

   --  Drawing

   procedure Translate (This : in out Instance; Pt : Point_T);

   procedure Set_Line_Width (This : in out Instance; Width : Positive);
   function Line_Width (This : Instance) return Positive;

   procedure Move_To (This : in out Instance; Pt : Point_T);

   procedure Line_To (This : in out Instance; Pt : Point_T);

   procedure Line (This : in out Instance; Start, Stop : Point_T);

   procedure Rectangle (This : in out Instance; Rect : Rect_T);

   procedure Rounded_Rectangle (This   : in out Instance;
                                Rect   : Rect_T;
                                Radius : Dim);

   procedure Fill_Rectangle (This : in out Instance; Rect : Rect_T);

   procedure Fill_Rounded_Rectangle (This   : in out Instance;
                                     Rect   : Rect_T;
                                     Radius : Dim);

   procedure Cubic_Bezier
     (This : in out Instance;
      P1, P2, P3, P4 : Point_T;
      N              : Positive := 20);

   procedure Circle
     (This : in out Instance;
      Center : Point_T;
      Radius : Dim);

   procedure Fill_Circle
     (This : in out Instance;
      Center : Point_T;
      Radius : Dim);

   procedure Fill_Arc
     (This     : in out Instance;
      Center   : Point_T;
      Radius   : Dim;
      From, To : Float);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Bitmap;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_1bit.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_2bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_4bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Indexed_8bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Set_Font (This : in out Instance; Font : Giza.Font.Ref_Const);
   function Get_Font (This : Instance) return Font.Ref_Const;
   procedure Print (This : in out Instance; C : Character);
   procedure Print (This : in out Instance; Str : String);
   procedure Print_In_Rect (This : in out Instance;
                            Str  : String;
                            Box  : Rect_T);
   procedure Box (This : Instance;
                  Str : String;
                  Rect : out Rect_T;
                  Max_Width : Natural := 0);

private

   type State;
   type State_Ref is access all State;

   type State is record
      Bounds         : Rect_T;
      Pos            : Point_T;
      Line_Width     : Positive;
      Font           : Giza.Font.Ref_Const := null;
      Font_Size      : Float := 1.0;
      Font_Spacing   : Dim := 1;
      Transform      : HC_Matrix := Id;

      Translate_Only : Boolean := True;
      --  When only translations are used we can avoid four unecessary float
      --  multiplications for each pixel.

      Next           : State_Ref := null;
   end record;

   type Instance is tagged record
      Bck           : Backend.Ref := null;
      Current_State : State;
   end record;

end Giza.Context;
