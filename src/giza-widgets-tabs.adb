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

package body Giza.Widgets.Tabs is

   -----------
   -- Dirty --
   -----------

   function Dirty (This : Gtabs) return Boolean is (This.Root.Dirty);

   ----------
   -- Draw --
   ----------

   procedure Draw (This : in out Gtabs;
                   Ctx : in out Context'Class;
                   Force : Boolean := True) is
   begin
      This.Root.Draw (Ctx, Force);
   end Draw;

   --------------
   -- On_Click --
   --------------

   function On_Click
     (This  : in out Gtabs;
      Pos   : Point_T;
      CType : Click_Type) return Boolean
   is
   begin
      if This.Root.On_Click (Pos, CType) then
         for Index in This.Tabs'Range loop
            if Index /= This.Selected
              and then
                This.Tabs (Index).Button.Active
            then
               This.Set_Selected (Index);
               exit;
            end if;
         end loop;
         This.Tabs (This.Selected).Button.Set_Active (True);
         return True;
      else
         return False;
      end if;
   end On_Click;

   -------------
   -- Set_Tab --
   -------------

   procedure Set_Tab
     (This  : in out Gtabs;
      Index : Natural;
      Title : String;
      Child : not null Widget_Ref)
   is
      Button_Size : constant Size_T := (This.Get_Size.W / This.Tab_Number,
                                        (This.Get_Size.H / 4 - 1));
   begin
      --  Initialization (This could/should be done only once...)
      This.Root.Set_Size (This.Get_Size);
      This.Tabs_Group.Set_Size ((This.Get_Size.W, This.Get_Size.H / 4));
      This.Root.Add_Child (This.Tabs_Group'Unchecked_Access, (0, 0));

      if Index in This.Tabs'Range then
         This.Tabs (Index).Widg := Child;
         Child.Set_Size (This.Get_Size - (0, (This.Get_Size.H / 4) + 1));
         Child.Set_Dirty;
         This.Tabs (Index).Button.Set_Size (Button_Size);
         This.Tabs (Index).Button.Set_Text (Title);
         This.Tabs (Index).Button.Set_Foreground (This.Foreground);
         This.Tabs (Index).Button.Set_Background (This.Background);
         This.Tabs (Index).Button.Set_Toggle (True);

         This.Tabs_Group.Add_Child
           (This.Tabs (Index).Button'Unchecked_Access,
            (Button_Size.W * (Index - 1), 0));
         This.Set_Selected (Index);
      end if;
   end Set_Tab;

   --------------
   -- Selected --
   --------------

   function Selected (This : Gtabs) return Natural is (This.Selected);

   ------------------
   -- Set_Selected --
   ------------------

   procedure Set_Selected (This : in out Gtabs; Selected : Natural) is
   begin
      if Selected in This.Tabs'Range
        and then
         This.Tabs (Selected).Widg /= null
      then
         This.Root.Remove_Child (This.Tabs (This.Selected).Widg);
         This.Selected := Selected;
         This.Tabs (This.Selected).Widg.Set_Dirty;
         This.Root.Add_Child (This.Tabs (This.Selected).Widg,
                              (0, This.Get_Size.H / 4));

         for Index in This.Tabs'Range loop
            This.Tabs (Index).Button.Set_Active (Index = Selected);
            This.Tabs (Index).Button.Set_Disabled (Index = Selected);
         end loop;
      end if;
   end Set_Selected;

end Giza.Widgets.Tabs;
