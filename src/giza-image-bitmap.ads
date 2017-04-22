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

with Giza.Bitmaps;

package Giza.Image.Bitmap is

   subtype Parent is Image.Instance;
   type Instance (Data : not null Giza.Bitmaps.Bitmap_Const_Ref) is
     new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   function Size (This : Instance) return Size_T;

   generic
      with package Bitmaps_Pck is new Giza.Bitmaps.Indexed_Bitmaps (<>);
   package Indexed_Bitmaps is

      subtype Parent is Image.Instance;
      type Instance (Data : not null Bitmaps_Pck.Bitmap_Indexed_Const_Ref) is
        new Parent with private;
      subtype Class is Instance'Class;
      type Ref is access all Class;

      overriding
      function Size (This : Instance) return Size_T;

   private
      type Instance (Data : not null Bitmaps_Pck.Bitmap_Indexed_Const_Ref) is
        new Parent with null record;
   end Indexed_Bitmaps;

private

   type Instance (Data : not null Giza.Bitmaps.Bitmap_Const_Ref) is
     new Parent with null record;

end Giza.Image.Bitmap;
