package E is
   procedure P1 with SPARK_Mode;

   procedure P2 with SPARK_Mode => On;

   procedure P3 with SPARK_Mode;
end E;
