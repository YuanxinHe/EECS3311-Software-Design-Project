note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_PRODUCT
inherit
	ADD_PRODUCT_INTERFACE
	redefine add_product end
create
	make
feature -- command
	add_product(a_product: STRING ; quantity: INTEGER)
		local
			m: STATUS_MESSAGE
    	do
			-- perform some update on the model state
			if is_invalid_type_name (a_product) then
				create m.make_empty_string
				model.update (m.out)
			elseif not is_existed_id (a_product,model.stock) then
				create m.make_no_product
				model.update (m.out)
			elseif is_invalid_quantity (quantity) then
				create m.make_negative_quantity
				model.update (m.out)
			else
				model.add_product (a_product, quantity)
				model.update("ok")
			end
			container.on_change.notify ([Current])
    	end

end
