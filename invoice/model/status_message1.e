note
	description: "Error Messages for invoice"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS_MESSAGE

inherit
	ANY
		redefine out end

create
	make_ok,
	make_empty_string,
	make_already_exsit,
	make_negative_quantity,
	make_no_product,
	make_no_more_id,
	make_empty_cart,
	make_not_valid_product,
	make_duplicate_product,
	make_not_enough,
	make_invalid_order_id,
	make_invoiced_order


feature {NONE} -- Initialization
	make_ok
		do
			err_code := err_ok
		end
	make_empty_string
		do
			err_code := err_empty_string
		end
	make_already_exsit
		do
			err_code := err_already_exsit
		end
	make_negative_quantity
		do
			err_code := err_negative_quantity
		end
	make_no_product
		do
			err_code := err_no_product
		end
	make_no_more_id
		do
			err_code := err_no_more_id
		end
	make_empty_cart
		do
			err_code := err_empty_cart
		end
	make_not_valid_product
		do
			err_code := err_not_valid_product
		end
	make_duplicate_product
		do
			err_code := err_duplicate_product
		end
	make_not_enough
		do
			err_code := err_not_enough
		end
	make_invalid_order_id
		do
			err_code := err_invalid_order_id
		end
	make_invoiced_order
		do
			err_code := err_invoiced_order
		end
feature --ancillary boolean queries (sorted alphabetically)

	all_products_valid(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]];stock:STOCK):BOOLEAN
	do
		result:= across order as x all is_existed_id(x.item.type_name,stock) end
	end

	all_quantity_valid(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]]):BOOLEAN
	do
		result:= across order as x all x.item.amount > 0 end
	end

	has_duplicate_products(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]]):BOOLEAN
	local
		tem_id_list:LINKED_LIST[STRING]
		tem_boolean:BOOLEAN
	do
		tem_id_list:=create{LINKED_LIST[STRING]}.make
		result:=false
		across order as x loop
			tem_boolean:= across tem_id_list as tests_id some tests_id.item.is_equal (x.item.type_name)  end
			if tem_boolean then
				result:=true
			else
				tem_id_list.force (x.item.type_name)
			end
		end
	end

	is_empty_cart(order:ARRAY[TUPLE[STRING,INTEGER]]):BOOLEAN
	do
		result:= order.is_empty
	end

	is_existed_id(type_name:STRING;stock:STOCK):BOOLEAN
	do
		result:= stock.is_existed_id(type_name,stock)
	end

	is_invalid_order_id(id:INTEGER;invoices:INVOICES):BOOLEAN
	do
		result:= invoices.is_invalid_order_id(id, invoices)
	end

	is_invalid_quantity(quantity:INTEGER):BOOLEAN
	do
		result:= quantity <= 0
	end

	is_invalid_type_name(type_name:STRING): BOOLEAN
	do
		Result := type_name.count < 1
	ensure
		Result implies type_name.count < 1
	end

	is_invoiced_order(id:INTEGER;invoices:INVOICES):BOOLEAN
	do
		result:= invoices.is_invoiced_order (id, invoices)
	end

	not_enough_stock(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]];stock:STOCK):BOOLEAN
	do
		result:= stock.not_enough_stock(order, stock)
	end

	too_many_id(invoices:INVOICES):BOOLEAN
	do
		result:= invoices.too_many_id(invoices)
	end

feature -- output handling
	out: STRING
			-- string representation of current status message
		do
			Result := err_message [err_code]
		end

feature {NONE} --erro message handling
	err_code: INTEGER

	err_message: ARRAY[STRING]
		once
			create Result.make_filled ("", 1, 12)
			Result.put("ok",1)
			Result.put ("product type must be non-empty string",2)
			Result.put("product type already in database",3)
			Result.put ("quantity added must be positive", 4)
			Result.put ("product not in database", 5)
			Result.put ("no more order ids left", 6)
			Result.put ("cart must be non-empty", 7)
			Result.put ("some products in order not valid", 8)
			Result.put ("duplicate products in order array", 9)
			Result.put ("not enough in stock", 10)
			Result.put ("order id is not valid", 11)
			Result.put ("order already invoiced", 12)
		end

	err_ok: INTEGER = 1
	err_empty_string : INTEGER = 2
	err_already_exsit: INTEGER = 3
	err_negative_quantity: INTEGER = 4
	err_no_product: INTEGER = 5
	err_no_more_id: INTEGER = 6
	err_empty_cart: INTEGER = 7
	err_not_valid_product: INTEGER = 8
	err_duplicate_product: INTEGER = 9
	err_not_enough:INTEGER = 10
	err_invalid_order_id:INTEGER = 11
	err_invoiced_order:INTEGER = 12

	valid_message(a_message_no:INTEGER): BOOLEAN
		do
			Result := err_message.lower <= a_message_no
				and a_message_no <= err_message.upper
		ensure
			Result =( err_message.lower <= a_message_no
				and a_message_no <= err_message.upper)
		end
end
