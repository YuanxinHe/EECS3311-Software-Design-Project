note
	description: "Summary description for {STOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STOCK

inherit
	STATUS_MESSAGE
	redefine
	    is_existed_id, not_enough_stock
	end


create{INVOICE_SYSTEM} --class can only be created by INVOICE_SYSTEM
	make

feature{NONE} --initialization
	make
	do
		products_id:= create{TWO_WAY_SORTED_SET[STRING]}.make
		in_stock:=create{MY_BAG[STRING]}.make_empty
	end

feature{STOCK} --states that are only visible to current class
	products_id:TWO_WAY_SORTED_SET[STRING]

	in_stock:MY_BAG[STRING]

feature --ancillary boolean queries
	is_existed_id(type_name:STRING;stock: STOCK):BOOLEAN
	    --check whether the type has already existed
	do
		result:= across products_id as x some x.item.is_equal (type_name)  end
	end

	not_enough_stock(order:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]];stock:STOCK):BOOLEAN
	    --check whether the order exceed the quantity of goods in the stock
	local
		tmp_bag: MY_BAG[STRING]
	do
		tmp_bag:= create{MY_BAG[STRING]}.make_from_tupled_array (order)
		result:= not tmp_bag.is_subset_of (in_stock)
	end

feature --state queries
    get_total_amount: INTEGER
        --return total amount of all items in the stock
    do
    	result:= current.in_stock.total
    end

    get_type_amount: INTEGER
        --return amount of types in the stock
    do
    	result:= current.products_id.count
    end

    occurrence alias "[]" (type_name: STRING): INTEGER
        --return quantity for given type name
    do
    	result:= current.in_stock.occurrences (type_name)
    end

	get_products_id:STRING
	    --output namespace (goods that can be imported) in the stock
	do
		result:=""
		across products_id as p
		loop
			if p.is_first then
				result.append(" ")
				result.append(p.item)
			else
				result.append(","+p.item)
			end
		end
	end

	get_stock_detail:STRING
	    --output a string illustrating all states of the stock
	local
		output:ARRAY[STRING]
	do
		result:=""
		output:=in_stock.domain
		across
			output as o
		loop
			if not o.is_last then
				result.append(o.item)
				result.append("->")
				result.append(in_stock[o.item].out)
				result.append(",")
			else
				result.append(o.item)
				result.append("->")
				result.append(in_stock[o.item].out)
			end
		end
	end

feature --commands
    add_order(order:ARRAY[TUPLE[type_name: STRING; quantity: INTEGER]])
        --export goods according to the order
    require
		nonempty_cart: not is_empty_cart (order)
		all_quantity_valid: all_quantity_valid (order)
		all_products_valid: all_products_valid (order,current)
		no_duplicate_products: not has_duplicate_products (order)
		enough_stock: not not_enough_stock(order,current)
	local
		o:ORDER
    do
    	o:= create{ORDER}.make(order)
	    across o.get_content as i loop
		    remove_product (i.item.type_name,i.item.amount)
		end
	ensure
		stock_decrease: current.get_total_amount < old current.get_total_amount
    end

	remove_product(type_name:STRING;quantity:INTEGER)
	    --export one type of good with certain quantity
	do
		in_stock.remove (type_name,quantity)
	ensure
		product_removed: not current.in_stock.has (type_name) or current.in_stock[type_name] = old current.in_stock[type_name] - quantity
	end

	cancel_order(order: ARRAY[TUPLE[type_name: STRING; quantity: INTEGER]])
        --import goods according to the order
    local
    	o:ORDER
    do
    	o:= create {ORDER}.make (order)
    	across o.get_content as i loop
    	    add_product(i.item.type_name, i.item.amount)
    	end
    ensure
    	stock_increase: current.get_total_amount > old current.get_total_amount
    end

	add_product(type_name:STRING; quantity:INTEGER)
	    --import one type of good with certain quantity
	require
		valid_quantity: not is_invalid_quantity (quantity)
		existed_type: is_existed_id (type_name,current)
	do
		in_stock.extend (type_name,quantity)
	ensure
		stock_increase: current.get_total_amount = old current.get_total_amount + quantity
	end

	add_type(type_name:STRING)
	    --define certain type of goods that can be imported
	require
		valid_type_name: not is_invalid_type_name (type_name)
		not_existed: not is_existed_id (type_name,current)
	do
		products_id.extend (type_name)
	ensure
		type_increase: current.get_type_amount = old current.get_type_amount + 1
		has_type: current.products_id.has (type_name)
	end

invariant
    positive_product_quantity: across current.in_stock.domain as p all current.in_stock[p.item] > 0 end
end
