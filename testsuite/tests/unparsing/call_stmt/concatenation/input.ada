Add_Attribute
  (Package_Name         => +"IDE",
   Attribute_Name       => +"Connection_Tool",
   Description          =>
     "Executable used to interface with a "
   & "remote target when debugging. GNAT Studio currently supports "
   & "OpenOCD, st-util or pyOCD. You can leave this attribute empty "
   & "if you are using a custom tool spawned outside of GNAT Studio'.",
   Index_Type           => PRA.No_Index,
   Value                => Single,
   Value_Case_Sensitive => True);
