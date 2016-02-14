note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class ADD_PRODUCT_INTERFACE
inherit
	COMMAND
	redefine make end

feature {NONE} -- Initialization

	make(a_name: STRING; args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			Precursor(a_name,args,a_container)
			routine := agent add_product(? , ?)
			routine.set_operands (args)
			if
				attached {STRING} args[1] as a_product and then attached {INTEGER} args[2] as quantity
			then
				out := "add_product(" + event_argument_out("add_product", "a_product", a_product) + "," + event_argument_out("add_product", "quantity", quantity) + ")"
			else
				error := True
			end
		end

feature -- command 
	add_product(a_product: STRING ; quantity: INTEGER)
    	deferred
    	end
end
