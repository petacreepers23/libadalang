procedure Foo is
begin

------------
-- Simple --
------------

#if A then
   null;
#end if;

#if not A then
   null;
#end if;

------------
-- Binops --
------------

#if A or T then
   null;
#end if;

#if T or A then
   null;
#end if;

#if A and T then
   null;
#end if;

#if T and A then
   null;
#end if;

#if A or F then
   null;
#end if;

#if F or A then
   null;
#end if;

#if A and F then
   null;
#end if;

#if F and A then
   null;
#end if;
end Foo;
