note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class NOTHING_INTERFACE
inherit
	COMMAND
	redefine make end

feature {NONE} -- Initialization

	make(a_name: STRING; args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			Precursor(a_name,args,a_container)
			routine := agent nothing
			routine.set_operands (args)
			if
				TRUE
			then
				out := "nothing"
			else
				error := True
			end
		end

feature -- command 
	nothing
    	deferred
    	end
end
