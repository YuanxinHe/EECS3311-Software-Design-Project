note
	description: "Summary description for {COMMAND_INTERFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMAND_INTERFACE
	inherit
		TYPE_CONSTRAINTS
		redefine out end

feature {NONE}
	make(a_name: STRING; a_args: TUPLE; a_container: ABSTRACT_UI_INTERFACE)
		do
			create message.make_empty
			name := a_name
			container := a_container
			out := ""
		end

feature -- attributes

	message: STRING

	container: ABSTRACT_UI_INTERFACE
		--allows a command to be observable
		-- container.on_change.notify ([Current])

	routine: ROUTINE[ANY, TUPLE]

	name: STRING

	out : STRING

	error: BOOLEAN

	debug_output: STRING
		do
			Result := out
		end

feature {NONE} -- queries

	event_argument_out(evt: STRING; param: STRING; v: ANY): STRING
		do
			create Result.make_empty
			if
				attached {HASH_TABLE[PARAM_TYPE, STRING]} evt_param_types[evt] as param_types
			   	and then
			   	attached {PARAM_TYPE} param_types [param] as param_type
			then
				Result := arg_out (param_type, v)
			else
				check FALSE end
			end
		end

	arg_out (t: PARAM_TYPE; v: ANY): STRING
		local
			param_type : PARAM_TYPE
		do
			create Result.make_empty
			param_type := retrieve_named_type_if_necessary (t)
			--------------------------------------------------
			if
				attached {STR_PARAM} param_type
			then
				Result.append ("%"" + v.out + "%"")
			--------------------------------------------------
			elseif
				attached {CHAR_PARAM} param_type
			then
				Result.append ("'" + v.out + "'")
			--------------------------------------------------
			elseif
				attached {VALUE_PARAM} param_type
				and then 
				attached {VALUE} v as value
			then
				Result.append (value.precise_out)
			--------------------------------------------------
			elseif
				attached {ARRAY_PARAM} param_type as array_param
				and then
				attached {ARRAY[ANY]} v as array_arg
			then
				Result.append (array_arg_out (array_param, array_arg))
			--------------------------------------------------
			elseif
				attached {TUPLE_PARAM} param_type as tuple_param
				and then
				attached {TUPLE} v as tuple_arg
			then
				Result.append (tuple_arg_out (tuple_param, tuple_arg))
			--------------------------------------------------
			elseif
				attached {ENUM_PARAM} param_type as enum_param
				and then
				attached {INTEGER} v as i
				and then
				attached {STRING} enum_items_inverse [i] as item_name
			then
				Result.append (item_name)
			--------------------------------------------------
			else
				Result.append (v.out)
			end
		end

	array_arg_out (param: ARRAY_PARAM; arg: ARRAY[ANY]): STRING
		local
			i : INTEGER
		do
			from
				create Result.make_empty
				Result.append ("<<")
				i := arg.lower
			until
				i > arg.upper
			loop
				Result.append (arg_out (param.base_type, arg[i]))

				if i < arg.upper then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append (">>")
		end

	tuple_arg_out (param: TUPLE_PARAM; arg: TUPLE): STRING
		local
			i : INTEGER
		do
			from
				create Result.make_empty
				Result.append ("[")
				i := 1
			until
				i > arg.count
			loop
				if attached {ANY} arg[i] as arg_value then
					Result.append (arg_out (param.base_types[i].type, arg_value))
				end

				if i < arg.upper then
					Result.append (", ")
				end
				i := i + 1
			end
			Result.append ("]")
		end

	retrieve_named_type_if_necessary (param_type: PARAM_TYPE): PARAM_TYPE
			-- Retrieve the PARAM_TYPE that the named type refers to.
		do
			if attached {NAMED_PARAM_TYPE} param_type as npt then

				Result := npt.type
			else
				Result := param_type
			end
		end
end