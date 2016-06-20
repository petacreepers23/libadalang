with Ada.Strings.Maps;
with Ada.Strings.Maps.Constants;

with Interfaces; use Interfaces;

with Langkit_Support.Text; use Langkit_Support.Text;

with Libadalang.AST.Types; use Libadalang.AST.Types;

package body Libadalang.Unit_Files is

   function Get_Unit_Name (N : Name) return Text_Type;
   --  Return a Name as a string. For instance: "Foo.Bar". Raise a
   --  Property_Error if N is not a valid unit name.

   function Get_Unit_File_Name (Name : Text_Type) return String;
   --  Return the file name corresponding to a unit name. Raise a
   --  Property_Error if N is not a valid unit name.
   --
   --  TODO??? Right now, this handles only pure ASCII unit names as it's not
   --  clear how we should handle Unicode characters for file names.

   function Get_Unit_File_Name (N : Name) return String is
     (Get_Unit_File_Name (Get_Unit_Name (N)));

   procedure Handle_With_Decl (Ctx : Analysis_Context; Names : List_Name);
   --  Helper for the environment hook to handle WithDecl nodes

   --------------
   -- Env_Hook --
   --------------

   procedure Env_Hook
     (Unit        : Analysis_Unit;
      Node        : Ada_Node;
      Initial_Env : in out Lexical_Env)
   is
      pragma Unreferenced (Initial_Env);
      Ctx : constant Analysis_Context := Get_Context (Unit);
   begin
      if Node.all in With_Decl_Type'Class then
         Handle_With_Decl (Ctx, With_Decl (Node).F_Packages);
      end if;
   end Env_Hook;

   ----------------------
   -- Handle_With_Decl --
   ----------------------

   procedure Handle_With_Decl (Ctx : Analysis_Context; Names : List_Name) is
   begin
      for N of Names.all loop
         declare
            Unit_File_Name : constant String :=
               Get_Unit_File_Name (Name (N)) & ".ads";
            Unit           : constant Analysis_Unit :=
               Get_From_File (Ctx, Unit_File_Name);
         begin
            --  TODO??? Should we do something special if the Unit has parsing
            --  errors?
            if Root (Unit) /= null then
               Populate_Lexical_Env (Unit);
            end if;
         end;
      end loop;
   end Handle_With_Decl;

   -------------------
   -- Get_Unit_Name --
   -------------------

   function Get_Unit_Name (N : Name) return Text_Type is
   begin
      if N.all in Identifier_Type'Class then
         return Data (Identifier (N).F_Tok).Text.all;

      elsif N.all in Dotted_Name_Type'Class then
         declare
            DN : constant Dotted_Name := Dotted_Name (N);
         begin
            if DN.F_Prefix.all in Name_Type'Class
               and then DN.F_Suffix.all in Identifier_Type'Class
            then
               return (Get_Unit_Name (Name (DN.F_Prefix))
                       & "."
                       & Get_Unit_Name (Name (DN.F_Suffix)));
            end if;
         end;
      end if;

      raise Property_Error with "invalid AST node for unit name";
   end Get_Unit_Name;

   ------------------------
   -- Get_Unit_File_Name --
   ------------------------

   function Get_Unit_File_Name (Name : Text_Type) return String is
      Result : String (1 .. Name'Length);
      I      : Positive := 1;
   begin
      for C of Name loop
         declare
            CN : constant Unsigned_32 := Wide_Wide_Character'Pos (C);
         begin
            if C = '.' then
               Result (I) := '-';
            elsif CN in 16#20# .. 16#7f# then
               Result (I) := Ada.Strings.Maps.Value
                 (Ada.Strings.Maps.Constants.Lower_Case_Map,
                  Character'Val (CN));
            else
               raise Property_Error with "unhandled unit name";
            end if;
         end;
         I := I + 1;
      end loop;
      return Result;
   end Get_Unit_File_Name;

end Libadalang.Unit_Files;
