class TYPE_CONSTRAINTS
feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER]
		do
			create Result.make (10)
		end
feature -- query on declarations of event parameters
	evt_param_types : HASH_TABLE[HASH_TABLE[PARAM_TYPE, STRING], STRING]
		local
			nothing_param_types: HASH_TABLE[PARAM_TYPE, STRING]
			add_type_param_types: HASH_TABLE[PARAM_TYPE, STRING]
			add_product_param_types: HASH_TABLE[PARAM_TYPE, STRING]
			add_order_param_types: HASH_TABLE[PARAM_TYPE, STRING]
			invoice_param_types: HASH_TABLE[PARAM_TYPE, STRING]
			cancel_order_param_types: HASH_TABLE[PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create nothing_param_types.make (10)
			nothing_param_types.compare_objects
			Result.extend (nothing_param_types, "nothing")
			create add_type_param_types.make (10)
			add_type_param_types.compare_objects
			add_type_param_types.extend (create {STR_PARAM}, "product_id")
			Result.extend (add_type_param_types, "add_type")
			create add_product_param_types.make (10)
			add_product_param_types.compare_objects
			add_product_param_types.extend (create {STR_PARAM}, "a_product")
			add_product_param_types.extend (create {INT_PARAM}, "quantity")
			Result.extend (add_product_param_types, "add_product")
			create add_order_param_types.make (10)
			add_order_param_types.compare_objects
			add_order_param_types.extend (create {ARRAY_PARAM}.make (create {TUPLE_PARAM}.make(<<create {PARAM_DECL}.make("pid", create {STR_PARAM}), create {PARAM_DECL}.make("no", create {INT_PARAM})>>)), "a_order")
			Result.extend (add_order_param_types, "add_order")
			create invoice_param_types.make (10)
			invoice_param_types.compare_objects
			invoice_param_types.extend (create {INT_PARAM}, "order_id")
			Result.extend (invoice_param_types, "invoice")
			create cancel_order_param_types.make (10)
			cancel_order_param_types.compare_objects
			cancel_order_param_types.extend (create {INT_PARAM}, "order_id")
			Result.extend (cancel_order_param_types, "cancel_order")
		end
feature -- comments for contracts
	comment(s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end