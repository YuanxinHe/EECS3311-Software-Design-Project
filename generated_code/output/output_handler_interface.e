note
	description: "Output handler for bank triggered via an observer event"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OUTPUT_HANDLER_INTERFACE

feature {NONE} -- Initialization

	make
		-- Initialization for `Current'.
	do
		create output.make_empty
		create error_message.make_empty
	end

feature -- queries

	output: STRING

	-- 'initial_state' is queried by
	-- 'execute' of SOFTWARE_OPERAION_INTERFACE
	initial_state: STRING
		deferred end

	error_message: STRING


feature -- Log to 'output'

	log_initial_state
		do
			output := initial_state
		end

	log_empty (a_cmd: COMMAND)
		do
			output := output
		end

	log_command (a_cmd: COMMAND)
			-- Log the normal effect of 'a_cmd' to 'output'
		local
			l_command_name: STRING
		do
			l_command_name := "->" + a_cmd.out + "%N"
			if a_cmd.message.count = 0 then
				output.append (l_command_name)
				-- 'output' may also be accumulated with the model state
			else
				output.append (l_command_name + "  Error: " + a_cmd.message)
			end
		end

	log_error (a_error: STRING)
			-- Log 'a_error' to 'error_message'
		do
			error_message := a_error
		end
end

