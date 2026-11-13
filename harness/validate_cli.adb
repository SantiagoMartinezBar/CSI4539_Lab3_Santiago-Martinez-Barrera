with Ada.Command_Line;
with Ada.Exceptions;
with Ada.Streams;
with Ada.Streams.Stream_IO;
with Ada.Text_IO;
with Input_Validator;

-- Je garde les entrées/sorties hors du module SPARK prouvé.
procedure Validate_Cli is
   use Ada.Streams;
   package IO renames Ada.Streams.Stream_IO;
   File   : IO.File_Type;
   Raw    : Stream_Element_Array (1 .. 101);
   Last   : Stream_Element_Offset;
   Result : Input_Validator.Validation_Result;
begin
   if Ada.Command_Line.Argument_Count /= 1 then
      Ada.Text_IO.Put_Line ("ERROR usage: validate_cli INPUT_FILE");
      Ada.Command_Line.Set_Exit_Status (2);
      return;
   end if;
   IO.Open (File, IO.In_File, Ada.Command_Line.Argument (1));
   IO.Read (File, Raw, Last);
   IO.Close (File);
   declare
      Input : String (1 .. Natural (Last));
   begin
      for I in Input'Range loop
         Input (I) := Character'Val (Raw (Stream_Element_Offset (I)));
      end loop;
      Input_Validator.Validate (Input, Result);
   end;
   if Result.Accepted then
      Ada.Text_IO.Put_Line ("ACCEPT" & Result.Length'Image);
   else
      Ada.Text_IO.Put_Line ("REJECT");
      Ada.Command_Line.Set_Exit_Status (1);
   end if;
exception
   when Error : others =>
      if IO.Is_Open (File) then
         IO.Close (File);
      end if;
      Ada.Text_IO.Put_Line
        ("ERROR " & Ada.Exceptions.Exception_Name (Error));
      Ada.Command_Line.Set_Exit_Status (2);
end Validate_Cli;
