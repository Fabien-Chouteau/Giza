with Giza.Widget.Frame; use Giza.Widget.Frame;
with Giza.Widget.Button; use Giza.Widget.Button;
with Giza.Widget.Composite; use Giza.Widget.Composite;
with Ada.Real_Time; use Ada.Real_Time;

package Giza.Widget.Number_Selection is

   subtype Parent is Frame.Instance;
   type Instance is new Parent with private;
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

   procedure Set_Value (This : in out Instance; Val : Integer);
   procedure Set_Step (This : in out Instance; Step : Integer);
   procedure Set_Min (This : in out Instance; Min : Integer);
   procedure Set_Max (This : in out Instance; Max : Integer);
   procedure Set_Label (This : in out Instance; Label : String);
   procedure Show_Value (This : in out Instance;
                         Show : Boolean := True);

   procedure Do_Plus (This : in out Instance);
   procedure Do_Minus (This : in out Instance);

   function Value (This : Instance) return Integer;
private

   type Repeat_Event is new Timer_Event with record
      Nbr : Instance_Ref;
   end record;

   overriding
   function Triggered (This : Repeat_Event) return Boolean;

   type Instance is new Parent with record
      Repeat_Time : Time_Span := Milliseconds (200);
      Repeat_Evt  : aliased Repeat_Event;
      Init        : Boolean := False;
      Show_Value  : Boolean := False;
      Value       : Integer := 0;
      Min         : Integer := 0;
      Max         : Integer := 100;
      Step        : Integer := 5;
      Plus, Minus : access Button.Instance := null;
      Str         : access String  := null;
      Root        : Composite.Instance;
   end record;
end Giza.Widget.Number_Selection;
