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

package body Giza.Image.Editable_Bitmap is

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Instance)
      return Size_T
   is
   begin
      return (This.Width, This.Height);
   end Size;

   ---------
   -- Set --
   ---------

   procedure Set
     (This : in out Instance;
      Bmp  : Giza.Bitmaps.Bitmap)
   is
   begin
--        This.Ctx.Set_Backend (This.Data'Unchecked_Access);
      This.Ctx.Copy_Bitmap (Bmp, (0, 0));
   end Set;

   -----------------
   -- Get_Context --
   -----------------

   function Get_Context
     (This : in out Instance)
      return not null Context.Ref
   is
   begin
--        This.Ctx.Set_Backend (This.Data'Unchecked_Access);
      return This.Ctx'Unchecked_Access;
   end Get_Context;

   ----------
   -- Data --
   ----------

   function Data (This : Instance) return Giza.Bitmaps.Bitmap is
   begin
      return This.Data;
   end Data;

end Giza.Image.Editable_Bitmap;
