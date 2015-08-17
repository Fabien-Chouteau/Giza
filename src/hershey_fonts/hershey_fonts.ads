package Hershey_Fonts is

   subtype Coord is Integer range -49 .. 40;

   type Vect is record
      X, Y : Coord;
   end record;

   Raise_Pen : constant Vect := (Coord'Last, Coord'Last);

   type Vect_Array is array (Natural range <>) of Vect;

   type Glyph (Number_Of_Vectors : Natural) is record
      Left, Right, Top, Bottom : Coord;
      Charcode                 : Integer;
      Vects                    : Vect_Array (1 .. Number_Of_Vectors);
   end record;

   type Glyph_Access is not null access constant Glyph;

   subtype Glyph_Index is Positive;

   type Glyph_Access_Array is array (Positive range <>) of Glyph_Access;

   type Font_Def (Number_Of_Glyphs : Natural) is record
      Glyphs : Glyph_Access_Array (1 .. Number_Of_Glyphs);
   end record;

   type Font_Access is not null access constant Font_Def;

   Empty_Glyph : aliased constant Glyph;
   Empty_Font : aliased constant Font_Def;
private

   Empty_Glyph : aliased constant Glyph :=
     (Number_Of_Vectors => 0,
      Charcode => 0,
      Left => 0,
      Right => 0,
      Top => 0,
      Bottom => 0,
      Vects => (others => (Raise_Pen)));

   Empty_Font : aliased constant Font_Def :=
     (Number_Of_Glyphs => 0, Glyphs => (others => Empty_Glyph'Access));

end Hershey_Fonts;
