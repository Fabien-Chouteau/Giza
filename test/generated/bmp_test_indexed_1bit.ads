--  This file was generated by bmp2ada
with Giza.Bitmaps.Indexed_1bit;
use Giza.Bitmaps.Indexed_1bit;
with Giza.Image.Bitmap.Indexed_1bit;

package bmp_test_indexed_1bit is
   pragma Style_Checks (Off);

   Data : aliased constant Bitmap_Indexed := (W => 50, H => 50, Length_Byte => 313,
Palette => (
(R => 0, G => 2, B => 0),
(R => 253, G => 255, B => 252)), Data => (
 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 192, 255, 127, 254, 3, 254,
 3, 248, 31, 128, 15, 192, 207, 207, 63, 255, 60, 255, 62, 127, 127, 255, 255, 252, 243, 252, 249, 252, 255, 243, 239,
 243, 247, 251, 255, 207, 191, 207, 223, 239, 255, 63, 255, 63, 191, 159, 255, 255, 0, 254, 0, 127, 126, 192, 3, 224,
 3, 254, 251, 1, 207, 63, 207, 247, 239, 255, 60, 255, 61, 159, 191, 255, 243, 252, 231, 252, 252, 252, 207, 243, 159,
 243, 247, 247, 63, 207, 127, 207, 191, 63, 255, 60, 255, 60, 255, 253, 1, 248, 0, 248, 252, 239, 127, 254, 3, 254,
 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 15, 255, 255, 255, 255, 255,
 63, 252, 143, 63, 128, 255, 255, 240, 31, 254, 0, 240, 255, 255, 7, 248, 3, 128, 255, 255, 31, 224, 15, 63, 254,
 63, 124, 128, 63, 252, 240, 255, 240, 31, 254, 240, 227, 255, 195, 127, 248, 195, 143, 255, 15, 255, 225, 15, 128, 255,
 63, 252, 135, 63, 0, 254, 255, 240, 31, 254, 0, 224, 255, 195, 127, 248, 195, 31, 255, 15, 255, 225, 15, 127, 248,
 63, 252, 135, 63, 252, 225, 255, 240, 31, 254, 240, 199, 255, 195, 7, 128, 3, 0, 255, 15, 31, 0, 14, 0, 255,
 63, 124, 0, 56, 128, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
));

   Image :
   aliased Giza.Image.Bitmap.Indexed_1bit.Instance
     (Data'Access);
   pragma Style_Checks (On);
end bmp_test_indexed_1bit;
