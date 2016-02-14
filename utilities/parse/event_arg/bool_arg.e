note
	description: "Summary description for {BOOL_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOL_ARG
inherit
	PRIMITIVE_ARG
	redefine
		out
	end

	ANY
	undefine
		out
	end
create
	make
feature
	make (b: BOOLEAN)
	  do
	  	create src_out.make_empty
	    value := b
	  end
feature
	value : BOOLEAN
feature
	out : STRING
		do
			Result := value.out
		end
end

