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

   procedure Set_Dirty (This : in out Widget; Dirty : Boolean := True) is
   begin
      This.Is_Dirty := Dirty;
   end Set_Dirty;

   ------------------
   -- Set_Disabled --
   ------------------

   procedure Set_Disabled (This : in out Widget; Disabled : Boolean := True) is
   begin
      This.Is_Disabled := Disabled;
   end Set_Disabled;

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

   ----------------------
   -- On_Builtin_Event --
   ----------------------

   function On_Builtin_Event
     (This : in out Widget'Class;
      Evt : Event_Not_Null_Access) return Boolean
   is
   begin
      if This.Is_Disabled then
         return False;
      end if;

      if Evt.all in Click_Event'Class then
         declare
            Click : constant Click_Event_Ref := Click_Event_Ref (Evt);
            Unref : Boolean with Unreferenced;
         begin
            return This.On_Click (Click.Pos, Click.CType);
         end;
      else
         return This.On_Custom_Event (Evt);
      end if;
   end On_Builtin_Event;

end Giza.Widgets;
