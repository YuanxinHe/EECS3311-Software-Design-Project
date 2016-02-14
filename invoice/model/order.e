note
	description: "Summary description for {ORDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER

create
	make

feature{NONE} --initialization
	make(order:ARRAY[TUPLE[type_name: STRING;amount:INTEGER]])
	require
		non_empty: not order.is_empty
	do
		content:=order
		status:=false
	end

feature{ORDER} --states that are only visible to current class
	content:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]]

	status:BOOLEAN

feature --queries
    equal_order(other: like current): BOOLEAN
        --check whether two orders are equal
    local
    	i: INTEGER
    do
    	result:= true
    	from
    		i:= 1
    	until
    		i > current.get_content.count
    	loop
    		result:= result and (current.get_content[i].type_name.is_equal (other.get_content[i].type_name) and current.get_content[i].amount = other.get_content[i].amount)
    	    i:= i + 1
    	end
    end

    is_all_positive: BOOLEAN
        --check whether if all products' quantity positive.
    do
    	result:= across current.content as p all p.item.amount > 0 end
    end

	check_status:BOOLEAN
	    --check order status, false if pending, true if invoiced
	do
		result:=current.status
	end

	get_content:ARRAY[TUPLE[type_name:STRING;amount:INTEGER]]
	    --return the content of the order
	do
		result:=content
	end

feature --commands
	set_invoiced
	    --alter the order status from pending to invoiced
	do
		status:= true
	end

invariant
	all_positive: across current.content as p all p.item.amount > 0 end
end
