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

package body Giza.Bitmaps is

   ---------------
   -- Get_Pixel --
   ---------------

   function Get_Pixel (Bmp : Bitmap; Pt : Point_T) return Color is
   begin
      return Bmp.Data ((Pt.X + Bmp.Data'First) + (Pt.Y * (Bmp.W)));
   end Get_Pixel;

   package body Indexed_Bitmaps is

      type Raw_Array is array (Integer range <>) of Index_Type with Pack;

      ---------------
      -- Get_Pixel --
      ---------------

      function Get_Pixel (Bmp : Bitmap_Indexed; Pt : Point_T) return Color is
         Map : Raw_Array (1 .. (Bmp.H * Bmp.W));
         for Map'Address use Bmp.Data'Address;
      begin
         return Bmp.Palette (Map ((Pt.X + 1) + (Pt.Y * (Bmp.W))));
      end Get_Pixel;
   end Indexed_Bitmaps;

--     ---------------
--     -- Set_Pixel --
--     ---------------
--
--     overriding procedure Set_Pixel
--       (This : in out Bitmap_Backend;
--        Pt : Point_T)
--     is
--     begin
--        if Pt.X + 1 in This.Data.Data'Range (1)
--          and then
--           Pt.Y + 1 in This.Data.Data'Range (2)
--        then
--           This.Data.Data (Pt.X + 1, Pt.Y + 1) := This.Current_Color;
--        end if;
--     end Set_Pixel;
--
--     ---------------
--     -- Set_Color --
--     ---------------
--
--     overriding procedure Set_Color
--       (This : in out Bitmap_Backend;
--        C : Color)
--     is
--     begin
--        This.Current_Color := C;
--     end Set_Color;
--
--     ----------
--     -- Size --
--     ----------
--
--     overriding function Size
--       (This : Bitmap_Backend)
--        return Size_T
--     is
--     begin
--        return (This.W, This.H);
--     end Size;

end Giza.Bitmaps;
