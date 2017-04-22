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

package body Giza.Widget.Frame is

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True) is
   begin
      if This.Dirty or else Force then
         if not This.BG_Disabled then
            Draw (Background.Instance (This), Ctx, Force);
         end if;
         if not This.Frame_Disabled then
            Ctx.Set_Color (This.FG);
            Ctx.Rounded_Rectangle (((0, 0), This.Get_Size), This.Radius);
         end if;
         if not This.Img_Disabled and then This.Img /= null then
            Ctx.Draw_Image (This.Img.all,
                            ((This.Get_Size.W - This.Img.Size.W) / 2,
                             (This.Get_Size.H - This.Img.Size.H) / 2));
         end if;
         This.Set_Dirty (False);
      end if;
   end Draw;

   --------------------
   -- Set_Foreground --
   --------------------

   procedure Set_Foreground (This : in out Instance; FG : Color) is
   begin
      This.FG := FG;
   end Set_Foreground;

   --------------------
   -- Get_Foreground --
   --------------------

   function Get_Foreground (This : Instance) return Color is (This.FG);

   -------------------
   -- Invert_Colors --
   -------------------

   procedure Invert_Colors (This : in out Instance) is
      Tmp_C   : Color;
      Tmp_Img : Image.Ref;
   begin
      Tmp_C := This.FG;
      This.FG := This.Get_Background;
      This.Set_Background (Tmp_C);

      Tmp_Img := This.Invert_Img;
      This.Invert_Img := This.Img;
      This.Img := Tmp_Img;
   end Invert_Colors;

   ---------------
   -- Set_Image --
   ---------------

   procedure Set_Image (This : in out Instance;
                        Img  : not null Image.Ref)
   is
   begin
      This.Img := Img;
      This.Img_Disabled := False;
   end Set_Image;

   ----------------------
   -- Set_Invert_Image --
   ----------------------

   procedure Set_Invert_Image (This : in out Instance;
                               Img  : not null Image.Ref)
   is
   begin
      This.Invert_Img := Img;
      This.Img_Disabled := False;
   end Set_Invert_Image;

   ------------------------
   -- Disable_Background --
   ------------------------

   procedure Disable_Background (This : in out Instance) is
   begin
      This.BG_Disabled := True;
   end Disable_Background;

   -------------------
   -- Disable_Frame --
   -------------------

   procedure Disable_Frame (This : in out Instance) is
   begin
      This.Frame_Disabled := True;
   end Disable_Frame;

   -------------------
   -- Disable_Image --
   -------------------

   procedure Disable_Image (This : in out Instance) is
   begin
      This.Img_Disabled := True;
   end Disable_Image;

end Giza.Widget.Frame;
