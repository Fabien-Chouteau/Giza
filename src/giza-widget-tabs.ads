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

with Giza.Widget.Frame; use Giza.Widget.Frame;
with Giza.Widget.Button; use Giza.Widget.Button;
with Giza.Widget.Composite; use Giza.Widget.Composite;
with Giza.Widget.Tiles; use Giza.Widget.Tiles;

package Giza.Widget.Tabs is

   subtype Parent is Frame.Instance;
   type Instance (Tab_Number : Natural) is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   type Instance_Ref is access all Instance'Class;

   overriding
   procedure Set_Dirty (This  : in out Instance;
                        Dirty : Boolean := True);

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Instance;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   overriding
   function On_Event
     (This : in out Instance;
      Evt  : Event_Not_Null_Ref) return Boolean;

   procedure Set_Tab
     (This  : in out Instance;
      Index : Natural;
      Title : String;
      Child : not null Widget.Reference);

   function Selected (This : Instance) return Natural;
   procedure Set_Selected (This : in out Instance; Selected : Natural);

private

   type Tab_Wrapper is record
      Widg   : Widget.Reference := null;
      Btn    : aliased Button.Instance;
      Pos    : Point_T;
   end record;

   type Wrapper_Array is array (Positive range <>) of Tab_Wrapper;

   type Instance (Tab_Number : Natural) is new Parent with record
      Init : Boolean := False;
      Selected   : Natural := 1;
      Tabs       : Wrapper_Array (1 .. Tab_Number);

      Root : aliased Composite.Instance;
      Tabs_Group : aliased Tiles.Instance (Tab_Number, Left_Right);
   end record;
end Giza.Widget.Tabs;
