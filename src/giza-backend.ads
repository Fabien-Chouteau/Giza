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

with Giza.Types;   use Giza.Types;
with Giza.Colors;  use Giza.Colors;
with Giza.Image;
with Giza.Bitmaps;
with Giza.Bitmaps.Indexed_1bit;
with Giza.Bitmaps.Indexed_2bits;
with Giza.Bitmaps.Indexed_4bits;
with Giza.Bitmaps.Indexed_8bits;

package Giza.Backend is

   type Instance is abstract tagged private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   procedure Set_Pixel (This : in out Instance; Pt : Point_T) is abstract;
   procedure Set_Color (This : in out Instance; C : Color) is abstract;
   function Size (This : Instance) return Size_T is abstract;
   function Has_Double_Buffring (This : Instance) return Boolean is abstract;
   procedure Swap_Buffers (This : in out Instance) is null;

   procedure Line (This : in out Instance; Start, Stop : Point_T);
   procedure Rectangle (This : in out Instance; Start, Stop : Point_T);
   procedure Fill_Rectangle (This : in out Instance; Start, Stop : Point_T);

   procedure Draw_Image
     (This : in out Instance;
      Img  : Giza.Image.Class;
      Pt   : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Bitmap;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_1bit.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_2bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_4bits.Bitmap_Indexed;
      Pt     : Point_T);

   procedure Copy_Bitmap
     (This   : in out Instance;
      Bmp    : Giza.Bitmaps.Indexed_8bits.Bitmap_Indexed;
      Pt     : Point_T);

private

   type Instance is abstract tagged null record;

end Giza.Backend;
