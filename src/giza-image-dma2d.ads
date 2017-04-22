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

--  This package provides Image bitmap implementation formated for STM32 DMA2D
--  hardware acceleration. A slow copy these bitmaps is supported in the
--  default backend so they can be used on any platform.

with Giza.Image;
with Giza.Colors;

package Giza.Image.DMA2D is

   type Color_Mode is (RGB888, L8, L4);

   type Unsigned_4 is mod 2**4 with Size => 4;
   type Unsigned_8 is mod 2**8 with Size => 8;

   type DMA2D_Color is record
      R : Unsigned_8;
      G : Unsigned_8;
      B : Unsigned_8;
   end record;

   for DMA2D_Color use record
      B at 0 range 0 .. 7;
      G at 1 range 0 .. 7;
      R at 2 range 0 .. 7;
   end record;

   type L8_CLUT_T is array (Unsigned_8) of DMA2D_Color with Pack;
   type L4_CLUT_T is array (Unsigned_4) of DMA2D_Color with Pack;

   type L8_CLUT_Acces_Const is access constant L8_CLUT_T;
   type L4_CLUT_Acces_Const is access constant L4_CLUT_T;

   type L8_Data_T is array (Natural range <>) of Unsigned_8 with Pack;
   type L4_Data_T is array (Natural range <>) of Unsigned_8 with Pack;
   type RGB888_Data_T is array (Natural range <>) of DMA2D_Color with Pack;

   type L8_Data_Access_Const     is access constant L8_Data_T;
   type L4_Data_Access_Const     is access constant L4_Data_T;
   type RGB888_Data_Access_Const is access constant RGB888_Data_T;

   subtype Parent is Giza.Image.Instance;
   type Instance (Mode         : Color_Mode;
                  Length, W, H : Natural) is new Parent with
      record
         case Mode is
            when RGB888 =>
               RGB888_Data : not null RGB888_Data_Access_Const;
            when L4 =>
               L4_CLUT : not null L4_CLUT_Acces_Const;
               L4_Data : not null L4_Data_Access_Const;
            when L8 =>
               L8_CLUT : not null L8_CLUT_Acces_Const;
               L8_Data : not null L8_Data_Access_Const;
         end case;
      end record;

   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   function Size (This : Instance) return Size_T;

   function To_Giza_Color (C : DMA2D_Color) return Giza.Colors.Color
     with Inline_Always;

   function Get_Pixel (This : Instance; Pt : Point_T) return DMA2D_Color
     with Pre => Pt.X in 0 .. (This.W - 1) and then Pt.Y in 0 .. (This.W - 1);
   function Get_Pixel (This : Instance; Pt : Point_T) return Giza.Colors.Color
     with Pre => Pt.X in 0 .. (This.W - 1) and then Pt.Y in 0 .. (This.W - 1);

end Giza.Image.DMA2D;
