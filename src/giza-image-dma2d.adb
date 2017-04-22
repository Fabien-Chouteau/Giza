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

with Giza.Colors; use Giza.Colors;

package body Giza.Image.DMA2D is

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Instance)
      return Size_T
   is
   begin
      return (This.W, This.H);
   end Size;

   -------------------
   -- To_Giza_Color --
   -------------------

   function To_Giza_Color (C : DMA2D_Color) return Giza.Colors.Color is
     (R => RGB_Component (C.R),
      G => RGB_Component (C.G),
      B => RGB_Component (C.B));

   ---------------
   -- Get_Pixel --
   ---------------

   function Get_Pixel (This : Instance; Pt : Point_T) return DMA2D_Color is
   begin
      case This.Mode is
         when RGB888 => null;
            return This.RGB888_Data
              ((Pt.X + This.RGB888_Data'First) + (Pt.Y * This.W));
         when L4 => null;
            declare
               Index : constant Natural :=
                 (Pt.X + This.L4_Data'First) + Pt.Y * This.W;
               B : constant Unsigned_8 :=
                 This.L4_Data (Index / 2);
            begin
               if Index mod 2 = 0 then
                  return This.L4_CLUT (Unsigned_4 (B and 16#0F#));
               else
                  return This.L4_CLUT (Unsigned_4 ((B and 16#F0#) / 2**4));
               end if;
            end;
         when L8 =>
            return This.L8_CLUT
              (This.L8_Data ((Pt.X + This.L8_Data'First) + Pt.Y * This.W));
      end case;
   end Get_Pixel;

   ---------------
   -- Get_Pixel --
   ---------------

   function Get_Pixel (This : Instance; Pt : Point_T) return Giza.Colors.Color
   is (To_Giza_Color (Get_Pixel (This, Pt)));

end Giza.Image.DMA2D;
