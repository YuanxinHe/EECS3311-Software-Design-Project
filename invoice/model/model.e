note
	description: "Summary description for {MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVOICE_SYSTEM

inherit
	ANY
	redefine out end

	STATUS_MESSAGE
	undefine out end

create {INVOICE_SYSTEM_ACCESS,STUDENT_TEST1}
	make

feature {NONE} -- Initialization
	make
		do
			stock:= create{STOCK}.make
			invoices:= create{INVOICES}.make
			s:="  report:      ok%N"
			s.append ("  id:          0%N")
			s.append ("  products:   %N")
			s.append ("  stock:       %N")
			s.append ("  orders:      %N")
			s.append ("  carts:       %N")
			s.append ("  order_state: %N")
		end

feature  --attributes
	stock :  STOCK -- track the quantity of product left in our stock and store the product id

	invoices : INVOICES -- handle all orders and change their status.

	s:STRING      --store output string

feature  --commands using defensive programming

	add_order(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]])
	    --first remove corresponding goods in stock, second add new order into invoices; postconditions here are WEAK, deatailed postconditions hidden in respective classes in order to achieve information hiding. Same as all commands below
	require
		id_valid: not too_many_id(invoices)
		nonempty_cart: not is_empty_cart (order)
		all_quantity_valid: all_quantity_valid (order)
		all_products_valid: all_products_valid (order,stock)
		no_duplicate_products: not has_duplicate_products (order)
		enough_stock: not not_enough_stock(order,stock)
	do
		stock.add_order(order)
		invoices.add_order (order)
	ensure
		stock_decrease: stock.get_total_amount < old stock.get_total_amount
		invoices_increase: invoices.get_order_amount = old invoices.get_order_amount + 1
	end

	add_product(type_name:STRING;quantity:INTEGER)
	    --invoke corresponding command in STOCK if preconditions are satisfied
	require
		valid_quantity: not is_invalid_quantity (quantity)
		existed_type: is_existed_id (type_name,stock)
	do
		stock.add_product (type_name, quantity)
	ensure
		stock_increase: current.stock.get_total_amount = old current.stock.get_total_amount + quantity
	end

	add_type(type_name:STRING)
	    --invoke corresponding command in STOCK if preconditions are satisfied
	require
		valid_type_name: not is_invalid_type_name (type_name)
		not_existed: not is_existed_id (type_name,stock)
	do
		stock.add_type (type_name)
	ensure
		type_increase: current.stock.get_type_amount = old current.stock.get_type_amount + 1
		type_exist: current.stock.is_existed_id (type_name, stock)
	end

	cancel_order(id:INTEGER)
	    --first remove order from invoices, second restore corresponding goods in stock
	require
		valid_order_id: not is_invalid_order_id (id,invoices)
	local
	    order:ARRAY[TUPLE[STRING,INTEGER]]
	do
		create order.make_from_array (invoices.get_order(id))
		invoices.cancel_order (id)
		stock.cancel_order(order)
	ensure
		invoices_decrease: current.invoices.get_order_amount = old current.invoices.get_order_amount - 1
		stock_increase: current.stock.get_total_amount > old current.stock.get_total_amount
	end

	invoice(id:INTEGER)
	    --invoke corresponding command in INVOICES if preconditions are satisfied
	require
		valid_order_id: not is_invalid_order_id (id,invoices)
		not_invoiced_order: not is_invoiced_order (id,invoices)
	do
		invoices.invoice (id)
	ensure
		order_invoiced: current.invoices.get_odr (id).check_status
	end

	nothing
	    --no state changes after operation
	do

	end

feature --output handling
	update(msg:STRING)
			-- Perform update to the model state.
		do
			s:="  report:      "+msg+"%N"
			s.append ("  id:          "+invoices.get_current_id.out+"%N")
			s.append ("  products:   "+stock.get_products_id+"%N")
			s.append ("  stock:       "+stock.get_stock_detail+"%N")
			s.append ("  orders:      "+invoices.get_exsited_order+"%N")
			s.append ("  carts:       "+invoices.get_cart_detail+"%N")
			s.append ("  order_state: "+invoices.get_order_status+"%N")
		end

	out : STRING
		do
			Result := s
		end

end

