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

with Giza.Colors;             use Giza.Colors;
with Giza.Widget.Background; use Giza.Widget.Background;
with Giza.Image;             use Giza.Image;

package Giza.Widget.Frame is

   subtype Parent is Background.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   procedure Set_Foreground (This : in out Instance; FG : Color);
   function Get_Foreground (This : Instance) return Color;
   procedure Invert_Colors (This : in out Instance);

   procedure Set_Image (This : in out Instance;
                        Img  : not null Image.Ref);
   procedure Set_Invert_Image (This : in out Instance;
                               Img  : not null Image.Ref);

   procedure Disable_Background (This : in out Instance);
   procedure Disable_Frame (This : in out Instance);
   procedure Disable_Image (This : in out Instance);

private
   type Instance is new Parent with record
      FG             : Color := Black;
      BG_Disabled    : Boolean := False;
      Frame_Disabled : Boolean := False;
      Img_Disabled   : Boolean := False;
      Img            : Image.Ref := null;
      Invert_Img     : Image.Ref := null;
   end record;
end Giza.Widget.Frame;
