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

package body Giza.Widgets.Button is

   --------------
   -- On_Click --
   --------------

   function On_Click
     (This  : in out Gbutton;
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
   function On_Click_Released (This  : in out Gbutton) return Boolean is
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

   function Active (This : Gbutton) return Boolean is (This.Is_Active);

   ----------------
   -- Set_Active --
   ----------------

   procedure Set_Active (This : in out Gbutton; Active : Boolean := True) is
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

   procedure Set_Toggle (This : in out Gbutton; Toggle : Boolean := True) is
   begin
      This.Is_Toggle := Toggle;
   end Set_Toggle;

end Giza.Widgets.Button;
