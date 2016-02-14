note
	description: "Summary description for {ENUM_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENUM_PARAM
inherit
	PRIMITIVE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	make

feature -- constructor
	make (list: ARRAY[STRING])
		do
			items := list
		end

feature -- attributes
	items: ARRAY[STRING]

feature -- queries

	eiffel_type : STRING
		do
			Result := "INTEGER"
		end

	create_clause : STRING
		local
			i: INTEGER
		do
			create Result.make_empty
			Result.append ("create {ENUM_PARAM}.make(<<")
			from
				i := items.lower
			until
				i > items.upper
			loop
				Result.append ("%"" + items[i] + "%"")
				if i < items.upper then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append (">>)")
		end

	out : STRING
		local
			i: INTEGER
		do
			create Result.make_empty
			Result.append ("{")
			from
				i := items.lower
			until
				i > items.upper
			loop
				Result.append (items[i])
				if i < items.upper then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append ("}")
		end
end

