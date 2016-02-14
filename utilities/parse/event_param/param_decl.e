note
	description: "Summary description for {PARAM_DECL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PARAM_DECL
create
	make
feature
	make (n : STRING; t : PARAM_TYPE)
		do
			name := n
			type := t
		end
feature
	name : STRING
	type : PARAM_TYPE
end

