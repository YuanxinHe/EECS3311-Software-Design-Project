note
	description : "bag application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	MY_BAG [G -> {HASHABLE, COMPARABLE}]

inherit
	ADT_BAG [G]
create
	make_empty,
	make_from_tupled_array
convert
	make_from_tupled_array({attached ARRAY[attached TUPLE[G, INTEGER_32]]})

feature {NONE} -- Initialization
	make_empty
			-- Run application
		do
			table:= create{HASH_TABLE[INTEGER_32, G]}.make(0)
			my_count:=0
		end
	make_from_tupled_array(a_array:attached ARRAY[attached TUPLE[G, INTEGER_32]])
		local
			t:TUPLE[x: G; y: INTEGER]
			i:INTEGER
			int:INTEGER_32
			k:G
		do
			create table.make(0)
			my_count:=0
			from
				i:=1
			until
				i> a_array.count
			loop
				t:=a_array[i]
				int:= t.y
				k:=t.x
				Current.extend(k,int)
				i:=i+1
			end
		end
feature{MY_BAG}--states that are only visible to current class
	table:HASH_TABLE[INTEGER_32, G]

	my_count:INTEGER

feature -- creation queries
	new_cursor:MY_BAG_ITERATION_CURSOR[G]
		do
			create Result.make(Current)
		end

	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
			-- Are all the `y' fields of tuples in `a_array' non-negative
		do
			result := (across a_array as it all it.item.y >=0 end)
		end

feature -- bag equality
	bag_equal alias "|=|"(other: like Current): BOOLEAN
			-- equal to current object?
		do
			Result:= current.table.is_equal(other.table)
		end

feature -- queries

	domain: ARRAY[G]
			-- sorted domain of bag
		local
			i:INTEGER
			a:ARRAY[G]
   		do
   			i:=1
   			create a.make_empty
			a.compare_objects
			across table.current_keys as x loop
				a.force (x.item, i)
				i:=i+1
			end
			result:= sort_array(a)
   		end

   	count: INTEGER
   		do
   			result:=my_count
   		end

 	occurrences alias "[]" (key: G): INTEGER
			-- Anything out of the domain can simply be considered out of the bag,
			-- i.e. has a number of occurrences of 0.
		do
			if current.table.has(key) then
				Result:= table.item (key)
			else
				Result:= 0
			end
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
			-- current bag is subset of `other'
			-- <=
		local
			i:INTEGER
			k:G
		do
			Result:= true
			from
				table.start
			until
				table.after or not Result
			loop
				i:=table.item_for_iteration
				k:=table.key_for_iteration
				Result:= other.table.has(k) and then other.table.item(k) >= i
				table.forth
			end
		end


feature -- commands
	extend  (a_key: G; a_quantity: INTEGER)
			-- add [a_key, a_quantity] to the bag
			-- add additional quantities if item already is in the bag
		local
			new_quantity:INTEGER
		do
			if table.has(a_key) then
				new_quantity:= table.item (a_key) + a_quantity
				table.replace(new_quantity,a_key)
			elseif (a_quantity > 0) then
					table.extend(a_quantity,a_key)
					my_count:=my_count+1
			else
			end
		end

	add_all (other: like Current)
			-- add all elements in the bag `other'
		local
			 i:INTEGER_32
			 k:G
		do
			from other.table.start
			until other.table.after
			loop
				i:=other.table.item_for_iteration
				k:=other.table.key_for_iteration
				current.extend (k,i)
				other.table.forth
			end
		end

	remove  (a_key: G; a_quantity: INTEGER)
			-- remove [a_key, a_quantity] from the bag
		local
			new_quantity:INTEGER
		do
			if table.has(a_key) then
				new_quantity:= table.item(a_key) - a_quantity
				if new_quantity <=0 then
					table.remove(a_key)
					my_count:= my_count-1
				else
					table.replace(new_quantity,a_key)
				end
			end
		end

	remove_all (other: like Current)
		  -- bag difference
		  -- i.e. no. of items in Current
		  -- minus no. of times in other,
		  -- or zero
		local
			 i:INTEGER_32
			 k:G
		do
			from other.table.start
			until other.table.after
			loop
				i:= other.table.item_for_iteration
				k:= other.table.key_for_iteration
				remove (k,i)
				other.table.forth
			end
		end

	debug_output : STRING
		do
			result := ""
		end
feature {NONE}
	sort_array(a_array:ARRAY[G]):ARRAY[G]
	local
		i,j,k:INTEGER
		tmp:G
	do
			from
			i:=1
			until
			i> a_array.count
			loop
				j:=i
			from
				k:=i
			until
				k > a_array.count
			loop
				if(a_array[j] > a_array[k])then
					j:=k
				end
				k:=k+1
			end
				tmp:=a_array[i]
				a_array[i]:=a_array[j]
				a_array[j]:=tmp
				i:= i + 1
			end
			Result:=a_array
	end
end
