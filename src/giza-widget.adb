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
