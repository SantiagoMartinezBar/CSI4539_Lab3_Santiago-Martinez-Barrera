package Input_Validator with SPARK_Mode => On is
   Maximum_Length : constant := 100;
   subtype Buffer_Index is Positive range 1 .. Maximum_Length;
   subtype Input_Length is Natural range 0 .. Maximum_Length;

   function Is_Allowed (Value : Character) return Boolean is
     (Value in 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '.');

   subtype Allowed_Character is Character
     with Dynamic_Predicate => Is_Allowed (Allowed_Character);

   type Validation_Result is record
      Accepted : Boolean := False;
      Length   : Input_Length := 0;
      Data     : String (Buffer_Index) := [others => ' '];
   end record;

   function Meets_Policy (Input : String) return Boolean is
     (Input'Length in 1 .. Maximum_Length
      and then (for all C of Input => Is_Allowed (C)));

   procedure Copy_Valid (Input : String; Result : out Validation_Result)
     with Global => null,
          Depends => (Result => Input),
          Pre => Meets_Policy (Input),
          Post => Result.Accepted
            and then Result.Length = Input'Length
            and then Result.Data (1 .. Result.Length) = Input
            and then (for all I in 1 .. Result.Length =>
                        Is_Allowed (Result.Data (I)));

   procedure Validate (Input : String; Result : out Validation_Result)
     with Global => null,
          Depends => (Result => Input),
          Post => Result.Accepted = Meets_Policy (Input)
            and then
              (if Result.Accepted then
                 Result.Length = Input'Length
                 and then Result.Data (1 .. Result.Length) = Input
                 and then (for all I in 1 .. Result.Length =>
                             Is_Allowed (Result.Data (I)))
               else Result.Length = 0
                 and then (for all C of Result.Data => C = ' '));
end Input_Validator;
