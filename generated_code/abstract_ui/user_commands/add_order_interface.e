note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class ADD_ORDER_INTERFACE
inherit
	COMMAND
	redefine make end

feature {NONE} -- Initialization

	make(a_name: STRING; args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			Precursor(a_name,args,a_container)
			routine := agent add_order(?)
			routine.set_operands (args)
			if
				attached {ARRAY[TUPLE[pid: STRING; no: INTEGER]]} args[1] as a_order
			then
				out := "add_order(" + event_argument_out("add_order", "a_order", a_order) + ")"
			else
				error := True
			end
		end

feature -- command 
	add_order(a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]])
    	deferred
    	end
end
