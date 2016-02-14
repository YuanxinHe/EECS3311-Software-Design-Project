note
	description: "Summary description for {INT_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_PARAM
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
			Result := "create {INT_PARAM}"
		end

	out : STRING
		do
			Result := "INTEGER"
		end
end

