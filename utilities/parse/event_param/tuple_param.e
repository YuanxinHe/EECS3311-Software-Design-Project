note
	description: "Summary description for {TUPLE_PARAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_PARAM
inherit
	PRIMITIVE_PARAM_TYPE
	redefine
		out, eiffel_type
	end
create
	make

feature

	make (types : ARRAY[PARAM_DECL])
		do
			base_types := types
		end

feature -- attributes

	base_types : ARRAY[PARAM_DECL]

feature -- queries

	eiffel_type : STRING
		local
			i: INTEGER
		do
			from
				create Result.make_empty
				Result.append ("TUPLE[")
				i := base_types.lower
			until
				i > base_types.upper
			loop
				Result.append (base_types[i].name)
				Result.append (": ")
				Result.append (base_types[i].type.eiffel_type)
				if i < base_types.upper then
					Result.append ("; ")
				end
				i := i + 1
			end
			Result.append ("]")
		end

	create_clause : STRING
		local
			i: INTEGER
		do
			from
				create Result.make_empty
				Result.append ("create {TUPLE_PARAM}.make(<<")
				i := base_types.lower
			until
				i > base_types.upper
			loop
				Result.append ("create {PARAM_DECL}.make(")
				Result.append ("%"" + base_types[i].name + "%"")
				Result.append (", ")
				Result.append (base_types[i].type.create_clause)
				Result.append (")")
				if i < base_types.upper then
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
			from
				create Result.make_empty
				Result.append ("TUPLE[")
				i := base_types.lower
			until
				i > base_types.upper
			loop
				Result.append (base_types[i].name)
				Result.append (": ")
				Result.append (base_types[i].type.out)
				if i < base_types.upper then
					Result.append ("; ")
				end
				i := i + 1
			end
			Result.append ("]")
		end
end

