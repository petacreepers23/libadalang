package body Xrefs_Wrapper is

   function Subp_Spec_Params (Spec : Subp_Spec) return Param_Spec_List is
     (Spec.F_Subp_Params.F_Params);
   function Subp_Decl_Params (Decl : Subp_Decl) return Param_Spec_List is
     (Subp_Spec_Params (Decl.F_Subp_Spec));

   ----------------------
   -- Subp_Body_Formal --
   ----------------------

   function Subp_Body_Formal (Decl : Basic_Decl'Class) return Basic_Decl is
      Subp_Decl : Libadalang.Analysis.Subp_Decl;
      Subp_Body : Libadalang.Analysis.Subp_Body;
   begin
      if Decl.Kind /= Ada_Param_Spec then
         return No_Basic_Decl;
      end if;

      --  TODO: use Decl.P_Semantic_Parent when GitHub issue #28 is fixed
      Subp_Body := Decl.Parent.Parent.Parent.Parent.As_Subp_Body;

      Subp_Decl := Subp_Body.P_Decl_Part.As_Subp_Decl;
      if Subp_Decl.Is_Null then
         return No_Basic_Decl;
      end if;

      declare
         Decl_Params : constant Param_Spec_List :=
           Subp_Decl_Params (Subp_Decl);
         Formal_Index : constant Positive := Decl.Child_Index + 1;
      begin
         return Decl_Params.Child (Formal_Index).As_Basic_Decl;
      end;
   end Subp_Body_Formal;

end Xrefs_Wrapper;
