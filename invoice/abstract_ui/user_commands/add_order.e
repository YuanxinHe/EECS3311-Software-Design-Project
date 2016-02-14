note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class ADD_ORDER
inherit
	ADD_ORDER_INTERFACE
	redefine add_order end
create
	make
feature -- command
	add_order(a_order: ARRAY[TUPLE[pid: STRING; no: INTEGER]])
    	local
    		m:STATUS_MESSAGE
    	do
			-- perform some update on the model state
			if too_many_id(model.invoices) then
				create m.make_not_enough
				model.update (m.out)
			elseif is_empty_cart (a_order) then
				create m.make_empty_cart
				model.update (m.out)
			elseif not all_quantity_valid (a_order) then
				create m.make_negative_quantity
				model.update (m.out)
			elseif not all_products_valid (a_order,model.stock) then
				create m.make_not_valid_product
				model.update (m.out)
			elseif has_duplicate_products (a_order) then
				create m.make_duplicate_product
				model.update (m.out)
			elseif not_enough_stock (a_order,model.stock) then
				create m.make_not_enough
				model.update (m.out)
			else
				model.add_order (a_order)
				model.update("ok")
			end

			container.on_change.notify ([Current])
    	end
end
