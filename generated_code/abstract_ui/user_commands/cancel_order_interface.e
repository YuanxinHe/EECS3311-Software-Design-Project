note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class CANCEL_ORDER_INTERFACE
inherit
	COMMAND
	redefine make end

feature {NONE} -- Initialization

	make(a_name: STRING; args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			Precursor(a_name,args,a_container)
			routine := agent cancel_order(?)
			routine.set_operands (args)
			if
				attached {INTEGER} args[1] as order_id
			then
				out := "cancel_order(" + event_argument_out("cancel_order", "order_id", order_id) + ")"
			else
				error := True
			end
		end

feature -- command 
	cancel_order(order_id: INTEGER)
    	deferred
    	end
end
