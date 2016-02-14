note
	description: "Summary description for {VALUE_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VALUE_PARAM
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
			Result := "create {VALUE_PARAM}"
		end

	out : STRING
		do
			Result := "VALUE"
		end
end

