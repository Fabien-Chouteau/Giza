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

package body Giza.Widgets is

   -----------
   -- Dirty --
   -----------

   function Dirty (This : Widget) return Boolean is (This.Is_Dirty);

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Widget; Dirty : Boolean) is
   begin
      This.Is_Dirty := Dirty;
   end Set_Dirty;

   --------------
   -- Set_Size --
   --------------

   procedure Set_Size (This : in out Widget; Size : Size_T) is
   begin
      This.Size := Size;
   end Set_Size;

   --------------
   -- Get_Size --
   --------------

   function Get_Size (This : Widget) return Size_T is (This.Size);

end Giza.Widgets;
