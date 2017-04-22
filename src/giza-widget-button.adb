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

package body Giza.Widget.Button is

   --------------
   -- On_Click --
   --------------

   overriding
   function On_Click
     (This  : in out Instance;
      Pos   : Point_T) return Boolean
   is
      pragma Unreferenced (Pos);
      Active_Old : constant Boolean := This.Active;
   begin
      This.Set_Active (if This.Is_Toggle then not Active_Old else True);
      return This.Active /= Active_Old;
   end On_Click;

   -----------------------
   -- On_Click_Released --
   -----------------------

   overriding
   function On_Click_Released (This  : in out Instance) return Boolean is
      Active_Old : constant Boolean := This.Active;
   begin
      if not This.Is_Toggle then
         This.Set_Active (False);
      end if;
      return This.Active /= Active_Old;
   end On_Click_Released;

   ------------
   -- Active --
   ------------

   function Active (This : Instance) return Boolean is (This.Is_Active);

   ----------------
   -- Set_Active --
   ----------------

   procedure Set_Active (This : in out Instance; Active : Boolean := True) is
   begin
      if This.Active /= Active then
         This.Is_Active := Active;
         This.Invert_Colors;
         This.Set_Dirty (True);
      end if;
   end Set_Active;

   ----------------
   -- Set_Toggle --
   ----------------

   procedure Set_Toggle (This : in out Instance; Toggle : Boolean := True) is
   begin
      This.Is_Toggle := Toggle;
   end Set_Toggle;

end Giza.Widget.Button;
