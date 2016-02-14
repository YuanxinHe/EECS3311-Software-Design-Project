note
	description: "Abstract user interface"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ABSTRACT_UI_INTERFACE

feature {NONE} --init
	make
		do
			create commands.make_empty
			create on_change
		end
feature -- queries
	commands: ARRAY[COMMAND_INTERFACE]

	on_change: EVENT [TUPLE [COMMAND_INTERFACE]]

feature -- Insert commands
	put(a_command: COMMAND_INTERFACE)
		do
			commands.force (a_command, commands.count+1)
		ensure
			commands.count = old commands.count + 1
			commands[commands.count] = a_command
		end

feature -- Execute commands
	run_input_commands
			-- execute each command in `commands'
		do
			across commands as cmd
			loop
				cmd.item.routine.apply
			end
		end

end

