note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class NOTHING
inherit
	NOTHING_INTERFACE
	redefine nothing end
create
	make
feature -- command
	nothing
    	do
			-- perform some update on the model state
			model.nothing
			model.update("ok")
			container.on_change.notify ([Current])
    	end

end
