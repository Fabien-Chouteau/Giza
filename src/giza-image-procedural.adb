package body Giza.Image.Procedural is

   ----------
   -- Size --
   ----------

   overriding function Size
     (This : Instance)
      return Size_T
   is
   begin
      return (This.Widht, This.Height);
   end Size;

end Giza.Image.Procedural;
