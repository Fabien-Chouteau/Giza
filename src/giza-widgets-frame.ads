-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)         --
--                                                                           --
--                                                                           --
--    Giza is free software: you can redistribute it and/or modify it        --
--    under the terms of the GNU General Public License as published by      --
--    the Free Software Foundation, either version 3 of the License, or      --
--    (at your option) any later version.                                    --
--                                                                           --
--    Giza is distributed in the hope that it will be useful, but WITHOUT    --
--    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY     --
--    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public        --
--    License for more details.                                              --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with Giza. If not, see <http://www.gnu.org/licenses/>.           --
--                                                                           --
-------------------------------------------------------------------------------

with Giza.Colors;             use Giza.Colors;
with Giza.Widgets.Background; use Giza.Widgets.Background;
with Giza.Images;             use Giza.Images;

package Giza.Widgets.Frame is

   subtype Parent is Background.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_Foreground (This : in out Instance; FG : Color);
   function Get_Foreground (This : Instance) return Color;
   procedure Invert_Colors (This : in out Instance);

   procedure Set_Image (This : in out Instance;
                        Img  : not null Image_Ref);
   procedure Set_Invert_Image (This : in out Instance;
                               Img  : not null Image_Ref);

   procedure Disable_Background (This : in out Instance);
   procedure Disable_Frame (This : in out Instance);
   procedure Disable_Image (This : in out Instance);

private
   type Instance is new Parent with record
      FG             : Color := Black;
      BG_Disabled    : Boolean := False;
      Frame_Disabled : Boolean := False;
      Img_Disabled   : Boolean := False;
      Img            : Image_Ref := null;
      Invert_Img     : Image_Ref := null;
   end record;
end Giza.Widgets.Frame;
