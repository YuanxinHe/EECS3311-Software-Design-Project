note
	description: "Summary description for {BOOL_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REAL_PARAM
inherit
	PRIMITIVE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	default_create

feature -- queries

	eiffel_type : STRING
		do
			Result := out
		end

	create_clause : STRING
		do
			Result := "create {REAL_PARAM}"
		end

	out : STRING
		do
			Result := "REAL"
		end
end

