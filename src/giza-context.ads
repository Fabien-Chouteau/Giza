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

with Giza.Colors;  use Giza.Colors;
with Giza.Types;   use Giza.Types;
with Giza.Font;    use Giza.Font;
with Giza.Backend; use Giza.Backend;
with Giza.Image;
with Giza.Bitmaps; use Giza.Bitmaps;
with Giza.Bitmaps.Indexed_1bit;
with Giza.Bitmaps.Indexed_2bits;
with Giza.Bitmaps.Indexed_4bits;
with Giza.Bitmaps.Indexed_8bits;

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

   procedure Draw_Image
     (This : in out Instance;
      Img  : Giza.Image.Class;
      Pt   : Point_T);

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
