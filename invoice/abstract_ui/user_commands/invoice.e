note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class INVOICE
inherit
	INVOICE_INTERFACE
	redefine invoice end
create
	make
feature -- command
	invoice(order_id: INTEGER)
		local
			m: STATUS_MESSAGE
    	do
			-- perform some update on the model state
			if is_invalid_order_id (order_id,model.invoices) then
				create m.make_invalid_order_id
				model.update (m.out)
			elseif is_invoiced_order (order_id,model.invoices) then
				create m.make_invoiced_order
				model.update (m.out)
			else
				model.invoice (order_id)
				model.update("ok")
			end
			container.on_change.notify ([Current])
    	end

end
