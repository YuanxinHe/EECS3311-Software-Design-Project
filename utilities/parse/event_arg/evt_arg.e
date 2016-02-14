note
	description: "Summary description for {EVT_ARG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVT_ARG

feature -- query
	src_out : STRING
		-- Original representation of the argument in the input file.
		-- e.g., for enumerated type argument src_out = 'on'

	set_src_out (s: STRING) 
		do
			src_out := s
		end
end

