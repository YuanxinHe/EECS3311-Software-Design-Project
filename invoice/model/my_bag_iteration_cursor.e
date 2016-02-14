note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR[G -> {HASHABLE, COMPARABLE}]
inherit
	ITERATION_CURSOR[G]
create
	make
feature
	make(bag:MY_BAG[G])
	do
		index:=1
		target:=bag
	end
feature
	item: G
	do
		result:=target.domain[index]
	end
	after: BOOLEAN
	do
		result := target.count = 0 or index > target.count
	end
	forth
	do
		index:=index + 1
	end
feature
	index:INTEGER
	target:MY_BAG[G]
end
