with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Widgets.Composite; use Giza.Widgets.Composite;
with Ada.Real_Time; use Ada.Real_Time;

package Giza.Widgets.Number_Selection is

   type Gnumber_Select is new Gframe with private;

   type Gnumber_Select_Ref is access all Gnumber_Select'Class;

   overriding
   procedure Set_Dirty (This : in out Gnumber_Select;
                        Dirty : Boolean := True);
   overriding
   procedure Draw (This : in out Gnumber_Select;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Gnumber_Select;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

   overriding
   function On_Event
     (This : in out Gnumber_Select;
      Evt  : Event_Not_Null_Ref) return Boolean;

   procedure Set_Value (This : in out Gnumber_Select; Val : Integer);
   procedure Set_Step (This : in out Gnumber_Select; Step : Integer);
   procedure Set_Min (This : in out Gnumber_Select; Min : Integer);
   procedure Set_Max (This : in out Gnumber_Select; Max : Integer);
   procedure Set_Label (This : in out Gnumber_Select; Label : String);
   procedure Show_Value (This : in out Gnumber_Select;
                         Show : Boolean := True);

   procedure Do_Plus (This : in out Gnumber_Select);
   procedure Do_Minus (This : in out Gnumber_Select);

   function Value (This : Gnumber_Select) return Integer;
private

   type Repeat_Event is new Timer_Event with record
      Nbr : Gnumber_Select_Ref;
   end record;

   procedure Triggered (This : Repeat_Event);

   type Gnumber_Select is new Gframe with record
      Repeat_Time : Time_Span := Milliseconds (200);
      Repeat_Evt  : aliased Repeat_Event;
      Init        : Boolean := False;
      Show_Value  : Boolean := False;
      Value       : Integer := 0;
      Min         : Integer := 0;
      Max         : Integer := 100;
      Step        : Integer := 5;
      Plus, Minus : access Gbutton := null;
      Str         : access String  := null;
      Root        : Composite_Widget;
   end record;
end Giza.Widgets.Number_Selection;
