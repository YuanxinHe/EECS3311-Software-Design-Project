note
	description: "Summary description for {ARRAY_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARRAY_PARAM
inherit
	COMPOSITE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	make
feature
	make (base : PRIMITIVE_PARAM_TYPE)
		do
			base_type := base
		end

feature -- attributes

base_type : PRIMITIVE_PARAM_TYPE

feature -- queries

	eiffel_type : STRING
		do
			Result := "ARRAY[" + base_type.eiffel_type + "]"
		end

	create_clause : STRING
		do
			Result := "create {ARRAY_PARAM}.make (" +
						base_type.create_clause + ")"
		end

	out : STRING
		do
			Result := "ARRAY[" + base_type.out + "]"
		end
end

