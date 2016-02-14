note
	description: "Summary description for {INT_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_ARG
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
	make(i : INTEGER)
	  do
	  	create src_out.make_empty
	    value := i
	  end
feature
	value : INTEGER
feature
	out : STRING
		do
			Result := value.out
		end
end

