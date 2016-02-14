note
	description: "Summary description for {PARAM_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PARAM_TYPE

feature -- query
	eiffel_type: STRING
			-- Representation as a valid Eiffel type.
			-- The 'out' feature, on the other hand, may give
			-- more information about the parameter type.
			-- e.g., out = "1..10" and eiffel_type = "INTEGER"
		deferred end

	create_clause: STRING
			-- Creation instruction needed to recreate the current type.
		deferred end
end

