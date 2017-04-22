------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)        --
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

with Ada.Unchecked_Deallocation;

package body Giza.Widget.Text is

   procedure Free is new Ada.Unchecked_Deallocation (String, String_Access);

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This : in out Instance;
                   Ctx : in out Context.Class;
                   Force : Boolean := True)
   is
      Margin_H : constant Dim := This.Get_Size.H / 30;
      Margin_W : constant Dim := This.Get_Size.W / 30;
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Parent (This), Ctx, Force => True);

      if This.Str /= null then
         Ctx.Set_Color (This.Get_Foreground);
         Ctx.Print_In_Rect (This.Str.all,
                            ((Margin_W, Margin_H),
                             This.Get_Size - (Margin_W * 2, Margin_H * 2)));
      end if;
   end Draw;

   --------------
   -- Set_Text --
   --------------

   procedure Set_Text (This : in out Instance; Str : String) is
   begin
      if This.Str /= null then
         Free (This.Str);
      end if;

      This.Str := new String'(Str);
      This.Set_Dirty;
   end Set_Text;

   ----------
   -- Text --
   ----------

   function Text (This : Instance) return String is
   begin
      if This.Str /= null then
         return This.Str.all;
      else
         return "";
      end if;
   end Text;

end Giza.Widget.Text;
