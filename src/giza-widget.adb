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

package body Giza.Widget is

   -----------
   -- Dirty --
   -----------

   function Dirty (This : Instance) return Boolean is (This.Is_Dirty);

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Instance; Dirty : Boolean := True) is
   begin
      This.Is_Dirty := Dirty;
   end Set_Dirty;

   ------------------
   -- Set_Disabled --
   ------------------

   procedure Set_Disabled (This     : in out Instance;
                           Disabled : Boolean := True)
   is
   begin
      This.Is_Disabled := Disabled;
   end Set_Disabled;

   --------------
   -- Set_Size --
   --------------

   procedure Set_Size (This : in out Instance; Size : Size_T) is
   begin
      This.Size := Size;
   end Set_Size;

   --------------
   -- Get_Size --
   --------------

   function Get_Size (This : Instance) return Size_T is (This.Size);

   -----------------------
   -- On_Position_Event --
   -----------------------

   function On_Position_Event
     (This : in out Instance;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean is
   begin
      if This.Is_Disabled then
         return False;
      end if;

      if Evt.all in Click_Event'Class then
         return On_Click (Class (This), Pos);
      end if;
      return False;
   end On_Position_Event;

   --------------
   -- On_Event --
   --------------

   function On_Event
     (This : in out Instance;
      Evt : Event_Not_Null_Ref) return Boolean is
   begin
      if This.Is_Disabled then
         return False;
      end if;

      if Evt.all in Click_Released_Event'Class then
         return On_Click_Released (Class (This));
      end if;
      return False;
   end On_Event;

end Giza.Widget;
