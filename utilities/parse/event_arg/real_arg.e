note
	description: "Summary description for {REAL_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REAL_ARG
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
	make (r: REAL)
	  do
	  	create src_out.make_empty
	    value := r
	  end
feature
	value : REAL
feature
	out : STRING
		do
			Result := value.out
		end
end

