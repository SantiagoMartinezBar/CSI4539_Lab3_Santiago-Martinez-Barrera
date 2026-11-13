package Proof_Copy with SPARK_Mode => On is
   subtype Buffer is String (1 .. 100);
   procedure Copy (Size : Positive; Data : out Buffer)
     with Global => null,
          Depends => (Data => Size),
          Pre => Size <= 101;
end Proof_Copy;
