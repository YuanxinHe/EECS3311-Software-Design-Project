note
	description: "Abstract Data Type for BAG[G] where G is hashable and comparable"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ADT_BAG [G -> {HASHABLE, COMPARABLE}]
inherit
	ITERABLE[G]

feature{NONE} -- creation
	make_empty
		deferred
		end

	make_from_tupled_array (a_array: ARRAY [TUPLE [x: G; y: INTEGER]])
		require
			non_empty: a_array.count >= 0
			nonnegative: is_nonnegative(a_array)
		deferred
		end

feature -- creation queries

	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
			-- Are all the `y' fields of tuples in `a_array' non-negative
		deferred
		ensure
			correct_result: Result = (across a_array as it all it.item.y >=0 end)
		end

feature -- bag equality
	bag_equal alias "|=|"(other: like Current): BOOLEAN
			-- equal to current object?
		deferred
		ensure
			symmetry: Result = (other |=| Current)
		end

feature -- queries

	total: INTEGER
			-- total number of items in the bag
		do
			Result := 0
			across Current as it loop
				Result := Result + occurrences(it.item)
			end
		end

	count: INTEGER
			-- cardinality of the domain
		deferred
		end


	domain: ARRAY[G]
			-- sorted domain of bag
   		deferred
   		ensure
   			value_semantics: Result.object_comparison
   			correct_items: across 1 |..| Result.count as j all
   				has(Result[j.item]) end
   			sorted: across 1 |..| (Result.count-1) as j all
   				Result[j.item] <= Result[j.item+1] end
   		end

 	occurrences alias "[]" (key: G): INTEGER
			-- Anything out of the domain can simply be considered out of the bag,
			-- i.e. has a number of occurrences of 0.
		deferred
		ensure
			Result >= 0
			has(key) implies Result > 0
		end

	has(a_item: G) : BOOLEAN
			-- bag has element `a_item'
		do
			Result := occurrences (a_item) > 0
		ensure
			has_item: Result = (occurrences (a_item) > 0)
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
			-- current bag is subset of `other'
			-- <=
		deferred
		ensure
			correct_subset:
				Result implies
				across domain as g all
					has(g.item) implies other.has(g.item) and then
					occurrences(g.item) <= other.occurrences(g.item)
				end
		end


feature -- commands
	extend  (a_key: G; a_quantity: INTEGER)
			-- add [a_key, a_quantity] to the bag
			-- add additional quantities if item already is in the bag
		require
			non_negative: a_quantity >= 0
		deferred
		ensure
			extended: has(a_key) and then
			occurrences (a_key) = old (occurrences (a_key)) + a_quantity
		end

	add_all (other: like Current)
			-- add all elements in the bag `other'
		deferred
		end

	remove  (a_key: G; a_quantity: INTEGER)
			-- remove [a_key, a_quantity] from the bag
		require
			non_negative: a_quantity >= 0
		deferred
		ensure
			subtract: old occurrences (a_key) > a_quantity
				implies has(a_key)
			       and then occurrences (a_key) = old occurrences (a_key) - a_quantity
			zero: old occurrences (a_key) <= a_quantity
				implies not has(a_key) and then occurrences (a_key)=0
		end

	remove_all (other: like Current)
		  -- bag difference
		  -- i.e. no. of items in Current
		  -- minus no. of times in other,
		  -- or zero
		deferred
		end

feature -- countimng quantifiers

	number_of(f: PREDICATE[ANY, TUPLE[G, INTEGER]]): INTEGER
		local
			g: G
			i: INTEGER
		do
			Result := 0
			across domain as it loop
				g := it.item
				i := occurrences(g)
				if f.item ([g,i]) then
					Result := Result + 1
				end
			end
		end
invariant
	consistent_count: count = domain.count
	nonnegative_items:
	   across domain as it all
	      occurrences (it.item) > 0
	   end
	reflexivity: Current |=| Current

end
