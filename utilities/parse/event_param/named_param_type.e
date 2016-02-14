note
	description: "Summary description for {NAMED_PARAM_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NAMED_PARAM_TYPE
inherit
	PARAM_TYPE
	redefine
		out, eiffel_type
	end

	COMPOSITE_PARAM_TYPE
	redefine
		out, eiffel_type
	end

	PRIMITIVE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	make

feature -- contructor
	make (n: STRING; t: PARAM_TYPE)
		do
			name := n
			type := t
		end

feature -- attributes
	name: STRING
	type: PARAM_TYPE

feature -- queries
	eiffel_type : STRING
		do
			Result := type.eiffel_type
		end

	create_clause : STRING
		do
			Result := "create {NAMED_PARAM_TYPE}.make(" +
						"%"" + name + "%"" + ", " + type.create_clause + ")"
		end

	out : STRING
		do
			Result := name + " = " + type.out
		end
end

