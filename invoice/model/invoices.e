note
	description: "Summary description for {INVOICES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVOICES

inherit
	STATUS_MESSAGE
	redefine
		is_invalid_order_id, is_invoiced_order, too_many_id
	end

create{INVOICE_SYSTEM} --class can only be created by INVOICE_SYSTEM
	make

feature{NONE}  --Initialization
	make
	do
		max_id:=0
		current_id:=0
		canceled_id_list:= create{LINKED_QUEUE[INTEGER]}.make
		output_sequence:= create{ARRAYED_LIST[INTEGER]}.make (10000)
		order_list:= create{HASH_TABLE[ORDER,INTEGER]}.make(10000)
	end

feature{INVOICES} --states that are only visible to current class

	order_list:HASH_TABLE[ORDER,INTEGER]    --store existing orders in order and its id, reserving vacant positions of cancelled orders.

	canceled_id_list:LINKED_QUEUE[INTEGER]  --record index of removed orders in order_list observing first come first out principle.

	output_sequence:ARRAYED_LIST[INTEGER]   --record the output sequence

	max_id:INTEGER                          --record the largest id that order_list has ever created

	current_id:INTEGER                      --record the id of last created order

feature  --ancillary boolean queries
	is_invalid_order_id(id:INTEGER;invoices:INVOICES):BOOLEAN
	    --if id not exist, return true; otherwise return false
	do
		result:= not output_sequence.has(id)
	end

	is_invoiced_order(id:INTEGER;invoices:INVOICES):BOOLEAN
	    --check whether the order is invoiced or not
	local
		temp:BOOLEAN
	do
		if attached order_list[id] as x then
			temp:=x.check_status
		end
		result:=temp
	end

    too_many_id(invoices:INVOICES):BOOLEAN
        --check whether the amount of ids exceeds 10000
	do
		result:= get_current_id >= 10000 and canceled_id_list.is_empty
	end

feature --state queries
    get_order_amount: INTEGER
        --return the amount of order in the order_list.
    do
        result:= current.order_list.count
    ensure
    	result = current.order_list.count
    end

	get_current_id:INTEGER
	    --return current id
	do
		result:= current_id
	ensure
	    result = current_id
	end

	get_max_id: INTEGER
	    --return max id
	do
		result:= max_id
	ensure
		result = max_id
	end

    get_odr(id:INTEGER): ORDER
        --return order by given id
    do
    	create result.make (<<>>)
    	if attached current.order_list[id] as it then
    		result:= it
    	end
    end

    get_order(id: INTEGER):ARRAY[TUPLE[STRING,INTEGER]]
        --return content of order by given id
    do
    	create Result.make_empty
        if attached order_list[id] as o then
        	Result:= o.get_content
        end
    ensure
    	not result.is_empty
    end

feature --commands
	add_order(order:ARRAY[TUPLE[STRING,INTEGER]])
	    --generate new order in order_list, modify output_sequence
	require
		id_valid: not too_many_id(current)
		nonempty_cart: not is_empty_cart (order)
		all_quantity_valid: all_quantity_valid (order)
		no_duplicate_products: not has_duplicate_products (order)
	local
		o:ORDER
		reused_id:INTEGER
	do
		o:= create{ORDER}.make(order)
		if canceled_id_list.is_empty then
			max_id:=max_id+1
			output_sequence.extend (max_id)
			order_list.force (o, max_id)
			current_id:=max_id
		else
			reused_id:=canceled_id_list.item
			output_sequence.extend (reused_id)
			order_list.force (o, reused_id)
			canceled_id_list.remove
			current_id:=reused_id
		end
	ensure
        order_increase: current.order_list.count = old current.order_list.count + 1
        id_unique: not current.order_list.found
        order_inserted: attached current.order_list[current_id] as ol implies ol.equal_order (create {ORDER}.make (order))
        output_correct: across current.output_sequence as o2 all current.order_list.has (o2.item) end
        max_id_correct: old canceled_id_list.is_empty implies current_id = max_id
	end

	cancel_order(id:INTEGER)
	    --remove order from order_list, create a new record in canceled_id_list, modify output_sequence
	require
		valid_order_id: not is_invalid_order_id (id,current)
	do
		output_sequence.start
		output_sequence.search (id)
		output_sequence.remove
		canceled_id_list.extend (id)
		order_list.remove (id)
	ensure
		order_removed: not current.order_list.has_key (id)
		cancel_added: current.canceled_id_list.count = old current.canceled_id_list.count + 1
		output_removed: across current.output_sequence as o3 all o3.item /= id end
	end

	invoice(id:INTEGER)
	    --alter state of order from pending to invoiced
	require
		valid_order_id: not is_invalid_order_id (id,current)
		not_invoiced_order: not is_invoiced_order (id,current)
	do
		if attached order_list[id] as o then
			o.set_invoiced
		end
	ensure
		order_invoiced: attached current.order_list[id]as o4 implies o4.check_status
	end

feature --output handling

	get_cart_detail:STRING
	    --output a string describing detail of the cart
	local
		cart:ARRAY[STRING]
		temp_bag:MY_BAG[STRING]
	do
		result:=""
		across
			output_sequence as id
		loop
			if not id.is_first then
				result.append ("               ")
			end
			result.append (id.item.out)
			result.append (": ")
			if attached order_list[id.item] as x then
				temp_bag:= create{MY_BAG[STRING]}.make_from_tupled_array (x.get_content)
				cart:=temp_bag.domain
				across cart as y
					loop
						if not y.is_last then
							result.append(y.item)
							result.append("->")
							result.append(temp_bag[y.item].out)
							result.append(",")
						else
							result.append(y.item)
							result.append("->")
							result.append(temp_bag[y.item].out)
						end
					end
			end
			if not id.is_last then
				result.append ("%N")
			end
		end
	end

	get_exsited_order:STRING
	    --output a string illustrating product types in the invoice list
	do
		result:=""
		across
			output_sequence as o
		loop
			if not o.is_last then
				result.append(o.item.out+",")
			else
				result.append(o.item.out)
			end
		end
	end

	get_order_status:STRING
	    --output a string illustrating status of orders
	do
		result:=""
		across
			output_sequence as id
		loop
			result.append(id.item.out)
			result.append("->")
			if attached order_list[id.item] as x then
				if x.check_status then
					result.append("invoiced")
				else
					result.append("pending")
				end
			end
			if not id.is_last then
				result.append(",")
			end
		end
	end
invariant
	all_positive_order: across current.order_list as o all o.item.is_all_positive end
	max_id: current.get_max_id <= 10000
end
