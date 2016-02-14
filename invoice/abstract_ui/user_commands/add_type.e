note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_TYPE
inherit
	ADD_TYPE_INTERFACE
	redefine add_type end
create
	make
feature -- command
	add_type(product_id: STRING)
		local
			m: STATUS_MESSAGE
    	do
			if is_invalid_type_name (product_id) then
				create m.make_empty_string
				model.update (m.out)
			elseif is_existed_id (product_id,model.stock) then
				create m.make_already_exsit
				model.update (m.out)
			else
				model.add_type (product_id)
				model.update("ok")
			end
			-- perform some update on the model state

			container.on_change.notify ([Current])
    	end

end
