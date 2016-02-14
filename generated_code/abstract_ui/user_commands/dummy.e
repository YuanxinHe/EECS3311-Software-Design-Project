note
	description: "Summary description for {DUMMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUMMY
inherit
	COMMAND
	redefine
		make
	end
create
	make

feature {NONE} -- Initialization

	make(a_name: STRING; a_args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			Precursor(a_name,a_args,a_container)
			routine := agent dummy
			routine.set_operands (a_args)
			out := "dummy"
		end

feature -- routine

	  dummy
    	do
    		container.on_change.notify ([Current])
    	end
end

