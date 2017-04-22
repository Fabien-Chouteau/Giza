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

with Giza.Events; use Giza.Events;
with Giza.Context; use Giza.Context;
with Giza.Types; use Giza.Types;

package Giza.Widget is

   type Instance is abstract tagged private;
   subtype Class is Instance'Class;
   type Reference is access all Class;

   type Widget_Ref_Array is array (Positive range <>) of Reference;

   function Dirty (This : Instance) return Boolean;
   procedure Set_Dirty (This : in out Instance; Dirty : Boolean := True);
   procedure Draw (This : in out Instance;
                   Ctx : in out Context.Class;
                   Force : Boolean := True) is null;

   procedure Set_Disabled (This : in out Instance; Disabled : Boolean := True);
   --  When a Instance is disabled, it will no longer react to events

   procedure Set_Size (This : in out Instance; Size : Size_T);
   function Get_Size (This : Instance) return Size_T;

   function On_Position_Event
     (This : in out Instance;
      Evt : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   function On_Event
     (This : in out Instance;
      Evt : Event_Not_Null_Ref) return Boolean;

   function On_Click
     (This  : in out Instance;
      Pos   : Point_T) return Boolean is (False);

   function On_Click_Released
     (This  : in out Instance) return Boolean is (False);

private
   type Instance is abstract tagged record
      Is_Dirty    : Boolean := True;
      Is_Disabled : Boolean := False;
      Size : Size_T := (0, 0);
--        Next : access Instance'Class := null;
   end record;
end Giza.Widget;
