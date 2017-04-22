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

package body Giza.Widget.Background is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Instance;
      Ctx : in out Context.Class;
      Force : Boolean := True)
   is
   begin
      if This.Is_Dirty or else Force then
         Ctx.Set_Color (This.BG);
         Ctx.Fill_Rounded_Rectangle (((0, 0), This.Get_Size), This.Radius);
         This.Set_Dirty (False);
      end if;
   end Draw;

   --------------------
   -- Set_Background --
   --------------------

   procedure Set_Background (This : in out Instance; BG : Color) is
   begin
      This.BG := BG;
   end Set_Background;

   --------------------
   -- Get_Background --
   --------------------

   function Get_Background (This : Instance) return Color is (This.BG);

   -----------------
   -- Set_Rounded --
   -----------------

   procedure Set_Rounded (This   : in out Instance;
                          Radius : Dim)
   is
   begin
      This.Radius := Radius;
   end Set_Rounded;

   ------------
   -- Radius --
   ------------

   function Radius (This : Instance) return Dim is (This.Radius);

end Giza.Widget.Background;
