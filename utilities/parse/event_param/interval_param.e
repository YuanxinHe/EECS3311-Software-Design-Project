note
	description: "Summary description for {INTERVAL_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERVAL_PARAM
inherit
	PRIMITIVE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	make

feature -- constructor
	make (l, u: INTEGER)
		do
			lower := l
			upper := u
		end

feature -- attributes
	lower, upper: INTEGER

feature -- queries

	eiffel_type : STRING
		do
			Result := "INTEGER"
		end

	create_clause : STRING
		do
			Result := "create {INTERVAL_PARAM}.make(" +
						lower.out + ", " + upper.out + ")"
		end

	out : STRING
		do
			Result := lower.out + " .. " + upper.out
		end
end

