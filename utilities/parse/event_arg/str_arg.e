note
	description: "Summary description for {STR_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STR_ARG
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
	make (s: STRING)
	  do
	  	create src_out.make_empty
	    value := s
	  end
feature
	value : STRING
feature
	out : STRING
		do
			Result := "%"" + value.out + "%""
		end
end

