note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class CANCEL_ORDER
inherit
	CANCEL_ORDER_INTERFACE
	redefine cancel_order end
create
	make
feature -- command
	cancel_order(order_id: INTEGER)
		local
			m: STATUS_MESSAGE
    	do
			-- perform some update on the model state
			if is_invalid_order_id (order_id,model.invoices) then
				create m.make_invalid_order_id
				model.update (m.out)
			else
				model.cancel_order (order_id)
				model.update("ok")
			end

			container.on_change.notify ([Current])
    	end

end
