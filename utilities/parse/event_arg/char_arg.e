note
	description: "Summary description for {CHAR_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHAR_ARG
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
	make (c: CHARACTER)
	  do
	  	create src_out.make_empty
	    value := c
	  end
feature
	value : CHARACTER
feature
	out : STRING
		do
			Result := "'" + value.out + "'"
		end
end

