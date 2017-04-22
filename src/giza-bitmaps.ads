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

pragma Restrictions (No_Elaboration_Code);

with Giza.Colors;   use Giza.Colors;
with Giza.Types; use Giza.Types;
--  with Giza.Backend; use Giza.Backend;
--  with Giza.Types;    use Giza.Types;

package Giza.Bitmaps is

   type Bitmap_Data is array (Integer range <>) of Color with Pack;

   type Bitmap (W, H, Length : Natural) is record
      Data : Bitmap_Data (1 .. Length) := (others => White);
   end record;

   type Bitmap_Ref is access all Bitmap;
   type Bitmap_Const_Ref is access constant Bitmap;

   function Get_Pixel (Bmp : Bitmap; Pt : Point_T) return Color
     with Pre => Pt.X in 0 .. (Bmp.W - 1) and then Pt.Y in 0 .. (Bmp.W - 1);

   --     --------------------
--     -- Bitmap_Backend --
--     --------------------
--
--     --  Used with a Gcontext, this backend allows to draw on bitmap as if
   --  it was
--     --  a screen.
--
--     type Bitmap_Backend (W, H : Natural) is new Backend.Instance with record
--        Data          : Bitmap (W, H);
--        Current_Color : Color;
--     end record;
--
--     overriding
--     procedure Set_Pixel (This : in out Bitmap_Backend; Pt : Point_T);
--
--     overriding
--     procedure Set_Color (This : in out Bitmap_Backend; C : Color);
--
--     overriding
--     function Size (This : Bitmap_Backend) return Size_T;
--
--     overriding
--     function Has_Double_Buffring (This : Bitmap_Backend) return Boolean is
--        (False);

   type Unsigned_1 is mod 2**1 with Size => 1;
   type Unsigned_2 is mod 2**2 with Size => 2;
   type Unsigned_4 is mod 2**4 with Size => 4;
   type Unsigned_8 is mod 2**8 with Size => 8;

   generic
      type Index_Type is mod <>;
   package Indexed_Bitmaps is

      type Bitmap_Indexed_Data is array (Integer range <>)
        of Unsigned_8 with Pack;

      type Color_Palette is array (Index_Type) of Color with Pack;

      type Bitmap_Indexed (W, H, Length_Byte : Natural) is
         record
            Palette : Color_Palette;
            Data : Bitmap_Indexed_Data (1 .. Length_Byte);
      end record;

      type Bitmap_Indexed_Ref is access all Bitmap_Indexed;
      type Bitmap_Indexed_Const_Ref is access constant Bitmap_Indexed;

      function Get_Pixel (Bmp : Bitmap_Indexed; Pt : Point_T) return Color
        with Pre => Pt.X in 0 .. (Bmp.W - 1) and then Pt.Y in 0 .. (Bmp.W - 1);
   end Indexed_Bitmaps;
end Giza.Bitmaps;
